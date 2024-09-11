import 'dart:async';

import 'package:firmus/infra/services/auth/auth_service.dart';
import 'package:firmus/infra/services/notification_service/entity/notification_entity.dart';
import 'package:firmus/infra/services/notification_service/notification_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationListController = AutoDisposeAsyncNotifierProvider<
    NotificationListController, List<NotificationEntity>>(() {
  return NotificationListController();
});

class NotificationListController
    extends AutoDisposeAsyncNotifier<List<NotificationEntity>> {
  @override
  FutureOr<List<NotificationEntity>> build() async {
    ref.keepAlive();
    final userId =
        await ref.watch(userProvider.selectAsync((data) => data.uid));
    return await ref.read(notificationService).fetchNotifications().then(
        (value) => value.where((element) => element.title !="null").toList()
    );
  }
}
