import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firmus/helper/logger.dart';
import 'package:firmus/infra/services/job/entity/employer_job_offers.dart';
import 'package:firmus/main.dart';
import 'package:firmus/models/job_offers.dart';
import 'package:firmus/models/student_job_offers.dart';
import 'package:firmus/view/pages/chats/controllers/chat_page_state.dart';
import 'package:firmus/view/pages/chats/single_chat_page.dart';
import 'package:firmus/view/pages/company/company_details_page.dart';
import 'package:firmus/view/pages/company_registration/company_registration_page.dart';
import 'package:firmus/view/pages/job_op_creation/job_op_creation_page.dart';
import 'package:firmus/view/pages/job_op_edit/job_op_edit.dart';
import 'package:firmus/view/pages/onboarding/pick_registation_type.dart';
import 'package:firmus/view/pages/onboarding/welcome_page.dart';
import 'package:firmus/view/pages/profile/edit_pages/bio_page.dart';
import 'package:firmus/view/pages/profile/edit_pages/cv_edit_page.dart';
import 'package:firmus/view/pages/profile/edit_pages/location_page.dart';
import 'package:firmus/view/pages/profile/edit_pages/university_edit_page.dart';
import 'package:firmus/view/pages/registration/registration_image_cropper.dart';
import 'package:firmus/view/pages/student_home/home_page.dart';
import 'package:firmus/view/pages/video_autofill_job_creation_page/full_screen_job_video_recorder.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../infra/services/job/entity/job_offer_details_response.dart';
import '../view/pages/employeer_home/employer_job_details.dart';
import '../view/pages/job_status_page/job_status_page.dart';
import '../view/pages/login/login_page.dart';
import '../view/pages/maintenance_page/maintenance_page.dart';
import '../view/pages/profile/edit_pages/profile_edit_page.dart';
import '../view/pages/profile/perference_edit.dart';
import '../view/pages/registration/registration_page.dart';
import '../view/pages/send_job_request/send_job_request_page.dart';
import '../view/pages/splash/splash_page.dart';

BuildContext get popupContext =>
    router.routerDelegate.navigatorKey.currentContext!;

class RoutePaths {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const maintenance = '/maintenance';
  static const login = '/login';
  static const pickRegistrationType = '/pickRegistrationType';
  static const registration = '/registration';
  static const registrationCompany = '/registrationCompany';
  static const registrationImageCropperPage = '/registrationImageCropper';
  static const profileEdit = '/profileEdit';
  static const bioEdit = '/bioEditPage';
  static const universityEdit = '/universityEdit';
  static const cvEdit = '/cvEdit';
  static const locationEdit = '/locationEdit';
  static const chat = '/chat';
  static const home = '/home';
  static const jobCreationPage = '/jobCreationPage';
  static const companyInfo = '/companyInfo';
  static const employerJobDetails = '/employerJobDetails';
  static const videoJobCreationPage = '/videoJobCreationPage';
  static const jobStatusPage = '/jobStatusPage';
  static const jobOpEdit = '/jobOpEdit';
  static const sendJobRequest = '/sendJobRequest';
  static const preferencesEdit = '/preferencesEdit';
}

