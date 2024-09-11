import 'package:firmus/infra/services/http/http_service.dart';
import 'package:firmus/infra/services/notification_service/entity/notification_entity.dart';
import 'package:firmus/infra/services/storage/storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'fcm.dart';

final notificationService = Provider<NotificationService>((ref) {
  return FCMService(ref.read(storageServiceProvider),
      ref.read(notificationEvents), ref.read(httpServiceProvider));
});

abstract class NotificationService {
  Future<NotificationStatus> init({bool soft = false});
  Future<NotificationStatus> toggle();
  Future<String?> getToken();

  Future<void> deleteToken();

  Future<List<NotificationEntity>> fetchNotifications();
}

class GetNotificationsRequest extends BaseHttpRequest {
  const GetNotificationsRequest()
      : super(endpoint: "/notifications", type: RequestType.get);

  @override
  Map<String, dynamic> toMap() {
    return {};
  }
}
