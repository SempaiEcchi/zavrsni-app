import 'package:firmus/config/config.dart';
import 'package:firmus/infra/observables/company_registration_state.dart';
import 'package:firmus/infra/stores/company_registration.dart';
import 'package:firmus/view/pages/company_registration/page_builders/company_account_creation.dart';
import 'package:firmus/view/pages/company_registration/page_builders/company_info.dart';
import 'package:firmus/view/pages/company_registration/page_builders/email_verification.dart';
import 'package:firmus/view/pages/onboarding/pick_registation_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

enum CompanyRegistrationPage { companyInfo, accountCreation, verifyEmail }

class CompanyRegistrationFlowPage extends ConsumerWidget {
  const CompanyRegistrationFlowPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final obs = ref.watch(companyRegistrationNotifierProvider);
    final notifier = ref.read(companyRegistrationNotifierProvider.notifier);

    return WillPopScope(
      onWillPop: () async {
        if (obs.currentPage.index == 0) {
          GoRouter.of(context).pop();
        } else {
          notifier.previousPage();
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        resizeToAvoidBottomInset: true,
        body: FirmusConfig.COMPANY_ENABLED == false
            ? SafeArea(
                top: true,
                child: Stack(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: BackButton(),
                    ),
                    Center(
                      child: Text(
                        "Prijava za poslodavce dolazi uskoro",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ),
                  ],
                ),
              )
            : Stack(
                children: [
                  Positioned.fill(
                      child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: page(obs, context))),
                  Positioned(
                    top: 0,
                    child: ColoredBox(
                      color: Theme.of(context).primaryColor,
                      child: SafeArea(
                        top: true,
                        bottom: false,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: FirmusCustomAppBar(
                            onPressed: () {
                              if (obs.currentPage.index == 0) {
                                GoRouter.of(context).pop();
                              } else {
                                notifier.previousPage();
                              }
                            },
                            text: 'Registracija',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget page(CompanyRegistrationState state, BuildContext context) {
    switch (state.currentPage) {
      case CompanyRegistrationPage.companyInfo:
        return const CompanyInfoPage();
      case CompanyRegistrationPage.accountCreation:
        return const CompanyDataPage();
      case CompanyRegistrationPage.verifyEmail:
        return const EmailVerificationPage();
    }
  }
}
