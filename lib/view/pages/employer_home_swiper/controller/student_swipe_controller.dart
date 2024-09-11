import 'dart:async';

import 'package:firmus/infra/services/job/entity/job_offer_details_response.dart';
import 'package:firmus/infra/services/job/job_service.dart';
import 'package:firmus/infra/stores/company_notifier.dart';
import 'package:firmus/models/job_offers.dart';
import 'package:firmus/view/pages/employer_home_swiper/controller/swipable_students_state.dart';
import 'package:firmus/view/pages/student_home/widges/view_type_selector.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final swipableStudentsProvider = AsyncNotifierProvider.autoDispose
    .family<SwipableStudentsController, SwipeableStudentsState, String>(() {
  return SwipableStudentsController();
});

final selectedJobProvider =
    NotifierProvider<SelectedJobStore, JobOpportunity?>(() {
  return SelectedJobStore();
});

class SelectedJobStore extends Notifier<JobOpportunity?> {
  void select(JobOpportunity job) {
    state = job;
  }

  void unselect() {
    state = null;
  }

  @override
  JobOpportunity? build() {
    return null;
  }
}

class SwipableStudentsController
    extends AutoDisposeFamilyAsyncNotifier<SwipeableStudentsState, String> {
  @override
  FutureOr<SwipeableStudentsState> build(String arg) async {
    if (state.hasValue && state.isRefreshing == false) {
      return state.requireValue;
    }

    final company = await ref.read(companyNotifierProvider.future);

    final allStudents = await ref
        .read(jobServiceProvider)
        .fetchSwipeableStudents(company.id, arg);

    return SwipeableStudentsState(
      viewType: HomeViewType.carousel,
      students: [
        ...allStudents.recommendedStudents,
        ...allStudents.swipableStudents,
      ],
    );
  }

  Future<void> swipeStudent(
      JobOfferApplicant student, FirmusSwipeType direction) async {
    ref.read(jobServiceProvider).swipeStudent(
          student.student.id,
          arg,
          direction,
        );

    state = AsyncData(
      state.requireValue.copyWith(
        students: state.requireValue.students
            .where((s) => s.student.id != student.student.id)
            .toList(),
      ),
    );
  }

  void changeViewType(HomeViewType type) {
    state = AsyncData(
      SwipeableStudentsState(
        students: state.requireValue.students,
        viewType: type,
      ),
    );
  }
}
