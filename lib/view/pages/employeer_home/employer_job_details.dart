import 'package:fade_and_translate/fade_and_translate.dart';
import 'package:firmus/helper/logger.dart';
import 'package:firmus/infra/services/job/entity/employer_job_offers.dart';
import 'package:firmus/infra/services/job/entity/job_offer_details_response.dart';
import 'package:firmus/infra/stores/job_creation_notifier.dart';
import 'package:firmus/models/job_offers.dart';
import 'package:firmus/router/router.dart';
import 'package:firmus/view/pages/employeer_home/controller/employer_jobs_notifier.dart';
import 'package:firmus/view/pages/employeer_home/widgets/applicant_list_tile.dart';
import 'package:firmus/view/pages/employer_home_swiper/controller/student_swipe_controller.dart';
import 'package:firmus/view/pages/employer_home_swiper/students_list.dart';
import 'package:firmus/view/pages/student_home/home_page.dart';
import 'package:firmus/view/shared/buttons/animated_tap_button.dart';
import 'package:firmus/view/shared/lists/tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../theme/_light_theme.dart';
import '../../shared/buttons/secondary_button.dart';

class EmployerJobDetailsPage extends HookConsumerWidget {
  final EmployerJobOffer jobDetails;
  const EmployerJobDetailsPage({Key? key, required this.jobDetails})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobOp = jobDetails.opportunity;

    final dets = ref.watch(employerJobDetailsProvider(jobDetails));

    // final c = CustomScrollView(
    //   slivers: [
    //     _JobDetailsHeader(jobOp),
    //     SliverList(
    //       delegate: SliverChildBuilderDelegate(
    //         (BuildContext context, int index) {
    //           return Card(
    //             margin: EdgeInsets.all(15),
    //             child: Container(
    //               color: Colors.orange[100 * (index % 12 + 1)],
    //               height: 60,
    //               alignment: Alignment.center,
    //               child: Text(
    //                 "List Item $index",
    //                 style: TextStyle(fontSize: 30),
    //               ),
    //             ),
    //           );
    //         },
    //         childCount: 10,
    //       ),
    //     ),
    //   ],
    // );

    return Scaffold(
      floatingActionButton: SwipeNewApplicantsButton(
        jobOpportunity: jobOp,
        count: dets.valueOrNull?.jobOfferDetailsResponse.newApplicantsCount,
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            _JobDetailsHeader(jobDetails),
            const SizedBox(
              height: 26,
            ),
            const RoundedTabBar(tabs: [
              "⭐ Matchevi",
              "Zaposleni",
            ]),
            const SizedBox(
              height: 12,
            ),
            dets.when(
              skipError: true,
              // skipLoadingOnReload: true,
              // skipLoadingOnRefresh: true,
              data: (data) {
                return Expanded(
                  child: TabBarView(
                    children: [
                      _body(context,
                          data.jobOfferDetailsResponse.matchedApplicants, ref),
                      _body(context, [], ref),
                    ],
                  ),
                );
              },
              loading: () {
                return const Expanded(
                    child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: ShimmerStudentList(),
                ));
              },
              error: (err, stack) {
                logger.info(stack);
                return Center(
                  child: Text(err.toString()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _body(
      BuildContext context, List<JobOfferApplicant> applicants, WidgetRef ref) {
    if (applicants.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            applicants is List<MatchedApplicant>
                ? "Nema matcheva"
                : "Nema zaposlenih",
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Colors.grey),
          ),
          const SizedBox(
            height: 16,
          ),
        ],
      );
    }

    return RefreshIndicator.adaptive(
      onRefresh: () async {
        HapticFeedback.lightImpact();
        return ref.refresh(employerJobDetailsProvider(jobDetails).future);
      },
      child: FadeAndTranslate(
        autoStart: true,
        translate: const Offset(0.0, 20.0),
        duration: const Duration(milliseconds: 300),
        child: ListView.separated(
            // shrinkWrap: true,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemCount: applicants.length,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            itemBuilder: (context, index) {
              final unread = ref.watch(unreadMessagesProvider(
                  (applicants[index].student.id, jobDetails.opportunity.id)));
              return AdminApplicantListTile(
                applicant: applicants[index],
                unreadMessageCount: unread.valueOrNull ?? 0,
                jobOpportunity: jobDetails.opportunity,
              );
            }),
      ),
    );
  }
}

