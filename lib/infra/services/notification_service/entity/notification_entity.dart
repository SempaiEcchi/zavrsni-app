import 'package:firmus/helper/uuid.dart';



enum NotificationType {
  match,
  message,
  chat,
  other,
}

sealed class NotificationEntity {
  final String id;
  final String title;
  final String? body;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.body,
  });

  factory NotificationEntity.fromMap(Map<String, dynamic> map) {
    if (map['id'] == null) {
      map['id'] = uuid.v4();
    }
    map['description'] = map['description'] ?? map['body'] ?? '';
    map['body'] = map['body'] ?? map['description'] ?? '';
    final type =
        NotificationType.values.byName(map['type'] as String? ?? 'other');
    switch (type) {
      case NotificationType.match:
        return MatchNotification.fromMap(map);
      default:
        return BasicNotification(
          id: map['id'].toString(),
          title: map['title'].toString(),
          body: map['body'].toString(),
        );
    }
  }
}

class BasicNotification extends NotificationEntity {
  const BasicNotification({
    required String title,
    required String body,
    required super.id,
  }) : super(
          title: title,
          body: body,
        );
}

class MatchNotification extends NotificationEntity {
  final String matchId;

  const MatchNotification({
    required this.matchId,
    required String title,
    required String description,
    required super.id,
  }) : super(
          title: title,
          body: description,
        );

  factory MatchNotification.fromMap(Map<String, dynamic> map) {
    return MatchNotification(
      id: map['id'] as String,
      matchId: map['match_id'] as String,
      title: map['title'] as String,
      description: map['body'] as String,
    );
  }
}




