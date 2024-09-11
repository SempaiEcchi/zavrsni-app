import 'package:cached_network_image/cached_network_image.dart';
import 'package:firmus/models/job_offers.dart';
import 'package:firmus/models/student_job_offers.dart';
import 'package:flutter/material.dart';
import 'package:firmus/helper/logger.dart';

import '../../../../main.dart';
import '../../../../theme/_light_theme.dart';
import '../../../pages/student_home/single_offer_page.dart';
import '../../buttons/animated_tap_button.dart';

class ActiveJobCard extends StatelessWidget {
  final ActiveJobOffer job;

  const ActiveJobCard({
    Key? key,
    required this.job,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RoundedJobCard(job: job.opportunity);
  }
}

class RoundedJobCard extends StatelessWidget {
  final JobOpportunity job;
  final Widget? indicatorWidget;
  final Widget? bottomWidget;
  final VoidCallback? onTap;
  const RoundedJobCard({
    Key? key,
    required this.job,
    this.indicatorWidget,
    this.bottomWidget,
    this.onTap,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final style = textStyles.paragraphXSmallHeavy
        .copyWith(color: FigmaColors.neutralNeutral4, height: 0);

    final company = job.company;

    return ValueListenableBuilder(
      builder: (context, isScrolling, child) {
        return AnimatedTapButton(
          onTap: () {
            if (onTap != null) {
              onTap!();
              return;
            }
            SingleOfferPage(job).show(context);
          },
          child: Container(
              height: bottomWidget == null ? 85 : 112,
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 71,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F6F9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.only(
                      top: 9,
                      left: 16,
                      right: 8,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(job.jobTitle,
                                  // overflow: TextOverflow,
                                  maxLines: 1,
                                  style: textStyles.f6Heavy1200.copyWith(
                                      color: Colors.black, height: 0)),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            if (indicatorWidget != null) indicatorWidget!,
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              height: 20,
                              width: 20,
                              child: ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: company.logoUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              company.name,
                              maxLines: 1,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: FigmaColors.neutralNeutral3),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Transform.translate(
                              offset: const Offset(0, 1),
                              child: const Icon(
                                Icons.location_on,
                                color: FigmaColors.neutralNeutral6,
                                size: 16,
                              ),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              job.location,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  )
                ],
              )),
        );
      },
      valueListenable: Scrollable.of(context).position.isScrollingNotifier,
    );
  }
}

class ColoredIndicator extends StatelessWidget {
  final Color bgColor;
  final Color textColor;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 7,
      ),
      height: 20,
      decoration: ShapeDecoration(
        color: bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 11,
              fontFamily: "SourceSansPro",
              color: textColor,
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          CircleAvatar(
            radius: 4.5,
            backgroundColor: textColor,
          )
        ],
      ),
    );
  }

  const ColoredIndicator({
    super.key,
    required this.bgColor,
    required this.textColor,
    required this.text,
  });
}
