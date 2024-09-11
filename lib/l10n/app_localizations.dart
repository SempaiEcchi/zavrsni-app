import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_hr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('hr')
  ];

  /// No description provided for @helloWorld.
  ///
  /// In hr, this message translates to:
  /// **'Bok!'**
  String get helloWorld;

  /// No description provided for @active.
  ///
  /// In hr, this message translates to:
  /// **'Aktivni'**
  String get active;

  /// No description provided for @register.
  ///
  /// In hr, this message translates to:
  /// **'Registriraj se'**
  String get register;

  /// No description provided for @skipLogin.
  ///
  /// In hr, this message translates to:
  /// **'Istaži kao gost'**
  String get skipLogin;

  /// No description provided for @alreadyRegistered.
  ///
  /// In hr, this message translates to:
  /// **'Već imaš profil?'**
  String get alreadyRegistered;

  /// No description provided for @pickCity.
  ///
  /// In hr, this message translates to:
  /// **'Odaberi grad u kojem studiraš'**
  String get pickCity;

  /// No description provided for @save.
  ///
  /// In hr, this message translates to:
  /// **'Spremi'**
  String get save;

  /// No description provided for @back.
  ///
  /// In hr, this message translates to:
  /// **'Povratak'**
  String get back;

  /// No description provided for @videoCreationTitle.
  ///
  /// In hr, this message translates to:
  /// **'Prezentiraj se poslodavcima kroz kratki video 🎥'**
  String get videoCreationTitle;

  /// No description provided for @videoCreationsubtitle.
  ///
  /// In hr, this message translates to:
  /// **'Kroz video od maksimalno 1 minutu prezentiraj zašto bi poslodavac trebao odabrati baš tebe!'**
  String get videoCreationsubtitle;

  /// No description provided for @videoOptional.
  ///
  /// In hr, this message translates to:
  /// **'*korak nije obavezan te je video moguće snimiti/učitati naknadno'**
  String get videoOptional;

  /// No description provided for @experienceOptional.
  ///
  /// In hr, this message translates to:
  /// **'*korak nije obavezan te je poslovno iskustvo moguće naknadno dodavati i uređivati'**
  String get experienceOptional;

  /// No description provided for @pickExperience.
  ///
  /// In hr, this message translates to:
  /// **'Već imaš poslovnog iskustva?'**
  String get pickExperience;

  /// No description provided for @pickExperienceSubtitle.
  ///
  /// In hr, this message translates to:
  /// **'Povećaj šanse za matching sa idealnim poslodavcem dodavanjem poslovnog iskustva'**
  String get pickExperienceSubtitle;

  /// No description provided for @pickJobs.
  ///
  /// In hr, this message translates to:
  /// **'Odaberi pozicije koje te zanimaju'**
  String get pickJobs;

  /// No description provided for @pickJobsSubtitle.
  ///
  /// In hr, this message translates to:
  /// **'Pritisni kako bi mogao prilagoditi frekvenciju prikazivanja oglasa za odabranu vrstu posla'**
  String get pickJobsSubtitle;

  /// No description provided for @jobProfileFrequencyTitle.
  ///
  /// In hr, this message translates to:
  /// **'Oglase za odabranu vrstu posla \"{jobtitle}\" prikazuj'**
  String jobProfileFrequencyTitle(Object jobtitle);

  /// No description provided for @jobProfileFrequencyRarely.
  ///
  /// In hr, this message translates to:
  /// **'Vrlo rijetko'**
  String get jobProfileFrequencyRarely;

  /// No description provided for @jobProfileFrequencyOften.
  ///
  /// In hr, this message translates to:
  /// **'Vrlo često'**
  String get jobProfileFrequencyOften;

  /// No description provided for @enterBasicInfoTitle.
  ///
  /// In hr, this message translates to:
  /// **'Još jedan korak si do poslova!'**
  String get enterBasicInfoTitle;

  /// No description provided for @verifyEmailTitle.
  ///
  /// In hr, this message translates to:
  /// **'Poslali smo 🔗 na tvoju email adresu! Verificiraj se jednim klikom!'**
  String get verifyEmailTitle;

  /// No description provided for @continueNext.
  ///
  /// In hr, this message translates to:
  /// **'Nastavi'**
  String get continueNext;

  /// No description provided for @login.
  ///
  /// In hr, this message translates to:
  /// **'Prijavi se'**
  String get login;

  /// No description provided for @registationTitle.
  ///
  /// In hr, this message translates to:
  /// **'Registracija'**
  String get registationTitle;

  /// No description provided for @cityPicker.
  ///
  /// In hr, this message translates to:
  /// **'Odaberi grad'**
  String get cityPicker;

  /// No description provided for @continueWithSocial.
  ///
  /// In hr, this message translates to:
  /// **'Nastavi uz {social}'**
  String continueWithSocial(Object social);

  /// No description provided for @openPositions.
  ///
  /// In hr, this message translates to:
  /// **'Slobodnih mjesta:'**
  String get openPositions;

  /// No description provided for @companyOpenPositions.
  ///
  /// In hr, this message translates to:
  /// **'{num} otvorenih mjesta'**
  String companyOpenPositions(Object num);

  /// No description provided for @workStart.
  ///
  /// In hr, this message translates to:
  /// **'Početak rada:'**
  String get workStart;

  /// No description provided for @finishApplication.
  ///
  /// In hr, this message translates to:
  /// **'Završi prijavu'**
  String get finishApplication;

  /// No description provided for @rateJob.
  ///
  /// In hr, this message translates to:
  /// **'Ocjeni posao'**
  String get rateJob;

  /// No description provided for @matches.
  ///
  /// In hr, this message translates to:
  /// **'🔥Matchevi'**
  String get matches;

  /// No description provided for @applications.
  ///
  /// In hr, this message translates to:
  /// **'Prijave'**
  String get applications;

  /// No description provided for @saved.
  ///
  /// In hr, this message translates to:
  /// **'Spremljeno'**
  String get saved;

  /// No description provided for @completedJobs.
  ///
  /// In hr, this message translates to:
  /// **'Odrađeno'**
  String get completedJobs;

  /// No description provided for @shareJob.
  ///
  /// In hr, this message translates to:
  /// **'Podijeli posao'**
  String get shareJob;

  /// No description provided for @jobs.
  ///
  /// In hr, this message translates to:
  /// **'Poslovi'**
  String get jobs;

  /// No description provided for @galleryPermission.
  ///
  /// In hr, this message translates to:
  /// **'Dozvolite pristup galeriji u postavkama.'**
  String get galleryPermission;

  /// No description provided for @openSettings.
  ///
  /// In hr, this message translates to:
  /// **'Otvori postavke'**
  String get openSettings;

  /// No description provided for @profile.
  ///
  /// In hr, this message translates to:
  /// **'Profil'**
  String get profile;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['hr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'hr': return AppLocalizationsHr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
