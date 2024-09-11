import 'dart:async';

import 'package:firmus/infra/services/lifecycle/lifecycle_provider.dart';
import 'package:firmus/infra/services/notification_service/fcm.dart';
import 'package:firmus/infra/services/notification_service/notification_service.dart';
import 'package:firmus/infra/services/user/user_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationController = AutoDisposeAsyncNotifierProvider<
    NotificationControllerProvider, NotificationStatus>(() {
  return NotificationControllerProvider();
});

class NotificationControllerProvider
    extends AutoDisposeAsyncNotifier<NotificationStatus> {
  @override
  FutureOr<NotificationStatus> build() async {
    ref.keepAlive();
    Future(() {
      ref.listen(lifeCycleControllerProvider, (a, b) async {
        state = AsyncData(await getStatus());
      });
    });
    NotificationStatus value = await getStatus();
    return value;
  }

  Future<NotificationStatus> getStatus() async {
    final value = await ref.read(notificationService).init(soft: true);
    await ref.read(userServiceProvider).registerToken(
        RegisterTokenRequest(token: value.token!, delete: !value.isEnabled));
    return value;
  }

  void init() async {
    await future;
    final value = await ref.read(notificationService).init(soft: false);
    await ref.read(userServiceProvider).registerToken(
        RegisterTokenRequest(token: value.token!, delete: !value.isEnabled));
    state = AsyncData(value);
  }

  Future<void> toggle() async {
    state = AsyncData(state.requireValue.copyWith(
      isEnabled: !state.requireValue.isEnabled,
    ));
    await ref.read(notificationService).toggle();
    NotificationStatus value = await getStatus();
    state = AsyncData(value);
  }
}
