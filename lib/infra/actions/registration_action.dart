import 'package:firebase_auth/firebase_auth.dart';
import 'package:firmus/infra/action.dart';
import 'package:firmus/infra/services/user/user_service.dart';
import 'package:firmus/infra/stores/registration_store.dart';
import 'package:firmus/models/registration.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RegistrationAction extends BaseAction {
  final RegistrationStore _store;
  final UserService _userService;

  RegistrationAction(this._store, this._userService);

  factory RegistrationAction.of(WidgetRef ref) {
    return RegistrationAction(
        ref.read(registrationStoreProvider), ref.read(userServiceProvider));
  }

  void saveStateAndNext(
      StudentRegistrationPage basicInfo, Map<String, dynamic> value) {
    _store.saveState(basicInfo, value);
  }

  void saveState(StudentRegistrationPage page, Map<String, dynamic> value) {
    _store.saveState(page, value, updatePage: false);
  }

  void previousPage() {
    _store.previousPage();
  }

  void next() {
    _store.nextPage();
  }

  Future<void> signInWithoutPassword([String? email]) {
    return FirebaseAuth.instance.sendSignInLinkToEmail(
        email: email ?? _store.current.get("email"),
        actionCodeSettings: ActionCodeSettings(
          iOSBundleId: "com.firmusapp.jobs",
          androidPackageName: "com.firmusapp.jobs",
          androidMinimumVersion: "1",
          handleCodeInApp: true,
          dynamicLinkDomain: "firmuswork.page.link",
          url: "https://firmuswork.page.link",
        ));
  }

  Future<void> requestLogin(String email) async {
    // bool isRegistered = await _userService.isRegistered(email);
    // if (!isRegistered) throw NotRegisteredException("Student nije registriran");

    return signInWithoutPassword(email);
  }

  Future<void> requestLoginAndPass(String email, String password) async {
    // bool isRegistered = await _userService.isRegistered(email);
    // if (!isRegistered) throw NotRegisteredException("Student nije registriran");

    return signInWithPassword(email, password);
  }

  Future<void> signInWithPassword(String email, String password) {
    return FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}

class NotRegisteredException implements Exception {
  final String message;

  NotRegisteredException(this.message);
}
