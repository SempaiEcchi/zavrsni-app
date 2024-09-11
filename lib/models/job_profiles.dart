import 'package:equatable/equatable.dart';

const MAX_FREQUENCY = 10;
const DEFAULT_FREQUENCY = 5;
const MIN_FREQUENCY = 0;

class JobProfile extends Equatable {
  final int id;
  final String name;
  final String emoji;

  const JobProfile({
    required this.id,
    required this.name,
    required this.emoji,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'emoji': emoji,
    };
  }

  factory JobProfile.fromMap(Map<String, dynamic> map) {
    return JobProfile(
      id: map['id'] as int,
      name: map['name'] as String,
      emoji: map['emoji'] ?? "",
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JobProfile &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          emoji == other.emoji;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ emoji.hashCode;

  @override
  List<Object?> get props => [toMap()];
}

class SelectedJobProfile {
  final JobProfile jobProfile;
  final int frequency;

  const SelectedJobProfile({
    required this.jobProfile,
    this.frequency = DEFAULT_FREQUENCY,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SelectedJobProfile &&
          runtimeType == other.runtimeType &&
          jobProfile == other.jobProfile &&
          frequency == other.frequency;

  @override
  int get hashCode => jobProfile.hashCode ^ frequency.hashCode;

  SelectedJobProfile copyWith({
    JobProfile? jobProfile,
    int? frequency,
  }) {
    return SelectedJobProfile(
      jobProfile: jobProfile ?? this.jobProfile,
      frequency: frequency ?? this.frequency,
    );
  }

  @override
  String toString() {
    return 'SelectedJobProfile{jobProfile: $jobProfile, frequency: $frequency}';
  }

  toMap() {
    return {
      "id": jobProfile.id,
      "frequency": frequency,
    };
  }
}
