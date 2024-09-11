import 'package:equatable/equatable.dart';

class JobSkill extends Equatable {
  final String id;
  final String name;

  const JobSkill({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];

  factory JobSkill.fromMap(Map<String, dynamic> map) {
    return JobSkill(
      id: map['id'].toString(),
      name: map['name'].toString(),
    );
  }
}
