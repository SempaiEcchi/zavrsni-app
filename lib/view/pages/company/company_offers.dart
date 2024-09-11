import 'package:firmus/infra/keep_alive.dart';
import 'package:firmus/infra/services/job/job_service.dart';
import 'package:firmus/models/job_offers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final companyOffersProvider = FutureProvider.autoDispose
    .family<List<JobOpportunity>, String>((ref, companyId) async {
  keepAlive(ref);
  final service = ref.read(jobServiceProvider);
  final offers = await service.fetchCompanyOffers(companyId);

  return offers;
});
