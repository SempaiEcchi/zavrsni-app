import 'dart:async';

import 'package:firmus/infra/services/user/user_service.dart';
import 'package:firmus/infra/stores/user_notifier.dart';
import 'package:firmus/models/entity/admin_entity.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final _admin = StreamProvider<AdminAccountEntity>((ref) async* {
  final userE = ref.watch(firmusUserProvider).valueOrNull;

  if (userE is AdminAccountEntity) {
    yield userE;
  }
});

class AdminO {}

final adminNotifierProvider = AsyncNotifierProvider<AdminNotifier, AdminO>(() {
  return AdminNotifier();
});

class AdminNotifier extends AsyncNotifier<AdminO> {
  UserService get userService => ref.read(userServiceProvider);

  @override
  FutureOr<AdminO> build() async {
    final A = await ref.watch(_admin.future);
    return AdminO();
  }
}
