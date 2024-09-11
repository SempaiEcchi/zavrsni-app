import 'dart:io';

import 'package:firmus/infra/observables/company_registration_state.dart';
import 'package:firmus/infra/observables/registration_observable.dart';
import 'package:firmus/infra/services/user/http_user_service.dart';
import 'package:firmus/infra/services/user/user_service.dart';
import 'package:firmus/infra/stores/industry_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../view/pages/company_registration/company_registration_page.dart';

final companyRegistrationNotifierProvider =
    NotifierProvider<CompanyRegistrationNotifier, CompanyRegistrationState>(() {
  return CompanyRegistrationNotifier();
});

class CompanyRegistrationNotifier extends Notifier<CompanyRegistrationState> {
  UserService get userService => ref.read(userServiceProvider);

  @override
  CompanyRegistrationState build() {
    ref.read(industryProvider);

    ref.onDispose(() {
      ref.invalidate(industryProvider);
    });

    return const CompanyRegistrationState(
        currentPage: CompanyRegistrationPage.companyInfo, state: {});
  }

  void previousPage() {
    state = state.copyWith(
        currentPage:
            CompanyRegistrationPage.values[state.currentPage.index - 1]);
  }

  void nextPage(Map<String, dynamic> data) {
    state = state.copyWith(
        state: {
          ...state.state,
          CompanyRegistrationPage.values[state.currentPage.index]: data
        },
        currentPage:
            CompanyRegistrationPage.values[state.currentPage.index + 1]);
  }

  Future register() async {
    final Iterable<FormData> maps = state.state.values.toList();
    Map<String, dynamic> expanded = {};
    for (var m in maps) {
      expanded.addAll(m);
    }
    final image = expanded["logo"] as File;

    final request = CreateCompanyRequest(
      email: expanded["email"],
      name: expanded["name"],
      logo: image,
      representative: expanded["representative"],
      oib: expanded["oib"],
      location: expanded["location"],
      industryId: expanded["industry"].id.toString(),
      description: expanded["description"],
    );

    await userService.createCompany(request);
  }
}
