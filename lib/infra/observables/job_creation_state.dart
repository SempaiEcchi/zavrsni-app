import 'package:equatable/equatable.dart';
import 'package:firmus/infra/observables/registration_observable.dart';
import 'package:firmus/models/job_offers.dart';
import 'package:firmus/models/job_skill.dart';
import 'package:firmus/view/pages/job_op_creation/basic_job_details.dart';
import 'package:firmus/view/pages/job_op_creation/job_skills.dart';
import 'package:firmus/view/pages/job_op_creation/job_video.dart';
import 'package:firmus/view/pages/job_op_creation/other_job_details.dart';
import 'package:flutter/foundation.dart';

enum JobCreationStatePage {
  video,
  basicJobDetails,
  skills,
  otherDetails;
}

//
// class JobCreationFormData {
//   Map<String, dynamic> toMap() {
//     return {};
//   }
//
//   void load(JobOpportunity jobOpportunity) {}
// }
//
// class FieldValue<String> {
//   final String fieldName;
//   dynamic value;
//
//   FieldValue(this.fieldName, [this.value]);
// }
//
// class BasicJobDetailsData extends JobCreationFormData {
//   FieldValue title = FieldValue("title");
//   FieldValue payment = FieldValue("payment");
//   FieldValue startDate = FieldValue(
//     "startDate",
//   );
//   FieldValue endDate = FieldValue("endDate");
//   FieldValue location = FieldValue("location");
//
//   @override
//   Map<String, dynamic> toMap() {
//     return {
//       "title": title.value,
//       "payment": payment.value,
//       "startDate": startDate.value,
//       "endDate": endDate.value,
//       "location": location.value,
//     };
//   }
//
//   @override
//   load(JobOpportunity jobOpportunity) {
//     title.value = jobOpportunity.jobTitle;
//     payment.value = jobOpportunity.payment.amount;
//     startDate.value = jobOpportunity.applyDeadline;
//     endDate.value = jobOpportunity.applyDeadline;
//     location.value = jobOpportunity.location;
//   }
// }

class JobCreationState extends Equatable {
  final JobCreationStatePage currentPage;
  final Map<JobCreationStatePage, FormData> state;

  const JobCreationState({
    this.currentPage = JobCreationStatePage.video,
    required this.state,
  });

  factory JobCreationState.job(JobOpportunity jobOpportunity) {
    return JobCreationState(
      state: {
        JobCreationStatePage.basicJobDetails: {
          BasicJobDetails.title: jobOpportunity.jobTitle,
          BasicJobDetails.payment:
              jobOpportunity.payment.amount.toStringAsFixed(2),
          BasicJobDetails.applyDeadline: jobOpportunity.applyDeadline,
          BasicJobDetails.location: jobOpportunity.location,
          BasicJobDetails.description: jobOpportunity.jobDescription,
        },
        JobCreationStatePage.skills: {
          JobSkillPicker.skills:
              jobOpportunity.skills.map((e) => e.name).toList()
        },
        JobCreationStatePage.video: {
          JobVideo.video: jobOpportunity.url,
        },
        JobCreationStatePage.otherDetails: {
          OtherJobDetails.language: const [],
          OtherJobDetails.jobType: jobOpportunity.jobType.name,
          OtherJobDetails.employeesNeeded: jobOpportunity.availablePositions,
          OtherJobDetails.acceptOnlyStudents: jobOpportunity.acceptOnlyStudents,
        },
      },
    );
  }
  factory JobCreationState.mocked() {
    if (kDebugMode) {
      return JobCreationState(
        state: {
          JobCreationStatePage.basicJobDetails: {
            BasicJobDetails.title: "debugjobTitle",
            BasicJobDetails.payment: 11.11.toString(),
            BasicJobDetails.applyDeadline:
                DateTime.now().add(const Duration(days: 80)),
            BasicJobDetails.location: "jobOpportunity.location",
            BasicJobDetails.description: "jobOpportunity.jobDescription",
          },
          JobCreationStatePage.skills: const {
            JobSkillPicker.skills: <JobSkill>[],
          },
          JobCreationStatePage.video: const {},
          JobCreationStatePage.otherDetails: {
            OtherJobDetails.language: const <String>[],
            OtherJobDetails.jobProfile: null,
            OtherJobDetails.jobType: JobType.PART_TIME,
            OtherJobDetails.employeesNeeded: 0.toString(),
            OtherJobDetails.acceptOnlyStudents: false,
          },
        },
      );
    }

    return const JobCreationState(
      state: {
        JobCreationStatePage.basicJobDetails: {},
        JobCreationStatePage.skills: {},
        JobCreationStatePage.video: {},
        JobCreationStatePage.otherDetails: {},
      },
    );
  }

  JobCreationState copyWith({
    JobCreationStatePage? currentPage,
    Map<JobCreationStatePage, FormData>? state,
  }) {
    return JobCreationState(
      currentPage: currentPage ?? this.currentPage,
      state: state ?? this.state,
    );
  }

  @override
  List<Object?> get props => [currentPage, state];
}
