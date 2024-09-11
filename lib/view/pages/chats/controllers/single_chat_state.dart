import 'package:equatable/equatable.dart';

import '../../../../models/entity/chat_message_entity.dart';
import 'chat_page_state.dart';

class SingleChatState extends Equatable {
  final ChatOverview chat;
  final List<ChatMessage> messages;
  const SingleChatState({
    required this.chat,
    required this.messages,
  });

  @override
  List<Object?> get props => [chat, messages];
}

class ChatMessage {
  final String id;
  final bool isSender;
  final String message;
  final DateTime sent;
  final bool isSeen;

  const ChatMessage({
    required this.id,
    required this.isSender,
    required this.message,
    required this.sent,
    required this.isSeen,
  });

  factory ChatMessage.fromEntity(
      ChatMessageEntity entity, String currentUserId) {
    return ChatMessage(
      id: entity.messageId,
      isSender: entity.senderId == currentUserId,
      message: entity.message,
      sent: entity.sentAt,
      isSeen: entity.isSeen,
    );
  }
}
