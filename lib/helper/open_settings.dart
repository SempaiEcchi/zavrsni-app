import 'package:app_settings/app_settings.dart';
import 'package:flutter/foundation.dart';

import 'logger.dart';

void openSettings() {
  if (kIsWeb) {
    logger.info("open settings");
  } else {
    AppSettings.openAppSettings();
  }
}
