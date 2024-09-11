import 'dart:async';
import 'dart:io';

import 'package:firmus/infra/services/job/job_service.dart';
import 'package:firmus/infra/services/user/user_service.dart';
import 'package:firmus/infra/store.dart';
import 'package:firmus/infra/stores/user_notifier.dart';
import 'package:firmus/models/job_profiles.dart';
import 'package:firmus/models/registration.dart';
import 'package:firmus/models/student_experience.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../helper/logger.dart';
import '../observables/registration_observable.dart';

final registrationStoreProvider = Provider<RegistrationStore>((ref) {
  return RegistrationStore(ref.container);
});

final jobProfilesProvider = FutureProvider<List<JobProfile>>((ref) {
  return ref
      .read(jobServiceProvider)
      .fetchJobProfiles(const JobProfileRequest(industry_ids: []));
});

class RegistrationStore extends BaseStore {
  RegistrationStore(super.providerContainer);

  RegistrationO get current => readObservable(registrationOProvider);

  void saveState(StudentRegistrationPage page, Map<String, dynamic> value,
      {bool updatePage = true}) {
    final updatedState = {
      ...current.state,
      page: {
        ...?current.state[page],
        ...value,
      }
    };

    writeObservable(
        registrationOProvider,
        current.copyWith(
            currentPage: updatePage
                ? StudentRegistrationPage.values
                    .elementAt(current.currentPage.index + 1)
                : null,
            state: updatedState));
  }

  void previousPage() {
    writeObservable(
        registrationOProvider,
        current.copyWith(
            currentPage:
                StudentRegistrationPage.values[current.currentPage.index - 1]));
  }

  Future<void> register() async {
    debugPrint("Registering");
    final Iterable<FormData> maps = current.state.values.toList();
    Map<String, dynamic> expanded = {};
    for (var m in maps) {
      expanded.addAll(m);
    }
    final image = expanded["image"] as File;

    final video = expanded["video"] as File?;

    final userService = providerContainer.read(userServiceProvider);
    logger.info("Image exits ${image.existsSync()}");
    logger.info("image size ${image.lengthSync()}");

    final request = CreateProfileRequest(
      dateOfBirth: DateTime.parse(expanded["date_of_birth"].toString()),
      first_name: expanded["name"],
      last_name: expanded["surname"],
      city: expanded["city"],
      email: expanded["email"],
      universityInfo: expanded["uni"] != null
          ? UniversityInfo(
              uniName: expanded["uni"],
              uniYear: expanded["uni_year"],
            )
          : null,
      image: image,
      selectedJobProfiles: expanded["jobProfiles"] ?? [],
      cv: CreateCV(experiences: expanded["experiences"] ?? []),
    );

    await userService.createProfile(request);
    if (video != null) {
      Future(() async {
        await providerContainer.refresh(studentNotifierProvider.future);
        providerContainer
            .read(studentNotifierProvider.notifier)
            .uploadVideo(video);
      });
    }
  }

  void reset() {
    writeObservable(registrationOProvider, RegistrationO());
  }

  void nextPage() {
    writeObservable(
        registrationOProvider,
        current.copyWith(
            currentPage:
                StudentRegistrationPage.values[current.currentPage.index + 1]));
  }
}
