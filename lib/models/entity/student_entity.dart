import 'package:collection/collection.dart';
import 'package:firmus/helper/map_extension.dart';
import 'package:firmus/models/entity/cv_video.dart';
import 'package:firmus/models/entity/user_entity.dart';
import 'package:firmus/models/student_experience.dart';
import 'package:latlong2/latlong.dart';

import '../../infra/services/user/user_service.dart';

class StudentAccountEntity extends UserEntity {
  final String first_name;
  final String last_name;
  final String? phoneNumber;
  final String? emailContact;
  final String email;
  final String imageUrl;
  final String bio;
  final bool tutorialCompleted;
  final double profileCompletionPercentage;
  final List<StudentCVVid> cvVideos;
  final Map<String, int> jobProfileFrequencies;
  final List<StudentExperienceEntity> experiences;
  final String gender;
  final int age;
  final DateTime dateOfBirth;
  final LatLng? location;
  final UniversityInfo? universityInfo;
  final List<String> languages;

  factory StudentAccountEntity.fromMap(Map<String, dynamic> map) {
    return StudentAccountEntity(
      universityInfo: map["university_info"] == null
          ? null
          : UniversityInfo.fromMap(map["university_info"]),
      age: map["age"] ?? 0,
      languages: map["languages"] == null
          ? []
          : (map["languages"] as List).map((e) => e.toString()).toList(),
      location: map["location"] == null
          ? null
          : LatLng(
              double.tryParse(map["location"]["location"]["coordinates"][1]
                      .toString()) ??
                  0.0,
              double.tryParse(map["location"]["location"]["coordinates"][0]
                      .toString()) ??
                  0.0,
            ),
      dateOfBirth:
          DateTime.tryParse(map["date_of_birth"].toString()) ?? DateTime.now(),
      emailContact: map["email_contact"] ?? map["email"],
      phoneNumber: map["phone_number"],
      gender: map["gender"].toString(),
      profileCompletionPercentage:
          double.tryParse(map["profile_completion_percentage"].toString()) ??
              0.0,
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
      bio: map["bio"] ?? "",
      jobProfileFrequencies: map["jobProfileFrequencies"] is! List
          ? {}
          : (map["jobProfileFrequencies"] as List)
              .map((e) => MapEntry<String, int>(e["job_profile_id"].toString(),
                  int.parse(e["frequency"].toString())))
              .toMap(),
      id: map['id'].toString(),
      tutorialCompleted: map['tutorial_completed'].toString() == "true",
      email: map['email'] ?? "",
      first_name: map['first_name'] ?? "",
      last_name: map['last_name'] ?? "",
      cvVideos: map["studentVideoCVs"] == null
          ? []
          : (map["studentVideoCVs"] as List)
              .map((e) {
                try {
                  return StudentCVVid.fromMap(e);
                } catch (e) {
                  return null;
                }
              })
              .whereNotNull()
              .toList(),
      imageUrl: map["profile_picture"] == null
          ? "https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png"
          : map["profile_picture"]['url'],
    );
  }

  const StudentAccountEntity({
    required super.id,
    required this.universityInfo,
    required this.languages,
    required this.location,
    required this.phoneNumber,
    required this.dateOfBirth,
    required this.emailContact,
    required this.age,
    super.userType = UserType.student,
    required this.gender,
    required this.experiences,
    required this.bio,
    required this.jobProfileFrequencies,
    required this.cvVideos,
    required this.tutorialCompleted,
    required this.email,
    required this.first_name,
    required this.last_name,
    required this.profileCompletionPercentage,
    required this.imageUrl,
  });

  @override
  String get debugProfileName {
    return "Student $first_name $last_name";
  }
}
