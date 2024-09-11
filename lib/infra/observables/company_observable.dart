import 'package:equatable/equatable.dart';
import 'package:firmus/models/entity/conpany_account_entity.dart';

class CompanyObservable extends Equatable {
  final String id;
  final String name;
  final double rating;
  final int openPositions;
  final String logoUrl;

  final bool isGreen;

  factory CompanyObservable.fromEntity(
      CompanyAccountEntity CompanyAccountEntity) {
    return CompanyObservable(
      id: CompanyAccountEntity.id,
      name: CompanyAccountEntity.name,
      rating: CompanyAccountEntity.rating,
      openPositions: CompanyAccountEntity.openPositions,
      logoUrl: CompanyAccountEntity.logoUrl,
      isGreen: CompanyAccountEntity.isGreen,
    );
  }

  const CompanyObservable({
    required this.id,
    required this.name,
    required this.rating,
    required this.openPositions,
    required this.logoUrl,
    required this.isGreen,
  });
  @override
  List<Object?> get props => [
        id,
        name,
        rating,
        openPositions,
        logoUrl,
        isGreen,
      ];
}
