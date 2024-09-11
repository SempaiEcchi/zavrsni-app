import 'package:firmus/gen/assets.gen.dart';
import 'package:firmus/helper/email_opener.dart';
import 'package:firmus/helper/logger.dart';
import 'package:firmus/infra/actions/registration_action.dart';
import 'package:firmus/infra/observables/registration_observable.dart';
import 'package:firmus/infra/stores/company_registration.dart';
import 'package:firmus/infra/stores/user_notifier.dart';
import 'package:firmus/localizations.dart';
import 'package:firmus/theme/_light_theme.dart';
import 'package:firmus/view/pages/registration/widgets/arrow_button.dart';
import 'package:firmus/view/pages/registration/widgets/constrained_body.dart';
import 'package:firmus/view/pages/registration/widgets/field_title.dart';
import 'package:firmus/view/pages/registration/widgets/next_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../main.dart';
import '../../../router/router.dart';
import '../onboarding/pick_registation_type.dart';

final StateProvider<String?> emailProvider = StateProvider((ref) {
  final state = ref.read(registrationOProvider);
  final state2 = ref.read(companyRegistrationNotifierProvider);

  return state.getOrNull("email") ?? state2.getOrNull("email");
});

class LoginPage extends ConsumerStatefulWidget {
  final String? error;

  const LoginPage([this.error]);

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool sentEmail = false;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    if (widget.error != null) {
      Future(() {
        ScaffoldMessenger.of(_scaffoldKey.currentContext!)
            .showSnackBar(SnackBar(content: Text(widget.error!)));
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).primaryColor,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: FormBuilder(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 24,
                  ),
                  Expanded(
                    child: SizedBox(
                      width: double.maxFinite,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        child: sentEmail
                            ? const SentEmailWidget()
                            : buildEnterEmailWidget(context),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 52,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: SafeArea(
              top: true,
              child: FirmusCustomAppBar(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                text: context.loc.back,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEnterEmailWidget(BuildContext context) {
    if (kIsWeb) {
      return WebEnterEmailWidget(
        onRequestLogin: (email, password) async {
          ref.invalidate(registrationOProvider);
          ref.invalidate(companyRegistrationNotifierProvider);
          return RegistrationAction.of(ref)
              .requestLoginAndPass(email, password)
              .then((v) async {
            final userType = await ref
                .refresh(firmusUserProvider.future)
                .then((value) => value!.userType);

            GoRouter.of(context).go(RoutePaths.home);
          }).catchError((e, st) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(e.message.toString())));
          });
        },
      );
    }

    return EnterEmailWidget(
      onRequestLogin: (email) {
        ref.invalidate(registrationOProvider);
        ref.invalidate(companyRegistrationNotifierProvider);
        setState(() {
          sentEmail = true;
        });
        ref.read(emailProvider.notifier).state = email;
        RegistrationAction.of(ref).requestLogin(email).catchError((e, st) {
          logger.info(e);
          setState(() {
            sentEmail = false;
          });
          if (e is NotRegisteredException) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(e.message.toString())));
          }
        });
      },
    );
  }
}

class EnterEmailWidget extends StatefulHookConsumerWidget {
  final Function(String email) onRequestLogin;

  const EnterEmailWidget({super.key, required this.onRequestLogin});

  @override
  ConsumerState<EnterEmailWidget> createState() => _EnterEmailWidgetState();
}

class _EnterEmailWidgetState extends ConsumerState<EnterEmailWidget> {
  @override
  Widget build(BuildContext context) {
    setNavBlue();
    final key = useMemoized(() => GlobalKey<FormFieldState>(), const []);

    return ConstrainedBody(
      child: Column(
        children: [
          /// Email adresa
          const SizedBox(
            height: 90,
          ),
          Text(
            "Prijavi se svojom email adresom",
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(
            height: 24,
          ),

          SizedBox(
            child: FormBuilderTextField(
              autocorrect: false,
              key: key,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
                FormBuilderValidators.email(),
              ]),
              keyboardType: TextInputType.emailAddress,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Colors.white),
              decoration: inputDecoration.copyWith(
                hintText: "Unesite studentsku email adresu",
                hintStyle: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Colors.white.withOpacity(0.5)),
              ),
              textInputAction: TextInputAction.done,
              initialValue: kDebugMode ? "leo.ironkid@gmail.com" : null,
              name: 'email',
            ).withTitle("Email adresa",
                large: key.currentState?.hasError ?? false),
          ),
          const SizedBox(
            height: 52,
          ),
          NextButton(onTap: () {
            key.currentState!.save();
            if (key.currentState!.validate())
              widget.onRequestLogin(key.currentState!.value);
            setState(() {});
          }),
        ],
      ),
    );
  }
}