class SwipeNewApplicantsButton extends ConsumerWidget {
  final JobOpportunity jobOpportunity;
  final int? count;
  const SwipeNewApplicantsButton({
    required this.jobOpportunity,
    required this.count,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnimatedTapButton(
      onTap: () {
        ref.read(selectedJobProvider.notifier).select(jobOpportunity);
        ref.invalidate(swipableStudentsProvider(jobOpportunity.id));
        ref.read(currentPageProvider.notifier).changePage(HomePages.swiper);
        GoRouter.of(context).pushReplacement(RoutePaths.home);
      },
      child: Container(
        width: 167,
        height: 44,
        decoration: ShapeDecoration(
          color: const Color(0xFF007AFF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x1F000000),
              blurRadius: 20,
              offset: Offset(0, 6.25),
              spreadRadius: 0,
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              if (count != null && count != 0) ...[
                CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.white,
                  child: Text(count.toString(),
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            height: 0.09,
                          )),
                ),
                Expanded(
                  child: FittedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Nove prijave",
                          maxLines: 1,
                          style:
                              Theme.of(context).textTheme.labelMedium!.copyWith(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    height: 0.09,
                                  )),
                    ),
                  ),
                ),
              ] else ...[
                Expanded(
                  child: FittedBox(
                    child: Text("Predloženi kandidati",
                        style:
                            Theme.of(context).textTheme.labelMedium!.copyWith(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  height: 0.09,
                                )),
                  ),
                ),
              ],
              const Icon(
                Icons.arrow_forward,
                color: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class StickySpacer extends StatelessWidget {
  final double height;
  const StickySpacer({Key? key, required this.height}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
        pinned: true,
        delegate: _StickyTabBarDelegate(
            child: PreferredSize(
          preferredSize: Size.fromHeight(height),
          child: SizedBox(
            width: 100,
            height: height,
          ),
        )));
  }
}

class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final PreferredSizeWidget child;
  const _StickyTabBarDelegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  double get maxExtent => child.preferredSize.height;

  @override
  double get minExtent => child.preferredSize.height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

class _JobDetailsHeader extends ConsumerWidget {
  final EmployerJobOffer employerJobOffer;

  const _JobDetailsHeader(this.employerJobOffer);

  JobOpportunity get jobOpportunity => employerJobOffer.opportunity;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //sliver app bar
    final activeFor = jobOpportunity.daysLeft;
    return Container(
      height: 190,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.vertical(bottom: Radius.elliptical(450, 35))),
      child: SafeArea(
        top: true,
        child: Padding(
          padding: const EdgeInsets.only(left: 0, right: 0),
          child: Row(
            children: [
              const BackButton(
                color: FigmaColors.neutralNeutral4,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildTitle(context, ref),
                    buildBackground(context, activeFor),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTitle(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: Text(
            jobOpportunity.jobTitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        SecondaryButton(
            smallMargin: true,
            onTap: () {
              if (employerJobOffer is ElapsedEmployerJobOffer) {
                ref
                    .read(jobOpCreationNotifierProvider.notifier)
                    .loadJobOpportunity(jobOpportunity);

                GoRouter.of(context).push(RoutePaths.jobCreationPage);
              } else {
                GoRouter.of(context)
                    .push(RoutePaths.jobOpEdit, extra: jobOpportunity);
              }
            },
            text: (employerJobOffer is ElapsedEmployerJobOffer)
                ? "Ponovi oglas"
                : "Uredi oglas"),
      ],
    );
  }

  Widget buildBackground(BuildContext context, int activeFor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            if (jobOpportunity.location.isNotEmpty) ...[
              Transform.translate(
                offset: const Offset(0, 1),
                child: const Icon(
                  Icons.location_on,
                  color: FigmaColors.neutralNeutral4,
                  size: 18,
                ),
              ),
              const SizedBox(
                width: 4,
              ),
              Text(
                jobOpportunity.location,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(),
              ),
              const SizedBox(
                width: 8,
              ),
            ],
            Transform.translate(
              offset: const Offset(0, 1),
              child: const Icon(
                Icons.wallet,
                color: FigmaColors.neutralNeutral4,
                size: 18,
              ),
            ),
            const SizedBox(
              width: 4,
            ),
            Text(
              jobOpportunity.rateText,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: FigmaColors.neutralNeutral1,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        Row(
          children: [
            Transform.translate(
              offset: const Offset(0, 1),
              child: Icon(
                Icons.calendar_month,
                color: jobOpportunity.applicationDeadlineColor ??
                    FigmaColors.neutralNeutral4,
                size: 18,
              ),
            ),
            const SizedBox(
              width: 4,
            ),
            Text(
              jobOpportunity.formattedApllicationDeadline,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: jobOpportunity.applicationDeadlineColor,
                  ),
            ),
            const SizedBox(
              width: 8,
            ),
            if (activeFor == 0)
              const Text("Oglas je istekao")
            else
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Aktivno još: ',
                      style: TextStyle(
                        color: Color(0xFF6C7580),
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                      text: activeFor == 1 ? '1 dan' : '$activeFor dana',
                      style: const TextStyle(
                        color: Color(0xFF6C7580),
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(),
              )
          ],
        ),
      ],
    );
  }
}
