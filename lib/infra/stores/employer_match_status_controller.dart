import 'dart:async';

import 'package:firmus/infra/services/job/entity/job_offer_details_response.dart';
import 'package:firmus/infra/services/job/job_service.dart';
import 'package:firmus/models/student_job_offers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final employerMatchStatusProvider = AutoDisposeNotifierProvider<
    EmployerMatchStatusController, MatchedApplicant?>(() {
  return EmployerMatchStatusController();
});

class EmployerMatchStatusController
    extends AutoDisposeNotifier<MatchedApplicant?> {
  @override
  MatchedApplicant? build() {
    return null;
  }

  JobService get service => ref.read(jobServiceProvider);

  void setMatchedStudent(MatchedApplicant? student) {
    state = student;
  }

  Future<void> sendRequest() async {
    final AppliedJobOffer match = await service.acceptMatch(state!.matchId);

    // state = state!.copyWith(
    //   jobApplicationStatus: match.jobApplicationStatus,
    // );
  }

  Future<void> cancelRequest() async {
    final AppliedJobOffer match = await service.cancelMatch(state!.matchId);

    // state = state!.copyWith(
    //   jobApplicationStatus: match.jobApplicationStatus,
    // );
  }
}
