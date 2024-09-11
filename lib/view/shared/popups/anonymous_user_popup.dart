import 'package:firmus/infra/stores/user_notifier.dart';
import 'package:firmus/router/router.dart';
import 'package:firmus/view/shared/popups/generic_action_popup.dart';
import 'package:flutter/material.dart';
import 'package:firmus/helper/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AnonymousUserPopup extends StatelessWidget with ShowDialogMixin {
  const AnonymousUserPopup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return GenericActionPopup(
            title: "Anonimni korisnik",
            icon: const SizedBox(),
            description:
                "Trenutno ste prijavljeni kao anonimni korisnik.\nDa biste koristili sve funkcionalnosti aplikacije, prijavite se.",
            actionText: "Prijavi se",
            onActionPressed: () {
              ref.read(studentNotifierProvider.notifier).logout();
              GoRouter.of(context).pushReplacement(RoutePaths.onboarding);
            });
      },
    );
  }
}

mixin ShowDialogMixin on Widget {
  Future<T?> showPopup<T>(BuildContext context) {
    return showDialog(
      context: context,
      useSafeArea: false,
      builder: (context) => this,
    );
  }
}
