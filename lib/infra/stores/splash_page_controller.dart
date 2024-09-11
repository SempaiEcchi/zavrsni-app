import 'package:firmus/infra/services/auth/auth_service.dart';
import 'package:firmus/infra/services/deeplink/deeplink_service.dart';
import 'package:firmus/infra/services/http/http_service.dart';
import 'package:firmus/infra/services/remote_config/remote_config_service.dart';
import 'package:firmus/infra/services/storage/storage_service.dart';
import 'package:firmus/infra/stores/job_offer_store.dart';
import 'package:firmus/infra/stores/user_notifier.dart';
import 'package:firmus/main.dart';
import 'package:firmus/models/entity/student_entity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_compress/video_compress.dart';

sealed class SplashState {}

class SplashLoading extends SplashState {}

enum SplashLoadedState {
  // pushes to onboarding(welcome screen)
  anon,
  // pushes to homePage
  loggedIn,
}

class SplashLoaded extends SplashState {
  final SplashLoadedState splashLoadedState;

  SplashLoaded(this.splashLoadedState);
}

class SplashError extends SplashState {
  final String message;
  final stack;

  SplashError(this.message, this.stack);
}

final splashControllerProvider =
    NotifierProvider.autoDispose<SplashController, SplashState>(() {
  return SplashController();
});

class SplashController extends AutoDisposeNotifier<SplashState> {
  SplashController();

  void load() async {
    state = SplashLoading();
    if (!kIsWeb) {
      VideoCompress.deleteAllCache();
    }
    await bootstrapServices();
    await ref.read(authServiceProvider).signInAnon();

    await ref.read(deepLinkServiceProvider).init();

    bool updateAvailable = await ref.read(upgradeProvider.future);

    if (updateAvailable) {
      state = SplashError("UPDATE", null);
      return;
    }

    Future(() async {
      try {
        final authUser = await ref.read(userProvider.future);

        final user = await ref.read(firmusUserProvider.future);

        if ((user?.isAnon ?? true)) {
          state = SplashLoaded(SplashLoadedState.anon);
        } else {
          if (user is StudentAccountEntity) {
            await ref.refresh(jobOfferStoreProvider.future);
          }
          state = SplashLoaded(SplashLoadedState.loggedIn);
        }
      } catch (e, st) {
        state = SplashError(e.toString(), st);
      }
    });
  }

  Future<void> bootstrapServices() async {
    await ref.read(httpServiceProvider).initialize();
    await ref.read(storageServiceProvider).initialize();
    await ref.read(remoteConfigServiceProvider).initialize();
  }

  @override
  SplashState build() {
    load();
    return SplashLoading();
  }
}
