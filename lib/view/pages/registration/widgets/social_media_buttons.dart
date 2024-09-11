import 'package:firmus/gen/assets.gen.dart';
import 'package:firmus/helper/logger.dart';
import 'package:firmus/localizations.dart';
import 'package:firmus/view/shared/buttons/animated_tap_button.dart';
import 'package:flutter/material.dart';

class SocialMediaButtons extends StatelessWidget {
  const SocialMediaButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Divider(
                color: Colors.white.withOpacity(0.5),
                thickness: 1,
                height: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12, bottom: 4),
              child: Text(
                "Ili",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Colors.white),
              ),
            ),
            Expanded(
              child: Divider(
                color: Colors.white.withOpacity(0.5),
                thickness: 1,
                height: 1,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 24,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _SocialMediaOption(
              icon: Assets.images.google.image(width: 29),
              title: "Google",
            ),
            const SizedBox(
              height: 18,
            ),
            _SocialMediaOption(
              icon: Assets.images.facebook.image(width: 29),
              title: "Facebook",
            ),
            const SizedBox(
              height: 18,
            ),
            _SocialMediaOption(
              icon: Assets.images.aai.image(width: 29),
              title: "AAI@EduHr",
            ),
          ],
        ),
      ],
    );
  }
}

class _SocialMediaOption extends StatelessWidget {
  final Widget icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return AnimatedTapButton(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          logger.info("tap");
        },
        child: Row(
          children: [
            const SizedBox(
              width: 12,
            ),
            icon,
            const SizedBox(
              width: 48,
            ),
            Text(
              context.loc.continueWithSocial(title),
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }

  const _SocialMediaOption({
    required this.icon,
    required this.title,
  });
}
