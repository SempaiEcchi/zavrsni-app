import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firmus/infra/services/chat/chat_service.dart';
import 'package:firmus/infra/services/http/http_service.dart';
import 'package:firmus/models/entity/chat_message_entity.dart';
import 'package:firmus/models/entity/chat_overview_entity.dart';

class FirebaseChatService extends ChatService {
  final HttpService httpServiceProvider;

  FirebaseChatService(this.httpServiceProvider);

  final firestore = FirebaseFirestore.instance;
  final collectionRef = FirebaseFirestore.instance.collection('chats');

  @override
  Stream<List<ChatOverviewEntity>> getMyChats(String uid) {
    final stream = collectionRef
        .where(Filter.or(Filter("student_firebase_id", isEqualTo: uid),
            Filter("company_firebase_id", isEqualTo: uid)))
        .snapshots()
        .map((event) => event.docs
            .map((e) => ChatOverviewEntity.fromMap(e.data(), e.id))
            .toList());
    return stream;
  }

  @override
  Stream<List<ChatMessageEntity>> getChatMessages(String chatId) {
    final stream = collectionRef
        .doc(chatId)
        .collection("messages")
        .snapshots()
        .map((event) => event.docs
            .map((e) => ChatMessageEntity.fromMap(e.data(), e.id))
            .toList());
    return stream;
  }

  @override
  Future<void> sendMessage(SendMessageRequest request) async {
    return (httpServiceProvider).request(
      request,
      converter: (Map<String, dynamic> response) {},
    );
  }

  @override
  Future<void> setSeen(String chatId, List<String> ids) {
    final batch = firestore.batch();
    for (var id in ids) {
      batch.update(
        collectionRef.doc(chatId).collection("messages").doc(id),
        {"isSeen": true},
      );
    }
    return batch.commit();
  }
}
