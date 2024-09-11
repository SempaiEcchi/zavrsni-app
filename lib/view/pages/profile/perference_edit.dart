import 'package:collection/collection.dart';
import 'package:firmus/infra/services/analytics/analytics_service.dart';
import 'package:firmus/infra/stores/job_offer_store.dart';
import 'package:firmus/infra/stores/registration_store.dart';
import 'package:firmus/infra/stores/user_notifier.dart';
import 'package:firmus/models/job_profiles.dart';
import 'package:firmus/theme/_light_theme.dart';
import 'package:firmus/view/pages/registration/widgets/constrained_body.dart';
import 'package:firmus/view/shared/buttons/firmus_back_button.dart';
import 'package:firmus/view/shared/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../main.dart';

class PreferenceEditPage extends ConsumerStatefulWidget {
  const PreferenceEditPage({Key? key}) : super(key: key);

  @override
  ConsumerState<PreferenceEditPage> createState() => _PreferenceEditPageState();
}

class _PreferenceEditPageState extends ConsumerState<PreferenceEditPage> {
  late var preferences = Map.from(
      ref.read(studentNotifierProvider).requireValue.jobProfileFrequencies);
  late final _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    final allJobsPositions = ref.watch(jobProfilesProvider);
    return Scaffold(
      body: SafeArea(
        top: true,
        child: Column(
          children: [
            Padding(
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
                      'Filteri i preferencije',
                      style: textStyles.f6Regular1200,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Expanded(
              child: ConstrainedBody(
                center: false,
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //dodaj preferenciju
                      Row(
                        children: [
                          const SizedBox(
                            width: 16,
                          ),
                          const Icon(
                            Icons.add,
                            color: Colors.black,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          TextButton(
                            onPressed: () async {
                              final positions = allJobsPositions.requireValue
                                  .toList()
                                ..sort((a, b) => a.name.compareTo(b.name))
                                ..removeWhere((element) => preferences.keys
                                    .contains(element.id.toString()));
                              final selectedJobProfile =
                                  await showDialog<JobProfile>(
                                context: context,
                                builder: (context) {
                                  return _SelectJobPopup(positions: positions);
                                },
                              );

                              if (selectedJobProfile != null) {
                                setState(() {
                                  preferences[selectedJobProfile.id
                                      .toString()] = DEFAULT_FREQUENCY;
                                });
                                ref.a.logEvent(
                                    name: AnalyticsEvent.select_preference,
                                    parameters: {
                                      'jobProfile': selectedJobProfile.name,
                                    });
                                await Future.delayed(
                                    const Duration(milliseconds: 200));
                                Future(() {
                                  _controller.animateTo(
                                    _controller.position.maxScrollExtent,
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.easeIn,
                                  );
                                });
                              }
                            },
                            child: Text('Dodaj preferenciju',
                                style: textStyles.paragraphSmallHeavy),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      if (preferences.isNotEmpty)
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ListView.separated(
                                shrinkWrap: true,
                                controller: _controller,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(
                                      height: 24,
                                    ),
                                itemCount: preferences.keys.length,
                                itemBuilder: (context, index) {
                                  final jobProfile = allJobsPositions
                                      .requireValue
                                      .firstWhereOrNull((element) =>
                                          element.id.toString() ==
                                          preferences.keys.elementAt(index))
                                      ?.name;
                                  if (jobProfile == null)
                                    return const SizedBox();
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 24.0),
                                        child: Text(
                                          jobProfile,
                                          style: textStyles.paragraphSmallHeavy,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: _PreferenceSlider(
                                              initialValue: preferences.values
                                                  .elementAt(index),
                                              title: jobProfile,
                                              onChanged: (amount) {
                                                preferences[preferences.keys
                                                    .elementAt(index)] = amount;
                                              },
                                            ),
                                          ),

                                          //delete button
                                          IconButton(
                                            onPressed: () {
                                              preferences.remove(preferences
                                                  .keys
                                                  .elementAt(index));
                                              setState(() {});
                                            },
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                }),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            PrimaryButton(
              onTap: () async {
                final selec = preferences.entries
                    .map((e) => SelectedJobProfile(
                          jobProfile: allJobsPositions.requireValue.firstWhere(
                              (element) => element.id.toString() == e.key),
                          frequency: e.value,
                        ))
                    .toList();
                ref.a.logEvent(
                  name: AnalyticsEvent.preferences_edit,
                );
                await ref
                    .read(studentNotifierProvider.notifier)
                    .updateJobFrequency(selec);
                ref.invalidate(jobOfferStoreProvider);
                Navigator.of(context).pop();
              },
              text: 'Spremi',
            ),
            const SizedBox(
              height: 24,
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectJobPopup extends StatefulWidget {
  const _SelectJobPopup({
    super.key,
    required this.positions,
  });

  final List<JobProfile> positions;

  @override
  State<_SelectJobPopup> createState() => _SelectJobPopupState();
}

class _SelectJobPopupState extends State<_SelectJobPopup> {
  String q = "";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Izaberite posao'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Zatvori'),
        ),
      ],
      content: SizedBox(
        width: 300,
        // height: 300,
        child: Column(
          children: [
            //
            SearchBar(
              hintText: 'Pretraga',
              onChanged: (value) {
                setState(() {
                  q = value;
                });
              },
              elevation: MaterialStatePropertyAll(0.2),
            ),
            const SizedBox(
              height: 16,
            ),
            Flexible(
              child: ListView.builder(
                itemCount: buildPositions().length,
                itemBuilder: (context, index) {
                  final jobProfile = buildPositions()[index];
                  return ListTile(
                    title: Text(jobProfile.name),
                    onTap: () {
                      Navigator.of(context).pop(jobProfile);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<JobProfile> buildPositions() => widget.positions.where((e) {
        return e.name.toLowerCase().contains(q.toLowerCase());
      }).toList();
}

LinearGradient get gradientLowPriority => LinearGradient(
        colors: <Color>[
      Colors.orange,
      Colors.orangeAccent.withOpacity(0.6),
    ].reversed.toList());

LinearGradient get gradientHighPriority => LinearGradient(
        colors: <Color>[
      Colors.green,
      Colors.greenAccent,
    ].reversed.toList());

class _PreferenceSlider extends StatefulWidget {
  final int initialValue;
  final String title;
  final Function(int amount) onChanged;

  @override
  State<_PreferenceSlider> createState() => _PreferenceSliderState();

  const _PreferenceSlider({
    required this.initialValue,
    required this.title,
    required this.onChanged,
  });
}

class _PreferenceSliderState extends State<_PreferenceSlider> {
  late double value = widget.initialValue.toDouble();

  @override
  Widget build(BuildContext context) {
    final gradient =
        value < DEFAULT_FREQUENCY ? gradientLowPriority : gradientHighPriority;
    return SizedBox(
      width: double.infinity,
      child: SliderTheme(
        data: SliderThemeData(
          trackShape: GradientRectSliderTrackShape(
              gradient: gradient, darkenInactive: false),
        ).copyWith(
          trackHeight: 28,
          overlayColor: Colors.transparent,
          thumbShape: const RoundSliderThumbShape(
              enabledThumbRadius: 15, pressedElevation: 0, elevation: 0),
          thumbColor: gradient.colors.last,
          inactiveTrackColor: Colors.white,
        ),
        child: Container(
          child: Slider(
            min: MIN_FREQUENCY.toDouble(),
            max: MAX_FREQUENCY.toDouble(),
            // divisions: 10,
            value: value,
            onChanged: (value) {
              bool shouldVibrate = this.value.toInt() != value.toInt();
              if (shouldVibrate) {
                if (value.toInt() == MAX_FREQUENCY ||
                    value.toInt() == MIN_FREQUENCY) {
                  HapticFeedback.mediumImpact();
                } else {
                  HapticFeedback.selectionClick();
                }
              }

              setState(() {
                this.value = value;
              });
              widget.onChanged(this.value.toInt());
            },
          ),
        ),
      ),
    );
  }
}

class GradientRectSliderTrackShape extends SliderTrackShape
    with BaseSliderTrackShape {
  const GradientRectSliderTrackShape({
    this.gradient = const LinearGradient(
      colors: [
        Colors.red,
        Colors.yellow,
      ],
    ),
    this.darkenInactive = true,
  });

  final LinearGradient gradient;
  final bool darkenInactive;

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isEnabled = true,
    bool isDiscrete = false,
    required TextDirection textDirection,
  }) {
    assert(sliderTheme.disabledActiveTrackColor != null);
    assert(sliderTheme.disabledInactiveTrackColor != null);
    assert(sliderTheme.activeTrackColor != null);
    assert(sliderTheme.inactiveTrackColor != null);
    assert(sliderTheme.thumbShape != null);
    assert(sliderTheme.trackHeight != null && sliderTheme.trackHeight! > 0);
    int additionalActiveTrackHeight = 2;
    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    final activeGradientRect = Rect.fromLTRB(
      trackRect.left,
      (textDirection == TextDirection.ltr)
          ? trackRect.top - (additionalActiveTrackHeight / 2)
          : trackRect.top,
      thumbCenter.dx,
      (textDirection == TextDirection.ltr)
          ? trackRect.bottom + (additionalActiveTrackHeight / 2)
          : trackRect.bottom,
    );

    // Assign the track segment paints, which are leading: active and
    // trailing: inactive.
    final ColorTween activeTrackColorTween = ColorTween(
        begin: sliderTheme.disabledActiveTrackColor,
        end: sliderTheme.activeTrackColor);
    final ColorTween inactiveTrackColorTween = darkenInactive
        ? ColorTween(
            begin: sliderTheme.disabledInactiveTrackColor,
            end: sliderTheme.inactiveTrackColor)
        : activeTrackColorTween;
    final Paint activePaint = Paint()
      ..shader = gradient.createShader(activeGradientRect)
      ..color = activeTrackColorTween.evaluate(enableAnimation)!;
    final Paint inactivePaint = Paint()
      ..color = FigmaColors.neutralNeutral3.withOpacity(0.2);
    final Paint leftTrackPaint;
    final Paint rightTrackPaint;
    switch (textDirection) {
      case TextDirection.ltr:
        leftTrackPaint = activePaint;
        rightTrackPaint = inactivePaint;
        break;
      case TextDirection.rtl:
        leftTrackPaint = inactivePaint;
        rightTrackPaint = activePaint;
        break;
    }

    final Radius trackRadius = Radius.circular(trackRect.height / 2);
    final Radius activeTrackRadius = Radius.circular(trackRect.height / 2 + 1);

    context.canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        trackRect.left,
        (textDirection == TextDirection.ltr)
            ? trackRect.top - (additionalActiveTrackHeight / 2)
            : trackRect.top,
        thumbCenter.dx,
        (textDirection == TextDirection.ltr)
            ? trackRect.bottom + (additionalActiveTrackHeight / 2)
            : trackRect.bottom,
        topLeft: (textDirection == TextDirection.ltr)
            ? activeTrackRadius
            : trackRadius,
        bottomLeft: (textDirection == TextDirection.ltr)
            ? activeTrackRadius
            : trackRadius,
        // topRight: (textDirection == TextDirection.ltr)
        //     ? activeTrackRadius
        //     : trackRadius,
        // bottomRight: (textDirection == TextDirection.ltr)
        //     ? activeTrackRadius
        //     : trackRadius,
      ),
      leftTrackPaint,
    );

    Path path = Path();
    path.addRRect(
      RRect.fromLTRBAndCorners(
        thumbCenter.dx,
        (textDirection == TextDirection.rtl)
            ? trackRect.top - (additionalActiveTrackHeight / 2)
            : trackRect.top,
        trackRect.right,
        (textDirection == TextDirection.rtl)
            ? trackRect.bottom + (additionalActiveTrackHeight / 2)
            : trackRect.bottom,
        topRight: (textDirection == TextDirection.rtl)
            ? activeTrackRadius
            : trackRadius,
        bottomRight: (textDirection == TextDirection.rtl)
            ? activeTrackRadius
            : trackRadius,
      ),
    );
    context.canvas.drawPath(path, rightTrackPaint);
  }
}
