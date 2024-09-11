import 'dart:io';

import 'package:firmus/helper/logger.dart';
import 'package:firmus/helper/video_export_service.dart';
import 'package:firmus/infra/keep_alive.dart';
import 'package:firmus/infra/observables/job_creation_state.dart';
import 'package:firmus/infra/observables/registration_observable.dart';
import 'package:firmus/infra/stores/company_notifier.dart';
import 'package:firmus/infra/stores/industry_notifier.dart';
import 'package:firmus/infra/stores/registration_store.dart';
import 'package:firmus/models/job_offers.dart';
import 'package:firmus/models/job_skill.dart';
import 'package:firmus/view/pages/employeer_home/controller/employer_jobs_notifier.dart';
import 'package:firmus/view/pages/job_op_creation/basic_job_details.dart';
import 'package:firmus/view/pages/job_op_creation/job_video.dart';
import 'package:firmus/view/pages/job_op_creation/other_job_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_compress/video_compress.dart';

import '../services/job/job_service.dart';

final jobOpCreationNotifierProvider =
    NotifierProvider.autoDispose<JobCreationNotifier, JobCreationState>(() {
  return JobCreationNotifier();
});

final formKeyProvider = Provider.autoDispose((ref) {
  ref.keepAlive();
  final keys = {};
  for (var value in JobCreationStatePage.values) {
    keys[value] = GlobalKey<FormBuilderState>();
  }
  return keys;
});

class JobCreationNotifier extends AutoDisposeNotifier<JobCreationState> {
  @override
  JobCreationState build() {
    keepAlive(ref);
    ref.read(jobSkillsProvider);
    ref.read(industryProvider);
    ref.read(jobProfilesProvider);

    ref.onDispose(() {
      ref.invalidate(formKeyProvider);
      ref.invalidate(jobSkillsProvider);
      ref.invalidate(industryProvider);
      ref.invalidate(jobProfilesProvider);
    });

    return JobCreationState.mocked();
  }

  void nextPage(FormData data) {
    final currentPage = state.currentPage;
    final nextPage = JobCreationStatePage.values[currentPage.index + 1];
    state = state.copyWith(currentPage: nextPage, state: {
      ...state.state,
      currentPage: data,
    });
  }

  void save(FormData data) {
    state = state.copyWith(state: {
      ...state.state,
      state.currentPage: data,
    });
  }

  void previousPage() {
    final currentPage = state.currentPage;
    final previousPage = JobCreationStatePage.values[currentPage.index - 1];
    state = state.copyWith(currentPage: previousPage);
  }

  Future<void> createJob() async {
    final expanded = state.state.expand();
    await createJobM(expanded, ref);
  }

  void loadJobOpportunity(JobOpportunity jobOpportunity) {
    state = JobCreationState.job(jobOpportunity);
  }

  Future<void> uploadVideo(File video) async {
    final audio = await ExportService.getAudioFromVideo(video.path);
    if (audio?.existsSync() ?? false) {
      final processedForm =
          await ref.read(jobServiceProvider).processAudio(audio!);
      debugPrint("processed form $processedForm");
    }
  }
}

Future<void> createJobM(Map expanded, ref, [companyid]) async {
  final thumbanil = kIsWeb
      ? null
      : await VideoCompress.getFileThumbnail(
          expanded[JobVideo.video].path,
          quality: 80,
        );

  final request = CreateJobRequest(
    thumbnail: thumbanil == null ? null : XFile(thumbanil?.path ?? ""),
    companyId: companyid ?? ref.read(companyNotifierProvider).requireValue.id,
    employeesNeeded:
        int.tryParse(expanded[OtherJobDetails.employeesNeeded].toString()) ?? 1,
    media: XFile(expanded[JobVideo.video].path),
    jobTitle: expanded[BasicJobDetails.title],
    jobDescription: expanded[BasicJobDetails.description],
    hourlyRate: double.parse(expanded[BasicJobDetails.payment].toString()),
    location: expanded[BasicJobDetails.location],
    workStartDate:
        DateTime.tryParse(expanded[BasicJobDetails.workStartDate].toString()),
    workEndDate:
        DateTime.tryParse(expanded[BasicJobDetails.workEndDate].toString()),
    applyDeadline:
        DateTime.parse(expanded[BasicJobDetails.applyDeadline].toString()),
    jobType: expanded[OtherJobDetails.jobType],
    jobProfileId: expanded[OtherJobDetails.jobProfile],
  );

  final job = await ref.read(jobServiceProvider).createJob(request);
  logger.info(
    "created job $job",
  );
  if (ref.exists(employerJobsProvider)) {
    ref.read(employerJobsProvider.notifier).addJob(job);
  }
}

extension Expander<T, FormData> on Map<T, FormData> {
  Map<String, dynamic> expand() {
    final Iterable<FormData> maps = values.toList();
    Map<String, dynamic> expanded = {};
    for (var m in maps) {
      expanded.addAll(m as Map<String, dynamic>);
    }
    return expanded;
  }
}

final languagesProvider = FutureProvider.autoDispose<List<String>>((ref) async {
  ref.keepAlive();
  return [
    "Hrvatski",
    "Engleski",
    "Njemački",
    "Francuski",
    "Talijanski",
    "Španjolski",
    "Ruski",
    "Kineski",
    "Mađarski",
  ];
});

final jobSkillsProvider =
    FutureProvider.autoDispose<List<JobSkill>>((ref) async {
  ref.keepAlive();
  final service = ref.read(jobServiceProvider);

  final List<JobSkill> tags = await service.fetchJobSkills();
  tags.sort((a, b) => a.name.length.compareTo(b.name.length));
  return tags;
});

extension FileSize on File {
  Future<double> inMb() async {
    final size = await length();
    return size / 1000000;
  }
}
