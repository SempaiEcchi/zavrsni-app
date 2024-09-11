import 'package:firmus/helper/open_settings.dart';
import 'package:firmus/infra/stores/notification_controller.dart';
import 'package:firmus/view/shared/buttons/primary_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationControl extends ConsumerWidget {
  const NotificationControl({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationControl = ref.watch(notificationController);
    if (notificationControl.hasValue == false) {
      return const Center(child: CircularProgressIndicator());
    }
    if (notificationControl.requireValue.permanentlyDenied) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Row(
          children: [
            const Text("Dozvoli obavijesti u postavkama"),
            const Spacer(),
            SmallPrimaryButton(
                onTap: () {
                  openSettings();
                },
                text: "Otvori postavke")
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: [
          const Text("Primaj obavijesti"),
          const Spacer(),
          SizedBox(
              height: 30,
              child: FittedBox(
                  child: CupertinoSwitch(
                      value: notificationControl.requireValue.isEnabled,
                      onChanged: (value) {
                        ref.read(notificationController.notifier).toggle();
                      }))),
        ],
      ),
    );
  }
}
