import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:firmus/infra/services/job/entity/job_offer_details_response.dart';
import 'package:firmus/models/user_type.dart';

class ChatOverviewEntity {
  //database ids
  final String companyId;
  final String studentId;
  final String jobOpportunityId;
  final String chatId;
  final DateTime? lastSent;
  final String? lastMessage;
  final UserType? lastSenderType;
  final SimpleStudentProfile? student;

  const ChatOverviewEntity({
    required this.companyId,
    required this.jobOpportunityId,
    required this.studentId,
    required this.chatId,
    required this.lastSent,
    required this.lastMessage,
    required this.lastSenderType,
    required this.student,
  });

  factory ChatOverviewEntity.fromMap(Map<String, dynamic> map, String id) {
    return ChatOverviewEntity(
      student: map["student"] == null
          ? null
          : SimpleStudentProfile.fromMap(map["student"]),
      jobOpportunityId: map['job_opportunity_id'] as String,
      companyId: map['company_id'] as String,
      studentId: map['student_id'] as String,
      chatId: id,
      lastSent: map["last_sent"] == null
          ? null
          : (map['last_sent'] as Timestamp).toDate(),
      lastMessage: map['last_message'] as String?,
      lastSenderType: UserType.values.firstWhereOrNull(
          (element) => element.name == map["last_sender_type"]),
    );
  }
}
