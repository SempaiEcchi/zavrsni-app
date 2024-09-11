import 'package:collection/collection.dart';
import 'package:firmus/view/pages/company_registration/company_registration_page.dart';

import 'registration_observable.dart';

class CompanyRegistrationState {
  final CompanyRegistrationPage currentPage;
  final Map<CompanyRegistrationPage, FormData> state;

  const CompanyRegistrationState({
    required this.currentPage,
    required this.state,
  });

  CompanyRegistrationState copyWith({
    CompanyRegistrationPage? currentPage,
    Map<CompanyRegistrationPage, FormData>? state,
  }) {
    return CompanyRegistrationState(
      currentPage: currentPage ?? this.currentPage,
      state: state ?? this.state,
    );
  }

  @override
  bool operator ==(Object other) {
    return false;
  }

  bool hasData() {
    return state.values.isNotEmpty;
  }

  String? getOrNull(String key) {
    return state.values
        .map((e) => e.entries)
        .expand((element) => element)
        .firstWhereOrNull((element) => element.key == key)
        ?.value;
  }
}
