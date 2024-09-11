import "dart:math" as math;

import 'package:firmus/infra/services/job/job_service.dart';
import 'package:firmus/models/job_offers.dart';
import 'package:firmus/view/admin/pages/admin_home.dart';
import 'package:firmus/view/shared/tiles/jobs/basic_info_job_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../infra/services/job/entity/job_offer_details_response.dart';
import '../../pages/employeer_home/widgets/applicant_list_tile.dart';
import '../../shared/buttons/primary_button.dart';

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

class CollapsingList extends ConsumerStatefulWidget {
  final Map<JobOpportunity, List<InterestedApplicant>> applications;
  final VoidCallback onRefresh;

  CollapsingList(this.applications, this.onRefresh);

  @override
  ConsumerState<CollapsingList> createState() => _CollapsingListState();
}

class _CollapsingListState extends ConsumerState<CollapsingList> {
  SliverPersistentHeader makeHeader(JobOpportunity job) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverAppBarDelegate(
        minHeight: 85.0,
        maxHeight: 85.0,
        child: BasicInfoJobTile(
          job: job,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.applications.isEmpty) {
      return Center(
        child: Column(
          children: [
            Text("nema novih studenata"),
            //refresh button
            PrimaryButton(
              onTap: widget.onRefresh,
              text: "Refresh",
            ),
          ],
        ),
      );
    }


    return ListView(
      padding: EdgeInsets.only(bottom: 20),
      children: <Widget>[
        for (var entry in buildEntries()) ...[
          BasicInfoJobTile(
            job: entry.key,
          ),
           for (var applicant in entry.value) ...[
            AdminApplicantListTile(
              applicant: applicant,
              unreadMessageCount: 0,
              jobOpportunity: entry.key,
              onSwipe: (FirmusSwipeType type) {
                ref
                    .read(adminApplicationsViewNotifierProvider.notifier)
                    .swipe(
                      type,
                      entry.key,
                      applicant,
                    );
              },
            ),
          ],SizedBox(height: 12,),

        ]
      ],
    );

    return CustomScrollView(
      slivers: <Widget>[
        for (var entry in buildEntries()) ...[
          makeHeader(entry.key),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return AdminApplicantListTile(
                  applicant: entry.value[index],
                  unreadMessageCount: 0,
                  jobOpportunity: entry.key,
                  onSwipe: (FirmusSwipeType type) {
                    ref
                        .read(adminApplicationsViewNotifierProvider.notifier)
                        .swipe(
                          type,
                          entry.key,
                          entry.value[index],
                        );
                  },
                );
              },
              childCount: entry.value.length,
            ),
          ),
        ]
      ],
    );
  }

  List<MapEntry<JobOpportunity, List<InterestedApplicant>>> buildEntries() {
    final entries =  widget.applications.entries.toList();

    entries.sort((a, b) {
      final al = a.value.length;
      final bl = b.value.length;
      return bl.compareTo(al);
    });

    return entries;
  }
}
