import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firmus/gen/assets.gen.dart';
import 'package:firmus/helper/logger.dart';
import 'package:firmus/infra/stores/splash_page_controller.dart';
import 'package:firmus/router/router.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SplashPage extends HookConsumerWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(splashControllerProvider, (previous, next) {
      if (next is SplashLoaded) {
        handleRoute(next.splashLoadedState);
      }
      if (next is SplashError) {
        logger.shout(next.message);
        FirebaseCrashlytics.instance
            .recordError(next.message, next.stack, fatal: true);
        GoRouter.of(context)
            .pushReplacement(RoutePaths.maintenance, extra: next.message);
      }
    });

    return Scaffold(
      body: Center(
        child: Hero(
            tag: "firmus_logo",
            child: Assets.images.landingLogo
                .image(height: 46 * 1.5)
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scaleXY(
                    begin: 1,
                    end: 1.2,
                    duration: const Duration(milliseconds: 2000))),
      ),
    );
  }
}

void handleRoute(SplashLoadedState state) {
  switch (state) {
    case SplashLoadedState.anon:
      if (kIsWeb) {
        router.pushReplacement(RoutePaths.login);
        break;
      }
      router.pushReplacement(RoutePaths.onboarding);
      break;

    case SplashLoadedState.loggedIn:
      router.pushReplacement(RoutePaths.home);
      break;
  }
}
