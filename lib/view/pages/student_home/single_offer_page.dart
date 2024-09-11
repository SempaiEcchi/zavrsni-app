import 'package:firmus/infra/services/analytics/analytics_service.dart';
import 'package:firmus/view/pages/student_home/widges/job_swipe_card.dart';
import 'package:firmus/view/pages/student_home/widges/swiper_controls.dart';
import 'package:firmus/view/shared/custom_back_gesture.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/job_offers.dart';

class SingleOfferPage extends ConsumerStatefulWidget {
  Future show(
    context,
  ) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => this,
      ),
    );
  }

  final JobOpportunity offer;
  final bool showControls;

  const SingleOfferPage(this.offer, {super.key, this.showControls = true});

  @override
  ConsumerState<SingleOfferPage> createState() => _SingleOfferPageState();
}

class _SingleOfferPageState extends ConsumerState<SingleOfferPage> {
  DragStartDetails? tdd;

  @override
 void initState() {
    super.initState();
    Future(() {
      ref.a.logEvent(name: AnalyticsEvent.view_job_offer, parameters: {
        "job_id": widget.offer.id,
        "job_name": widget.offer.jobTitle,
        "job_profile": widget.offer.jobProfile.name,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomBackGesture(
      child: Scaffold(
          body: Stack(
        children: [
          SingleJobCard(
            jobOpportunity: widget.offer,
            showControls: widget.showControls,
          ),
          if (widget.showControls)
            Positioned(
              bottom: 120,
              child: AdditionalSwiperControls(widget.offer),
            ),
        ],
      )),
    );
  }
}
