import 'package:firmus/models/entity/admin_entity.dart';
import 'package:firmus/models/entity/conpany_account_entity.dart';
import 'package:firmus/models/entity/student_entity.dart';
import 'package:firmus/models/user_type.dart';

export 'package:firmus/models/user_type.dart';

abstract class UserEntity {
  final UserType userType;
  final String id;

  bool get isAnon {
    if (this is StudentAccountEntity) {
      return (this as StudentAccountEntity).email.isEmpty;
    }
    return false;
  }

  const UserEntity({
    required this.userType,
    required this.id,
  });

  factory UserEntity.fromMap(Map<String, dynamic> map) {
    if (map["user_type"] == "student") {
      return StudentAccountEntity.fromMap(map);
    } else if (map["user_type"] == "company") {
      return CompanyAccountEntity.fromMap(map);
    } else if (map["user_type"] == "admin") {
      return AdminAccountEntity(id: map["id"], userType: UserType.admin);
    } else {
      throw Exception("Unknown user type");
    }
  }

  String get debugProfileName;
}
