import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firmus/helper/image_picker.dart';
import 'package:firmus/helper/logger.dart';
import 'package:firmus/helper/measure_time.dart';
import 'package:firmus/helper/uuid.dart';
import 'package:firmus/infra/observables/user_observable.dart';
import 'package:firmus/infra/services/analytics/analytics_service.dart';
import 'package:firmus/infra/services/auth/auth_service.dart';
import 'package:firmus/infra/services/http/http_service.dart';
import 'package:firmus/infra/services/job/job_service.dart';
import 'package:firmus/infra/services/notification_service/notification_service.dart';
import 'package:firmus/infra/services/user/user_service.dart';
import 'package:firmus/infra/stores/cv_upload_provider.dart';
import 'package:firmus/infra/stores/registration_store.dart';
import 'package:firmus/models/entity/cv_video.dart';
import 'package:firmus/models/entity/student_entity.dart';
import 'package:firmus/models/entity/user_entity.dart';
import 'package:firmus/models/job_profiles.dart';
import 'package:firmus/models/student_experience.dart';
import 'package:firmus/router/router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:path/path.dart';
import 'package:video_compress/video_compress.dart';

final studentNotifierProvider =
    AsyncNotifierProvider<StudentNotifier, StudentObservable>(() {
  return StudentNotifier();
});

final firmusUserProvider =
    AsyncNotifierProvider<FirmusUserNotifier, UserEntity?>(() {
  return FirmusUserNotifier();
});

class FirmusUserNotifier extends AsyncNotifier<UserEntity?> {
  @override
  FutureOr<UserEntity?> build() async {
    final user = await ref.watch(userProvider.future);
    try {
      var userE = await ref
          .read(userServiceProvider)
          .getUser(GetUserRequest(userId: user.uid));
      user.updateDisplayName(userE.debugProfileName);
      return userE;
    } catch (e) {
      logger.info("$e for ${user.uid}");
      return null;
    }
  }

  Future<void> logout() async {
    return ref.read(authServiceProvider).logout();
  }
}

final _student = StreamProvider<StudentAccountEntity>((ref) async* {
  final userE = ref.watch(firmusUserProvider).valueOrNull;

  if (userE is StudentAccountEntity) {
    yield userE;
  }
});

class StudentNotifier extends AsyncNotifier<StudentObservable> {
  JobService get jobService => ref.read(jobServiceProvider);

  UserService get userService => ref.read(userServiceProvider);

  String get id => this.state.requireValue.id;

  String get user_id => ref.read(userProvider).requireValue.uid;

  @override
  FutureOr<StudentObservable> build() async {
    final userE = await ref.read(_student.future);

    final user = StudentObservable.fromEntity(userE);
    ref.listen(_student, (previous, next) {
      if (next.hasValue) {
        state = AsyncData(StudentObservable.fromEntity(next.requireValue));
      }
    });

    ref.listenSelf((previous, next) {
      if (next is AsyncData) {
        ref.read(analyticsServiceProvider).setProps(

        );
      }
    });

    try {
      await precacheImage(CachedNetworkImageProvider(user.imageUrl),
          router.routerDelegate.navigatorKey.currentContext!);
      for (var cv in user.cvVideos) {
        precacheImage(CachedNetworkImageProvider(cv.thumbnailUrl),
            router.routerDelegate.navigatorKey.currentContext!);
      }
    } finally {}

    return user;
  }

  Future<void> updateJobFrequency(List<SelectedJobProfile> updated) async {
    if (state is AsyncData) {
      state = AsyncData((state as AsyncData<StudentObservable>)
          .requireValue
          .copyWith(
              jobProfileFrequencies: Map.fromEntries(updated.map(
                  (e) => MapEntry(e.jobProfile.id.toString(), e.frequency)))));
    }
    await userService
        .updateJobFrequency(UpdateJobFrequencyRequest(jobProfiles: updated));
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    if (data["image"] is File) {
    } else {
      data.remove("image");
    }

    final user = await userService.updateProfile(UpdateProfileRequest.fromMap(
      data,
      state.requireValue.id.toString(),
    ));
    state = AsyncData(StudentObservable.fromEntity(
      user,
    ));
  }

  Future<void> updateBio(Map<String, dynamic> data) async {
    loggerTime("update bio");
    final bio = await userService
        .updateBio(UpdateBioRequest(bio: data["bio"] as String));
    if (state is AsyncData) {
      state = AsyncData((state as AsyncData<StudentObservable>)
          .requireValue
          .copyWith(bio: bio));
    }
    loggerTimeEnd("update bio");
  }

  Future<void> updateUserLocation(LatLng pos, String locationName) async {
    final locationE = await userService.updateLocation(
        UpdateLocationRequest(location: pos, locationName: locationName));
    if (state is AsyncData) {
      state = AsyncData((state as AsyncData<StudentObservable>)
          .requireValue
          .copyWith(location: LatLng(locationE.lat, locationE.lng)));
    }
  }

