import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:firmus/infra/services/user/user_service.dart';
import 'package:firmus/models/entity/cv_video.dart';
import 'package:firmus/models/entity/student_entity.dart';
import 'package:firmus/models/job_profiles.dart';
import 'package:firmus/models/student_experience.dart';

class JobOfferDetailsResponse extends Equatable {
  final List<MatchedApplicant> matchedApplicants;
  final List<EmployedApplicant> employedApplicants;
  final int newApplicantsCount;

  const JobOfferDetailsResponse({
    required this.matchedApplicants,
    required this.employedApplicants,
    required this.newApplicantsCount,
  });

  factory JobOfferDetailsResponse.fromMap(Map<String, dynamic> map) {
    return JobOfferDetailsResponse(
      newApplicantsCount: map['new_applicants_count'] ?? 0,
      employedApplicants: List<EmployedApplicant>.from(
          map['employed_applicants'].map((x) => EmployedApplicant.fromMap(x))),
      matchedApplicants: List<MatchedApplicant>.from(
              map['matched_applicants'].map((x) => MatchedApplicant.fromMap(x)))
          .toList(),
    );
  }

  @override
  List<Object?> get props =>
      [matchedApplicants, employedApplicants, newApplicantsCount];
}

typedef SimpleStudentProfile = StudentApplicant;

class StudentApplicant extends Equatable {
  final String id;
  final String first_name;
  final String last_name;
  final String bio;
  final String imageUrl;
  final String location;
  final String? phoneNumber;
  final String email_contact;
  final List<StudentCVVid> videos;
  final List<String> languages;
  final DateTime? dateOfBirth;
  final List<StudentExperienceEntity> experiences;
  final UniversityInfo? universityInfo;

  String get universityText {
    if (universityInfo == null) return "Fakultet nepoznat";

    return "${universityInfo!.uniName} ${universityInfo!.uniYear}";
  }

  StudentCVVid? videoForJob(JobProfile jobProfile) {
    return videos.isEmpty
        ? null
        : videos.firstWhere((element) {
            return element.jobProfiles.contains(jobProfile.id);
          }, orElse: () => videos.first);
  }

  String get age {
    if (dateOfBirth == null) return "Nepoznato";

    return (DateTime.now().year - dateOfBirth!.year).toString();
  }

  const StudentApplicant({
    required this.id,
    required this.languages,
    required this.universityInfo,
    required this.experiences,
    required this.dateOfBirth,
    required this.videos,
    required this.email_contact,
    required this.first_name,
    required this.location,
    required this.last_name,
    required this.bio,
    required this.imageUrl,
    this.phoneNumber,
  });

  factory StudentApplicant.fromMap(Map<String, dynamic> map) {
    return StudentApplicant(
      languages: map["languages"] == null
          ? []
          : (map["languages"] as List).map((e) => e.toString()).toList(),
      email_contact: map['email_contact'] ?? map['email'] ?? "",
      universityInfo: map["university_info"] == null
          ? null
          : UniversityInfo.fromMap(map["university_info"]),
      dateOfBirth: map['date_of_birth'] == null
          ? null
          : DateTime.parse(map['date_of_birth']),
      phoneNumber: map['phone_number'] ?? "",
      experiences: map["cv"] == null
          ? []
          : (map["cv"]["experiences"] as List)
              .map((e) {
                try {
                  return StudentExperienceEntity.fromMap(e);
                } catch (e) {
                  return null;
                }
              })
              .whereNotNull()
              .toList(),
      videos: map["studentVideoCVs"] == null
          ? []
          : List.from(map["studentVideoCVs"]).map((e) {
              return StudentCVVid.fromMap(e);
            }).toList(),
      id: map['id'].toString(),
      location: map['location'] is Map ? map['location']['location_name'] : "",
      first_name: map['first_name'] ?? "Anonymous",
      last_name: map['last_name'] ?? "",
      bio: map['bio'] ?? "",
      imageUrl: map["profile_picture"] == null
          ? "https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png"
          : map["profile_picture"]['url'],
    );
  }

  @override
  List<Object?> get props => [
        id,
        first_name,
        last_name,
        bio,
        imageUrl,
        location,
        videos,
        experiences,
        languages
      ];

  String get name => "$first_name $last_name";

  static mocked() {
    return const StudentApplicant(
      languages: [],
      phoneNumber: "123456789",
      universityInfo: null,
      dateOfBirth: null,
      experiences: [],
      id: "1",
      first_name: "John",
      last_name: "Doe",
      bio: "I am a student",
      imageUrl: "https://placekitten.com/200/300",
      location: "Sarajevo",
      videos: [],
      email_contact: '',
    );
  }

  factory StudentApplicant.fromStudent(StudentAccountEntity student) {
    return StudentApplicant(
      languages: student.languages,
      email_contact: student.emailContact ?? student.email,
      universityInfo: student.universityInfo,
      dateOfBirth: student.dateOfBirth,
      phoneNumber: student.phoneNumber,
      experiences: student.experiences,
      id: student.id,
      first_name: student.first_name,
      last_name: student.last_name,
      bio: student.bio,
      imageUrl: student.imageUrl,
      location: "",
      videos: student.cvVideos,
    );
  }

  String formattedBodyText() {
    // to show in a widget
    return "Name: $first_name $last_name\nLocation: $location\nAge: $age\nBio: $bio\nLanguages: $languages\nExperiences: ${experiences.map((e) {
      return e.formattedBodyText();
    }).join("\n")}";
  }
}

sealed class JobOfferApplicant extends Equatable {
  final StudentApplicant student;

  const JobOfferApplicant({
    required this.student,
  });

  @override
  List<Object?> get props => [student];
}

class MatchedApplicant extends JobOfferApplicant {
  final String matchId;

  factory MatchedApplicant.fromMap(Map<String, dynamic> map) {
    return MatchedApplicant(
      matchId: map['match_id'].toString(),
      student: StudentApplicant.fromMap(map["student"]),
    );
  }

  const MatchedApplicant({
    required this.matchId,
    required super.student,
  });

  //copywith
  MatchedApplicant copyWith({
    String? matchId,
    StudentApplicant? student,
  }) {
    return MatchedApplicant(
      matchId: matchId ?? this.matchId,
      student: student ?? this.student,
    );
  }
}

class EmployedApplicant extends JobOfferApplicant {

  final String record_id;

  const EmployedApplicant({
    required this.record_id,
    required super.student,
  });

  factory EmployedApplicant.fromMap(Map<String, dynamic> map) {
    return EmployedApplicant(
      record_id: map['record_id'].toString(),
      student: StudentApplicant.fromMap(map["student"]),
    );
  }
}

class InterestedApplicant extends JobOfferApplicant {
  const InterestedApplicant({
    required super.student,
  });

  factory InterestedApplicant.fromMap(Map<String, dynamic> map) {
    return InterestedApplicant(
      student: StudentApplicant.fromMap(map["student"]),
    );
  }
}

class RecommendedApplicant extends JobOfferApplicant {
  const RecommendedApplicant({
    required super.student,
  });

  factory RecommendedApplicant.fromMap(Map<String, dynamic> map) {
    return RecommendedApplicant(
      student: StudentApplicant.fromMap(map["student"]),
    );
  }
}
