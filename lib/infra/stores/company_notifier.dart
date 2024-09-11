import 'dart:async';

import 'package:firmus/infra/observables/company_observable.dart';
import 'package:firmus/infra/services/user/user_service.dart';
import 'package:firmus/infra/stores/user_notifier.dart';
import 'package:firmus/models/entity/conpany_account_entity.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final _company = StreamProvider<CompanyAccountEntity>((ref) async* {
  final userE = ref.watch(firmusUserProvider).valueOrNull;

  if (userE is CompanyAccountEntity) {
    yield userE;
  }
});

final companyNotifierProvider =
    AsyncNotifierProvider<CompanyNotifier, CompanyObservable>(() {
  return CompanyNotifier();
});

class CompanyNotifier extends AsyncNotifier<CompanyObservable> {
  UserService get userService => ref.read(userServiceProvider);

  @override
  FutureOr<CompanyObservable> build() async {
    final companyE = await ref.watch(_company.future);
    final company = CompanyObservable.fromEntity(companyE);
    return company;
  }

  Future createFakeCompany() async {
    final user = await userService.createFakeCompany();
    state = AsyncData(CompanyObservable.fromEntity(user));
  }
}
