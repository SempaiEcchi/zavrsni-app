import 'package:fade_and_translate/fade_and_translate.dart';
import 'package:firmus/gen/assets.gen.dart';
import 'package:firmus/helper/warmup_provider.dart';
import 'package:firmus/infra/services/analytics/analytics_service.dart';
import 'package:firmus/infra/stores/company_registration.dart';
import 'package:firmus/infra/stores/registration_store.dart';
import 'package:firmus/main.dart';
import 'package:firmus/models/user_type.dart';
import 'package:firmus/router/router.dart';
import 'package:firmus/view/pages/registration/widgets/constrained_body.dart';
import 'package:firmus/view/shared/buttons/animated_tap_button.dart';
import 'package:firmus/view/shared/popups/generic_action_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:open_mail_app/open_mail_app.dart';

class PickRegistrationTypePage extends ConsumerStatefulWidget {
  const PickRegistrationTypePage({Key? key}) : super(key: key);

  @override
  ConsumerState<PickRegistrationTypePage> createState() =>
      _PickRegistrationTypePageState();
}

class _PickRegistrationTypePageState
    extends ConsumerState<PickRegistrationTypePage> {
  @override
  Widget build(BuildContext context) {
    setNavBlue();

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(
        children: [
          Positioned.fill(
              child: ConstrainedBody(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 120,
                ),
                Text(
                  "Odaberi vrstu prijave",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 64),
                const UserTypeTile(UserType.student),
                const SizedBox(
                  height: 16,
                ),
                const UserTypeTile(UserType.company),
              ],
            ),
          )),
          Positioned(
            top: 0,
            child: SafeArea(
                top: true,
                child: FirmusCustomAppBar(
                  onPressed: () {
                    GoRouter.of(context).pop();
                  },
                  text: 'Registracija',
                )),
          ),
        ],
      ),
    );
  }
}

class UserTypeTile extends ConsumerWidget {
  final UserType type;

  const UserTypeTile(this.type, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (title, desc) = titleAndDescFor(type);

    return AnimatedTapButton(
      onTap: () {
        ref.a.logEvent(
          name: AnalyticsEvent.pick_registration_type,
          parameters: {"type": type.toString()},
        );

        if (type == UserType.student) {
          //warmup
          warmupProvider(ref, jobProfilesProvider);

          GoRouter.of(context).push(RoutePaths.registration);
        } else {
          //dolazi uskoro
          GenericActionPopup(
            title: "Prijava za poslodavce dolazi uskoro!",
            icon: SizedBox(),
            description: """
            Ako se želite prijaviti kao poslodavac, kontaktirajte nas kako bismo Vam dali pristup Firmusu.
            """,
            actionText: "Pošalji mail",
            onActionPressed: () {
              OpenMailApp.composeNewEmailInMailApp(
                  emailContent: EmailContent(to: ["info@dposlovi.com"]));
              context.pop();
            },
          ).show(context);

          // GoRouter.of(context).push(RoutePaths.registrationCompany);
        }

        ref.read(registrationStoreProvider).reset();
        ref.invalidate(companyRegistrationNotifierProvider);
      },
      child: Container(
        height: 108,
        width: 450,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 20, top: 16, bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: textStyles.f5Heavy0.copyWith(color: Colors.white),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Expanded(
                      child: Text(
                        desc,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              size: 40,
            ),
            const SizedBox(
              width: 4,
            ),
          ],
        ),
      ),
    );
  }

  (String, String) titleAndDescFor(UserType type) {
    switch (type) {
      case UserType.student:
        return (
          "Prijava za radnike",
          "Prijava u svrhu pronalaska studentskih poslova..."
        );
      case UserType.company:
        return (
          'Prijava za poslodavce',
          "Prijava u svrhu pronalaska kvalitetne radne snage..."
        );
      case UserType.admin:
        return ("", "");
    }
  }
}

class FirmusCustomAppBar extends ConsumerWidget {
  final VoidCallback onPressed;
  final String text;
  final bool centerTitle;

  const FirmusCustomAppBar({
    super.key,
    required this.onPressed,
    required this.text,
    this.centerTitle = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (centerTitle) {
      return SizedBox(
        height: 40,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                  splashRadius: 0.01,
                  iconSize: 30,
                  color: Colors.white,
                  onPressed: onPressed,
                  icon: Assets.images.arrowBack.image(
                      height: 30, color: Theme.of(context).iconTheme.color)),
            ),
            Align(
              alignment: Alignment.center,
              child: FadeAndTranslate(
                autoStart: true,
                translate: const Offset(10.0, 0.0),
                duration: const Duration(milliseconds: 300),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    text,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }

    return SizedBox(
      height: 40,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
              splashRadius: 0.01,
              iconSize: 30,
              color: Colors.white,
              onPressed: onPressed,
              icon: Assets.images.arrowBack
                  .image(height: 30, color: Theme.of(context).iconTheme.color)),
          FadeAndTranslate(
            autoStart: true,
            translate: const Offset(10.0, 0.0),
            duration: const Duration(milliseconds: 300),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                text,
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class FirmusAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: SizedBox(
          child: FirmusCustomAppBar(
        onPressed: onPressed,
        centerTitle: true,
        text: text,
      )),
    );
  }

  @override
  Size get preferredSize => const Size(double.infinity, 40);

  const FirmusAppBar({
    super.key,
    required this.onPressed,
    required this.text,
  });
}
