import 'package:fade_and_translate/fade_and_translate.dart';
import 'package:firmus/helper/logger.dart';
import 'package:firmus/infra/services/job/entity/job_offer_details_response.dart';
import 'package:firmus/infra/services/job/job_service.dart';
import 'package:firmus/models/job_offers.dart';
import 'package:firmus/view/pages/employer_home_swiper/controller/student_swipe_controller.dart';
import 'package:firmus/view/pages/employer_home_swiper/student_swiper.dart';
import 'package:firmus/view/pages/student_home/widges/swiper_controls.dart';
import 'package:firmus/view/shared/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmployerSwipingPage extends ConsumerStatefulWidget {
  final JobOpportunity job;

  const EmployerSwipingPage(this.job, {super.key});

  @override
  ConsumerState<EmployerSwipingPage> createState() => _SwipingPageState();
}

class _SwipingPageState extends ConsumerState<EmployerSwipingPage> {
  var controller = CardSwiperController();
  @override
  Widget build(BuildContext context) {
    final controlsVisible =
        ref.watch(swipableStudentsProvider(widget.job.id)).when(
              skipLoadingOnRefresh: false,
              skipLoadingOnReload: false,
              loading: () {
                return false;
              },
              data: (d) {
                return d.students.isNotEmpty;
              },
              error: (e, st) {
                return false;
              },
            );
    return Stack(
      children: [
        Positioned.fill(
            child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: ref.watch(swipableStudentsProvider(widget.job.id)).when(
                    skipLoadingOnRefresh: false,
                    data: (response) {
                      if (response.students.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Nemate više niti jednog kandidata za \"${widget.job.jobTitle}\"",
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(color: Colors.grey),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              PrimaryButton(
                                onTap: () {
                                  ref
                                      .read(selectedJobProvider.notifier)
                                      .unselect();
                                },
                                text: "Pogledajte druge oglase",
                              )
                            ],
                          ),
                        );
                      }

                      return FadeAndTranslate(
                          autoStart: true,
                          translate: const Offset(0.0, 20.0),
                          duration: const Duration(milliseconds: 300),
                          child: StudentSwiperWidget(
                            students: response.students,
                            controller: controller,
                            onSwipe: (JobOfferApplicant student,
                                FirmusSwipeType direction) async {
                              ref
                                  .read(swipableStudentsProvider(widget.job.id)
                                      .notifier)
                                  .swipeStudent(student, direction);
                            },
                            job: widget.job,
                          ));
                    },
                    error: (err, st) {
                      logger.info(err);
                      debugPrintStack(stackTrace: st);
                      return const Text("Failed");
                    },
                    loading: () {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(12),
                        ),
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
                    }))),
        Align(
            alignment: Alignment.center,
            child: SwiperControls(
              controller: controller,
              visible: controlsVisible,
            )),
      ],
    );
  }
}
