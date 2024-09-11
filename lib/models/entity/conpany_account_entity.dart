import 'package:equatable/equatable.dart';
import 'package:firmus/models/entity/user_entity.dart';

class CompanyAccountEntity extends UserEntity with EquatableMixin {
  final String name;
  final double rating;
  final int openPositions;
  final String logoUrl;
  final bool isGreen;

  const CompanyAccountEntity({
    super.userType = UserType.company,
    required super.id,
    required this.name,
    required this.isGreen,
    required this.rating,
    required this.openPositions,
    required this.logoUrl,
  });

  factory CompanyAccountEntity.fromMap(Map<String, dynamic> map) {
    return CompanyAccountEntity(
      id: map['id'].toString(),
      isGreen: map['isGreen'].toString() == "true",
      name: map['name'] as String,
      rating: double.tryParse(map['rating'].toString()) ?? 0,
      openPositions: int.tryParse(map["open_positions"].toString()) ?? 1,
      logoUrl: map['logoUrl'] as String,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        rating,
        openPositions,
        logoUrl,
        isGreen,
      ];

  @override
  String get debugProfileName => "Company: $name";
}
