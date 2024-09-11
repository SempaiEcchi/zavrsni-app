import 'package:cached_network_image/cached_network_image.dart';
import 'package:firmus/models/job_offers.dart';
import 'package:firmus/view/admin/pages/admin_home.dart';
import 'package:firmus/view/shared/tiles/jobs/basic_info_job_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../infra/services/job/entity/job_offer_details_response.dart';
import '../../../theme/_light_theme.dart';
import '../../pages/employeer_home/widgets/applicant_list_tile.dart';
import '../../shared/buttons/animated_tap_button.dart';
import '../../shared/buttons/primary_button.dart';

class CollapsingListMatched extends ConsumerStatefulWidget {
  final Map<JobOpportunity, List<MatchedApplicant>> applications;
  final VoidCallback onRefresh;

  CollapsingListMatched(this.applications, this.onRefresh);

  @override
  ConsumerState<CollapsingListMatched> createState() => _CollapsingListState();
}

class _CollapsingListState extends ConsumerState<CollapsingListMatched> {
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
      padding: const EdgeInsets.only(bottom: 20),
      children: [
        for (var entry in widget.applications.entries) ...[
          BasicInfoJobTile(
            job: entry.key,
          ),
          for (MatchedApplicant applicant in entry.value)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: MatchedApplicantListTile(
                      applicant: applicant,
                      unreadMessageCount: 0,
                      jobOpportunity: entry.key,
                    ),
                  ),
                  SizedBox(width: 6,),
                  Column(
                    children: [
                      SmallPrimaryButton(
                        onTap: () async {
                          await ref
                              .read(adminApplicationsViewNotifierProvider
                                  .notifier)
                              .startJob(applicant.matchId);
                        },
                        text: "Zaposli",
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      SmallPrimaryButton(onTap: ()async {
                        await ref
                            .read(adminApplicationsViewNotifierProvider
                            .notifier)
                            .startJob(applicant.matchId);
                      }, text: "Odbij"),
                    ],
                  ),
                ],
              ),
            ),
          SizedBox(
            height: 12,
          ),
        ]
      ],
    );
  }
}

class MatchedApplicantListTile extends StatelessWidget {
  final JobOpportunity jobOpportunity;
  final MatchedApplicant applicant;
  final int unreadMessageCount;

  const MatchedApplicantListTile({
    Key? key,
    required this.applicant,
    required this.jobOpportunity,
    required this.unreadMessageCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final student = applicant.student;

    final location = student.location;
    return AnimatedTapButton(
      onTap: () {
        showAdminStudentDialog(context, applicant, jobOpportunity);
      },
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 70,
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                    color: const Color(0xffF4F6F9),
                    borderRadius: BorderRadius.circular(16)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 16,
                        backgroundImage:
                            CachedNetworkImageProvider(student.imageUrl),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${student.first_name} ${student.last_name}",
                            maxLines: 1,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(height: 0),
                          ),
                          Flexible(
                            child: Row(
                              children: [
                                Text(
                                  student.age.toString(),
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                Transform.translate(
                                  offset: const Offset(0, 1),
                                  child: const Icon(
                                    Icons.location_on,
                                    color: FigmaColors.neutralNeutral4,
                                    size: 16,
                                  ),
                                ),
                                Text(
                                  location,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    if (unreadMessageCount > 0)
                      Container(
                        width: 96,
                        height: 21,
                        decoration: ShapeDecoration(
                          color: const Color(0xFFFEEFEF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Center(
                            child: SizedBox(
                          width: 88,
                          child: Text(
                            '$unreadMessageCount Nova poruka',
                            style: const TextStyle(
                              color: Color(0xFFDA1414),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              height: 0.12,
                            ),
                          ),
                        )),
                      )
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                    ),
                    // width: 121,
                    height: 21,
                    decoration: ShapeDecoration(
                      color: const Color(0x190B9C40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Center(
                        child: SizedBox(
                      child: Text(
                        student.universityText,
                        style: TextStyle(
                          color: Color(0xFF287D3C),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )),
                  ),
                  const Spacer(),
                  const Icon(Icons.arrow_forward_ios,
                      color: FigmaColors.neutralNeutral4, size: 16)
                ],
              )
            ],
          )),
    );
  }
}
