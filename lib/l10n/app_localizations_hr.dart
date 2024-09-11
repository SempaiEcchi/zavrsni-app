import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Croatian (`hr`).
class AppLocalizationsHr extends AppLocalizations {
  AppLocalizationsHr([String locale = 'hr']) : super(locale);

  @override
  String get helloWorld => 'Bok!';

  @override
  String get active => 'Aktivni';

  @override
  String get register => 'Registriraj se';

  @override
  String get skipLogin => 'Istaži kao gost';

  @override
  String get alreadyRegistered => 'Već imaš profil?';

  @override
  String get pickCity => 'Odaberi grad u kojem studiraš';

  @override
  String get save => 'Spremi';

  @override
  String get back => 'Povratak';

  @override
  String get videoCreationTitle => 'Prezentiraj se poslodavcima kroz kratki video 🎥';

  @override
  String get videoCreationsubtitle => 'Kroz video od maksimalno 1 minutu prezentiraj zašto bi poslodavac trebao odabrati baš tebe!';

  @override
  String get videoOptional => '*korak nije obavezan te je video moguće snimiti/učitati naknadno';

  @override
  String get experienceOptional => '*korak nije obavezan te je poslovno iskustvo moguće naknadno dodavati i uređivati';

  @override
  String get pickExperience => 'Već imaš poslovnog iskustva?';

  @override
  String get pickExperienceSubtitle => 'Povećaj šanse za matching sa idealnim poslodavcem dodavanjem poslovnog iskustva';

  @override
  String get pickJobs => 'Odaberi pozicije koje te zanimaju';

  @override
  String get pickJobsSubtitle => 'Pritisni kako bi mogao prilagoditi frekvenciju prikazivanja oglasa za odabranu vrstu posla';

  @override
  String jobProfileFrequencyTitle(Object jobtitle) {
    return 'Oglase za odabranu vrstu posla \"$jobtitle\" prikazuj';
  }

  @override
  String get jobProfileFrequencyRarely => 'Vrlo rijetko';

  @override
  String get jobProfileFrequencyOften => 'Vrlo često';

  @override
  String get enterBasicInfoTitle => 'Još jedan korak si do poslova!';

  @override
  String get verifyEmailTitle => 'Poslali smo 🔗 na tvoju email adresu! Verificiraj se jednim klikom!';

  @override
  String get continueNext => 'Nastavi';

  @override
  String get login => 'Prijavi se';

  @override
  String get registationTitle => 'Registracija';

  @override
  String get cityPicker => 'Odaberi grad';

  @override
  String continueWithSocial(Object social) {
    return 'Nastavi uz $social';
  }

  @override
  String get openPositions => 'Slobodnih mjesta:';

  @override
  String companyOpenPositions(Object num) {
    return '$num otvorenih mjesta';
  }

  @override
  String get workStart => 'Početak rada:';

  @override
  String get finishApplication => 'Završi prijavu';

  @override
  String get rateJob => 'Ocjeni posao';

  @override
  String get matches => '🔥Matchevi';

  @override
  String get applications => 'Prijave';

  @override
  String get saved => 'Spremljeno';

  @override
  String get completedJobs => 'Odrađeno';

  @override
  String get shareJob => 'Podijeli posao';

  @override
  String get jobs => 'Poslovi';

  @override
  String get galleryPermission => 'Dozvolite pristup galeriji u postavkama.';

  @override
  String get openSettings => 'Otvori postavke';

  @override
  String get profile => 'Profil';
}
