import 'package:firmus/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

export 'package:firmus/l10n/app_localizations.dart';

extension CtxExt on BuildContext {
  AppLocalizations get loc => AppLocalizations.of(this)!;
}
//run build runner command
// flutter pub run build_runner build --delete-conflicting-outputs
