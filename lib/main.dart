import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firmus/firebase_options.dart';
import 'package:firmus/helper/image_picker.dart';
import 'package:firmus/infra/services/lifecycle/lifecycle_provider.dart';
import 'package:firmus/router/router.dart';
import 'package:firmus/theme/_light_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:upgrader/upgrader.dart';

import 'localizations.dart';

const textStyles = FigmaTextStyles();

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

bool _firebaseInitialized = false;

void main() async {
  setUrlStrategy(null);

  runZonedGuarded(() async {
    setNavGrey();
    HttpOverrides.global = MyHttpOverrides();
    FormBuilderLocalizations.setCurrentInstance(
        FormBuilderLocalizationsImplHr());
    WidgetsFlutterBinding.ensureInitialized();

    //disable rotation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);



    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    _firebaseInitialized = true;

    await _initCrashlytics();

    await PathHelper.init();

    runApp(const ProviderScope(child: Firmus()));
  }, (error, stack) async {
    if (!_firebaseInitialized) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
    if (!kIsWeb) {
      FirebaseCrashlytics.instance.recordError(error, stack);
    }
  });
}

Future<void> _initCrashlytics() async {
  if (kIsWeb) return;
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
  analytics.logAppOpen();
}

void setNavGrey() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.grey.withOpacity(0.1),
    systemNavigationBarColor: Colors.transparent,
  ));
}

void setNavBlue() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.grey.withOpacity(0.1),
    systemNavigationBarColor: Colors.transparent,
  ));
}

final keyboardOnProvider = StateProvider<bool>((ref) => false);

final navkey = GlobalKey<NavigatorState>();

class Firmus extends ConsumerStatefulWidget {
  const Firmus({Key? key}) : super(key: key);

  @override
  ConsumerState<Firmus> createState() => _FirmusState();
}

class _FirmusState extends ConsumerState<Firmus> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    ref.read(lifeCycleControllerProvider.notifier).updateState(state);
  }

  @override
  Widget build(BuildContext context) {
    Future(() {
      ref.read(keyboardOnProvider.notifier).state =
          MediaQuery.of(context).viewInsets.bottom > 10;
    });
    return MaterialApp.router(
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
      routerDelegate: router.routerDelegate,
      title: "Firmus",
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: lightTheme,
      darkTheme: lightTheme,
    );
  }
}

final upgradeProvider = FutureProvider.autoDispose<bool>((ref) async {
  if(kIsWeb) return false;

  ref.keepAlive();
  await Upgrader.sharedInstance.initialize();

  return Upgrader.sharedInstance.isUpdateAvailable();
});
