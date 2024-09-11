import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firmus/helper/logger.dart';
import 'package:firmus/infra/observables/registration_observable.dart';
import 'package:firmus/infra/services/analytics/analytics_service.dart';
import 'package:firmus/infra/stores/company_notifier.dart';
import 'package:firmus/infra/stores/company_registration.dart';
import 'package:firmus/infra/stores/job_offer_store.dart';
import 'package:firmus/infra/stores/registration_store.dart';
import 'package:firmus/infra/stores/user_notifier.dart';
import 'package:firmus/models/user_type.dart';
import 'package:firmus/router/router.dart';
import 'package:firmus/view/pages/employeer_home/controller/employer_jobs_notifier.dart';
import 'package:firmus/view/pages/login/login_page.dart';
import 'package:firmus/view/pages/registration/registration_image_cropper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';

final deepLinkServiceProvider = Provider<DeeplinkService>((ref) {
  return DeeplinkService(ref);
});

class DeeplinkService {
  final Ref ref;

  DeeplinkService(this.ref);

  final FirebaseDynamicLinks instance = FirebaseDynamicLinks.instance;

  PublishSubject<PendingDynamicLinkData> linkStream =
      PublishSubject<PendingDynamicLinkData>();

  Future<void> init() async {
    if (kIsWeb) return;

    _setupListener();
    instance.onLink.listen((event) {
      linkStream.add(event);
    });

    final PendingDynamicLinkData? initialLink = await instance.getInitialLink();
    if (initialLink != null) {
      linkStream.add(initialLink);
    }
  }

  void _setupListener() {
    linkStream.listen((event) {
      onLinkEvent(event.link);
    });
  }

  BuildContext get context =>
      router.routerDelegate.navigatorKey.currentContext!;

  void onLinkEvent(Uri link) async {
    logger.info("on link");
    // Confirm the link is a sign-in with email link.
    if (FirebaseAuth.instance.isSignInWithEmailLink(link.toString())) {
      showLoadingDialog(context, true);
      bool isFromStudentRegistration =
          ref.read(registrationOProvider).hasData();
      bool isFromCompanyRegistration =
          ref.read(companyRegistrationNotifierProvider).hasData();
      final currentUser = FirebaseAuth.instance.currentUser!;
      if (currentUser.email != null) {
        if (FirebaseAuth.instance.currentUser != null) {
          await FirebaseAuth.instance.signOut();
        }
        await FirebaseAuth.instance.signInAnonymously();
      }
      String emailAuth = ref.read(emailProvider)!;

      try {
        final userCredential = await FirebaseAuth.instance
            .signInWithEmailLink(email: emailAuth, emailLink: link.toString());
        logger.info("signed in with email link");
        if (isFromStudentRegistration) {
          await ref.read(registrationStoreProvider).register();
        }

        if (isFromCompanyRegistration) {
          await ref
              .read(companyRegistrationNotifierProvider.notifier)
              .register();
        }

        final userType = await ref
            .refresh(firmusUserProvider.future)
            .then((value) => value!.userType);

        await userType.when(
          student: () async {
            await ref.read(studentNotifierProvider.future);
            await ref.refresh(jobOfferStoreProvider.future);
          },
          company: () async {
            await ref.read(companyNotifierProvider.future);
            await ref.read(employerJobsProvider.future);
          },
          admin: () async {},
        );

        router.pop();
        ref
            .read(analyticsServiceProvider)
            .logEvent(name: AnalyticsEvent.email_link_sign_in, parameters: {
          "email": emailAuth,
          "user_type": userType.toString(),
        });
        router.pushReplacement(RoutePaths.home);
      } catch (e, st) {
        debugPrintStack(stackTrace: st);
        logger.info(e);
        router.pop();
        router.pushReplacement(RoutePaths.onboarding);
        return;
      }
    }
  }
}



