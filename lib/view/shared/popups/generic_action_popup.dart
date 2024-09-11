import 'package:firmus/helper/logger.dart';
import 'package:firmus/theme/_light_theme.dart';
import 'package:firmus/view/pages/registration/widgets/constrained_body.dart';
import 'package:firmus/view/shared/buttons/animated_tap_button.dart';
import 'package:firmus/view/shared/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GenericActionPopup extends StatelessWidget {
  final String title;
  final Widget icon;
  final double iconSize;
  final String description;
  final String? subDescription;

  final String actionText;
  final VoidCallback onActionPressed;

  final String? cancelText;
  final VoidCallback? onCancelPressed;

  Future<T?> show<T>(BuildContext context) async {
    return await showDialog<T?>(
      context: context,
      barrierDismissible: true,
      builder: (context) => this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBody(
      child: Center(
        child: Material(
            type: MaterialType.transparency,
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 12,
                  ),
                  SizedBox(width: iconSize, height: iconSize, child: icon),
                  const SizedBox(
                    height: 24,
                  ),
                  Text(title, style: Theme.of(context).textTheme.titleLarge!),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(description,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: FigmaColors.neutralNeutral4)),
                  const SizedBox(
                    height: 24,
                  ),
                  if (subDescription != null) ...[
                    Text(subDescription!,
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: FigmaColors.neutralNeutral6)),
                    const SizedBox(
                      height: 24,
                    ),
                  ],
                  PrimaryButton(
                    onTap: onActionPressed,
                    text: actionText,
                    expand: true,
                  ),
                  AnimatedTapButton(
                    onTap: () {
                      if (onCancelPressed != null)
                        return onCancelPressed?.call();
                      Navigator.of(context).pop(false);
                    },
                    child: SizedBox(
                      width: double.infinity,
                      height: 52,
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
                    height: 8,
                  ),
                ],
              ),
            )),
      ),
    );
  }

  const GenericActionPopup({
    super.key,
    required this.title,
    required this.icon,
    required this.description,
    required this.actionText,
    required this.onActionPressed,
    this.subDescription,
    this.iconSize = 32,
    this.cancelText,
    this.onCancelPressed,
  });
}

class GenericRationalePopup extends StatelessWidget {
  final String title;

  Future<T?> show<T>(BuildContext context) async {
    return await showDialog<T?>(
      context: context,
      barrierDismissible: true,
      builder: (context) => this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBody(
      child: Center(
        child: Material(
            type: MaterialType.transparency,
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                   const SizedBox(
                    height: 24,
                  ),
                  Text(title, style: Theme.of(context).textTheme.titleLarge!),
                  const SizedBox(
                    height: 16,
                  ),
                   const SizedBox(
                    height: 24,
                  ),

                  PrimaryButton(
                    onTap: (){
                      context.pop(true);
                    },
                    text: "Da",
                    expand: true,
                  ),
                  AnimatedTapButton(
                    onTap: () {
                      context.pop(false);
                    },
                    child: SizedBox(
                      width: double.infinity,
                      height: 52,
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
                    height: 8,
                  ),
                ],
              ),
            )),
      ),
    );
  }

  const GenericRationalePopup({
    super.key,
    required this.title,
  });
}
