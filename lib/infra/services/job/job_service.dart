import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:equatable/equatable.dart';
import 'package:firmus/infra/services/http/http_service.dart';
import 'package:firmus/infra/services/job/entity/employer_job_offers.dart';
import 'package:firmus/infra/services/job/entity/industry.dart';
import 'package:firmus/infra/services/job/entity/job_offer_details_response.dart';
import 'package:firmus/infra/services/job/entity/swipable_students_response.dart';
import 'package:firmus/models/job_offers.dart';
import 'package:firmus/models/job_profiles.dart';
import 'package:firmus/models/job_skill.dart';
import 'package:firmus/models/student_job_offers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'entity/match_details.dart';
import 'http_job_service.dart';

final jobServiceProvider = Provider<JobService>((ref) {
  return JobServiceImpl(ref.watch(httpServiceProvider));
});

abstract class JobService {
  final HttpService httpService;

  JobService(this.httpService);

  Future<JobsResponse> fetchJobs(FetchJobsRequest request);

  Future<JobOpportunity> createJob(CreateJobRequest request);

  Future<IndustryResponse> getIndustries(IndustriesRequest request);

  Future<void> swipeJob(SwipeJobRequest request);

  Future<List<JobProfile>> fetchJobProfiles(
      JobProfileRequest jobProfileRequest);

  Future<SavedJobsResponse> fetchSavedJobs(
      FetchSavedJobsRequest fetchSavedJobsRequest);

  Future<JobOpportunity> getJobOpportunity(
      GetJobOpportunityRequest getJobOpportunityRequest);

  //when browsing as a student you can call this
  Future<List<JobOpportunity>> fetchCompanyOffers(String companyId);

  //when browsing as a company you can call this to get list of your active/expired offers, should not be called by students
  Future<EmployerJobOffersResponse> fetchEmployerJobOffers(String companyId);

  Future<JobOfferDetailsResponse> fetchJobOfferDetails(
      String companyId, String jobId);

  Future<SwipeableStudentsResponse> fetchSwipeableStudents(
      String companyId, String jobId);

  Future<List<JobSkill>> fetchJobSkills();

  Future<List<JobSkill>> createJobSkill(String name);

  Future<void> swipeStudent(
      String studentId, String? jobId, FirmusSwipeType direction);

  Future<AppliedJobOffer> acceptMatch(String matchId);

  Future<AppliedJobOffer> cancelMatch(String matchId);

  Future<Map<String, dynamic>> processAudio(File file);

  Future<MatchDetailsResponse> getMatchDetails(String matchId);

  /// Admin methos
  Future<Map<JobOpportunity, List<InterestedApplicant>>>
      getAllInterestedApplicants();

  Future<Map<JobOpportunity, List<MatchedApplicant>>> getAllMatchedApplicants();

  Future<Map<JobOpportunity, List<EmployedApplicant>>>
      getAllEmployedApplicants();
}

enum FirmusSwipeType {
  like,
  dislike,
  save,
}

class GetAllInterestedApplicantsRequest extends BaseHttpRequest {
  const GetAllInterestedApplicantsRequest()
      : super(
            endpoint: "/jobs/admin/all-interested-applicants",
            type: RequestType.get);

  @override
  Map<String, dynamic> toMap() {
    return {};
  }
}

class GetMatchDetails extends BaseHttpRequest {
  final String matchId;

  const GetMatchDetails({
    required this.matchId,
  }) : super(endpoint: "/jobs/match/$matchId", type: RequestType.get);

  @override
  Map<String, dynamic> toMap() {
    return {};
  }
}

class CancelMatchRequest extends BaseHttpRequest {
  final String matchId;

  const CancelMatchRequest({
    required this.matchId,
  }) : super(endpoint: "/jobs/match/$matchId/cancel", type: RequestType.get);

  @override
  Map<String, dynamic> toMap() {
    return {};
  }
}

class AcceptMatchRequest extends BaseHttpRequest {
  final String matchId;

  const AcceptMatchRequest({
    required this.matchId,
  }) : super(endpoint: "/jobs/match/$matchId/accept", type: RequestType.get);

  @override
  Map<String, dynamic> toMap() {
    return {};
  }
}

class ProcessAudioRequest extends BaseHttpRequest {
  final File file;

  const ProcessAudioRequest({
    required this.file,
  }) : super(
            endpoint: "/video-parser/process-job",
            type: RequestType.post,
            contentType: Headers.multipartFormDataContentType);

  @override
  toMap() async {
    return {
      "file": MultipartFileRecreatable.fromFileSync(file.path),
    };
  }
}

