import 'package:equatable/equatable.dart';
import 'package:firmus/main.dart';
import 'package:firmus/models/job_profiles.dart';
import 'package:firmus/theme/_light_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class JobTag extends Equatable {
  final String text;
  final String tagEmoji;
  final Color? color;
  final bool superTag;

  const JobTag({
    required this.text,
    required this.tagEmoji,
    required this.superTag,
    this.color,
  });

  @override
  List<Object?> get props => [text, tagEmoji, superTag, color];
}

class JobTagChip extends StatelessWidget {
  final JobTag tag;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: tag.color ?? const Color(0xffEEF2FA),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        "${tag.tagEmoji} ${tag.text}",
        style: textStyles.paragraphXSmallHeavy
            .copyWith(color: FigmaColors.neutralNeutral2),
      ),
    );
  }

  const JobTagChip({
    super.key,
    required this.tag,
  });
}

class SelectableJobProfileChip extends StatelessWidget {
  final JobProfile tag;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final bool large;
  final bool staticTextColor;
  final bool inverted;
  final Color? textColor;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () {
        HapticFeedback.mediumImpact();
        onLongPress();
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: large ? 48 : 20,
          padding: EdgeInsets.symmetric(
              horizontal: large ? 12 : 9, vertical: large ? 6 : 3),
          decoration: BoxDecoration(
            border: Border.all(
              color: inverted
                  ? (isSelected
                      ? FigmaColors.primaryPrimary100
                      : const Color(0xffEEF2FA))
                  : const Color(0xffEEF2FA),
              width: 2,
            ),
            color: isSelected
                ? (inverted ? Colors.transparent : const Color(0xffEEF2FA))
                : Colors.transparent,
            borderRadius: BorderRadius.circular(large ? 24 : 10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${tag.emoji} ${tag.name}",
                textAlign: TextAlign.center,
                style: large
                    ? Theme.of(context).textTheme.headlineMedium!.copyWith(
                        fontSize: 18,
                        height: 1,
                        color: isSelected || staticTextColor
                            ? textColor ?? Theme.of(context).primaryColor
                            : const Color(0xffEEF2FA))
                    : textStyles.paragraphXSmallHeavy.copyWith(
                        color: FigmaColors.neutralNeutral2,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  const SelectableJobProfileChip(
      {super.key,
      required this.tag,
      this.staticTextColor = false,
      this.onLongPress = _noOp,
      required this.isSelected,
      required this.onTap,
      this.large = false,
      this.inverted = false,
      this.textColor});
}

void _noOp() {}
