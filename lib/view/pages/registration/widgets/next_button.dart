import 'package:firmus/gen/assets.gen.dart';
import 'package:firmus/localizations.dart';
import 'package:firmus/theme/_light_theme.dart';
import 'package:firmus/view/shared/buttons/animated_tap_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class NextButton extends HookWidget {
  final Function onTap;
  final bool invertColors;
  final bool showSkip;

  @override
  Widget build(BuildContext context) {
    var loading = useState(false);
    return AnimatedTapButton(
      onTap: () {
        if (loading.value) return;

        bool isAsync = onTap.runtimeType.toString().contains('Future');

        if (isAsync) {
          loading.value = true;
          try {
            onTap().whenComplete(() => loading.value = false);
          } catch (e) {
            loading.value = false;
          }
        } else {
          onTap();
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(showSkip?"Preskoči":context.loc.continueNext,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: invertColors
                      ? Theme.of(context).primaryColor
                      : FigmaColors.neutralWhite)),
          const SizedBox(width: 15),
          loading.value
              ? Container(
                  width: 63,
                  height: 63,
                  decoration: BoxDecoration(
                    color: invertColors
                        ? Theme.of(context).primaryColor
                        : Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: !invertColors
                            ? Theme.of(context).primaryColor
                            : Colors.white,
                      ),
                    ),
                  ),
                )
              : (invertColors
                  ? Assets.images.nextBtnI.image(
                      // fit: BoxFit.fitWidth,
                      width: 63,
                      height: 63,
                    )
                  : Assets.images.nextBtn.image(
                      // fit: BoxFit.fitWidth,
                      width: 63,
                      height: 63,
                    )),
        ],
      ),
    );
  }

  const NextButton({
    super.key,
    required this.onTap,
    this.showSkip=false,
    this.invertColors = false,
  });
}
