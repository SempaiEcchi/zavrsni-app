import 'package:fade_and_translate/fade_and_translate.dart';
import 'package:firmus/helper/logger.dart';
import 'package:firmus/infra/services/job/entity/employer_job_offers.dart';
import 'package:firmus/router/router.dart';
import 'package:firmus/view/pages/employeer_home/controller/employer_jobs_notifier.dart';
import 'package:firmus/view/pages/student_home/saved_jobs_page.dart';
import 'package:firmus/view/shared/buttons/primary_button.dart';
import 'package:firmus/view/shared/lists/tab_bar.dart';
import 'package:firmus/view/shared/tiles/large_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CompanyActiveJobsList extends HookConsumerWidget {
  const CompanyActiveJobsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      ref.refresh(employerJobsProvider);
      return null;
    }, const []);

    final _ = ref.watch(employerJobsProvider);
    logger.info(_.isRefreshing);
    final jobs = _.valueOrNull;
    return DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const RoundedTabBar(tabs: [
              "Aktivni oglasi",
              "Istekli oglasi",
            ]),
            const SizedBox(
              height: 12,
            ),
            // const Expanded(child: LargeJobsShimmerList())

            if (jobs == null || _.isRefreshing)
              const Expanded(child: LargeJobsShimmerList())
            else
              Expanded(
                child: TabBarView(children: [
                  _body(
                      context, jobs.employerJobOffersResponse.activeJobs, ref),
                  _body(
                      context, jobs.employerJobOffersResponse.elapsedJobs, ref),
                ]),
              ),
          ],
        ));
  }

  Widget _body(BuildContext context, List<EmployerJobOffer> jobs, ref) {
    return RefreshIndicator.adaptive(
      onRefresh: () async {
        HapticFeedback.lightImpact();
        return ref.refresh(employerJobsProvider.future);
      },
      child: jobs.isEmpty
          ? _empty(context, jobs)
          : FadeAndTranslate(
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
                        GoRouter.of(context)
                            .push(RoutePaths.employerJobDetails, extra: job);
                      },
                      title: job.jobTitle,
                      location: job.location,
                      rateText: job.rateText,
                      activeFor: job.daysLeft,
                    );
                  }),
            ),
    );
  }

  Widget _empty(context, jobs) {
    if (jobs is List<ActiveEmployerJobOffer>) {
      return const NoActiveOffersWidget();
    }
    return const BasicEmptyWidget("Nemate isteklih oglasa");
  }
}

class NoActiveOffersWidget extends StatelessWidget {
  const NoActiveOffersWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Nemate aktivnih oglasa",
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Colors.grey),
          ),
          const SizedBox(
            height: 16,
          ),
          PrimaryButton(
              onTap: () {
                GoRouter.of(context).push(RoutePaths.jobCreationPage);
              },
              text: 'Dodaj oglas'),
        ],
      ),
    );
  }
}

class LargeJobsShimmerList extends StatelessWidget {
  final double height;
  const LargeJobsShimmerList({
    super.key,
    this.height = 105,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        separatorBuilder: (context, index) => const SizedBox(
              height: 16,
            ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemCount: 20,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey.shade300,
            ),
            height: height,
          )
              .animate(
                onPlay: (c) => c.repeat(reverse: true),
              )
              .blurXY(
                begin: 0.0,
                end: 1,
                duration: const Duration(milliseconds: 2000),
              )
              .shimmer(
                duration: const Duration(milliseconds: 2000),
              );
        });
  }
}
