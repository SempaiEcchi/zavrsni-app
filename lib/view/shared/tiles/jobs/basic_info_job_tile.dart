import 'package:firmus/models/job_offers.dart';
import 'package:firmus/theme/_light_theme.dart';
import 'package:firmus/view/shared/tiles/jobs/job_list_tile.dart';
import 'package:flutter/material.dart';

class BasicInfoJobTile extends StatelessWidget {
  final JobOpportunity job;
  final VoidCallback? onTap;

  const BasicInfoJobTile({
    super.key,
    required this.job,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return RoundedJobCard(
      job: job,
      onTap: onTap,
      indicatorWidget: BasicIndicatorWidget(job: job),
    );
  }
}

class BasicIndicatorWidget extends StatelessWidget {
  const BasicIndicatorWidget({
    super.key,
    required this.job,
  });

  final JobOpportunity job;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 7,
      ),
      height: 20,
      decoration: ShapeDecoration(
        color: FigmaColors.statusSuccessBG,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            job.rateText,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              fontFamily: "SourceSansPro",
              color: FigmaColors.statusSuccess,
            ),
          ),
        ],
      ),
    );
  }
}

class ActiveIndicatorWidget extends StatelessWidget {
  const ActiveIndicatorWidget({
    super.key,
    required this.isActive,
  });

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 7,
      ),
      height: 20,
      decoration: ShapeDecoration(
        color:
            isActive ? FigmaColors.statusSuccessBG : FigmaColors.statusInfoBG,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 4,
          ),
          CircleAvatar(
            radius: 4,
            backgroundColor: color(),
          ),
          const SizedBox(
            width: 4,
          ),
          Text(
            isActive ? "U tijeku" : "Završeno",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              fontFamily: "SourceSansPro",
              color: color(),
            ),
          ),
        ],
      ),
    );
  }

  Color color() {
    return isActive
                ? FigmaColors.statusSuccess
                : FigmaColors.primaryPrimary100;
  }
}
