import 'package:equatable/equatable.dart';
import 'package:firmus/infra/services/job/entity/job_offer_details_response.dart';
import 'package:firmus/models/entity/chat_overview_entity.dart';
import 'package:firmus/models/entity/user_entity.dart';
import 'package:firmus/models/job_offers.dart';

class ChatsState extends Equatable {
  final List<ChatOverview> chats;

  @override
  List<Object?> get props => [chats];

  const ChatsState({
    required this.chats,
  });

  int unreadCountForStudent(String studentId, String jobId) {
    return chats
        .where((element) =>
            element.sender == UserType.student &&
            element.jobOpportunity.id == jobId)
        .length;
  }
}

class ChatOverview extends Equatable {
  final String chatId;
  final SimpleCompany company;
  final SimpleStudentProfile? student;
  final JobOpportunity jobOpportunity;
  final DateTime? lastSent;
  final String? lastMessage;
  final UserType sender;

  factory ChatOverview.fromEntity(ChatOverviewEntity entity,
      JobOpportunity jobOp, SimpleStudentProfile? student) {
    return ChatOverview(
        student: student,
        jobOpportunity: jobOp,
        chatId: entity.chatId,
        company: jobOp.company,
        lastSent: entity.lastSent,
        lastMessage: entity.lastMessage,
        sender: entity.lastSenderType ?? UserType.company);
  }

  const ChatOverview({
    required this.student,
    required this.chatId,
    required this.jobOpportunity,
    required this.company,
    required this.lastSent,
    required this.lastMessage,
    required this.sender,
  });

  @override
  List<Object?> get props => [
        chatId,
        company,
        lastSent,
        student,
        lastMessage,
        sender,
      ];

  String title(UserType myType) =>
      "${myType == UserType.company ? student?.name ?? "Student" : company.name} - ${jobOpportunity.jobTitle}";
}
