import 'dart:developer';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firmus/infra/services/auth/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  final service = AnalyticsService();
  ref.listen(userProvider, (_, user) {
    if (user.hasValue) {
      service.setId(user.requireValue.uid);
    }
  }, fireImmediately: true);
  return service;
});

extension AnalyticsProvider on WidgetRef {
  AnalyticsService get a => read(analyticsServiceProvider);
}

enum AnalyticsEvent {
  login,
  preferences_edit,
  pick_registration_type,
  swipe_job,
  update_student_profile,
  navigate,
  view_company_details,
  login_anonymous,
  tap_cv_video_option,
  tab_bar_tap,
  contact_company_whatsapp,
  select_preference,
  email_link_sign_in,
  tap_notification_tile,
  pick_cv_video,
  view_job_offer,
  tap_profile_setting_option,

}

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  void logEvent(
      {required AnalyticsEvent name, Map<String, Object>? parameters}) {
    final event = name.name;

    _analytics.logEvent(name: event, parameters: parameters);
    // log('Analytics: $event parameters: $parameters');
  }

  void setPage(String name) {
    _analytics.logScreenView(screenName: name);
    logEvent(name: AnalyticsEvent.navigate, parameters: {
      "screen": name,
    });
  }

  void setId(String uid) {
    _analytics.setUserId(id: uid);
  }



  void setProps() {

   }
}
