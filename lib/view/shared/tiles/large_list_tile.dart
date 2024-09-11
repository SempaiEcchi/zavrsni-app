import 'package:firmus/main.dart';
import 'package:firmus/theme/_light_theme.dart';
import 'package:firmus/view/shared/buttons/animated_tap_button.dart';
import 'package:flutter/material.dart';
import 'package:firmus/helper/logger.dart';

class LargeListTile extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final String location;
  final String rateText;
  final int activeFor;
  final Widget? bottomRow;
  const LargeListTile({
    super.key,
    required this.onTap,
    required this.title,
    required this.location,
    required this.rateText,
    required this.activeFor,
    this.bottomRow,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedTapButton(
      onTap: onTap,
      child: Container(
        height: bottomRow == null ? 105 : 141,
        width: 352,
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
          top: 13,
          bottom: 13,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textStyles.f6Heavy1200
                      .copyWith(color: FigmaColors.neutralBlack),
                  maxLines: 1,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    if (location.isNotEmpty) ...[
                      Transform.translate(
                        offset: const Offset(0, 1),
                        child: const Icon(
                          Icons.location_on,
                          color: FigmaColors.neutralNeutral4,
                          size: 18,
                        ),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        location,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: FigmaColors.neutralNeutral4),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                    ],
                    Transform.translate(
                      offset: const Offset(0, 1),
                      child: const Icon(
                        Icons.wallet,
                        color: FigmaColors.neutralNeutral4,
                        size: 18,
                      ),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      rateText,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: FigmaColors.neutralNeutral4),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 18,
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Aktivno još: ',
                        style: TextStyle(
                          color: Color(0xFF6C7580),
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          height: 0.12,
                        ),
                      ),
                      TextSpan(
                        text: activeFor == 1 ? '1 dan' : '$activeFor dana',
                        style: const TextStyle(
                          color: Color(0xFF6C7580),
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          height: 0.12,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            const Align(
                alignment: Alignment.centerRight,
                child: Icon(Icons.arrow_forward_ios,
                    size: 19, color: FigmaColors.neutralNeutral4))
          ],
        ),
      ),
    );
  }
}