class CreateJobRequest extends BaseHttpRequest {
  final String jobTitle;
  final String jobDescription;
  final String location;
  final double hourlyRate;
  final DateTime applyDeadline;
  final DateTime? workStartDate;
  final DateTime? workEndDate;
  final String jobProfileId;

  final JobType jobType;
  final XFile media;
  final XFile? thumbnail;
  final int employeesNeeded;

  CreateJobRequest({
    required this.jobTitle,
    required this.employeesNeeded,
    required this.workEndDate,
    required this.jobDescription,
    required this.location,
    required this.hourlyRate,
    required this.applyDeadline,
    required this.workStartDate,
    required this.jobProfileId,
    required this.jobType,
    required this.media,
    required this.thumbnail,
    required String companyId,
  }) : super(
            endpoint: "/jobs/company/$companyId",
            type: RequestType.post,
            contentType: Headers.jsonContentType);

  @override
  FutureOr<Map<String, dynamic>> toMap() async {
    return {
      "workEndDate": workEndDate?.toIso8601String(),
      "file": base64Encode(await media.readAsBytes()),
      if (thumbnail != null)
        "thumbnail": thumbnail != null
            ? base64Encode(await thumbnail!.readAsBytes())
            : null,
      'jobTitle': jobTitle,
      'jobDescription': jobDescription,
      'location': location,
      'hourlyRate': hourlyRate,
      'applyDeadline': applyDeadline.toIso8601String(),
      'workStartDate': applyDeadline.toIso8601String(),
      'jobProfileId': jobProfileId,
      'jobType': jobType.name,
      "employeesNeeded": employeesNeeded,
    };
  }
}

class SwipeStudentRequest extends BaseHttpRequest {
  final String studentId;
  final String? jobId;
  final FirmusSwipeType direction;

  const SwipeStudentRequest({
    required this.studentId,
    required this.jobId,
    required this.direction,
  }) : super(endpoint: "/jobs/student-swipe", type: RequestType.post);

  @override
  Map<String, dynamic> toMap() {
    return {
      "student_id": studentId,
      "job_opportunity_id": jobId,
      "action": direction.name.toUpperCase(),
    };
  }
}

class CreateJobSkillRequest extends BaseHttpRequest {
  final String name;

  const CreateJobSkillRequest({
    required this.name,
  }) : super(endpoint: "/skills/", type: RequestType.post);

  @override
  Map<String, dynamic> toMap() {
    return {
      "name": name,
    };
  }
}

class GetJobSkillsRequest extends BaseHttpRequest {
  const GetJobSkillsRequest()
      : super(endpoint: "/skills/", type: RequestType.get);

  @override
  Map<String, dynamic> toMap() {
    return {};
  }
}

class GetSwipeableStudentsForJobRequest extends BaseHttpRequest {
  final String companyId;

  final String jobId;

  const GetSwipeableStudentsForJobRequest({
    required this.jobId,
    required this.companyId,
  }) : super(
            endpoint:
                "/jobs/employer/$companyId/opportunity/$jobId/swipeable-students",
            type: RequestType.get);

  @override
  Map<String, dynamic> toMap() {
    return {};
  }
}

class GetSwipeableStudentsForCompanyRequest extends BaseHttpRequest {
  final String companyId;

  const GetSwipeableStudentsForCompanyRequest({
    required this.companyId,
  }) : super(
            endpoint: "/jobs/employer/$companyId/swipeable-students",
            type: RequestType.get);

  @override
  Map<String, dynamic> toMap() {
    return {};
  }
}

class GetJobOfferDetailsRequest extends BaseHttpRequest {
  final String companyId;
  final String jobId;

  const GetJobOfferDetailsRequest({
    required this.companyId,
    required this.jobId,
  }) : super(
            endpoint: "/jobs/employer/$companyId/opportunity/$jobId",
            type: RequestType.get);

  @override
  Map<String, dynamic> toMap() {
    return {};
  }
}

class GetEmployerJobOffersRequest extends BaseHttpRequest {
  final String companyId;

  const GetEmployerJobOffersRequest({
    required this.companyId,
  }) : super(endpoint: "/jobs/employer/$companyId", type: RequestType.get);

  @override
  Map<String, dynamic> toMap() {
    return {};
  }
}

class GetCompanyJobsRequest extends BaseHttpRequest {
  final String companyId;

  const GetCompanyJobsRequest({
    required this.companyId,
  }) : super(endpoint: "/jobs/company/$companyId", type: RequestType.get);

  @override
  Map<String, dynamic> toMap() {
    return {};
  }
}

