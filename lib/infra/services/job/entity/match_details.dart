import 'package:firmus/infra/services/job/entity/job_offer_details_response.dart';
import 'package:firmus/models/job_offers.dart';

class MatchDetailsResponse {
  final String match_id;
  final String chat_id;
  final JobOpportunity job;
  final SimpleStudentProfile student;

  const MatchDetailsResponse({
    required this.match_id,
    required this.chat_id,
    required this.job,
    required this.student,
  });

  factory MatchDetailsResponse.fromMap(Map<String, dynamic> map) {
    return MatchDetailsResponse(
      match_id: map['match_id'].toString(),
      chat_id: map['chat_id'].toString(),
      job: JobOpportunity.fromMap(map['job_opportunity']),
      student: SimpleStudentProfile.fromMap(map['student']),
    );
  }
}
