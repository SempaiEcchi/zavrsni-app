import 'package:flutter/material.dart';
import 'package:firmus/helper/logger.dart';

import 'animated_tap_button.dart';

class FirmusTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedTapButton(
      onTap: onTap,
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: Center(
          child: Text(
            text,
            style: Theme.of(context).textTheme.labelMedium!.copyWith(
                  color: Theme.of(context).primaryColor,
                ),
          ),
        ),
      ),
    );
  }

  const FirmusTextButton({
    super.key,
    required this.text,
    required this.onTap,
  });
}
