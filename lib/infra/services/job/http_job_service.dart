import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firmus/helper/logger.dart';
import 'package:firmus/infra/services/http/http_service.dart';
import 'package:firmus/infra/services/job/entity/employer_job_offers.dart';
import 'package:firmus/infra/services/job/entity/industry.dart';
import 'package:firmus/infra/services/job/entity/job_offer_details_response.dart';
import 'package:firmus/infra/services/job/entity/match_details.dart';
import 'package:firmus/infra/services/job/entity/swipable_students_response.dart';
import 'package:firmus/infra/services/job/job_service.dart';
import 'package:firmus/main.dart';
import 'package:firmus/models/job_offers.dart';
import 'package:firmus/models/job_profiles.dart';
import 'package:firmus/models/job_skill.dart';
import 'package:firmus/models/student_job_offers.dart';
import 'package:flutter/cupertino.dart';

class JobServiceImpl extends JobService {
  JobServiceImpl(HttpService httpService) : super(httpService);

  @override
  Future<JobsResponse> fetchJobs(FetchJobsRequest jobsRequest) async {
    final context = navkey.currentContext!;

    final initial = await httpService.request(jobsRequest, converter: (data) {
      return JobsResponse.fromMap(data);
    });
    logger.info("got ${initial.offers.length} offers");

    final futures = <Future>[];
    for (var element in initial.offers) {
      final f2 = precacheImage(
          CachedNetworkImageProvider(element.company.logoUrl), context);

      futures.add(f2);

      if (!element.isVideo) {
        final f1 =
            precacheImage(CachedNetworkImageProvider(element.url), context);
        futures.add(f1);
      }
    }

    Future.wait(futures);
    return initial;
  }

  @override
  Future<void> swipeJob(SwipeJobRequest swipeJobRequest) async {
    await httpService.request(swipeJobRequest, converter: (data) {});
  }

  @override
  Future<List<JobProfile>> fetchJobProfiles(
      JobProfileRequest jobProfileRequest) {
    return httpService.request(jobProfileRequest, converter: (resp) {
      return (resp['data'] as List).map((e) => JobProfile.fromMap(e)).toList();
    });
  }

  @override
  Future<IndustryResponse> getIndustries(IndustriesRequest request) {
    return httpService.request(request, converter: (resp) {
      return IndustryResponse(
        industries: (resp['data'] as List)
            .map((e) => IndustryModel.fromMap(e))
            .toList(),
      );
    });
  }

  @override
  Future<SavedJobsResponse> fetchSavedJobs(
      FetchSavedJobsRequest fetchSavedJobsRequest) async {
    final resp =
        await httpService.request(fetchSavedJobsRequest, converter: (resp) {
      return SavedJobsResponse.fromMap(resp);
    });

    return resp;
  }

  @override
  Future<JobOpportunity> getJobOpportunity(
      GetJobOpportunityRequest getJobOpportunityRequest) {
    return httpService.request(getJobOpportunityRequest, converter: (resp) {
      return JobOpportunity.fromMap(resp['data']);
    });
  }

  @override
  Future<List<JobOpportunity>> fetchCompanyOffers(String companyId) {
    return httpService.request(GetCompanyJobsRequest(companyId: companyId),
        converter: (resp) {
      try {
        final jobs = (resp['data'] as List)
            .map((e) => JobOpportunity.fromMap(e))
            .toList();
        return jobs;
      } catch (e) {
        logger.info(e);

        return [];
      }
    });
  }

  @override
  Future<EmployerJobOffersResponse> fetchEmployerJobOffers(String companyId) {
    return httpService.request(
        GetEmployerJobOffersRequest(companyId: companyId), converter: (resp) {
      return EmployerJobOffersResponse.fromMap(resp["data"]);
    });
  }

  @override
  Future<JobOfferDetailsResponse> fetchJobOfferDetails(
      String companyId, String jobId) {
    return httpService
        .request(GetJobOfferDetailsRequest(companyId: companyId, jobId: jobId),
            converter: (resp) {
      return JobOfferDetailsResponse.fromMap(resp["data"]);
    });
  }

