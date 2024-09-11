import 'package:firmus/gen/assets.gen.dart';
import 'package:firmus/infra/stores/job_creation_notifier.dart';
import 'package:firmus/router/router.dart';
import 'package:firmus/theme/_light_theme.dart';
import 'package:firmus/view/shared/buttons/animated_tap_button.dart';
import 'package:firmus/view/shared/buttons/text_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PickJobCreationTypePopup extends ConsumerWidget {
  const PickJobCreationTypePopup({Key? key}) : super(key: key);

  Future<void> show(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return this;
        });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 450),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 24,
            ),
            Text(
              "Odaberite način kreiranja oglasa",
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(color: FigmaColors.neutralBlack),
            ),
            const SizedBox(
              height: 24,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                AnimatedTapButton(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    GoRouter.of(context).pop();
                    GoRouter.of(context).push(RoutePaths.videoJobCreationPage);
                  },
                  child: Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: FigmaColors.neutralNeutral6, width: 2),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Column(
                      children: [
                        Flexible(
                            child: Assets.images.videoType.image(width: 90)),
                        const Text("Putem videa")
                      ],
                    ),
                  ),
                ),
                AnimatedTapButton(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    ref.invalidate(jobOpCreationNotifierProvider);
                    GoRouter.of(context).pop();
                    GoRouter.of(context).push(RoutePaths.jobCreationPage);
                  },
                  child: Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: FigmaColors.neutralNeutral6, width: 2),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Column(
                      children: [
                        Flexible(
                            child: Assets.images.formType.image(width: 90)),
                        const Text("Putem forme")
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            FirmusTextButton(
                text: "Odustani",
                onTap: () {
                  Navigator.of(context).pop();
                }),
            const SizedBox(
              height: 12,
            ),
          ],
        ),
      ),
    );
  }
}
