import 'dart:async';

import 'package:firmus/infra/keep_alive.dart';
import 'package:firmus/infra/services/job/job_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/student_job_offers.dart';

final studentJobsProvider = AsyncNotifierProvider.autoDispose<StudentJobsNotifier, SavedJobsResponse>(() {
  return StudentJobsNotifier();
});

class StudentJobsNotifier extends AutoDisposeAsyncNotifier<SavedJobsResponse> {
  @override
  FutureOr<SavedJobsResponse> build() {
    keepAlive(ref);
    final service = ref.read(jobServiceProvider);

    final jobs = service.fetchSavedJobs(FetchSavedJobsRequest());
    return jobs;
  }

  Future<void> refreshSavedJobs() async {
    if (this.state is AsyncLoading) return;

    ref.invalidateSelf();
  }

  Future<AppliedJobOffer> acceptMatch(String matchId) async {
    final service = ref.read(jobServiceProvider);

    final job = await service.acceptMatch(matchId);
    refreshSavedJobs();
    return job;
  }
}
