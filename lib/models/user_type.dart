import 'package:flutter/foundation.dart';

enum UserType {
  student("STUDENT"),
  company("COMPANY"),
  admin("ADMIN");

  final String name;

  const UserType(this.name);
}

extension UserTypeX on UserType {
  T when<T>({
    required T Function() student,
    required T Function() company,
    required T Function() admin,
  }) {
    switch (this) {
      case UserType.student:
        if (kIsWeb) throw UnimplementedError();
        return student();
      case UserType.company:
        if (kIsWeb) throw UnimplementedError();
        return company();
      case UserType.admin:
        return admin();
    }
  }
}
