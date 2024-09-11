import 'package:firmus/infra/stores/user_notifier.dart';
import 'package:firmus/router/router.dart';
import 'package:firmus/view/pages/employer_purchases/employer_purchases_widget.dart';
import 'package:firmus/view/shared/buttons/primary_button.dart';
import 'package:firmus/view/shared/buttons/secondary_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EmployerProfilePage extends ConsumerWidget {
  const EmployerProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PrimaryButton(
            text: "Kupovina test",
            onTap: () {
              const EmployerPurchasesSheet().show(context);
            },
          ),
          const SizedBox(
            height: 20,
          ),
          SecondaryButton(
              onTap: () {
                ref.read(firmusUserProvider.notifier).logout();
                GoRouter.of(context).pushAndRemoveUntil(RoutePaths.onboarding);
              },
              text: "Logout")
        ],
      ),
    );
  }
}
