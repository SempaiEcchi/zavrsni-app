import 'package:fade_and_translate/fade_and_translate.dart';
import 'package:firmus/helper/logger.dart';
import 'package:firmus/view/pages/employeer_home/company_active_job_list.dart';
import 'package:firmus/view/pages/employeer_home/controller/employer_jobs_notifier.dart';
import 'package:firmus/view/pages/employer_home_swiper/controller/student_swipe_controller.dart';
import 'package:firmus/view/pages/employer_home_swiper/students_list.dart';
import 'package:firmus/view/pages/employer_home_swiper/swiping_page.dart';
import 'package:firmus/view/pages/student_home/widges/view_type_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../infra/stores/job_offer_store.dart';
import '../../shared/tiles/large_list_tile.dart';

class JobBasedSwiperPage extends ConsumerWidget {
  const JobBasedSwiperPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedJob = ref.watch(selectedJobProvider);

    if (selectedJob != null) {
      return ref.watch(jobHomeViewType) == HomeViewType.carousel
          ? EmployerSwipingPage(selectedJob)
          : StudentsList(selectedJob);
    }

    final myActiveJobs = ref.watch(employerJobsProvider);
    return myActiveJobs.when(data: (data) {
      final jobs = data.employerJobOffersResponse.activeJobs;

      if (jobs.isEmpty) {
        return const NoActiveOffersWidget();
      }

      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Text(
              "Odaberite oglas za koji želite pregledati potencijalne kandidate",
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: RefreshIndicator.adaptive(
              onRefresh: () async {
                HapticFeedback.lightImpact();
                return ref.refresh(employerJobsProvider.future);
              },
              child: FadeAndTranslate(
                autoStart: true,
                translate: const Offset(0.0, 20.0),
                duration: const Duration(milliseconds: 300),
                child: ListView.separated(
                    // shrinkWrap: true,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemCount: jobs.length,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    itemBuilder: (context, index) {
                      final job = jobs[index].opportunity;
                      return LargeListTile(
                        onTap: () async {
                          final job = jobs[index];
                          ref
                              .read(selectedJobProvider.notifier)
                              .select(job.opportunity);
                        },
                        title: job.jobTitle,
                        location: job.location,
                        rateText: job.rateText,
                        activeFor: job.daysLeft,
                      );
                    }),
              ),
            ),
          ),
        ],
      );
    }, error: (err, st) {
      logger.info(st);
      return const Center(
        child: Text("Failed to load jobs"),
      );
    }, loading: () {
      return const LargeJobsShimmerList();
    });
  }
}