class SentEmailWidget extends StatelessWidget {
  const SentEmailWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
            alignment: Alignment.topCenter,
            child: Assets.images.handshake
                .image(fit: BoxFit.cover, height: 250)
                .animate()
                .fadeIn(duration: 100.ms)
                .scale(duration: 200.ms, begin: const Offset(0.9, 0.9))),
        Positioned.fill(
          top: 200,
          child: ConstrainedBody(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  context.loc.verifyEmailTitle,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(
                  height: 24,
                ),
                // FadeAndTranslate(
                //   autoStart: true,
                //   translate: const Offset(0.0, 20.0),
                //   duration: const Duration(milliseconds: 300),
                //   child: FormBuilderTextField(
                //     enabled: false,
                //     style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white),
                //     decoration: inputDecoration,
                //     name: 'code',
                //   ).withTitle("Verifikacijski kod"),
                // ),
                const SizedBox(
                  height: 48,
                ),
                ArrowButton(
                    onTap: () async {
                      await openEmail(context);
                      // showLoadingDialog(context);
                      // await ref.read(userNotifierProvider.future);
                      // Navigator.of(context).pop();
                      //
                      // GoRouter.of(context).pushAndRemoveUntil(RoutePaths.home);
                    },
                    text: "Otvori Mail",
                    rotation: 45)
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class WebEnterEmailWidget extends StatefulHookConsumerWidget {
  final Future Function(String email, String password) onRequestLogin;

  const WebEnterEmailWidget({super.key, required this.onRequestLogin});

  @override
  ConsumerState<WebEnterEmailWidget> createState() =>
      _WebEnterEmailWidgetState();
}

class _WebEnterEmailWidgetState extends ConsumerState<WebEnterEmailWidget> {
  @override
  Widget build(BuildContext context) {
    setNavBlue();
    final key = useMemoized(() => GlobalKey<FormFieldState>(), const []);
    final key2 = useMemoized(() => GlobalKey<FormFieldState>(), const ["pass"]);

    return ConstrainedBody(
      child: Column(
        children: [
          /// Email adresa
          const SizedBox(
            height: 90,
          ),
          Text(
            "Prijavi se svojom email adresom",
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(
            height: 24,
          ),

          SizedBox(
            child: FormBuilderTextField(
              autocorrect: false,
              key: key,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
                FormBuilderValidators.email(),
              ]),
              keyboardType: TextInputType.emailAddress,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Colors.white),
              decoration: inputDecoration.copyWith(
                hintText: "Unesite email adresu",
                hintStyle: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Colors.white.withOpacity(0.5)),
              ),
              textInputAction: TextInputAction.done,
              initialValue: kDebugMode ? "leo.radocaj2+admin@gmail.com" : null,
              name: 'email',
            ).withTitle("Email adresa",
                large: key.currentState?.hasError ?? false),
          ),
          SizedBox(
            height: 24,
          ),
          SizedBox(
            child: FormBuilderTextField(
              autocorrect: false,
              key: key2,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
                FormBuilderValidators.email(),
              ]),
              keyboardType: TextInputType.emailAddress,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Colors.white),
              decoration: inputDecoration.copyWith(
                hintText: "Unesite lozinku",
                hintStyle: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Colors.white.withOpacity(0.5)),
              ),
              textInputAction: TextInputAction.done,
              initialValue: kDebugMode ? "Dposlovi999" : null,
              name: 'password',
            ).withTitle("Lozinka", large: key2.currentState?.hasError ?? false),
          ),
          const SizedBox(
            height: 52,
          ),
          NextButton(onTap: () async {
            key.currentState!.save();
            if (key.currentState!.validate())
              await widget.onRequestLogin(
                  key.currentState!.value, key2.currentState!.value);
            setState(() {});
          }),
        ],
      ),
    );
  }
}
