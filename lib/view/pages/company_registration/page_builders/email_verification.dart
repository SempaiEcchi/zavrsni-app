import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firmus/gen/assets.gen.dart';
import 'package:firmus/infra/actions/registration_action.dart';
import 'package:firmus/infra/stores/company_registration.dart';
import 'package:firmus/localizations.dart';
import 'package:firmus/router/router.dart';
import 'package:firmus/view/pages/login/login_page.dart';
import 'package:firmus/view/pages/registration/widgets/arrow_button.dart';
import 'package:firmus/view/pages/registration/widgets/constrained_body.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../helper/email_opener.dart';

class EmailVerificationPage extends ConsumerStatefulWidget {
  const EmailVerificationPage({Key? key}) : super(key: key);

  @override
  ConsumerState<EmailVerificationPage> createState() =>
      _EmailValidateScreenState();
}

class _EmailValidateScreenState extends ConsumerState<EmailVerificationPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  @override
  void initState() {
    super.initState();

    Future(() async {
      final state = ref.read(companyRegistrationNotifierProvider);

      final email = ref.refresh(emailProvider);

      RegistrationAction.of(ref).signInWithoutPassword(email).catchError((e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      });
    }).catchError((e, st) async {
      if (e is DioException) {
        if (e.response?.statusCode == HttpStatus.forbidden) {
          await ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(
                  content: Text("Email se već koristi. Ulogirajte se.")))
              .closed;
        }
      }
      if (kReleaseMode) {
        await FirebaseCrashlytics.instance.recordError(e, st,
            information: [ref.read(emailProvider).toString()]);
      }
      await ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(
              content: Text("Greška prilikom registracije. Pokušajte ponovo.")))
          .closed;
      ref.invalidate(companyRegistrationNotifierProvider);
      GoRouter.of(context).pushReplacement(RoutePaths.onboarding);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(
            height: 24,
          ),
          Expanded(
            child: SizedBox(
              width: double.maxFinite,
              child: Stack(
                children: [
                  Align(
                      alignment: Alignment.topCenter,
                      child: Assets.images.handshake
                          .image(fit: BoxFit.cover, height: 250)
                          .animate()
                          .fadeIn(duration: 100.ms)
                          .scale(
                              duration: 200.ms, begin: const Offset(0.9, 0.9))),
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
              ),
            ),
          ),
          const SizedBox(
            height: 52,
          ),
        ],
      ),
    );
  }
}
