import 'package:firebase_auth/firebase_auth.dart';
import 'package:firmus/infra/services/auth/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FirebaseAuthService extends AuthService {
  final auth = FirebaseAuth.instance;
  final ProviderRef ref;
  FirebaseAuthService(
    this.ref,
  );

  @override
  Future<void> init() async {}

  @override
  Future<void> signInAnon() async {
    if (auth.currentUser == null) await auth.signInAnonymously();
  }

  @override
  Stream<User?> get authStateChanges => auth.authStateChanges();

  Future<void> logout() {
    return auth.signOut().then((value) => signInAnon());
  }
}
