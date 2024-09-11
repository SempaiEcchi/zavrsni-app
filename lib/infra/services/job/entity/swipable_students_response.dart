import 'package:equatable/equatable.dart';
import 'package:firmus/infra/services/job/entity/job_offer_details_response.dart';

class SwipeableStudentsResponse extends Equatable {
  final List<InterestedApplicant> swipableStudents;
  final List<RecommendedApplicant> recommendedStudents;
  const SwipeableStudentsResponse(
      {required this.swipableStudents, required this.recommendedStudents});

  factory SwipeableStudentsResponse.fromMap(Map<String, dynamic> map) {
    return SwipeableStudentsResponse(
      recommendedStudents: map["recommended_students"] == null
          ? []
          : List<RecommendedApplicant>.from(map['recommended_students']
              .map((x) => RecommendedApplicant.fromMap(x))),
      swipableStudents: List<InterestedApplicant>.from(
          map['swipeable_students'].map((x) => InterestedApplicant.fromMap(x))),
    );
  }

  @override
  List<Object?> get props => [swipableStudents, recommendedStudents];

  SwipeableStudentsResponse copyWithRemove(JobOfferApplicant applicant) {
    final newSwipableStudents = applicant is InterestedApplicant
        ? swipableStudents
            .where((element) => element.student.id != applicant.student.id)
            .toList()
        : swipableStudents;
    final newRecommendedStudents = applicant is RecommendedApplicant
        ? recommendedStudents
            .where((element) => element.student.id != applicant.student.id)
            .toList()
        : recommendedStudents;
    return SwipeableStudentsResponse(
      swipableStudents: newSwipableStudents,
      recommendedStudents: newRecommendedStudents,
    );
  }
}
