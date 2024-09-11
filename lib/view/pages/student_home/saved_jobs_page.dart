import 'package:firmus/infra/stores/job_offer_store.dart';
import 'package:firmus/localizations.dart';
import 'package:firmus/models/student_job_offers.dart';
import 'package:firmus/view/pages/employeer_home/company_active_job_list.dart';
import 'package:firmus/view/pages/student_home/single_offer_page.dart';
import 'package:firmus/view/pages/student_home/widges/saved_job_tile.dart';
import 'package:firmus/view/shared/lists/tab_bar.dart';
import 'package:firmus/view/shared/tiles/jobs/basic_info_job_tile.dart';
import 'package:firmus/view/shared/tiles/jobs/job_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../infra/stores/student_jobs_store.dart';

class SavedJobsPage extends HookConsumerWidget {
  const SavedJobsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      ref.read(studentJobsProvider.notifier).refreshSavedJobs();
      return null;
    }, const []);

    final jobs = ref.watch(studentJobsProvider);
    bool isLoading = jobs is AsyncLoading && jobs.hasValue == false;
    return DefaultTabController(
        length: 4,
        child: Column(
          children: [
            RoundedTabBar(
              breakPoint: 3,
              large: true,
              tabs: [
                context.loc.matches,
                context.loc.applications,
                context.loc.active,
                context.loc.saved,
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            Expanded(
              child: TabBarView(children: [
                body(
                  jobs.valueOrNull?.matchedJobs ?? [],
                  ref,
                  isLoading,
                ),
                body(
                  jobs.valueOrNull?.appliedJobs ?? [],
                  ref,
                  isLoading,
                ),
                body(
                  jobs.valueOrNull?.activeJobs ?? [],
                  ref,
                  isLoading,
                ),
                body(
                  jobs.valueOrNull?.savedJobs ?? [],
                  ref,
                  isLoading,
                ),
              ]),
            ),
          ],
        ));
  }

  Widget body(
    List<StudentJobOffer> offers,
    ref,
    bool isLoading,
  ) {
    String text = "Nema oglasa gdje ste matchani";
    if (offers is List<AppliedJobOffer>) {
      text = "Nema oglasa gdje ste se prijavili";
    }
    if (offers is List<SavedJobOffer>) {
      text = "Nema spremljenih oglasa";
    }
    if (offers is List<ActiveJobOffer>) {
      text = "Nema aktivnih oglasa";
    }
    if (isLoading) {
      return const LargeJobsShimmerList(
        height: 95,
      );
    }

    return RefreshIndicator.adaptive(
      onRefresh: () async {
        HapticFeedback.lightImpact();
        await ref.read(jobOfferStoreProvider.notifier).refreshSavedJobs();
      },
      child: offers.isEmpty
          ? CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: BasicEmptyWidget(text),
                )
              ],
            )
          : ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(
                    height: 8,
                  ),
              padding: EdgeInsets.zero,
              itemCount: offers.length,
              itemBuilder: (context, index) {
                final job = offers[index];
                // return RoundedJobListTile(job: job.opportunity);
                if (job is SavedJobOffer) {
                  return BasicInfoJobTile(
                    job: job.opportunity,
                  );
                }

                if (job is MatchedJobOffer) {
                  return BasicInfoJobTile(
                      job: job.opportunity,
                      onTap: () {
                        SingleOfferPage(
                          job.opportunity,
                          showControls: false,
                        ).show(context);
                      });
                }
                if (job is ActiveJobOffer) {
                  return RoundedJobCard(
                    indicatorWidget: ActiveIndicatorWidget(isActive:job.completionDate == null),
                      onTap: () {
                        SingleOfferPage(
                          job.opportunity,
                          showControls: false,
                        ).show(context);
                      },
                      job: job.opportunity);
                }

                return StudentJobTile(
                  studentJobOffer: job,
                );
              }),
    );
  }
}

class BasicEmptyWidget extends StatelessWidget {
  final String text;

  const BasicEmptyWidget(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: Theme.of(context)
            .textTheme
            .titleLarge!
            .copyWith(color: Colors.grey),
      ),
    );
  }
}
