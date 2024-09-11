import 'package:cached_network_image/cached_network_image.dart';
import 'package:firmus/models/job_offers.dart';
import 'package:firmus/models/student_job_offers.dart';
import 'package:firmus/view/pages/student_home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../main.dart';
import '../../../theme/_light_theme.dart';
import '../../shared/buttons/animated_tap_button.dart';
import '../../shared/buttons/firmus_back_button.dart';
import '../job_op_edit/markdown_editor/widgets/markdown_auto_preview.dart';
import '../registration/widgets/constrained_body.dart';
import '../student_home/widges/complete_application.dart';

// student's view
class JobStatusPage extends StatelessWidget {
  final AppliedJobOffer appliedJobOffer;

  const JobStatusPage(this.appliedJobOffer, {super.key});

  @override
  Widget build(BuildContext context) {
    final jobOpportunity = appliedJobOffer.opportunity;
    final jobOp = jobOpportunity;
    return Scaffold(
      backgroundColor: Colors.white,
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
                          // const SizedBox(
                          //   height: 12,
                          // ),
                          // isWaitingForResponse
                          //     ? _ZahtjevPoslan(appliedJobOffer.jobApplicationStatus.daysLeftToRespond,
                          //         appliedJobOffer.jobApplicationStatus.daysLeftToRespondPercentage)
                          //     : const _PosaoUTijeku(10),
                          const SizedBox(
                            height: 12,
                          ),
                          _CompanyChatTile(
                              company:
                                  SimpleCompany.fromCompany(jobOp.company)),
                          const SizedBox(
                            height: 24,
                          ),

                          ThreeJobDetails(
                            jobOpportunity: jobOpportunity,
                          ),

                          const SizedBox(
                            height: 24,
                          ),
                          Row(
                            children: [
                              Text("Opis posla", style: textStyles.f5Heavy1200),
                            ],
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          // editable text with toolbar by default
                          const IgnorePointer(
                            ignoring: true,
                            child: MarkdownAutoPreview(
                              showEmojiSelection: false,
                              emojiConvert: true,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}

class _CompanyChatTile extends StatelessWidget {
  final SimpleCompany company;
  const _CompanyChatTile({
    required this.company,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 53,
      key: ValueKey(company.id),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
          color: const Color(0xffF4F6F9),
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                    spreadRadius: 0,
                  )
                ],
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: CachedNetworkImage(
                  imageUrl: company.logoUrl,
                  fit: BoxFit.cover,
                ),
              )),
          const SizedBox(
            width: 8,
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                company.name,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      height: 0,
                    ),
              ),
            ],
          ),
          const Spacer(),
          Consumer(
            builder: (context, ref, child) {
              return AnimatedTapButton(
                onTap: () {
                  ref
                      .read(currentPageProvider.notifier)
                      .changePage(HomePages.chat);
                  GoRouter.of(context).pop();
                },
                child: Row(
                  children: [
                    const Text(
                      "Očekivani odgovor\nunutar sat vremena",
                      style: TextStyle(
                          color: Color(0xFF535D68),
                          fontSize: 9,
                          fontWeight: FontWeight.w300,
                          height: 1.15),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    Container(
                      width: 39,
                      height: 39,
                      decoration: const ShapeDecoration(
                        color: Color(0x191479EC),
                        shape: OvalBorder(),
                      ),
                      child: Icon(
                        Icons.question_answer,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

class _ZahtjevPoslan extends StatelessWidget {
  final int daysLeft;
  final double daysLeftPercentage;
  const _ZahtjevPoslan(this.daysLeft, this.daysLeftPercentage);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 115,
      decoration: ShapeDecoration(
        color: const Color(0xFF09101D),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularPercentIndicator(
            progressColor: Theme.of(context).primaryColor,
            radius: 42,
            lineWidth: 7,
            backgroundColor: Colors.white,
            center: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$daysLeft',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'dana do isteka\nzahtjeva',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFD9DDE2),
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    height: 1.15,
                  ),
                )
              ],
            ),
            percent: daysLeftPercentage,
          ),
          const SizedBox(
            width: 32,
          ),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 21,
                child: Text(
                  'Zahtjev poslan',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(
                height: 4,
              ),
              SizedBox(
                height: 38,
                child: Text(
                  'Čekanje na potvrdu od\nstrane poslodavca',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w300,
                      height: 1.20),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class _PosaoUTijeku extends StatelessWidget {
  final int? daysLeft;

  const _PosaoUTijeku(this.daysLeft);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 115,
      decoration: ShapeDecoration(
        color: const Color(0xFF09101D),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularPercentIndicator(
            progressColor: Theme.of(context).primaryColor,
            radius: 42,
            lineWidth: 7,
            backgroundColor: Colors.white,
            center: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$daysLeft',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'dana do isteka\nposla',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFD9DDE2),
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    height: 1.15,
                  ),
                )
              ],
            ),
            percent: 0.5,
          ),
          const SizedBox(
            width: 32,
          ),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 21,
                child: Text(
                  'Posao u tijeku',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(
                height: 4,
              ),
              SizedBox(
                height: 38,
                child: Text(
                  'Poslovni odnos sa\nposlodavcem je aktivan ',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w300,
                      height: 1.20),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
