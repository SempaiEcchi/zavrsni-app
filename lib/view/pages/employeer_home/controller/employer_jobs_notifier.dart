import 'dart:async';

import 'package:firmus/infra/keep_alive.dart';
import 'package:firmus/infra/services/job/entity/employer_job_offers.dart';
import 'package:firmus/infra/services/job/job_service.dart';
import 'package:firmus/infra/stores/company_notifier.dart';
import 'package:firmus/models/job_offers.dart';
import 'package:firmus/view/pages/chats/controllers/chat_page_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'employer_jobs_state.dart';

final employerJobsProvider = AsyncNotifierProvider.autoDispose<
    EmployerJobsController, EmployerJobsState>(() {
  return EmployerJobsController();
});

class EmployerJobsController
    extends AutoDisposeAsyncNotifier<EmployerJobsState> {
  @override
  FutureOr<EmployerJobsState> build() async {
    keepAlive(ref);
    final company = await ref.watch(companyNotifierProvider.future);
    final service = ref.read(jobServiceProvider);
    final employerJobOffers = await service.fetchEmployerJobOffers(company.id);
    return EmployerJobsState(
      employerJobOffersResponse: employerJobOffers,
    );
  }

  void addJob(JobOpportunity jobOffer) {
    state = AsyncData(state.requireValue.copyWith(
      employerJobOffersResponse:
          state.requireValue.employerJobOffersResponse.copyWith(
        activeJobs: [
          ActiveEmployerJobOffer(opportunity: jobOffer),
          ...state.requireValue.employerJobOffersResponse.activeJobs,
        ],
      ),
    ));
  }
}

final employerJobDetailsProvider = FutureProvider.autoDispose
    .family<EmployerJobDetailState, EmployerJobOffer>((ref, job) async {
  final service = ref.read(jobServiceProvider);
  final jobOfferDetailsResponse = await service.fetchJobOfferDetails(
      job.opportunity.company.id, job.opportunity.id);
  return EmployerJobDetailState(
    jobOpportunity: job,
    jobOfferDetailsResponse: jobOfferDetailsResponse,
  );
});

final unreadMessagesProvider =
    FutureProvider.autoDispose.family<int, (String, String)>((ref, arg) async {
  final messages = await ref.watch(chatsControllerProvider.future);
  return messages.unreadCountForStudent(arg.$1, arg.$2);
});
