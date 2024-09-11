import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:firmus/helper/logger.dart';
import 'package:firmus/infra/services/job/entity/job_offer_details_response.dart';
import 'package:firmus/infra/services/job/job_service.dart';
import 'package:firmus/infra/stores/registration_store.dart';
import 'package:firmus/models/job_offers.dart';
import 'package:firmus/router/router.dart';
import 'package:firmus/theme/_light_theme.dart';
import 'package:firmus/view/shared/buttons/animated_tap_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/link.dart';

import '../../../shared/popups/cv_video_player_popup.dart';

class AdminApplicantListTile extends StatelessWidget {
  final JobOpportunity jobOpportunity;
  final JobOfferApplicant applicant;
  final int unreadMessageCount;
  final Function(FirmusSwipeType type)? onSwipe;

  const AdminApplicantListTile({
    Key? key,
    required this.applicant,
    required this.jobOpportunity,
    required this.unreadMessageCount,
    this.onSwipe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final student = applicant.student;

    final location = student.location;
    return Dismissible(
      key: ValueKey(applicant),
      onDismissed: (direction) {
        FirmusSwipeType? type;
        switch (direction) {
          case DismissDirection.endToStart:
            type = FirmusSwipeType.dislike;
          case DismissDirection.startToEnd:
            type = FirmusSwipeType.like;
          default:
            break;
        }

        logger.info("Swipe $type");

        if (type != null && onSwipe != null) {
          onSwipe!(type);
        }
      },
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              onSwipe!(FirmusSwipeType.dislike);
            },
            icon: Icon(
              Icons.thumb_down,
              color: FigmaColors.primaryPrimary100,
            ),
          ),
          Expanded(
            child: AnimatedTapButton(
              onTap: () {
                switch (applicant) {
                  case MatchedApplicant matched:
                    GoRouter.of(context)
                        .push(RoutePaths.sendJobRequest, extra: {
                      "matchedApplicant": matched,
                      "jobOpportunity": jobOpportunity,
                    });
                  case InterestedApplicant interested:
                    showAdminStudentDialog(context, interested, jobOpportunity);
                  default:
                    break;
                }
              },
              child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                                backgroundImage: CachedNetworkImageProvider(
                                    student.imageUrl),
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                          if (applicant is MatchedApplicant)
                            buildApplicationSubmitted(
                                applicant as MatchedApplicant),
                          const Spacer(),
                          const Icon(Icons.arrow_forward_ios,
                              color: FigmaColors.neutralNeutral4, size: 16)
                        ],
                      )
                    ],
                  )),
            ),
          ),
          SizedBox(
            width: 24,
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.chat_outlined,
              color: Colors.orange,
            ),
          ),
          SizedBox(
            width: 24,
          ),
          IconButton(
            onPressed: () {
              onSwipe!(FirmusSwipeType.like);
            },
            icon: Icon(
              Icons.thumb_up,
              color: FigmaColors.primaryPrimary100,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildApplicationSubmitted(MatchedApplicant applicant) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
      ),
      margin: const EdgeInsets.only(left: 8),
      // width: 121,
      height: 21,
      decoration: ShapeDecoration(
        color: const Color(0x190B9C40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Center(
          child: SizedBox(
        child: Text(
          'Student završio prijavu',
          style: TextStyle(
            color: Color(0xFF287D3C),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      )),
    );
  }
}

Future<dynamic> showAdminStudentDialog(BuildContext context,
    JobOfferApplicant interested, JobOpportunity jobOpportunity) {
  return showDialog(
      context: context,
      builder: (context) {
        final video = interested.student.videoForJob(jobOpportunity.jobProfile);

        final otherVideos = interested.student.videos
            .where((element) => element.id != video?.id)
            .toList();
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Consumer(
              builder: (context, ref, child) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (video != null)
                      ElevatedButton(
                                                onPressed: (){
                                                  CvVideoPlayerPopup(
                                                    videoUrl: video.videoUrl,
                                                    thumbnailUrl: video.thumbnailUrl,
                                                  ).show(context);
                                                },
                                                child: Text("Pogledaj video"),
                                              )
                    else
                      Container(
                        height: 100,
                        child: CachedNetworkImage(
                          imageUrl: interested.student.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),

                    ...otherVideos.map((vid) {
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: ElevatedButton(
                                                    onPressed: (){
                                                      CvVideoPlayerPopup(
                                                        videoUrl: vid.videoUrl,
                                                        thumbnailUrl: vid.thumbnailUrl,
                                                      ).show(context);

                                                    },
                                                    child: Text(
                                                        "Pogledaj video za ${vid.jobProfiles.map((e) {
                                                      final source =
                        ref.read(jobProfilesProvider).valueOrNull;
                                                      if (source == null) return "";

                                                      return (source
                            .firstWhereOrNull(
                                (element) => element.id == e)
                            ?.name) ??
                        "";
                                                    })}"),
                                                  ),
                      );
                    }),
                    Text(interested.student.formattedBodyText())
                  ],
                );
              },
            ),
          ),
        );
      });
}
