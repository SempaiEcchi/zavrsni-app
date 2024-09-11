import 'package:equatable/equatable.dart';

class StudentCVVid extends Equatable {
  final int id;
  final String videoUrl;

  final String thumbnailUrl;
  final List<int> jobProfiles;
  const StudentCVVid({
    required this.id,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.jobProfiles,
  });

  @override
  List<Object?> get props => [
        id,
        videoUrl,
        thumbnailUrl,
        jobProfiles,
      ];

  factory StudentCVVid.fromMap(Map<String, dynamic> map) {
    return StudentCVVid(
      id: map['id'] ?? 0,
      videoUrl: map['video']["url"] as String,
      thumbnailUrl: map['thumbnail']["url"] as String,
      jobProfiles: map["job_profiles"] == null
          ? []
          : List<int>.from(map['job_profiles'] as List<dynamic>),
    );
  }
}
