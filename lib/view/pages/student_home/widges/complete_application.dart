import 'package:firmus/helper/date_time_ext.dart';
import 'package:firmus/infra/stores/job_offer_store.dart';
import 'package:firmus/infra/stores/student_jobs_store.dart';
import 'package:firmus/models/job_offers.dart';
import 'package:firmus/models/student_job_offers.dart';
import 'package:firmus/view/pages/registration/widgets/constrained_body.dart';
import 'package:firmus/view/shared/buttons/animated_tap_button.dart';
import 'package:firmus/view/shared/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../router/router.dart';

class CompleteApplicationBottomSheet extends ConsumerStatefulWidget {
  final JobOpportunity jobOpportunity;
  final String matchId;
  const CompleteApplicationBottomSheet({
    super.key,
    required this.jobOpportunity,
    required this.matchId,
  });

  Future<Object?> show(context) async {
    return showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        context: context,
        builder: (context) => this);
  }

  @override
  ConsumerState<CompleteApplicationBottomSheet> createState() =>
      _CompleteApplicationBottomSheet();
}

class _CompleteApplicationBottomSheet
    extends ConsumerState<CompleteApplicationBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
      child: ColoredBox(
        color: Colors.white,
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: ConstrainedBody(
            center: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 16,
                ),
                Container(
                  width: 120,
                  height: 7,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFEAEEF2),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Assets.images.tabletGirl.image(),
                const SizedBox(
                  height: 24,
                ),
                Text(
                  "Završna prijava",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                    "Čestitamo, došli ste do završne prijave za posao! Prije nego što se konačno prijavite, prođimo još jednom kroz sve detalje posla na koji se prijavljujete.",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: const Color(0xFF6C7580),
                        )),
                const SizedBox(
                  height: 16,
                ),
                ThreeJobDetails(
                  jobOpportunity: widget.jobOpportunity,
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                    "Nakon završetka prijave poslodavac mora napraviti finalni korak kako bi stupili u poslovni odnos. Za sve dodatne informacije možete kontaktirati poslodavca putem chat-a.",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: const Color(0xFF6C7580),
                        )),
                const SizedBox(
                  height: 32,
                ),
                PrimaryButton(
                    onTap: () async {
                      AppliedJobOffer jobOffer = await ref
                          .read(studentJobsProvider.notifier)
                          .acceptMatch(widget.matchId);
                      Navigator.of(context).pop();
                      router.push(RoutePaths.jobStatusPage,
                          extra: widget.jobOpportunity);
                    },
                    text: 'Završi prijavu'),
                const SizedBox(
                  height: 16,
                ),
                AnimatedTapButton(
                  onTap: () {
                    Navigator.of(context).pop(false);
                  },
                  child: SizedBox(
                    width: double.infinity,
                    height: 30,
                    child: Center(
                      child: Text(
                        "Odustani",
                        style:
                            Theme.of(context).textTheme.labelMedium!.copyWith(
                                  color: Theme.of(context).disabledColor,
                                ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ThreeJobDetails extends StatelessWidget {
  const ThreeJobDetails({
    super.key,
    required this.jobOpportunity,
  });

  final JobOpportunity jobOpportunity;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _RoundedChip(
          icon: const Icon(
            Icons.euro_symbol,
            size: 12,
          ),
          text: "Satnica",
          content: jobOpportunity.rateText,
          color: const Color(0xFF2D6A6A),
        ),

        //todo: add dates on backend
        if (jobOpportunity.workStartDate != null)
          _RoundedChip(
              icon: Transform.rotate(
                  angle: -3.14 / 2,
                  child: const Icon(
                    Icons.play_for_work,
                    size: 12,
                  )),
              text: "Početak",
              content: jobOpportunity.workStartDate!.formatCroatianDate(),
              color: const Color(0xFF1479EC)),
        if (jobOpportunity.workEndDate != null)
          _RoundedChip(
              icon: Transform.rotate(
                  angle: 3.14 / 2,
                  child: const Icon(
                    Icons.play_for_work,
                    size: 12,
                  )),
              text: "Završetak",
              content: jobOpportunity.workEndDate!.formatCroatianDate(),
              color: const Color(0xFFEC8714)),
      ],
    );
  }
}

class _RoundedChip extends StatelessWidget {
  final Widget icon;
  final String text;
  final String content;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      constraints: const BoxConstraints(minWidth: 107),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFFEAEEF2),
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 13.5,
            backgroundColor: color,
            child: icon,
          ),
          const SizedBox(
            width: 3,
          ),
          FittedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(text,
                    style: const TextStyle(
                      color: Color(0xFF858B94),
                      fontSize: 9,
                      fontFamily: 'SourceSansPro',
                      fontWeight: FontWeight.normal,
                    )),
                Text(content,
                    style: const TextStyle(
                      color: Color(0xFF09101D),
                      fontSize: 13,
                      fontFamily: 'SourceSansPro',
                      fontWeight: FontWeight.bold,
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }

  const _RoundedChip({
    required this.icon,
    required this.text,
    required this.content,
    required this.color,
  });
}

TextStyle get _textStyle => const TextStyle(
    fontFamily: "SourceSansPro",
    color: Color(0xFF535D68),
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 16 / 14,
    letterSpacing: 1);
// Color(0xFFF4F6F9)
// radius 8
InputDecoration get greyRoundedInputDecoration => InputDecoration(
      hintStyle: _textStyle.copyWith(color: _textStyle.color!.withOpacity(0.5)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      fillColor: const Color(0xFFF4F6F9),
      filled: true,
    );
