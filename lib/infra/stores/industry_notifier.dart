import 'package:firmus/helper/logger.dart';
import 'package:firmus/infra/services/job/job_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/job/entity/industry.dart';

final industryProvider =
    FutureProvider.autoDispose<List<IndustryModel>>((ref) async {
  ref.keepAlive();
  final sw = Stopwatch()..start();
  final response = await ref.read(jobServiceProvider).getIndustries(
        const IndustriesRequest(""),
      );
  logger.info('industrySearchProvider: ${sw.elapsedMilliseconds}');
  return response.industries;
});
