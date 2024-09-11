import 'dart:async';

import 'package:firmus/infra/services/http/http_service.dart';
import 'package:firmus/models/entity/chat_message_entity.dart';
import 'package:firmus/models/entity/chat_overview_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_chat_service.dart';

final chatServiceProvider = Provider<ChatService>((ref) {
  return FirebaseChatService(ref.read(httpServiceProvider));
});

abstract class ChatService {
  Stream<List<ChatOverviewEntity>> getMyChats(String uid);

  Stream<List<ChatMessageEntity>> getChatMessages(String chatId);

  Future<void> sendMessage(SendMessageRequest request);

  Future<void> setSeen(String chatId, List<String> ids);
}

class SendMessageRequest extends BaseHttpRequest {
  final String chatId;
  final String message;

  SendMessageRequest({
    required this.chatId,
    required this.message,
  }) : super(endpoint: '/chat/$chatId/messages', type: RequestType.post);

  @override
  FutureOr<Map<String, dynamic>> toMap() {
    return {
      'message': message,
    };
  }
}