  @override
  Future<SwipeableStudentsResponse> fetchSwipeableStudents(String companyId,
      [String? jobId]) {
    return httpService.request(
        jobId == null
            ? GetSwipeableStudentsForCompanyRequest(companyId: companyId)
            : GetSwipeableStudentsForJobRequest(
                companyId: companyId, jobId: jobId), converter: (resp) {
      return SwipeableStudentsResponse.fromMap(resp["data"]);
    });
  }

  @override
  Future<List<JobSkill>> fetchJobSkills() {
    return httpService.request(const GetJobSkillsRequest(), converter: (resp) {
      return (resp['data'] as List).map((e) => JobSkill.fromMap(e)).toList();
    });
  }

  @override
  Future<List<JobSkill>> createJobSkill(String name) {
    return httpService.request(CreateJobSkillRequest(name: name),
        converter: (resp) {
      return (resp['data'] as List).map((e) => JobSkill.fromMap(e)).toList();
    });
  }

  @override
  Future<void> swipeStudent(
      String studentId, String? jobId, FirmusSwipeType direction) async {
    return httpService.request(
        SwipeStudentRequest(
            studentId: studentId, jobId: jobId, direction: direction),
        converter: (c) {});
  }

  @override
  Future<JobOpportunity> createJob(CreateJobRequest request) {
    return httpService.request(request, converter: (resp) {
      return JobOpportunity.fromMap(resp['data']);
    });
  }

  @override
  Future<Map<String, dynamic>> processAudio(File file) {
    return httpService.request(ProcessAudioRequest(file: file),
        converter: (resp) {
      return resp;
    });
  }

  @override
  Future<AppliedJobOffer> acceptMatch(String matchId) {
    return httpService.request(AcceptMatchRequest(matchId: matchId),
        converter: (resp) {
      return AppliedJobOffer.fromMap(resp["data"]);
    });
  }

  @override
  Future<MatchDetailsResponse> getMatchDetails(String matchId) {
    return httpService.request(GetMatchDetails(matchId: matchId),
        converter: (resp) {
      return MatchDetailsResponse.fromMap(resp["data"]);
    });
  }

  @override
  Future<AppliedJobOffer> cancelMatch(String matchId) {
    return httpService.request(CancelMatchRequest(matchId: matchId),
        converter: (resp) {
      return AppliedJobOffer.fromMap(resp["data"]);
    });
  }

  Future<Map<JobOpportunity, List<InterestedApplicant>>>
      getAllInterestedApplicants() {
    return httpService.request(GetAllInterestedApplicantsRequest(),
        converter: (resp) {
      final all = resp['data'] as List;

      final entries = all.map((e) {
        final job = JobOpportunity.fromMap(e['job']);
        final applicants = (e['applicants'] as List).map((e) {
          final map = {"student": e};
          return InterestedApplicant.fromMap(map);
        }).toList();
        return MapEntry(job, applicants);
      });
      return Map.fromEntries(entries);
    });
  }

  @override
  Future<Map<JobOpportunity, List<MatchedApplicant>>>
      getAllMatchedApplicants() {
    return httpService.request(
        const GetRequest(endpoint: "/jobs/admin/all-matched-applicants"),
        converter: (resp) {
      final all = resp['data'] as List;

      final entries = all.map((e) {
        final job = JobOpportunity.fromMap(e['job']);
        final applicants = (e['applicants'] as List).map((e) {
          final map = {"student": e, "match_id": e["match_id"]};
          return MatchedApplicant.fromMap(map);
        }).toList();
        return MapEntry(job, applicants);
      });
      return Map.fromEntries(entries);
    });
  }

  @override
  Future<Map<JobOpportunity, List<EmployedApplicant>>>
      getAllEmployedApplicants() {
    return httpService.request(
        const GetRequest(endpoint: "/jobs/admin/all-employed-applicants"),
        converter: (resp) {
      final all = resp['data'] as List;

      final entries = all.map((e) {
        final job = JobOpportunity.fromMap(e['job']);
        final applicants = (e['applicants'] as List).map((e) {
          final map = {
            "record_id": e["record_id"],
            "student": e,
          };
          return EmployedApplicant.fromMap(map);
        }).toList();
        return MapEntry(job, applicants);
      });
      return Map.fromEntries(entries);
    });
  }
}
