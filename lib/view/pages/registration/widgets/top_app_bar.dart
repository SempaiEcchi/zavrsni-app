import 'package:firmus/infra/actions/registration_action.dart';
import 'package:firmus/router/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../infra/observables/registration_observable.dart';
import '../../onboarding/pick_registation_type.dart';

class RegistrationAppBar extends ConsumerWidget {
  const RegistrationAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = ref.watch(registrationOProvider).title(context);

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: FirmusCustomAppBar(
        onPressed: () {
          final page = ref.read(registrationOProvider).currentPage;

          if (page.index == 0) {
            GoRouter.of(context).canPop()
                ? GoRouter.of(context).pop()
                : GoRouter.of(context).pushReplacement(RoutePaths.onboarding);
          } else {
            RegistrationAction.of(ref).previousPage();
          }
        },
        text: title,
      ),
    );
  }
}
