import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firmus/helper/card_swiper_extension.dart';
import 'package:firmus/helper/logger.dart';
import 'package:firmus/infra/services/job/entity/job_offer_details_response.dart';
import 'package:firmus/infra/stores/job_offer_store.dart';
import 'package:firmus/models/job_offers.dart';
import 'package:firmus/view/pages/employer_home_swiper/controller/student_swipe_controller.dart';
import 'package:firmus/view/shared/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:video_player/video_player.dart';

import '../../../infra/services/job/job_service.dart';
import '../../../main.dart';
import '../../../theme/_light_theme.dart';

class StudentSwiperWidget extends ConsumerStatefulWidget {
  final List<JobOfferApplicant> students;
  final JobOpportunity job;
  final CardSwiperController controller;
  final Function(JobOfferApplicant student, FirmusSwipeType direction) onSwipe;
  @override
  ConsumerState<StudentSwiperWidget> createState() => _CardSwiperState();

  const StudentSwiperWidget({
    super.key,
    required this.students,
    required this.job,
    required this.controller,
    required this.onSwipe,
  });
}

class _CardSwiperState extends ConsumerState<StudentSwiperWidget> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final supportedDirections = [
      CardSwiperDirection.left,
      CardSwiperDirection.right,
      CardSwiperDirection.bottom,
    ];

    if (widget.students.isEmpty) return noMoreStudents();

    return CardSwiper(
      key: ValueKey(widget.job.id),
      scale: 1,
      controller: widget.controller,
      isLoop: false,
      allowedSwipeDirection: AllowedSwipeDirection.only(
          right: true, left: true, down: true, up: false),
      backCardOffset: Offset.zero,
      cardsCount: widget.students.length,
      numberOfCardsDisplayed: widget.students.length,
      onSwipe: (previousIndex, c, direction) {
        setState(() {
          currentIndex = 0;
        });

        if (!supportedDirections.contains(direction)) return false;

        widget.onSwipe(
            widget.students[previousIndex], direction.firmusActionType);

        return true;
      },
      onUndo: (previousIndex, currentIndex, direction) {
        return true;
      },
      padding: const EdgeInsets.symmetric(horizontal: 0),
      cardBuilder: (
        context,
        index,
        horizontalOffsetPercentage,
        verticalOffsetPercentage,
      ) {
        return StudentVideoCard(
          widget.students[index],
          onDragUp: () {},
        );
      },
    );
  }

  ClipRRect noMoreStudents() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
                child: Text(
              "Nema više prijavljenih studenata",
              textAlign: TextAlign.center,
            )),
            const SizedBox(height: 12),
            PrimaryButton(
                onTap: () {
                  ref.refresh(swipableStudentsProvider(widget.job.id));
                },
                text: "Pregledaj ponovno"),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class StudentVideoCard extends ConsumerStatefulWidget {
  final JobOfferApplicant student;
  final Function onDragUp;
  const StudentVideoCard(this.student, {required this.onDragUp, Key? key})
      : super(key: key);

  @override
  ConsumerState<StudentVideoCard> createState() => _StudentVideoCardState();
}

class _StudentVideoCardState extends ConsumerState<StudentVideoCard> {
  Offset? _tdPos;

  late StudentApplicant student = widget.student.student;
  Timer? debounceTimer;

  VideoPlayerController? controller;

  @override
  void initState() {
    super.initState();

    if (student.videos.isNotEmpty) {
      controller =
          ref.read(videoControllerWarmuperProvider)[student.videos.first!.videoUrl];
      controller!.play().then((value) {
        setState(() {});
      });
    }
  }

  @override
  void deactivate() {
    controller?.pause();
    super.deactivate();
  }

