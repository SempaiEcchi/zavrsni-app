import 'dart:async';

import 'package:firmus/helper/logger.dart';
import 'package:firmus/infra/keep_alive.dart';
import 'package:firmus/infra/services/analytics/analytics_service.dart';
import 'package:firmus/infra/services/job/job_service.dart';
import 'package:firmus/infra/stores/user_notifier.dart';
import 'package:firmus/models/entity/conpany_account_entity.dart';
import 'package:firmus/models/entity/student_entity.dart';
import 'package:firmus/models/student_job_offers.dart';
import 'package:firmus/view/pages/employer_home_swiper/controller/student_swipe_controller.dart';
import 'package:firmus/view/pages/student_home/widges/view_type_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

import '../../models/job_offers.dart';
import '../observables/job_offer_observable.dart';

final jobOfferStoreProvider =
    AsyncNotifierProvider.autoDispose<JobOfferStore, JobOffersO>(() {
  return JobOfferStore();
});

final jobHomeViewType = Provider.autoDispose<HomeViewType>((ref) {
  final user = ref.watch(firmusUserProvider).valueOrNull;

  if (user is StudentAccountEntity) {
    if (ref.exists(jobOfferStoreProvider)) {
      final store = ref.watch(jobOfferStoreProvider);
      return store.valueOrNull?.viewType ?? HomeViewType.carousel;
    } else {
      return HomeViewType.carousel;
    }
  } else if (user is CompanyAccountEntity) {
    final selectedJob = ref.watch(selectedJobProvider);
    if (selectedJob == null) {
      return HomeViewType.carousel;
    }
    final store = ref.watch(swipableStudentsProvider(selectedJob.id));
    return store.valueOrNull?.viewType ?? HomeViewType.carousel;
  } else {
    return HomeViewType.carousel;
  }
});

class VideoControllerWarmuper {
  final Map<String, VideoPlayerController> _controllers = {};

  //override []
  VideoPlayerController operator [](String url) {
    if (!_controllers.containsKey(url)) {
      _controllers[url] = VideoPlayerController.networkUrl(Uri.parse(url));
    }

    return _controllers[url]!;
  }

  Future disposeVideos() async {
    logger.info("Disposing videos");
    for (var controller in _controllers.values) {
      await controller.dispose();
    }
    _controllers.clear();
  }

  Future warmupNext(List<String> urls) async =>
      Future.forEach(urls.toSet(), (url) async {
        final VideoPlayerController controller = this[url];
        await controller.initialize();
        await controller.setLooping(true);
        if (kDebugMode) {
          controller.setVolume(0);
        }
      });

  void disposeVideo(String url) {
    logger.info("Disposing video $url");
    _controllers.remove(url)?.dispose();
  }
}

final videoControllerWarmuperProvider =
    Provider.autoDispose<VideoControllerWarmuper>((ref) {
  ref.keepAlive();
  return VideoControllerWarmuper();
});

const warmupAmount = 3;

class JobOfferStore extends AutoDisposeAsyncNotifier<JobOffersO> {
  // ignore: avoid_public_notifier_properties
  VideoControllerWarmuper get warmer =>
      ref.read(videoControllerWarmuperProvider);

  @override
  FutureOr<JobOffersO> build() async {
    logger.info("build job store");
    keepAlive(ref);

    ref.onDispose(() {
      logger.info("disposing job store");
      warmer.disposeVideos();
      ref.invalidate(videoControllerWarmuperProvider);
    });
    ref.onCancel(() {
      logger.info("cancelling job store");
    });
    final service = ref.read(jobServiceProvider);

    final o = JobOffersO(
      response: await service.fetchJobs(FetchJobsRequest()),
      isImmersed: false,
      viewType: state.valueOrNull?.viewType ?? HomeViewType.carousel,
    );
    await warmer.warmupNext(o.response.offers
        .toList()
        .where((element) => element.isVideo)
        .take(warmupAmount)
        .map((e) => e.url)
        .toList());
    return o;
  }


  Future<void> swipeJob(JobOpportunity offer, FirmusSwipeType direction) async {
    final videoc = ref.read(videoControllerWarmuperProvider)[offer.url];

    logAnalytics(videoc, offer, direction);

    final service = ref.read(jobServiceProvider);
    removeJob(offer);

    final nextUrl = state.requireValue.response.offers.firstOrNull?.url;

    if (nextUrl == offer.url) {
      warmer[nextUrl!].seekTo(const Duration(milliseconds: 1));
    } else {
      warmer.disposeVideo(offer.url);
    }
    warmer.warmupNext(state.requireValue.response.offers
        .where((element) => element.isVideo)
        .take(warmupAmount)
        .map((e) => e.url)
        .toList());

    service.swipeJob(SwipeJobRequest(
      offer: offer,
      action: direction,
    ));
  }

  void logAnalytics(VideoPlayerController videoc, JobOpportunity offer,
      FirmusSwipeType direction) {
    final additional = {};

    try {
      final watched = videoc.value.position.inSeconds;
      final total = videoc.value.duration.inSeconds;
      additional.addAll({
        "watched_seconds": watched,
        "total_seconds": total,
        "watch_percentage": watched / total,
      });
    } catch (e) {
      logger.severe(e);
    }

    ref.read(analyticsServiceProvider).logEvent(
      name: AnalyticsEvent.swipe_job,
      parameters: {
        ...additional,
        "job_id": offer.id,
        "job_title": offer.jobTitle,
        "student_name": ref.read(studentNotifierProvider).requireValue.name,
        "student_id": ref.read(studentNotifierProvider).requireValue.id,
        "job_profile": offer.jobProfile.name,
        "direction": direction.toString(),
      },
    );
  }


  void removeJob(JobOpportunity offer) {
    final newJobs = state.requireValue.copyWith(
      response: JobsResponse(
          offers: state.requireValue.response.offers
              .where((element) => element.id != offer.id)
              .toList()),
    );
    state = AsyncData(newJobs);
  }

  void setImmersed(bool immersed) {
    state = AsyncData(state.requireValue.copyWith(isImmersed: immersed));
  }

  void changeViewType(HomeViewType type) {
    state = AsyncData(
        state.requireValue.copyWith(viewType: type, isImmersed: false));
  }
}