class GetJobOpportunityRequest extends BaseHttpRequest {
  final String id;

  const GetJobOpportunityRequest({
    required this.id,
  }) : super(endpoint: "/jobs/opportunity/$id", type: RequestType.get);

  @override
  Map<String, dynamic> toMap() {
    return {};
  }
}

class FetchJobsRequest extends BaseHttpRequest {
  FetchJobsRequest()
      : super(endpoint: "/jobs/job-opportunities", type: RequestType.get);

  @override
  FutureOr<Map<String, dynamic>> toMap() {
    return {};
  }
}

class FetchSavedJobsRequest extends BaseHttpRequest {
  FetchSavedJobsRequest()
      : super(endpoint: "/jobs/saved-jobs", type: RequestType.get);

  @override
  FutureOr<Map<String, dynamic>> toMap() {
    return {};
  }
}

class SwipeJobRequest extends BaseHttpRequest {
  final JobOpportunity offer;
  final FirmusSwipeType action;

  SwipeJobRequest({
    required this.offer,
    required this.action,
  }) : super(endpoint: "/jobs/job-swipe", type: RequestType.post);

  @override
  FutureOr<Map<String, dynamic>> toMap() {
    return {
      "job_opportunity_id": offer.id,
      "action": action.name.toUpperCase(),
    };
  }
}

class IndustriesRequest extends BaseHttpRequest {
  final String query;

  @override
  Map<String, dynamic> toMap() {
    return {
      'query': query,
    };
  }

  const IndustriesRequest(this.query)
      : super(
          endpoint: "/jobs/industries",
          type: RequestType.get,
        );
}

class JobProfileRequest extends BaseHttpRequest {
  /// pass empty to get all
  final List<int> industry_ids;

  @override
  Map<String, dynamic> toMap() {
    return {};
  }

  const JobProfileRequest({
    required this.industry_ids,
  }) : super(
          type: RequestType.get,
          endpoint: "/jobs/job-profiles",
        );
}

class SavedJobsResponse {
  final List<SavedJobOffer> savedJobs;
  final List<AppliedJobOffer> appliedJobs;
  final List<MatchedJobOffer> matchedJobs;
  final List<ActiveJobOffer> activeJobs;

  const SavedJobsResponse({
    required this.savedJobs,
    required this.matchedJobs,
    required this.appliedJobs,
    required this.activeJobs,
  });

  factory SavedJobsResponse.fromMap(Map<String, dynamic> map) {
    return SavedJobsResponse(
      activeJobs: (map['data']['active_jobs'] as List)
          .map((x) => ActiveJobOffer.fromMap(x))
          .toList()
        ..sort((a, b) {
          int compareStartedAt = b.startedDate.compareTo(a.startedDate);
          if (compareStartedAt != 0) {
            return compareStartedAt;
          } else {
            // If started_at is equal, sort by finished_at in ascending order
            if (a.completionDate == null && b.completionDate == null) {
              return 0;
            } else if (a.completionDate == null) {
              return 1; // Place tasks with null completionDate at the bottom
            } else if (b.completionDate == null) {
              return -1; // Place tasks with null completionDate at the bottom
            } else {
              return a.completionDate!.compareTo(b.completionDate!);
            }
          }
        }),
      matchedJobs: (map['data']['matched_jobs'] as List)
          .map((x) => MatchedJobOffer.fromMap(x))
          .toList(),
      savedJobs: (map['data']['saved_jobs'] as List)
          .map((x) => SavedJobOffer.fromMap(x))
          .toList(),
      appliedJobs: (map['data']['applied_jobs'] as List)
          .map((x) => AppliedJobOffer.fromMap(x))
          .toList(),
    );
  }
}

class JobsResponse extends Equatable {
  final List<JobOpportunity> offers;

  const JobsResponse({
    required this.offers,
  });

  factory JobsResponse.fromMap(Map<String, dynamic> map) {
    return JobsResponse(
      offers: List<JobOpportunity>.from(map['data']['job_opportunities']
          .map((x) => JobOpportunity.fromMap(x))),
    );
  }

  @override
  List<Object?> get props => [offers];
}

class UpdateJobFrequencyRequest extends BaseHttpRequest {
  final List<SelectedJobProfile> jobProfiles;

  @override
  Map<String, dynamic> toMap() {
    return {
      "job_profiles": jobProfiles.map((e) => e.toMap()).toList(),
    };
  }

  UpdateJobFrequencyRequest({
    required this.jobProfiles,
  }) : super(
          type: RequestType.post,
          endpoint: "/user/student/job-profiles",
        );
}
