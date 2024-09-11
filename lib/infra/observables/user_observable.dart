import 'package:equatable/equatable.dart';
import 'package:firmus/models/entity/student_entity.dart';
import 'package:firmus/models/student_experience.dart';
import 'package:latlong2/latlong.dart';

import '../../models/entity/cv_video.dart';

class StudentObservable extends Equatable {
  final String id;
  final String first_name;
  final String last_name;
  final String email;
  final String imageUrl;
  final bool anon;
  final bool tutorialCompleted;
  final Map<String, int> jobProfileFrequencies;
  final List<StudentCVVid> cvVideos;
  final String bio;
  final LatLng? location;
  final List<StudentExperienceEntity> experiences;
  final List<String> languages;
  final StudentAccountEntity studentEntity;

  factory StudentObservable.fromEntity(StudentAccountEntity entity) {
    return StudentObservable(
      studentEntity: entity,
      languages: entity.languages,
      experiences: entity.experiences.toList(),
      bio: entity.bio,
      id: entity.id,
      anon: entity.email.isEmpty,
      cvVideos: entity.cvVideos,
      first_name: entity.first_name,
      last_name: entity.last_name,
      email: entity.email,
      tutorialCompleted: entity.tutorialCompleted,
      imageUrl: entity.imageUrl,
      jobProfileFrequencies: entity.jobProfileFrequencies,
      location: entity.location,
    );
  }

  const StudentObservable({
    required this.bio,
    required this.languages,
    required this.studentEntity,
    required this.experiences,
    required this.id,
    this.location,
    required this.cvVideos,
    required this.tutorialCompleted,
    required this.jobProfileFrequencies,
    required this.email,
    required this.first_name,
    this.anon = false,
    required this.last_name,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [
        id,
        languages,
        location,
        cvVideos,
        tutorialCompleted,
        jobProfileFrequencies,
        email,
        studentEntity,
        first_name,
        bio,
        experiences,
        anon,
        last_name,
        imageUrl,
      ];

  double get profileCompletionPercentage =>
      studentEntity.profileCompletionPercentage;

  get name => "$first_name $last_name";

  Map<String, dynamic> toProfileEditForm() {
    return {
      "first_name": first_name,
      "last_name": last_name,
      "email": email,
      "image": imageUrl,
      "gender": studentEntity.gender,
      "phone_number": studentEntity.phoneNumber,
      "email_contact": studentEntity.emailContact,
      "date_of_birth": studentEntity.dateOfBirth,
    };
  }

  Map<String, dynamic> toBioEditForm() {
    return {
      "bio": bio,
    };
  }

  Map<String, dynamic> toUniEdit() {
    if (studentEntity.universityInfo == null) return {};

    return studentEntity.universityInfo!.toMap();
  }

  toExperienceForm() {
    return {
      "experiences": experiences.toList(),
    };
  }

  StudentObservable copyWith({
    String? id,
    String? first_name,
    String? last_name,
    String? email,
    String? imageUrl,
    bool? anon,
    bool? firebaseUserIsAnon,
    bool? tutorialCompleted,
    Map<String, int>? jobProfileFrequencies,
    List<StudentCVVid>? cvVideos,
    String? bio,
    LatLng? location,
    List<StudentExperienceEntity>? experiences,
    List<String>? languages,
  }) {
    return StudentObservable(
      id: id ?? this.id,
      languages: languages ?? this.languages,
      studentEntity: studentEntity,
      first_name: first_name ?? this.first_name,
      last_name: last_name ?? this.last_name,
      email: email ?? this.email,
      imageUrl: imageUrl ?? this.imageUrl,
      anon: anon ?? this.anon,
      tutorialCompleted: tutorialCompleted ?? this.tutorialCompleted,
      jobProfileFrequencies:
          jobProfileFrequencies ?? this.jobProfileFrequencies,
      cvVideos: cvVideos ?? this.cvVideos,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      experiences: experiences ?? this.experiences,
    );
  }
}
