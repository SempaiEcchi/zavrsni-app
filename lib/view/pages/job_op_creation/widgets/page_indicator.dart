import 'package:firmus/theme/_light_theme.dart';
import 'package:flutter/material.dart';

class JobCreationPageIndicator extends StatelessWidget {
  final int total;
  final int current;

  const JobCreationPageIndicator({
    super.key,
    required this.total,
    required this.current,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      height: 26,
      decoration: BoxDecoration(
        color: FigmaColors.neutralNeutral8,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ...List.generate(total, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: Container(
                  width: 26,
                  height: 7,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: index + 1 == current
                        ? Theme.of(context).primaryColor
                        : FigmaColors.neutralNeutral4,
                  ),
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}
