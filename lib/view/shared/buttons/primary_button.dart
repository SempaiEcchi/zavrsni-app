import 'package:firmus/theme/_light_theme.dart';
import 'package:firmus/view/shared/buttons/animated_tap_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PrimaryButton extends HookWidget {
  final Function onTap;
  final String text;
  final bool compact;
  final bool expand;

  PrimaryButton({
    required this.onTap,
    required this.text,
    this.compact = false,
    this.expand = false,
  }) : super(key: ValueKey("${text}_primary_button"));

  @override
  Widget build(BuildContext context) {
    var loading = useState(false);

    return AnimatedTapButton(
      child: GestureDetector(
        onTap: () async {
          if (loading.value) return;

          if (!onTap.runtimeType.toString().contains("Future")) {
            onTap();
            return;
          }
          loading.value = true;
          onTap().whenComplete(() {
            loading.value = false;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).primaryColor,
          ),
          margin: expand
              ? EdgeInsets.zero
              : const EdgeInsets.symmetric(horizontal: 26),
          height:
              compact ? FigmaSizes.secondaryHeight : FigmaSizes.primaryHeight,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          width: FigmaSizes.primaryWidth,
          child: Center(
            child: loading.value
                ? const Center(
                    child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        )))
                : Text(
                    text,
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium!
                        .copyWith(height: 1),
                  ),
          ),
        ),
      ),
    );
  }
}

class PrimaryHollowButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;

  PrimaryHollowButton({
    required this.onTap,
    required this.text,
  }) : super(key: ValueKey("${text}PrimaryHollowButton"));

  @override
  Widget build(BuildContext context) {
    return AnimatedTapButton(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(width: 2, color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.circular(8),
            color: Colors.transparent,
          ),
          margin: const EdgeInsets.symmetric(horizontal: 26),
          height: FigmaSizes.primaryHeight,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          width: FigmaSizes.primaryWidth,
          child: Center(
            child: Text(
              text,
              style: Theme.of(context)
                  .textTheme
                  .labelMedium!
                  .copyWith(color: Theme.of(context).primaryColor),
            ),
          ),
        ),
      ),
    );
  }
}

class SmallPrimaryButton extends HookWidget {
  final Function onTap;
  final String text;

  SmallPrimaryButton({
    required this.onTap,
    required this.text,
  }) : super(key: ValueKey("${text}_small_button"));

  @override
  Widget build(BuildContext context) {
    var loading = useState(false);

    return AnimatedTapButton(
      child: GestureDetector(
        onTap: () {
          if (loading.value) return;

          if (!onTap.runtimeType.toString().contains("Future")) {
            onTap();
            return;
          }
          loading.value = true;
          onTap().whenComplete(() {
            loading.value = false;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).primaryColor,
          ),
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          width: 106,
          child: Center(
            child: loading.value
                ? const Center(
                    child: SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        )))
                : FittedBox(
                    child: Text(
                      text,
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium!
                          .copyWith(fontSize: 14),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
