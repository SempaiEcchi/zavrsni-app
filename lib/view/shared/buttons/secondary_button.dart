import 'package:firmus/theme/_light_theme.dart';
import 'package:firmus/view/shared/buttons/animated_tap_button.dart';
import 'package:flutter/material.dart';

class SecondaryButton extends StatefulWidget {
  final Function onTap;
  final String text;
  //on tap async
  final bool smallMargin;
  final bool fitText;

  SecondaryButton({
    required this.onTap,
    this.fitText = false,
    this.smallMargin = false,
    required this.text,
  }) : super(key: ValueKey("${text}_button"));

  @override
  State<SecondaryButton> createState() => _SecondaryButtonState();
}

class _SecondaryButtonState extends State<SecondaryButton> {
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedTapButton(
      child: GestureDetector(
        onTap: () {
          if (_loading) return;
          bool isAsync = widget.onTap.runtimeType.toString().contains("Future");

          if (isAsync) {
            setState(() {
              _loading = true;
            });
            widget.onTap().whenComplete(() => setState(() {
                  _loading = false;
                }));
          } else {
            widget.onTap();
          }
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(width: 2, color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.circular(6),
            color: Colors.transparent,
          ),
          margin: widget.smallMargin
              ? const EdgeInsets.symmetric(horizontal: 13)
              : const EdgeInsets.symmetric(horizontal: 26),
          height: FigmaSizes.secondaryHeight,
          width: FigmaSizes.secondaryWidth,
          child: Center(
            child: _loading
                ? const SizedBox(
                    width: 18, height: 18, child: CircularProgressIndicator())
                : FittedBox(
                    fit: widget.fitText ? BoxFit.fitWidth : BoxFit.none,
                    child: Text(
                      widget.text,
                      maxLines: 1,
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium!
                          .copyWith(color: Theme.of(context).primaryColor),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
