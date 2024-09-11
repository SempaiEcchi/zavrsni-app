import 'package:equatable/equatable.dart';
import 'package:firmus/infra/services/job/entity/job_offer_details_response.dart';
import 'package:firmus/view/pages/student_home/widges/view_type_selector.dart';

class SwipeableStudentsState extends Equatable {
  final List<JobOfferApplicant> students;

  final HomeViewType viewType;
  const SwipeableStudentsState({
    required this.students,
    this.viewType = HomeViewType.carousel,
  });

  @override
  List<Object?> get props => [
        students,
        viewType,
      ];

  SwipeableStudentsState copyWith({
    List<JobOfferApplicant>? students,
    HomeViewType? viewType,
  }) {
    return SwipeableStudentsState(
      students: students ?? this.students,
      viewType: viewType ?? this.viewType,
    );
  }
}
