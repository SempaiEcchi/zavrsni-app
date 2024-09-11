import 'package:fade_and_translate/fade_and_translate.dart';
import 'package:firmus/models/job_offers.dart';
import 'package:firmus/view/pages/employeer_home/widgets/applicant_list_tile.dart';
import 'package:firmus/view/pages/employer_home_swiper/controller/student_swipe_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class StudentsList extends ConsumerWidget {
  final JobOpportunity job;
  const StudentsList(this.job, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(swipableStudentsProvider(job.id)).when(
        skipLoadingOnRefresh: false,
        data: (response) {
          // return ShimmerStudentList();

          return RefreshIndicator.adaptive(
            onRefresh: () async {
              HapticFeedback.lightImpact();
              await ref.refresh(swipableStudentsProvider(job.id).future);
            },
            child: FadeAndTranslate(
                autoStart: true,
                translate: const Offset(0.0, 20.0),
                duration: const Duration(milliseconds: 300),
                child: ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    separatorBuilder: (context, index) => const SizedBox(
                          height: 16,
                        ),
                    itemCount: response.students.length,
                    itemBuilder: (context, index) {
                      return AdminApplicantListTile(
                        applicant: response.students.elementAt(index),
                        unreadMessageCount: 0,
                        jobOpportunity: job,
                      );
                    })),
          );
        },
        error: (err, st) {
          debugPrintStack(stackTrace: st);
          return const Text("Failed");
        },
        loading: () => const Text("Loading"));
  }
}

class ShimmerStudentList extends StatelessWidget {
  const ShimmerStudentList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 16),
        separatorBuilder: (context, index) => const SizedBox(
              height: 16,
            ),
        itemCount: 20,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey.shade300,
            ),
            height: 104,
          )
              .animate(
                onPlay: (c) => c.repeat(reverse: true),
              )
              .blurXY(
                begin: 0.0,
                end: 1,
                duration: const Duration(milliseconds: 2000),
              )
              .shimmer(
                duration: const Duration(milliseconds: 2000),
              );
        });
  }
}
