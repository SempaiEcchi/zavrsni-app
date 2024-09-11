import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firmus/gen/assets.gen.dart';
import 'package:firmus/infra/stores/job_offer_store.dart';
import 'package:firmus/localizations.dart';
import 'package:firmus/main.dart';
import 'package:firmus/models/job_offers.dart';
import 'package:firmus/router/router.dart';
import 'package:firmus/theme/_light_theme.dart';
import 'package:firmus/view/pages/student_home/widges/job_tag_chip.dart';
import 'package:firmus/view/shared/buttons/animated_tap_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoSingleJobCard extends ConsumerStatefulWidget {
  final JobOpportunity offer;

  final Function onDragUp;

  const VideoSingleJobCard({
    super.key,
    required this.offer,
    required this.onDragUp,
  });

  @override
  ConsumerState<VideoSingleJobCard> createState() => _VideoSingleJobCardState();
}

class _VideoSingleJobCardState extends ConsumerState<VideoSingleJobCard> {
  Offset? _tdPos;

  Timer? debounceTimer;

  VideoPlayerController? controller;

  @override
  void initState() {
    super.initState();
    initVideo();
  }

  void initVideo() async {
    if (!widget.offer.isVideo) return;
    controller = ref.read(videoControllerWarmuperProvider)[widget.offer.url];
    if (kDebugMode) {
      controller!.setVolume(0);
    }
    controller!.play();
  }

  get id => widget.offer.jobTitle;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: ValueKey(widget.offer.id),
      onVisibilityChanged: (visibilityInfo) {
        if (controller == null) return;
        if (controller!.hasListeners == false) return;
        if (visibilityInfo.visibleFraction == 0) {
          controller?.pause();
        } else {
          controller?.play();
        }
      },
      child: Listener(
        behavior: HitTestBehavior.opaque,
        onPointerDown: (event) {
          _tdPos = null;
          debounceTimer = Timer(const Duration(milliseconds: 200), () async {
            if (_tdPos == null) return;

            final diff = (_tdPos!.dy - event.position.dy).abs();

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
            borderRadius: BorderRadius.circular(15.0),
            child: Center(
              child: Container(
                color: Colors.white,
                height: snapshot.maxHeight,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Hero(
                      tag: widget.offer.videoHeroTag,
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Container(
                            child: widget.offer.isVideo
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
                                            width: controller!.value.size.width,
                                            height:
                                                controller!.value.size.height,
                                            child: VideoPlayer(controller!),
                                          ),
                                        ),
                                      ),
                                    ))
                                : CachedNetworkImage(
                                    height: snapshot.maxHeight,
                                    width: double.maxFinite,
                                    fit: BoxFit.cover,
                                    imageUrl: widget.offer.url,
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
                                      _JobInfoTag(
                                        backgroundColor:
                                            const Color(0xff2D6A6A),
                                        center: const Icon(
                                          Icons.euro,
                                          size: 16,
                                        ),
                                        caption: widget.offer.rateText,
                                      ),
                                      Container(
                                        height: 29,
                                        width: 1,
                                        color: Colors.white,
                                      ),
                                      _JobInfoTag(
                                        backgroundColor:
                                            const Color(0xffE9AD8C),
                                        center: const Icon(Icons.access_time),
                                        caption: DateFormat("dd/MM/y")
                                            .format(widget.offer.applyDeadline),
                                      ),
                                      if (widget.offer.location.isNotEmpty) ...[
                                        Container(
                                          height: 29,
                                          width: 1,
                                          color: Colors.white,
                                        ),
                                        _JobInfoTag(
                                          backgroundColor:
                                              const Color(0xff7CC6D6),
                                          center: const Icon(Icons.location_on),
                                          caption: widget.offer.location,
                                        )
                                      ]
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topCenter,
                            child: SafeArea(
                              top: true,
                              minimum: const EdgeInsets.only(
                                  top: 10.0, left: 12, right: 12),
                              child: Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                alignment: WrapAlignment.center,
                                children: widget.offer.tags
                                    .where((element) => element.superTag)
                                    .map((e) => JobTagChip(
                                          tag: e,
                                        ))
                                    .toList(),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      child: Container(
                        width: snapshot.maxWidth,
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Hero(
                                    tag: "jobTitle${widget.offer.id}",
                                    child: Text(
                                      widget.offer.jobTitle,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium!
                                          .copyWith(color: Colors.white),
                                    ),
                                  ),
                                ),
                                IconButton(
                                    onPressed: () async {
                                      controller?.pause();
                                      await widget.onDragUp();
                                      controller?.play();
                                    },
                                    icon: const Icon(Icons.info_outline))
                              ],
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Hero(
                                tag: "jobtagz${widget.offer.id}",
                                child: Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  alignment: WrapAlignment.start,
                                  children: widget.offer.tags
                                      .where((element) => !element.superTag)
                                      .map((e) => JobTagChip(
                                            tag: e,
                                          ))
                                      .toList(),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Container(
                              alignment: Alignment.center,
                              child: CompanyTile(
                                company: widget.offer.company,
                                jobId: widget.offer.id,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

const double _kScrollForMoreInfoHeight = 0;

class _ScrollForMoreInfo extends StatelessWidget {
  const _ScrollForMoreInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _kScrollForMoreInfoHeight,
      child: Assets.images.scrollForMoreInfo.image(height: 24, width: 113),
    );
  }
}

const double _kCompanyTileHeight = 53;

class CompanyTile extends StatelessWidget {
  final SimpleCompany company;
  final String jobId;

  const CompanyTile({
    super.key,
    required this.company,
    required this.jobId,
  });

  @override
  Widget build(BuildContext context) {
    final style = textStyles.paragraphXSmallHeavy
        .copyWith(color: FigmaColors.neutralNeutral4, height: 0);

    return Hero(
      tag: "${company.id}$jobId+company",
      child: AnimatedTapButton(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          GoRouter.of(context).push(RoutePaths.companyInfo, extra: company);
        },
        child: Container(
          height: _kCompanyTileHeight,
          key: ValueKey(company.id),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
              color: const Color(0xffF4F6F9),
              borderRadius: BorderRadius.circular(10)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: CachedNetworkImageProvider(company.logoUrl),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      company.name,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            height: 0,
                          ),
                    ),
                    Text(
                      context.loc.companyOpenPositions(company.openPositions),
                      style: style,
                    ),
                  ],
                ),
              ),
              if (company.isGreen)
                const Icon(
                  Icons.energy_savings_leaf_rounded,
                  color: Colors.green,
                ),
              const SizedBox(
                width: 12,
              ),
              Column(
                children: [
                  const Icon(
                    Icons.star,
                    color: Color(0xffEC8714),
                  ),
                  Text(company.rating.toStringAsFixed(1),
                      style: textStyles.paragraphTinyHeavy
                          .copyWith(color: FigmaColors.neutralNeutral2)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _JobInfoTag extends StatelessWidget {
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

  const _JobInfoTag({
    required this.backgroundColor,
    required this.center,
    required this.caption,
  });
}
