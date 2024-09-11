import 'dart:async';

import 'package:firmus/gen/assets.gen.dart';
import 'package:firmus/infra/services/analytics/analytics_service.dart';
import 'package:firmus/infra/services/deeplink/deeplink_service.dart';
import 'package:firmus/infra/stores/admin_notifier.dart';
import 'package:firmus/infra/stores/company_notifier.dart';
import 'package:firmus/infra/stores/job_offer_store.dart';
import 'package:firmus/infra/stores/user_notifier.dart';
import "package:firmus/localizations.dart";
import 'package:firmus/main.dart';
import 'package:firmus/router/router.dart';
import 'package:firmus/view/pages/student_home/home_page.dart';
import 'package:firmus/view/shared/buttons/primary_button.dart';
import 'package:firmus/view/shared/buttons/secondary_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../profile/profile_page.dart';

class SomeWidget extends StatelessWidget {
  final String text;

  const SomeWidget(this.text);

  @override
  Widget build(BuildContext context) {
    print("rebuild $text");
    return Column(
      children: [
        Text(text),
        ...List.generate(10, (index) => Text("index: $index"))
      ],
    );
  }
}

class WelcomePage extends ConsumerStatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends ConsumerState<WelcomePage> {
  @override
  void initState() {
    setNavGrey();
    Future(() {
      ref.invalidate(studentNotifierProvider);
      ref.invalidate(adminNotifierProvider);
      ref.invalidate(companyNotifierProvider);
      ref.invalidate(firmusUserProvider);
    });
    super.initState();
  }

  @override
  void activate() {
    setNavGrey();
    super.activate();
  }

  @override
  Widget build(BuildContext context) {
    final radius = MediaQuery.of(context).size.width / 2;
    final y = MediaQuery.of(context).size.height / 12;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        bottom: false,
        minimum: const EdgeInsets.only(bottom: 12),
        child: Center(
          child: kIsWeb
              ? buildGestureDetector(context)
              : Container(
                  color: Colors.white,
                  // constraints: const BoxConstraints(maxWidth: 500),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.elliptical(radius, y),
                          bottomRight: Radius.elliptical(radius, y),
                        ),
                        child: SizedBox(
                          // height: MediaQuery.of(context).size.height / 2,
                          width: double.infinity,
                          child: Assets.images.welcomeGirl
                              .image(fit: BoxFit.cover)
                              .animate()
                              .moveY(),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Hero(
                                tag: "firmus_logo",
                                child: GestureDetector(
                                    onTap: () async {
                                      if (kReleaseMode) return;
                                      final link =
                                          await Clipboard.getData("text/plain");
                                      ref
                                          .read(deepLinkServiceProvider)
                                          .onLinkEvent(Uri.parse(link!.text!));
                                    },
                                    child: Assets.images.landingLogo
                                        .image(height: 46))),
                            const Spacer(),
                            const SizedBox(
                              height: 50,
                            ),
                            PrimaryButton(
                                onTap: () {
                                  GoRouter.of(context)
                                      .push(RoutePaths.pickRegistrationType);
                                },
                                text: context.loc.register),
                            const SizedBox(
                              height: 12,
                            ),
                            buildGestureDetector(context),
                            const Spacer(),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 20.0,
                                ),
                                child: Center(
                                  child: SecondaryButton(
                                    onTap: () async {
                                      ref.a.logEvent(
                                          name: AnalyticsEvent.login_anonymous);
                                      await ref
                                          .read(
                                              studentNotifierProvider.notifier)
                                          .createAnonStudent();
                                      await ref
                                          .refresh(firmusUserProvider.future);
                                      await ref.refresh(
                                          jobOfferStoreProvider.future);
                                      ref.refresh(currentPageProvider);
                                      GoRouter.of(context)
                                          .pushAndRemoveUntil(RoutePaths.home);
                                    },
                                    text: context.loc.skipLogin,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            const PrivacyTOSFooter(),
                            const SizedBox(
                              height: 8,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  GestureDetector buildGestureDetector(BuildContext context) {
    return GestureDetector(
      onTap: () {
        GoRouter.of(context).push(RoutePaths.login);
      },
      child: SizedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(context.loc.alreadyRegistered,
                style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(
              width: 6,
            ),
            Text(context.loc.login,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Theme.of(context).primaryColor)),
          ],
        ),
      ),
    );
  }
}

// if (false) const Spacer(),

// class _WebWelcome extends ConsumerWidget {
//   const _WebWelcome({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final radius = MediaQuery.of(context).size.width / 2;
//     final y = MediaQuery.of(context).size.height / 12;
//
//     return Scaffold(
//       body: Column(
//         children: [
//           const SizedBox(
//             height: 24,
//           ),
//           InkWell(
//               onTap: () {
//                 MatchedWithStudentPopup().show(context);
//                },
//               child: Center(child: Hero(tag: "firmus_logo", child: Assets.images.landingLogo.image(height: 140)))),
//           Spacer(),
//           const SizedBox(
//             height: 48,
//           ),
//           PrimaryButton(
//               onTap: () async {
//                 ref.invalidate(firmusUserProvider);
//                 return ref.read(authServiceProvider).logout();
//               },
//               text: "Resetiraj račune"),
//           const SizedBox(
//             height: 50,
//           ),
//           PrimaryButton(
//               onTap: () {
//                 GoRouter.of(context).push(RoutePaths.pickRegistrationType);
//               },
//               text: context.loc.register),
//           const SizedBox(
//             height: 12,
//           ),
//           GestureDetector(
//             onTap: () {
//               GoRouter.of(context).push(RoutePaths.login);
//             },
//             child: SizedBox(
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(context.loc.alreadyRegistered, style: Theme.of(context).textTheme.bodyLarge),
//                   const SizedBox(
//                     width: 6,
//                   ),
//                   Text(context.loc.login,
//                       style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).primaryColor)),
//                 ],
//               ),
//             ),
//           ),
//           Container(
//             width: 500,
//             child: IntrinsicHeight(
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Expanded(
//                     child: Container(
//                       color: const Color(0xffF3F8FE),
//                       width: MediaQuery.of(context).size.width,
//                       child: Padding(
//                         padding: const EdgeInsets.only(top: 20.0, bottom: 20),
//                         child: Center(
//                           child: SecondaryButton(
//                             onTap: () async {
//                               await ref.read(studentNotifierProvider.notifier).createAnonStudent();
//                               await ref.refresh(firmusUserProvider.future);
//                               await ref.refresh(jobOfferStoreProvider.future);
//                               GoRouter.of(context).pushAndRemoveUntil(RoutePaths.home);
//                             },
//                             text: context.loc.skipLogin,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: Container(
//                       color: const Color(0xffF3F8FE),
//                       width: MediaQuery.of(context).size.width,
//                       child: Padding(
//                         padding: const EdgeInsets.only(top: 20.0, bottom: 20),
//                         child: Center(
//                           child: SecondaryButton(
//                             fitText: true,
//                             onTap: () async {
//                               await ref.read(companyNotifierProvider.notifier).createFakeCompany();
//
//                               await ref.refresh(firmusUserProvider.future);
//
//                               GoRouter.of(context).pushAndRemoveUntil(RoutePaths.home);
//                             },
//                             text: "Napravi test firmu",
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           SizedBox(
//             height: 20,
//           ),
//         ],
//       ),
//     );
//   }
// }