final GoRouter router = GoRouter(
  navigatorKey: navkey,
  observers: [FirebaseAnalyticsObserver(
      analytics: FirebaseAnalytics.instance)],
  initialLocation: RoutePaths.splash,
  routes: <RouteBase>[
    GoRoute(
        path: RoutePaths.splash,
        builder: (BuildContext context, GoRouterState state) {
          return const SplashPage();
        },
        routes: const []),
    GoRoute(
        path: RoutePaths.sendJobRequest,
        builder: (BuildContext context, GoRouterState state) {
          final data = state.extra as Map<String, dynamic>;
          return SendJobRequestPage(
            matchedApplicant: data["matchedApplicant"] as MatchedApplicant,
            jobOp: data["jobOpportunity"] as JobOpportunity,
          );
        },
        routes: const []),
    GoRoute(
        path: RoutePaths.maintenance,
        builder: (BuildContext context, GoRouterState state) {
          return MaintenancePage(error: state.extra as String?);
        },
        routes: const []),
    GoRoute(
        path: RoutePaths.preferencesEdit,
        builder: (BuildContext context, GoRouterState state) {
          return const PreferenceEditPage();
        },
        routes: const []),
    GoRoute(
        path: RoutePaths.chat,
        builder: (BuildContext context, GoRouterState state) {
          return SingleChatPage(state.extra as ChatOverview);
        },
        routes: const []),
    GoRoute(
      path: RoutePaths.jobOpEdit,
      builder: (BuildContext context, GoRouterState state) {
        return JobOpEdit(
          jobOpportunity: state.extra as JobOpportunity,
        );
      },
    ),
    GoRoute(
      path: RoutePaths.employerJobDetails,
      builder: (BuildContext context, GoRouterState state) {
        return EmployerJobDetailsPage(
            jobDetails: state.extra as EmployerJobOffer);
      },
    ),
    GoRoute(
      path: RoutePaths.jobStatusPage,
      builder: (BuildContext context, GoRouterState state) {
        return JobStatusPage(state.extra as AppliedJobOffer);
      },
    ),
    GoRoute(
        path: RoutePaths.login,
        builder: (BuildContext context, GoRouterState state) {
          if (state.extra is Map) {
            logger.info(state.extra);
            return LoginPage(
              (state.extra as Map)["error"].toString(),
            );
          }
          return const LoginPage();
        },
        routes: const []),
    GoRoute(
        path: RoutePaths.onboarding,
        builder: (BuildContext context, GoRouterState state) {
          return const WelcomePage();
        },
        routes: const []),
    GoRoute(
      path: RoutePaths.pickRegistrationType,
      builder: (BuildContext context, GoRouterState state) {
        return const PickRegistrationTypePage();
      },
    ),
    GoRoute(
      path: RoutePaths.companyInfo,
      builder: (BuildContext context, GoRouterState state) {
        return CompanyDetailsPage(company: state.extra as SimpleCompany);
      },
    ),
    GoRoute(
      path: RoutePaths.registration,
      builder: (BuildContext context, GoRouterState state) {
        if (state.extra is Map) {
          logger.info(state.extra);
          return RegistrationPage(
            (state.extra as Map)["error"].toString(),
          );
        }
        return const RegistrationPage();
      },
    ),
    GoRoute(
      path: RoutePaths.registrationCompany,
      builder: (BuildContext context, GoRouterState state) {
        return const CompanyRegistrationFlowPage();
      },
    ),
    GoRoute(
      path: RoutePaths.registrationImageCropperPage,
      builder: (BuildContext context, GoRouterState state) {
        return RegistrationImageCropperPage(
          uncroppedImage: state.extra as File,
        );
      },
    ),
    GoRoute(
      path: RoutePaths.home,
      builder: (BuildContext context, GoRouterState state) {
        return const StudentHomePage();
      },
    ),
    GoRoute(
      path: RoutePaths.jobCreationPage,
      builder: (BuildContext context, GoRouterState state) {
        return const JobOpCreationPage();
      },
    ),
    GoRoute(
      path: RoutePaths.videoJobCreationPage,
      builder: (BuildContext context, GoRouterState state) {
        return const FullScreenJobVideoRecorder();
      },
    ),
    GoRoute(
      path: RoutePaths.profileEdit,
      builder: (BuildContext context, GoRouterState state) {
        return const ProfileEditPage();
      },
    ),
    GoRoute(
      path: RoutePaths.bioEdit,
      builder: (BuildContext context, GoRouterState state) {
        return const BioEditPage();
      },
    ),
    GoRoute(
      path: RoutePaths.universityEdit,
      builder: (BuildContext context, GoRouterState state) {
        return const UniversityEditPage();
      },
    ),
    GoRoute(
      path: RoutePaths.cvEdit,
      builder: (BuildContext context, GoRouterState state) {
        return const CVEditPage();
      },
    ),
    GoRoute(
      path: RoutePaths.locationEdit,
      builder: (BuildContext context, GoRouterState state) {
        return const LocationEditPage();
      },
    ),
  ],
);

extension SubRouteAttempt on GoRouter {
  void goSubRoute(String subRoute) {
    go('/$subRoute');
  }
}

extension GoRouterEXT on GoRouter {
  void pushAndRemoveUntil(String path, [Object? data]) {
    while (canPop()) {
      pop();
    }
    pushReplacement(path, extra: data);
  }
}
