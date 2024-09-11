import 'package:firmus/helper/date_time_ext.dart';
import 'package:firmus/infra/services/job/entity/job_offer_details_response.dart';
import 'package:firmus/models/job_offers.dart';
import 'package:firmus/models/student_experience.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../infra/stores/employer_match_status_controller.dart';
import '../../../main.dart';
import '../../../theme/_light_theme.dart';
import '../../shared/buttons/firmus_back_button.dart';
import '../registration/widgets/constrained_body.dart';
import '../student_home/widges/complete_application.dart';

class SendJobRequestPage extends HookConsumerWidget {
  final MatchedApplicant matchedApplicant;
  final JobOpportunity jobOp;

  const SendJobRequestPage(
      {Key? key, required this.matchedApplicant, required this.jobOp})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      Future(() {
        ref
            .read(employerMatchStatusProvider.notifier)
            .setMatchedStudent(this.matchedApplicant);
      });
      return null;
    }, []);

    final matchedApplicant =
        ref.watch(employerMatchStatusProvider) ?? this.matchedApplicant;

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: buildButton(matchedApplicant, ref),
      body: SafeArea(
        top: true,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: FirmusBackButton(),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Pregled poslovne prilike',
                        style: textStyles.f6Regular1200,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: SingleChildScrollView( keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,

                child: Column(
                  children: [
                    const SizedBox(
                      height: 12,
                    ),
                    ConstrainedBody(
                      center: false,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(jobOp.jobTitle, style: textStyles.f5Heavy1200),
                          const SizedBox(
                            height: 12,
                          ),
                          if (jobOp.location.isNotEmpty) ...[
                            Row(
                              children: [
                                Transform.translate(
                                  offset: const Offset(0, 1),
                                  child: const Icon(
                                    Icons.location_on,
                                    color: FigmaColors.neutralNeutral4,
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  jobOp.location,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                          ],
                          const SizedBox(
                            height: 12,
                          ),
                          ThreeJobDetails(
                            jobOpportunity: jobOp,
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          Text(
                              "${matchedApplicant.student.name}, ${matchedApplicant.student.age}",
                              style: textStyles.f5Heavy1200),
                          const SizedBox(
                            height: 24,
                          ),
                          if (matchedApplicant.student.location.isNotEmpty) ...[
                            Row(
                              children: [
                                Transform.translate(
                                  offset: const Offset(0, 1),
                                  child: const Icon(
                                    Icons.location_on,
                                    color: FigmaColors.neutralNeutral4,
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  matchedApplicant.student.location,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                          ],
                          Text(
                            matchedApplicant.student.bio,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(),
                          ),
                          JobCVList(
                            cv: matchedApplicant.student.experiences.isNotEmpty
                                ? []
                                : [
                                    StudentExperienceEntity(
                                      id: "1",
                                      acquiredSkills: [
                                        "Konobarejne",
                                      ],
                                      jobTitle: "Konobar",
                                      companyName: "Pietas",
                                      description: "Party",
                                      start: DateTime.now(),
                                      end: DateTime.now(),
                                    )
                                  ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 120,
                    ),
                  ],
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButton(MatchedApplicant matchedApplicant, WidgetRef ref) {
    return const Text("missing stuff");
  }
}

class JobCVList extends StatelessWidget {
  final List<StudentExperienceEntity> cv;

  const JobCVList({
    super.key,
    required this.cv,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          child: Text(
            'Povijest poslova(cv)',
            style: TextStyle(
              color: Color(0xFF2B394B),
              fontSize: 18,
              fontFamily: 'SourceSansPro',
              fontWeight: FontWeight.w600,
              height: 0.06,
            ),
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 16),
          separatorBuilder: (context, index) => const SizedBox(
            height: 14,
          ),
          itemCount: cv.length,
          itemBuilder: (context, index) {
            return _JobExperienceTile(experience: cv.elementAt(index));
          },
        ),
      ],
    );
  }
}

class _JobExperienceTile extends StatelessWidget {
  final StudentExperienceEntity experience;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 106,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFD9DDE2)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                experience.jobTitle,
                style: const TextStyle(
                  color: Color(0xFF2B394B),
                  fontSize: 18,
                  fontFamily: 'SourceSansPro',
                  fontWeight: FontWeight.w600,
                  height: 0.06,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 2,
                height: 17,
                decoration: const BoxDecoration(color: Color(0xFF2B394B)),
              ),
              const SizedBox(width: 10),
              Text(
                experience.companyName,
                style: const TextStyle(
                  color: Color(0xFF2B394B),
                  fontSize: 18,
                  fontFamily: 'SourceSansPro',
                  fontWeight: FontWeight.w600,
                  height: 0.06,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 3,
          ),
          SizedBox(
            child: Opacity(
              opacity: 0.90,
              child: Text(
                "${experience.start?.formatCroatianDate() ?? ""} - ${experience.end?.formatCroatianDate() ?? ""}",
                style: const TextStyle(
                  color: Color(0xFF535D68),
                  fontSize: 13,
                  fontFamily: 'SourceSansPro',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          //skills
          Flexible(
            child: ListView.separated(
              itemCount: experience.acquiredSkills.length,
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 0),
              separatorBuilder: (context, index) => const SizedBox(
                width: 8,
              ),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return _SkillChip(
                    skill: experience.acquiredSkills.elementAt(index));
              },
            ),
          )
        ],
      ),
    );
  }

  const _JobExperienceTile({
    required this.experience,
  });
}

class _SkillChip extends StatelessWidget {
  final String skill;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: const Color(0xFFEEF2FA),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Center(
        child: Text(
          skill,
          style: const TextStyle(
            color: Color(0xFF2E5AAC),
            fontSize: 13,
            fontFamily: 'SourceSansPro',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  const _SkillChip({
    required this.skill,
  });
}
