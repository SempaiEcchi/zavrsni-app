import 'dart:math';

import 'package:fade_and_translate/fade_and_translate.dart';
import 'package:firmus/helper/card_swiper_extension.dart';
import 'package:firmus/infra/stores/job_offer_store.dart';
import 'package:firmus/models/job_offers.dart';
import 'package:firmus/view/pages/student_home/home_page.dart';
import 'package:firmus/view/pages/student_home/single_offer_page.dart';
import 'package:firmus/view/pages/student_home/widges/video_job_swipe_card.dart';
import 'package:firmus/view/shared/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../infra/services/job/job_service.dart';

class CardSwiperWidget extends ConsumerStatefulWidget {
  final JobsResponse cards;
  final CardSwiperController controller;
  final Function(JobOpportunity job, FirmusSwipeType direction) onSwipe;

  @override
  ConsumerState<CardSwiperWidget> createState() => _CardSwiperState();

  const CardSwiperWidget({
    super.key,
    required this.cards,
    required this.controller,
    required this.onSwipe,
  });
}

class _CardSwiperState extends ConsumerState<CardSwiperWidget> {
  late final offers2 = widget.cards.offers;
  @override
  void didUpdateWidget(covariant CardSwiperWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final supportedDirections = [
      CardSwiperDirection.left,
      CardSwiperDirection.right,
      CardSwiperDirection.bottom,
    ];

    return CardSwiper(
      scale: 1,
      controller: widget.controller,
      isLoop: false,
      allowedSwipeDirection: AllowedSwipeDirection.only(
          right: true, left: true, down: true, up: false),
      backCardOffset: Offset.zero,
      cardsCount: offers2.length,
      numberOfCardsDisplayed: min(offers2.length, 1),
      onSwipe: (previousIndex, c, direction) async {
        if (!supportedDirections.contains(direction)) return false;
        widget.onSwipe(offers2[previousIndex], direction.firmusActionType);
        return true;
      },
      onUndo: (previousIndex, currentIndex, direction) {
        return false;
      },
      padding: const EdgeInsets.symmetric(horizontal: 0),
      cardBuilder: (
        context,
        index,
        horizontalOffsetPercentage,
        verticalOffsetPercentage,
      ) {
        return VideoSingleJobCard(
         key: ValueKey(offers2[index].id),
          offer: offers2[index],
         onDragUp: () async {
           return SingleOfferPage(
             offers2[index],
             showControls: false,
           ).show(context);
         },
                  );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

ClipRRect noMoreJobs() {
  return ClipRRect(
    borderRadius: BorderRadius.circular(12.0),
    child: Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
              child: Text(
            "Nema više oglasa koji odgovaraju vašim preferencama",
            textAlign: TextAlign.center,
          )),
          const SizedBox(height: 12),
          Consumer(
            builder: (context, ref, child) {
              return PrimaryButton(
                  onTap: () {
                    ref
                        .read(currentPageProvider.notifier)
                        .changePage(HomePages.profile);
                    ref.invalidate(jobOfferStoreProvider);
                  },
                  text: "Podesi preferencije");
            },
          ),
        ],
      ),
    ),
  );
}
