import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firmus/infra/services/http/http_service.dart';
import 'package:firmus/infra/services/notification_service/entity/notification_entity.dart';
import 'package:firmus/infra/services/storage/storage_service.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/subjects.dart';

import '../../../helper/logger.dart';
import 'notification_service.dart';

class NotificationStatus extends Equatable {
  final bool isGrantedInSysSettings;
  final bool isEnabled;
  final bool permanentlyDenied;
  final String? token;

  const NotificationStatus({
    required this.permanentlyDenied,
    required this.isGrantedInSysSettings,
    required this.isEnabled,
    this.token,
  });

  @override
  List<Object?> get props => [
        isGrantedInSysSettings,
        permanentlyDenied,
        isEnabled,
        token,
      ];

  NotificationStatus copyWith({
    bool? isGrantedInSysSettings,
    bool? isEnabled,
    bool? permanentlyDenied,
    String? token,
  }) {
    return NotificationStatus(
      isGrantedInSysSettings:
          isGrantedInSysSettings ?? this.isGrantedInSysSettings,
      isEnabled: isEnabled ?? this.isEnabled,
      permanentlyDenied: permanentlyDenied ?? this.permanentlyDenied,
      token: token ?? this.token,
    );
  }
}

final notificationEvents =
    Provider.autoDispose<PublishSubject<NotificationEntity>>((ref) {
  ref.keepAlive();
  return PublishSubject<NotificationEntity>(sync: true);
});

class FCMService implements NotificationService {
  final StorageService _storageService;
  final PublishSubject<NotificationEntity> _notificationEvents;
  final HttpService _httpService;
  FCMService(
      this._storageService, this._notificationEvents, this._httpService) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      logger.info('Got a message whilst in the foreground!');
      logger.info('Message data: ${message.data}');

      if (message.notification != null) {
        logger.info(
            'Message also contained a notification: ${message.notification}');
        _notificationEvents.add(NotificationEntity.fromMap({
          ...message.data,
          "title": message.notification!.title,
          "body": message.notification!.body,
        }));
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      logger.info('A new onMessageOpenedApp event was published!');
      logger.info('Message data: ${message.data}');

      if (message.notification != null) {
        logger.info(
            'Message also contained a notification: ${message.notification}');
      }
    });
    FirebaseMessaging.onBackgroundMessage((message) async {
      logger.info('Got a message whilst in the background!');
      logger.info('Message data: ${message.data}');

      if (message.notification != null) {
        logger.info(
            'Message also contained a notification: ${message.notification}');
      }
    });
  }

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  Future<String?> getToken() async {
    if (!kIsWeb) {
      try {
         await _firebaseMessaging.subscribeToTopic("all");
      } catch (e) {
        try {
          await _firebaseMessaging.unsubscribeFromTopic("all");
        } catch (e) {
          logger.info(e);
        }
        logger.info("deleting token");
        await _firebaseMessaging.deleteToken();
      }
    }

    return _firebaseMessaging.getToken();
  }

  @override
  Future<NotificationStatus> init({bool soft = false}) async {
    if (soft) {
      return NotificationStatus(
        permanentlyDenied: await Permission.notification.isPermanentlyDenied,
        isGrantedInSysSettings: await Permission.notification.isGranted,
        isEnabled:
            _storageService.getValue("notifications").toString() == "true",
        token: await getToken(),
      );
    }

    try {
      await _firebaseMessaging.requestPermission();
      await _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: false,
        badge: false,
        sound: false,
      );

     } catch (e) {
      logger.info(e);
    } finally {
      final systemSettings = await Permission.notification.isGranted;

      var isEnabled =
          _storageService.getValue("notifications").toString() == "true";
      if (_storageService.getValue("notifications") == null) {
        await _storageService.setValue(
            key: "notifications", data: true.toString());
        isEnabled = true;
      }
      final token = isEnabled == false ? null : await getToken();

      return NotificationStatus(
        permanentlyDenied: await Permission.notification.isPermanentlyDenied,
        isGrantedInSysSettings: systemSettings,
        isEnabled: isEnabled,
        token: token,
      );
    }
  }

  @override
  Future<NotificationStatus> toggle() async {
    final bool current =
        _storageService.getValue("notifications").toString() == "true";

    if (!current) {
      await _firebaseMessaging.requestPermission();
      await _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: false,
        badge: false,
        sound: false,
      );
    }

    await _storageService.setValue(
        key: "notifications", data: (!current).toString());

    bool isEnabled =
        _storageService.getValue("notifications").toString() == "true";

    if (!isEnabled) {
      await _firebaseMessaging.deleteToken();
    }

    return NotificationStatus(
      permanentlyDenied: await Permission.notification.isPermanentlyDenied,
      isGrantedInSysSettings: await Permission.notification.isGranted,
      isEnabled: isEnabled,
      token: await getToken(),
    );
  }

  @override
  Future<void> deleteToken() {
    return _firebaseMessaging.deleteToken();
  }

  @override
  Future<List<NotificationEntity>> fetchNotifications() {
    return _httpService.request(
      const GetNotificationsRequest(),
      converter: (response) {
        return (response["data"] as List)
            .map((e) => NotificationEntity.fromMap(e))
            .toList();
      },
    );
  }
}
