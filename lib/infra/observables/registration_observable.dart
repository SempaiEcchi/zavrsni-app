import 'package:collection/collection.dart';
import 'package:firmus/localizations.dart';
import 'package:firmus/models/registration.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final registrationOProvider = StateProvider<RegistrationO>((ref) {
  return RegistrationO();
});

class RegistrationO {
  final StudentRegistrationPage currentPage;
  final Map<StudentRegistrationPage, FormData> state;

  RegistrationO({
    this.currentPage = StudentRegistrationPage.basicInfo,
    this.state = const {},
  });

  RegistrationO copyWith({
    StudentRegistrationPage? currentPage,
    Map<StudentRegistrationPage, FormData>? state,
  }) {
    return RegistrationO(
      currentPage: currentPage ?? this.currentPage,
      state: state ?? this.state,
    );
  }

  String get(String key) {
    return state.values
        .map((e) => e.entries)
        .expand((element) => element)
        .firstWhere((element) => element.key == key)
        .value;
  }

  String? getOrNull(String key) {
    return state.values
        .map((e) => e.entries)
        .expand((element) => element)
        .firstWhereOrNull((element) => element.key == key)
        ?.value;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RegistrationO &&
          runtimeType == other.runtimeType &&
          currentPage == other.currentPage &&
          state == other.state;

  @override
  int get hashCode => currentPage.hashCode ^ state.hashCode;

  String title(BuildContext context) {
    switch (currentPage) {
      case StudentRegistrationPage.cityPicker:
        return context.loc.cityPicker;
      case StudentRegistrationPage.basicInfo:
        break;
      case StudentRegistrationPage.verifyEmail:
        break;
      case StudentRegistrationPage.done:
        break;
      default:
    }
    return context.loc.registationTitle;
  }

  bool hasData() {
    return state.values.isNotEmpty;
  }

  @override
  String toString() {
    return 'RegistrationO{currentPage: $currentPage, state: $state}';
  }
}

typedef FormData = Map<String, dynamic>;