  @override
  void activate() {
    controller?.play();
    super.activate();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: (event) {
        _tdPos = null;
        debounceTimer = Timer(const Duration(milliseconds: 200), () async {
          if (_tdPos == null) return;

          final diff = (_tdPos!.dy - event.position.dy).abs();
          logger.info(diff);

          bool didMoveUp = _tdPos!.dy < event.position.dy && diff > 100;
          if (didMoveUp) {
            controller?.pause();

            await widget.onDragUp();
            controller?.play();
          }
        });
      },
      onPointerUp: (event) {
        // debounceTimer?.cancel();
      },
      onPointerMove: (event) {
        _tdPos = event.position;
      },
      child: LayoutBuilder(builder: (context, snapshot) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: Center(
            child: Container(
              color: Colors.white,
              height: snapshot.maxHeight,
              child: SingleChildScrollView( keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,

                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Container(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    topRight: Radius.circular(12)),
                                child: student.videos.isNotEmpty
                                    ? Container(
                                        constraints: BoxConstraints(
                                          maxHeight: snapshot.maxHeight,
                                        ),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: SizedBox.expand(
                                            child: FittedBox(
                                              fit: BoxFit.cover,
                                              child: SizedBox(
                                                width: controller!
                                                        .value.size.width ??
                                                    0,
                                                height: controller!
                                                        .value.size.height ??
                                                    0,
                                                child: VideoPlayer(controller!),
                                              ),
                                            ),
                                          ),
                                        ))
                                    : CachedNetworkImage(
                                        height: snapshot.maxHeight,
                                        width: double.maxFinite,
                                        fit: BoxFit.cover,
                                        imageUrl: student.imageUrl,
                                      ),
                              ),
                            ),
                            Positioned(
                              top: 20,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 8.0, left: 24, right: 24),
                                  child: Container(
                                    width: snapshot.maxWidth,
                                    constraints:
                                        const BoxConstraints(maxWidth: 600),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        const _StudentInfoTag(
                                          backgroundColor: Color(0xff2D6A6A),
                                          center: Icon(Icons.cake),
                                          caption: "${0} godina",
                                        ),
                                        Container(
                                          height: 29,
                                          width: 1,
                                          color: Colors.white,
                                        ),
                                        const _StudentInfoTag(
                                          backgroundColor: Color(0xffE9AD8C),
                                          center: Icon(Icons.school_outlined),
                                          caption: "Faks",
                                        ),
                                        if (student.location.isNotEmpty) ...[
                                          Container(
                                            height: 29,
                                            width: 1,
                                            color: Colors.white,
                                          ),
                                          _StudentInfoTag(
                                            backgroundColor:
                                                const Color(0xff7CC6D6),
                                            center:
                                                const Icon(Icons.location_on),
                                            caption: student.location,
                                          )
                                        ]
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          bottom: 20,
                          child: Container(
                            width: snapshot.maxWidth,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      color: Colors.black,
                                      child: Text(
                                        student.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium!
                                            .copyWith(color: Colors.white),
                                      ),
                                    ),
                                    const Spacer(),
                                    IconButton(
                                        onPressed: () async {
                                          controller?.pause();
                                          await widget.onDragUp();
                                          controller?.play();
                                        },
                                        icon: const Icon(Icons.info_outline))
                                  ],
                                ),
                                // Align(
                                //   alignment: Alignment.topLeft,
                                //   child: Hero(
                                //     tag: "jobtagz${widget.offer.id}",
                                //     child: Wrap(
                                //       spacing: 8,
                                //       runSpacing: 8,
                                //       alignment: WrapAlignment.start,
                                //       children: widget.offer.tags
                                //           .where((element) => !element.superTag)
                                //           .map((e) => JobTagChip(
                                //                 tag: e,
                                //               ))
                                //           .toList(),
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _StudentInfoTag extends StatelessWidget {
  final Color backgroundColor;
  final Widget center;
  final String caption;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 33,
          height: 33,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: backgroundColor,
          ),
          child: Center(
            child: FittedBox(
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Container(child: center),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        Container(
          height: 20,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: FigmaColors.statusInfoBG,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          child: Text(caption,
              style: textStyles.paragraphXSmallHeavy.copyWith(
                color: FigmaColors.neutralNeutral2,
              )),
        ),
      ],
    );
  }

  const _StudentInfoTag({
    required this.backgroundColor,
    required this.center,
    required this.caption,
  });
}