  Future<void> uploadVideo(File video, [List<int> ids = const []]) async {
    final id = uuid.v4();

    ref
        .read(uploadingVideosProvider.notifier)
        .add(UploadingCV(thumbnail: null, id: id));

    File thumbnailFile = await VideoCompress.getFileThumbnail(video.path,
        quality: 80, // default(100)
        position: -1 // default(-1)
        );

    ref
        .read(uploadingVideosProvider.notifier)
        .add(UploadingCV(thumbnail: thumbnailFile, id: id));

    File uploadableVideo = video;

    final sizeInMb = video.lengthSync() / 1024 / 1024;

    ref
        .read(analyticsServiceProvider)
        .logEvent(name: AnalyticsEvent.pick_cv_video, parameters: {
      "size": sizeInMb,
    });

    if (sizeInMb > 150) {
      MediaInfo? mediaInfo = await VideoCompress.compressVideo(
        video.path,
        quality: VideoQuality.MediumQuality,
        deleteOrigin: false, // It's false by default
      );

      logger.info(
          "compression ratio is ${mediaInfo!.filesize} vs ${video.lengthSync()}");
      logger.info(
          "in megabytes ${mediaInfo.filesize! / 1024 / 1024} vs ${video.lengthSync() / 1024 / 1024}");
      uploadableVideo = File(mediaInfo.path!);
    }

    //copy videos to documents dir
    uploadableVideo = await uploadableVideo
        .copy("${PathHelper.documentsPath}/${basename(uploadableVideo.path)}");
    thumbnailFile = await thumbnailFile
        .copy("${PathHelper.documentsPath}/${basename(thumbnailFile.path)}");

    return userService
        .uploadVideo(UploadVideoRequest(
            selectedJobProfiles: ids,
            video: uploadableVideo,
            thumbnail: thumbnailFile))
        .whenComplete(() {
      uploadableVideo.delete();
      thumbnailFile.delete();
    }).then((value) {
      logger.info("uploaded video");
      if (state is AsyncData) {
        final v = (state as AsyncData<StudentObservable>).requireValue;
        state = AsyncData(v.copyWith(cvVideos: [
          value,
          ...v.cvVideos,
        ]));
      }
    }).whenComplete(() {
      ref.read(uploadingVideosProvider.notifier).remove(id);
    });
  }

  void deleteVideo(StudentCVVid vid) {
    //delete immediately
    final newState = state.requireValue
        .copyWith(cvVideos: state.requireValue.cvVideos.toList()..remove(vid));
    state = AsyncData(newState);

    userService
        .deleteVideoRequest(DeleteVideoRequest(id: vid.id.toString()))
        .then((value) {
      final newState = state.requireValue.copyWith(cvVideos: value);
      state = AsyncData(newState);
    });
  }

  Future<void> updateCV(Map<String, dynamic> data) {
    final createcv = CreateCV(
      experiences: data["experiences"] as List<StudentExperienceEntity>,
    );
    return userService.updateCV(UpdateCVRequest(cv: createcv)).then((value) {
      state = AsyncData(state.requireValue.copyWith(experiences: value));
    });
  }

  Future<void> logout() async {
    ref.read(notificationService).deleteToken();
    return ref.read(authServiceProvider).logout();
  }

  Future<void> reloadStudent(StudentAccountEntity entity) async {
    var status = await ref.read(notificationService).init(soft: true);
    final user = StudentObservable.fromEntity(entity);
    state = AsyncData(user);
  }

  Future createAnonStudent() async {
    final user = await userService.createAnonStudent();

    state = AsyncData(StudentObservable.fromEntity(user));
  }

  Future updateVideo(String id, List<int> ids) {
    final existing = state.requireValue.cvVideos.toList();
    return userService
        .updateVideo(UpdateVideoRequest(id: id, selectedJobProfiles: ids))
        .then((StudentCVVid value) {
      final newState = state.requireValue.copyWith(
          cvVideos: existing.map((e) => e.id == value.id ? value : e).toList());
      state = AsyncData(newState);
    });
  }

  Future updateLanguages(List<String> list) async {
    final http = ref.read(httpServiceProvider);
    await http.request(
        PostRequest(endpoint: "/user/student/$id/languages", body: {
          "languages": list,
        }),
        converter: noOp);
    this.update((state) {
      return state!.copyWith(languages: list);
    });
  }

  Future<void> deleteAccount() async => ref
      .read(httpServiceProvider)
      .request(PostRequest(endpoint: "/user/$user_id/delete-account", body: {}),
          converter: noOp)
      .then((value) => ref.read(authServiceProvider).logout());

  updateUni(Map<String, dynamic> data) {}
}

final selectableJobProfileFrequenciesProvider =
    FutureProvider<List<SelectedJobProfile>>((ref) async {
  final student = await ref.watch(studentNotifierProvider.future);
  final jobProfiles = await ref.watch(jobProfilesProvider.future);

  return jobProfiles
      .map((e) => SelectedJobProfile(
          jobProfile: e,
          frequency: student.jobProfileFrequencies[e.id.toString()] ?? 0))
      .toList();
});

noOp(_) {}
