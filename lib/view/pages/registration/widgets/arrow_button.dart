import 'package:firmus/gen/assets.gen.dart';
import 'package:firmus/theme/_light_theme.dart';
import 'package:firmus/view/shared/buttons/animated_tap_button.dart';
import 'package:flutter/material.dart';

class ArrowButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final int rotation;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(text,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: FigmaColors.neutralWhite)),
        const SizedBox(width: 15),
        Transform.rotate(
          angle: -rotation * 3.14 / 180,
          child: AnimatedTapButton(
            child: GestureDetector(
              onTap: onTap,
              child: Assets.images.nextBtn.image(
                // fit: BoxFit.fitWidth,
                width: 63,
                height: 63,
              ),
            ),
          ),
        ),
      ],
    );
  }

  const ArrowButton({
    super.key,
    required this.onTap,
    required this.text,
    required this.rotation,
  });
}
