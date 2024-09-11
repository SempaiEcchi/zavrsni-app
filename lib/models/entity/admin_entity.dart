import 'package:firmus/models/entity/user_entity.dart';

class AdminAccountEntity extends UserEntity {
  AdminAccountEntity({required super.userType, required super.id});

  @override
  String get debugProfileName => "Admin";
}
