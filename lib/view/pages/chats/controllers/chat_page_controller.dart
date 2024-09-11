import 'dart:async';

import 'package:firmus/infra/services/auth/auth_service.dart';
import 'package:firmus/infra/services/chat/chat_service.dart';
import 'package:firmus/infra/services/job/job_service.dart';
import 'package:firmus/infra/services/user/user_service.dart';
import 'package:firmus/models/entity/chat_overview_entity.dart';
import 'package:firmus/models/job_offers.dart';
import 'package:firmus/view/pages/chats/controllers/chat_page_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final chatsControllerProvider =
    AsyncNotifierProvider.autoDispose<ChatPageController, ChatsState>(() {
  return ChatPageController();
});

class ChatPageController extends AutoDisposeAsyncNotifier<ChatsState> {
  UserService get userService => ref.read(userServiceProvider);

  StreamSubscription<List<ChatOverviewEntity>>? _stream;

  @override
  FutureOr<ChatsState> build() async {
    ref.keepAlive();

    _stream?.cancel();

    final completer = Completer<List<ChatOverview>>();
    final uid = ref.watch(firebaseUserIdProvider);
    _stream =
        ref.read(chatServiceProvider).getMyChats(uid).listen((event) async {


          final value = await chatOverviewsFromEntity(event);
          if (!completer.isCompleted) return completer.complete(value);
      state = AsyncData(ChatsState(chats: value));
    });

    ref.onDispose(() {
      _stream?.cancel();
    });

    return ChatsState(
      chats: await completer.future,
    );
  }

  Future<List<ChatOverview>> chatOverviewsFromEntity(
      List<ChatOverviewEntity> entities) async {
    final es = await Future.wait(entities.map((ChatOverviewEntity e) async {
      final JobOpportunity jobOpportunity = await ref
          .read(jobServiceProvider)
          .getJobOpportunity(GetJobOpportunityRequest(id: e.jobOpportunityId));
      return ChatOverview.fromEntity(e, jobOpportunity, e.student);
    }).toList());
    return es.sortWithDate((date) => date.lastSent ?? DateTime.now());
  }
}
