import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:firmus/localizations.dart';
import 'package:firmus/models/student_job_offers.dart';
import 'package:firmus/theme/_light_theme.dart';
import 'package:firmus/view/pages/student_home/widges/complete_application.dart';
import 'package:firmus/view/shared/buttons/primary_button.dart';
import 'package:firmus/view/shared/tiles/jobs/basic_info_job_tile.dart';
import 'package:firmus/view/shared/tiles/jobs/job_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../router/router.dart';

class StudentJobTile extends StatelessWidget {
  final StudentJobOffer studentJobOffer;

  const StudentJobTile({
    super.key,
    required this.studentJobOffer,
  });

  @override
  Widget build(BuildContext context) {
    final job = studentJobOffer.opportunity;

    Widget indicatorWidget = BasicIndicatorWidget(job: job);

    switch (studentJobOffer) {
      case AppliedJobOffer():
        indicatorWidget = Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 7,
          ),
          height: 20,
          decoration: ShapeDecoration(
            color: FigmaColors.primaryPrimary10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Prijava poslana",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  fontFamily: "SourceSansPro",
                  color: FigmaColors.primaryPrimary100,
                ),
              ),
              SizedBox(
                width: 4,
              ),
              CircleAvatar(
                radius: 4,
                backgroundColor: FigmaColors.primaryPrimary100,
              )
            ],
          ),
        );
        break;
      case SavedJobOffer():
        break;
      case MatchedJobOffer():
        break;
      case ActiveJobOffer():
        break;
      case CompletedJobOffer():
        break;
    }

    return RoundedJobCard(
      job: job,
      indicatorWidget: indicatorWidget,
    );
  }

  SmallPrimaryButton completeApplication(BuildContext context, jobop, matchid) {
    return SmallPrimaryButton(
      onTap: () {
        CompleteApplicationBottomSheet(
          jobOpportunity: jobop,
          matchId: matchid,
        ).show(
          context,
        );
      },
      text: context.loc.finishApplication,
    );
  }

  SmallPrimaryButton rateJob(BuildContext context) {
    return SmallPrimaryButton(
      onTap: () {
        showModalBottomSheet(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            backgroundColor: Colors.white,
            showDragHandle: false,
            constraints: const BoxConstraints(maxWidth: 600),
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return const RateJobSheet();
            });
      },
      text: context.loc.rateJob,
    );
  }

  SmallPrimaryButton viewJobStatus(BuildContext context) {
    return SmallPrimaryButton(
      onTap: () {
        GoRouter.of(context)
            .go(RoutePaths.jobStatusPage, extra: studentJobOffer);
      },
      text: "Pregled prijave",
    );
  }

  SmallPrimaryButton shareJob(BuildContext context) {
    return SmallPrimaryButton(
      onTap: () =>
          Share.shareUri(Uri.parse(studentJobOffer.opportunity.shareLink)),
      text: context.loc.shareJob,
    );
  }
}

class JobTileChip extends StatelessWidget {
  const JobTileChip({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class RateJobSheet extends HookWidget {
  const RateJobSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final key = useMemoized(() => GlobalKey<FormBuilderState>(), const []);
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: FormBuilder(
        key: key,
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const DragHandle(),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    "Ocijeni poslodavca",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const Text(
                      "Ocijenite poslodavca kako bi drugi radnici mogli lakše odabrati radno mjesto koje im se sviđa. Ocjena radnog mjesta će biti javno vidljiva."),
                  const SizedBox(
                    height: 12,
                  ),
                  RatingBar(
                    filledIcon: Icons.star,
                    isHalfAllowed: true,
                    alignment: Alignment.center,
                    halfFilledIcon: Icons.star_half,
                    filledColor: FigmaColors.primaryPrimary100,
                    emptyIcon: Icons.star_border,
                    onRatingChanged: (value) => debugPrint('$value'),
                    initialRating: 3,
                    maxRating: 5,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  SizedBox(
                    child: FormBuilderTextField(
                      autocorrect: false,
                      minLines: 3,
                      autovalidateMode: AutovalidateMode.always,
                      maxLines: 10,
                      keyboardType: TextInputType.text,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(),
                      decoration: outlineInputDecoration.copyWith(
                        hintText: "Recenzija...",
                      ),
                      textInputAction: TextInputAction.done,
                      name: 'review',
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  PrimaryButton(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      text: "Ocijeni"),
                  const SizedBox(
                    height: 24,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DragHandle extends StatelessWidget {
  const DragHandle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Container(
        width: 120,
        height: 7,
        decoration: ShapeDecoration(
          color: const Color(0xFFEAEEF2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),
    );
  }
}
