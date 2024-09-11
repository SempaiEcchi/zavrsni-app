import 'package:firmus/models/job_offers.dart';
import 'package:firmus/router/router.dart';
import 'package:firmus/view/pages/student_home/home_page.dart';
import 'package:firmus/view/shared/popups/anonymous_user_popup.dart';
import 'package:flutter/material.dart';
import 'package:firmus/helper/logger.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';

import 'generic_action_popup.dart';

@Deprecated("Use MatchedJobPopup instead")
class MatchedJobPopup extends ConsumerWidget with ShowDialogMixin {
  final JobOpportunity offer;

  MatchedJobPopup(this.offer, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GenericActionPopup(
        title: "Matchani ste s poslodavcem!",
        iconSize: 45,
        icon: Lottie.asset("assets/animations/matched.json",
            width: 45, height: 45),
        description:
            "Poslodavac vas je također označio kao zanimljivog kandidata. Kontaktirajte ga i dogovorite razgovor za posao.",
        actionText: "Kontaktiraj poslodavca",
        onActionPressed: () {
          ref.read(currentPageProvider.notifier).changePage(HomePages.chat);
          router.pop();
        });
  }
}
