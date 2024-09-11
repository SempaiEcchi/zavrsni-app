import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firmus/main.dart';
import 'package:firmus/models/job_offers.dart';
import 'package:firmus/router/router.dart';
import 'package:firmus/theme/_light_theme.dart';
import 'package:firmus/view/shared/buttons/animated_tap_button.dart';
import 'package:firmus/view/shared/popups/cv_video_player_popup.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../helper/synchronizer.dart';
import '../../../shared/buttons/firmus_back_button.dart';

class SingleJobCard extends StatefulWidget {
  final JobOpportunity jobOpportunity;
  final bool showControls;

  const SingleJobCard({
    super.key,
    required this.jobOpportunity,
    required this.showControls,
  });

  @override
  State<SingleJobCard> createState() => _SingleJobCardState();
}

class _SingleJobCardState extends State<SingleJobCard> {
  final scrollController = ScrollController();
  double offset = 0;
  late final s = Synchronizer(() {
    GoRouter.of(context).pop();
  });

  @override
  void initState() {
    Future(() {
      scrollController.addListener(() {
        setState(() {
          offset = scrollController.offset;
          if (offset < -100) {
            s.runOnce();
          }
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SafeArea(
            top: true,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: FirmusBackButton(),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      widget.jobOpportunity.jobTitle,
                      style: textStyles.f6Regular1200,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 600),
              child: SingleChildScrollView( keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,

                controller: scrollController,
                physics: AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (!widget.showControls)
                        Container(
                          width: 125,
                          height: 125,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: widget.jobOpportunity.thumbnailUrl == null
                                ? null
                                : DecorationImage(
                                    fit: BoxFit.cover,
                                    image: CachedNetworkImageProvider(
                                      widget.jobOpportunity.thumbnailUrl!,
                                    ),
                                  ),
                          ),
                          child: Center(
                            child: IconButton(
                              onPressed: () {
                                CvVideoPlayerPopup(
                                  videoUrl: widget.jobOpportunity.url,
                                  thumbnailUrl:
                                      widget.jobOpportunity.thumbnailUrl,
                                ).show(context);
                              },
                              icon: Icon(
                                Icons.play_circle,
                                size: 40,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ),
                      _CompanyTile(
                        company: widget.jobOpportunity.company,
                        jobId: widget.jobOpportunity.id,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        widget.jobOpportunity.shortDescription,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        "Opis posla",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Hero(
                        tag: "jobDescription${widget.jobOpportunity.id}",
                        child: Text(widget.jobOpportunity.jobDescription,
                            style: Theme.of(context).textTheme.bodyMedium),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double height(BuildContext context) {
    final calc = MediaQuery.of(context).size.height / 4 - offset;
    return max(120, calc);
  }
}

class _CompanyTile extends StatelessWidget {
  final SimpleCompany company;
  final String jobId;

  const _CompanyTile({
    required this.company,
    required this.jobId,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedTapButton(
      onTap: () {
        GoRouter.of(context).push(RoutePaths.companyInfo, extra: company);
      },
      child: Container(
        height: 53,
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
            Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  company.name,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(height: 0),
                ),
                Text(
                  "${company.openPositions} otvorena mjesta",
                  style: textStyles.paragraphXSmallHeavy
                      .copyWith(color: FigmaColors.neutralNeutral4, height: 0),
                ),
              ],
            ),
            const Spacer(),
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
