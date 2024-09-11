import 'package:firmus/infra/services/job/job_service.dart';
import 'package:firmus/infra/stores/job_offer_store.dart';
import 'package:firmus/models/job_offers.dart';
import 'package:firmus/theme/_light_theme.dart';
import 'package:firmus/view/shared/buttons/animated_tap_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
extension on CardSwiperController {
  void swipeLeft() {
    swipe(CardSwiperDirection.left);
  }

  void swipeRight() {
    swipe(CardSwiperDirection.right);
  }

}
class SwiperControls extends ConsumerWidget {
  final CardSwiperController controller;
  final bool visible;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnimatedOpacity(
      opacity: visible ? 1 : 0,
      duration: const Duration(milliseconds: 300),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AnimatedTapButton(
              child: GestureDetector(
                onTap: () {
                  controller.swipeLeft();
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 55 / 2,
                      backgroundColor: Colors.white,
                    ),
                    CircleAvatar(
                      radius: 39 / 2,
                      backgroundColor: const Color(0x19EC8714),
                      child: Container(
                        decoration: const BoxDecoration(),
                        child: Icon(
                          Icons.clear,
                          color: FigmaColors.statusError,
                          shadows: [
                            BoxShadow(
                              color: FigmaColors.statusError.withOpacity(0.5),
                              blurRadius: 10,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedTapButton(
              child: GestureDetector(
                onTap: () {
                  controller.swipeRight();
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 55 / 2,
                      backgroundColor: Colors.white,
                    ),
                    CircleAvatar(
                      radius: 39 / 2,
                      backgroundColor: const Color(0x191479EC),
                      child: Container(
                        decoration: const BoxDecoration(),
                        child: Icon(
                          Icons.check,
                          color: FigmaColors.primaryPrimary100,
                          shadows: [
                            BoxShadow(
                              color: FigmaColors.primaryPrimary100
                                  .withOpacity(0.5),
                              blurRadius: 10,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  const SwiperControls({
    super.key,
    required this.controller,
    required this.visible,
  });
}

class AdditionalSwiperControls extends ConsumerWidget {
  final JobOpportunity job;

  AdditionalSwiperControls(this.job);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AnimatedTapButton(
              child: GestureDetector(
                onTap: () {
                  ref
                      .read(jobOfferStoreProvider.notifier)
                      .swipeJob(job, FirmusSwipeType.dislike);
                  context.pop();
                },
                child: const CircleAvatar(
                  radius: 56 / 2,
                  backgroundColor: FigmaColors.accentAccent6,
                  child: Icon(Icons.clear),
                ),
              ),
            ),
            AnimatedTapButton(
              child: GestureDetector(
                onTap: () {
                  ref
                      .read(jobOfferStoreProvider.notifier)
                      .swipeJob(job, FirmusSwipeType.like);
                  context.pop();
                },
                child: const CircleAvatar(
                  radius: 56 / 2,
                  child: Icon(Icons.check),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
