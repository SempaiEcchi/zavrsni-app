import 'package:fade_and_translate/fade_and_translate.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firmus/helper/logger.dart';
import 'package:firmus/infra/stores/job_offer_store.dart';
import 'package:firmus/infra/stores/user_notifier.dart';
import 'package:firmus/view/pages/student_home/card_swiper.dart';
import 'package:firmus/view/pages/student_home/widges/swiper_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SwipingPage extends ConsumerStatefulWidget {
  const SwipingPage({Key? key}) : super(key: key);

  @override
  ConsumerState<SwipingPage> createState() => _SwipingPageState();
}

class _SwipingPageState extends ConsumerState<SwipingPage> {
  var controller = CardSwiperController();
  @override
  Widget build(BuildContext context) {
    final jobController = ref.read(jobOfferStoreProvider.notifier);
    final visible = ref.watch(jobOfferStoreProvider).when(
          skipLoadingOnRefresh: false,
          skipLoadingOnReload: false,
          loading: () {
            return false;
          },
          data: (d) {
            return d.response.offers.isNotEmpty;
          },
          error: (e, st) {
            return false;
          },
        );
    return Stack(
      children: [
        Positioned.fill(
            child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: ref.watch(jobOfferStoreProvider).when(
                    skipLoadingOnRefresh: false,
                    data: (response) {
                      if (visible == false) return noMoreJobs();
                      return FadeAndTranslate(
                          autoStart: true,
                          translate: const Offset(0.0, 20.0),
                          duration: const Duration(milliseconds: 300),
                          child: CardSwiperWidget(
                            onSwipe: (job, direction) async {
                              final action =
                                  ref.read(jobOfferStoreProvider.notifier);
                              final student = ref
                                  .read(studentNotifierProvider)
                                  .requireValue
                                  .studentEntity;
                              action.swipeJob(job, direction);
                            },
                            cards: response.response,
                            controller: controller,
                          ));
                    },
                    error: (err, st) {
                      logger.info(err);
                      debugPrintStack(stackTrace: st);
                      FirebaseCrashlytics.instance
                          .recordError(err, st, fatal: true);
                      return const Text("Failed");
                    },
                    loading: () {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey.shade300,
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
              visible: visible,
            )),
      ],
    );
  }
}
