import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firmus/infra/keep_alive.dart';
import 'package:firmus/models/entity/chat_message_entity.dart';
import 'package:firmus/view/pages/chats/controllers/chat_page_state.dart';
import 'package:firmus/view/pages/chats/controllers/single_chat_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../infra/services/chat/chat_service.dart';

final singleChatControllerProvider = AsyncNotifierProvider.autoDispose
    .family<SingleChatController, SingleChatState, ChatOverview>(
        SingleChatController.new);

class SingleChatController
    extends AutoDisposeFamilyAsyncNotifier<SingleChatState, ChatOverview> {
  StreamSubscription<List<ChatMessageEntity>>? _stream;

  @override
  FutureOr<SingleChatState> build(ChatOverview arg) async {
    keepAlive(ref);
    final chatService = ref.read(chatServiceProvider);
    _stream?.cancel();
    Completer<List<ChatMessage>> completer = Completer();
    _stream = chatService.getChatMessages(arg.chatId).listen((event) async {
      final v = await chatMessagesFromEntity(event);
      if (!completer.isCompleted) return completer.complete(v);
      state = AsyncData(SingleChatState(chat: arg, messages: v));
    });

    ref.onDispose(() {
      _stream?.cancel();
    });

    return SingleChatState(chat: arg, messages: await completer.future);
  }

  Future<List<ChatMessage>> chatMessagesFromEntity(
      List<ChatMessageEntity> entities) async {
    final msgs = await Future.wait(entities.map((e) async {
      return ChatMessage.fromEntity(e, FirebaseAuth.instance.currentUser!.uid);
    }).toList());
    return msgs.sortWithDate((date) => date.sent);
  }

  Future sendMessage(String message) {
    pseudoAdd(message);

    final chatService = ref.read(chatServiceProvider);
    return chatService.sendMessage(SendMessageRequest(
      chatId: state.requireValue.chat.chatId,
      message: message,
    ));
  }

  void pseudoAdd(String message) {
    state = AsyncData(SingleChatState(chat: state.requireValue.chat, messages: [
      ...state.requireValue.messages,
      ChatMessage(
          id: DateTime.now().toString(),
          isSender: true,
          message: message,
          sent: DateTime.now(),
          isSeen: false)
    ]));
  }

  Future<void> seeMessages() {
    final chatService = ref.read(chatServiceProvider);
    final messagesToSee = state.requireValue.messages
        .where((element) => !element.isSender && !element.isSeen)
        .toList();
    return chatService.setSeen(state.requireValue.chat.chatId,
        messagesToSee.map((e) => e.id).toList());
  }
}
