import 'package:firmus/localizations.dart';
import 'package:firmus/models/job_profiles.dart';
import 'package:firmus/theme/_light_theme.dart';
import 'package:firmus/view/shared/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:firmus/helper/logger.dart';

class JobProfileFrequencyPopup extends StatefulWidget {
  final SelectedJobProfile profile;

  Future<SelectedJobProfile> show(BuildContext context) async {
    final result = await showDialog<SelectedJobProfile?>(
        context: context, builder: (context) => this, barrierDismissible: true);
    return result ?? profile;
  }

  const JobProfileFrequencyPopup({Key? key, required this.profile})
      : super(key: key);

  @override
  State<JobProfileFrequencyPopup> createState() =>
      _JobProfileFrequencyPopupState();
}

class _JobProfileFrequencyPopupState extends State<JobProfileFrequencyPopup> {
  late int value = widget.profile.frequency;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(12),
      backgroundColor: Colors.white,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Container(
        color: Colors.white,
        width: double.infinity,
        constraints: const BoxConstraints(
          maxWidth: 400,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.loc
                    .jobProfileFrequencyTitle(widget.profile.jobProfile.name),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(
                height: 12,
              ),
              slider,
              PrimaryButton(
                  expand: true,
                  // compact: true,
                  onTap: () {
                    Navigator.of(context)
                        .pop(widget.profile.copyWith(frequency: value));
                  },
                  text: context.loc.save)
            ],
          ),
        ),
      ),
    );
  }

  Widget get slider {
    return SizedBox(
      height: 90,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.topCenter,
            // top: 0,
            // height: 90,
            child: SizedBox(
              height: 40,
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 4,
                  inactiveTrackColor:
                      FigmaColors.neutralNeutral3.withOpacity(0.2),
                  trackShape: CustomTrackShape(),
                  thumbShape:
                      const RoundSliderThumbShape(enabledThumbRadius: 12),
                ),
                child: Slider(
                    value: value.toDouble(),
                    thumbColor: Colors.white,
                    activeColor: const Color(0xff70CE98),
                    min: MIN_FREQUENCY.toDouble(),
                    max: MAX_FREQUENCY.toDouble(),
                    onChanged: (v) {
                      setState(() {
                        value = v.toInt();
                      });
                    }),
              ),
            ),
          ),
          Positioned.fill(
            bottom: 0,
            child: Row(
              children: [
                Text(
                  context.loc.jobProfileFrequencyRarely,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const Spacer(),
                Text(
                  context.loc.jobProfileFrequencyOften,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final trackHeight = sliderTheme.trackHeight;
    final trackLeft = offset.dx;
    final trackTop = offset.dy + (parentBox.size.height - trackHeight!) / 2;
    final trackWidth = parentBox.size.width - 10;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
