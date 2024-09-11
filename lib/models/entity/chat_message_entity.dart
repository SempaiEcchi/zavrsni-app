import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessageEntity {
  final String senderId;
  final String messageId;
  final String message;
  final String senderType;
  final DateTime sentAt;
  final bool isSeen;

  const ChatMessageEntity({
    required this.messageId,
    required this.senderId,
    required this.senderType,
    required this.message,
    required this.sentAt,
    this.isSeen = false,
  });

  factory ChatMessageEntity.fromMap(
    Map<String, dynamic> map,
    String id,
  ) {
    return ChatMessageEntity(
      messageId: id,
      senderType: map['sender_type'] as String,
      senderId: map['sender_firebase_id'] as String,
      message: map['message'] as String,
      isSeen: map['is_seen'].toString() == 'true',
      sentAt: (map['sent_at'] as Timestamp).toDate(),
    );
  }
}
