import 'package:firmus/helper/uuid.dart';
import 'package:intl/intl.dart';

class CreateCV {
  final List<StudentExperienceEntity> experiences;

  const CreateCV({
    required this.experiences,
  });

  Map<String, dynamic> toMap() {
    return {
      'experiences': experiences.map((e) => e.toMap()).toList(),
    };
  }
}

class StudentExperienceEntity {
  final String id;
  final String jobTitle;
  final String companyName;
  final String description;
  final DateTime? start;
  final DateTime? end;
  final List<String> acquiredSkills;
  const StudentExperienceEntity({
    required this.id,
    required this.acquiredSkills,
    required this.jobTitle,
    required this.companyName,
    required this.description,
    required this.start,
    this.end,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'jobTitle': jobTitle.trim(),
      'description': description,
      'companyName': companyName.trim(),
      'start': start?.toIso8601String(),
      'end': end?.toIso8601String(),
      "acquiredSkills": acquiredSkills ?? [],
    };
  }

  Map<String, dynamic> toMapForm() {
    return {
      'id': id,
      'jobTitle': jobTitle.trim(),
      'description': description,
      'companyName': companyName.trim(),
      'start': start,
      'end': end,
      "acquiredSkills": acquiredSkills ?? [],
    };
  }

  factory StudentExperienceEntity.fromMap(Map<String, dynamic> map) {
    return StudentExperienceEntity(
      description: map['description'] ?? "",
      id: map['id']?.toString() ?? uuid.v4(),
      jobTitle: map['jobTitle'] as String,
      companyName: map["company"] ?? map['companyName'] as String,
      acquiredSkills: map['acquiredSkills'] == null
          ? []
          : List<String>.from(map['acquiredSkills'] as List<dynamic>),
      start: map['start'] == null
          ? null
          : DateTime.tryParse(map['start'].toString()),
      end: map['end'] == null
          ? null
          : DateTime.tryParse(map['end'].toString()),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudentExperienceEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          jobTitle == other.jobTitle &&
          companyName == other.companyName &&
          description == other.description &&
          start == other.start &&
          end == other.end;

  @override
  int get hashCode =>
      id.hashCode ^
      jobTitle.hashCode ^
      companyName.hashCode ^
      description.hashCode ^
      start.hashCode ^
      end.hashCode;

  String formattedBodyText() {
    String formattedText = "$jobTitle";
    if (companyName.isNotEmpty) {
      formattedText += " at $companyName";
    }
    if (start != null) {
      formattedText += " from ${DateFormat('MMM yyyy').format(start!)}";
      if (end != null) {
        formattedText += " to ${DateFormat('MMM yyyy').format(end!)}";
      } else {
        formattedText += " to Present";
      }
    }
    if (description.isNotEmpty) {
      formattedText += "\n$description";
    }
    if (acquiredSkills.isNotEmpty) {
      formattedText += "\nSkills acquired: ${acquiredSkills.join(', ')}";
    }
    return formattedText;
  }
}
