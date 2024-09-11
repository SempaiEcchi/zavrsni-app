import 'package:firmus/theme/_light_theme.dart';
import 'package:firmus/view/pages/registration/widgets/constrained_body.dart';
import 'package:firmus/view/shared/buttons/primary_button.dart';
import 'package:firmus/view/shared/popups/anonymous_user_popup.dart';
import 'package:flutter/material.dart';
import 'package:firmus/helper/logger.dart';

class GenericErrorPopup extends StatelessWidget with ShowDialogMixin {
  final String title;

  final String description;

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
                  Text(description,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: FigmaColors.neutralNeutral4)),
                  const SizedBox(
                    height: 24,
                  ),
                  PrimaryButton(
                    onTap: () {
                      Navigator.of(context).pop(false);
                    },
                    text: "Pokušaj ponovno",
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                ],
              ),
            )),
      ),
    );
  }

  const GenericErrorPopup({
    super.key,
    required this.title,
    required this.description,
  });
}
