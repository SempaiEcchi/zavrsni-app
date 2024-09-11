import 'package:firmus/models/student_experience.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../shared/buttons/animated_tap_button.dart';

class ExperienceTile extends StatelessWidget {
  final StudentExperienceEntity experience;
  final VoidCallback onTap;

  const ExperienceTile({
    super.key,
    required this.experience,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: AnimatedTapButton(
        child: Container(
          constraints: BoxConstraints(minHeight: 120),
          decoration: ShapeDecoration(
            color: Colors.white.withOpacity(0.15),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(experience.jobTitle.trim(),
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge!
                        .copyWith(color: Colors.white, height: 1)),
                Row(
                  children: [
                    Flexible(
                      child: Text(experience.companyName,
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(color: Colors.white)),
                    ),

                    //bulletpoint
                    Text(' • ',
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(color: Colors.white)),

                    if (experience.start != null)
                      Text(experience.start!.formatted,
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(color: Colors.white)),
                    if (experience.start != null)
                      Text(' - ',
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(color: Colors.white)),
                    if (experience.end != null)
                      Text(experience.end!.formatted,
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(color: Colors.white)),
                  ],
                ),
                Wrap(
                  runSpacing: 0,
                  spacing: 0,
                  children: [
                    ...[...experience.acquiredSkills].map((e) => SimpleChip(e))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SimpleChip extends StatelessWidget {
  final String text;

  const SimpleChip(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
        side: const BorderSide(
          color: Colors.white,
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(13),
      )),
      child: Text(text,
          style: Theme.of(context)
              .textTheme
              .labelSmall!
              .copyWith(color: Colors.white, height: 1)),
    );
  }
}

extension on DateTime {
  //DD/MM/YY
  String get formatted => DateFormat('dd/MM/yy').format(this);
}
