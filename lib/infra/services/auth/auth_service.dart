import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firmus/helper/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_auth_service.dart';

final userProvider = StreamProvider<fb.User>((ref) async* {
  final stream = ref.watch(authServiceProvider).authStateChanges;

  await for (final user in stream) {
    logger.info("User is $user");
    if (user?.uid == null) {
      await ref.read(authServiceProvider).signInAnon();
    } else {
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.setUserIdentifier(user!.uid);
      }

      yield user!;
    }
  }
});

final firebaseUserIdProvider = Provider((ref) {
  return ref.watch(userProvider).requireValue.uid;
});

final tokenProvider = FutureProvider<String?>((ref) async {
  try {
    final value = ref.watch(userProvider).value;
    final result = await value?.getIdTokenResult();
    await value!.reload();
    return value.getIdToken(false);
  } catch (e) {
    await ref.read(authServiceProvider).signInAnon();
    final value = ref.watch(userProvider).value;
    return value?.getIdToken(true);
  }
});

final uidProvider = Provider((ref) {
  return ref.watch(userProvider).value?.uid;
});

final authServiceProvider = Provider((ref) => FirebaseAuthService(ref));

abstract class AuthService {
  Future<void> init();
  Future<void> signInAnon();
  Stream<fb.User?> get authStateChanges;
}
