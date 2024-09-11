import 'package:firmus/infra/services/analytics/analytics_service.dart';
import 'package:firmus/infra/services/job/job_service.dart';
import 'package:firmus/infra/services/notification_service/entity/notification_entity.dart';
import 'package:firmus/infra/services/notification_service/fcm.dart';
import 'package:firmus/infra/stores/notification_list_controller.dart';
import 'package:firmus/infra/stores/user_notifier.dart';
import 'package:firmus/main.dart';
import 'package:firmus/models/user_type.dart';
import 'package:firmus/view/pages/employer_home_swiper/matched_with_student_popup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final notificationHandlerProvider =
    AutoDisposeNotifierProvider<NotificationHandler, void>(() {
  return NotificationHandler();
});

class NotificationHandler extends AutoDisposeNotifier<void> {
// ignore: avoid_public_notifier_properties
  final BuildContext context = navkey.currentContext!;

  JobService get _jobService => ref.read(jobServiceProvider);

  @override
  build() {
    ref.keepAlive();
    final provider = ref.read(notificationEvents);
    provider.listen(handle);
  }

  void handle(NotificationEntity event) {
    bool canHandle = ref.read(firmusUserProvider).requireValue!.isAnon == false;
    if (!canHandle) return;
    ref.invalidate(notificationListController);
    switch (event) {
      case final MatchNotification noti:
        handleMatchNotification(noti);
      default:
        HapticFeedback.mediumImpact();
        break;
    }
  }

  void handleMatchNotification(MatchNotification noti) async {
    final matchData = await _jobService.getMatchDetails(noti.matchId);
    final currentUser = ref.read(firmusUserProvider).requireValue!.userType;
    currentUser.when(student: () {
      MatchedWithCompanyPopup(
        student: matchData.student,
        company: matchData.job.company,
        jobOpportunity: matchData.job,
        matchId: matchData.match_id,
      ).show(context);
    }, company: () {
      MatchedWithStudentPopup(
        student: matchData.student,
        company: matchData.job.company,
      ).show(context);
    }, admin: () {
      /* Do nothing */
    });
  }

  void handleTap(NotificationEntity noti) {
    ref
        .read(analyticsServiceProvider)
        .logEvent(name: AnalyticsEvent.tap_notification_tile, parameters: {
      "notification_id": noti.id,
      "notification_type": noti.runtimeType.toString(),
      "notification_title": noti.title,
    });
  }
}
