import 'package:cached_network_image/cached_network_image.dart';
import 'package:firmus/gen/assets.gen.dart';
import 'package:firmus/infra/services/job/entity/job_offer_details_response.dart';
import 'package:firmus/main.dart';
import 'package:firmus/models/job_offers.dart';
import 'package:firmus/theme/_light_theme.dart';
import 'package:firmus/view/shared/buttons/primary_button.dart';
import 'package:firmus/view/shared/buttons/text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../student_home/home_page.dart';

class MatchedWithStudentPopup extends StatelessWidget {
  final SimpleStudentProfile student;
  final SimpleCompany company;

  Future<void> show(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return this;
        });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.close, color: Colors.black),
                ),
              ),
            ),
            Text(
              "Match-ani ste sa\n radnikom!",
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge!
                  .copyWith(color: FigmaColors.neutralBlack),
            ),
            const SizedBox(
              height: 24,
            ),
            Expanded(
              child: Stack(
                children: [
                  // some different emojis in text widget
                  Positioned(
                    left: 20,
                    child: Transform.scale(scale: 2, child: const Text("🔥")),
                  ),
                  Positioned.fill(
                    left: 40,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child:
                          Transform.scale(scale: 1.4, child: const Text("👔")),
                    ),
                  ),
                  const Positioned.fill(
                    left: 100,
                    top: 30,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("🤩"),
                    ),
                  ),
                  Positioned.fill(
                    left: 60,
                    bottom: 20,
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Transform.scale(scale: 2, child: const Text("🤩")),
                    ),
                  ),

                  Positioned(
                    right: 20,
                    child: Transform.scale(scale: 2, child: const Text("🔥")),
                  ),
                  Positioned.fill(
                    right: 40,
                    bottom: 40,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child:
                          Transform.scale(scale: 1.4, child: const Text("🤝")),
                    ),
                  ),
                  const Positioned.fill(
                    right: 100,
                    top: 10,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text("🔥"),
                    ),
                  ),
                  Positioned.fill(
                    right: 60,
                    bottom: 40,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Transform.scale(scale: 2, child: const Text("💼")),
                    ),
                  ),

                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      child: Column(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image:
                                    CachedNetworkImageProvider(company.logoUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Assets.images.bolt.image(width: 40),
                          ),
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                    student.imageUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(student.name,
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium!
                        .copyWith(color: FigmaColors.neutralBlack)),
                const SizedBox(
                  width: 8,
                ),
                const Icon(Icons.arrow_forward_ios,
                    color: FigmaColors.neutralNeutral4, size: 14),
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            Text(
              "Radnik sa kojim ste match-ani je upravo zaprimio obavijest. Pošaljite mu zahtjev za zapošljavanjem\n ili ga kontaktirajte.",
              style: textStyles.paragraphBaseRegular
                  .copyWith(color: FigmaColors.neutralNeutral2),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 24,
            ),
            PrimaryButton(
              onTap: () {
                Navigator.of(context).pop();
              },
              text: ("Pošalji zahtjev"),
            ),
            const SizedBox(
              height: 12,
            ),
            FirmusTextButton(onTap: () {}, text: "Kontaktiraj radnika"),
            const SizedBox(
              height: 24,
            ),
          ],
        ),
      ),
    );
  }

  const MatchedWithStudentPopup({
    super.key,
    required this.student,
    required this.company,
  });
}

class MatchedWithCompanyPopup extends StatelessWidget {
  final SimpleStudentProfile student;
  final SimpleCompany company;
  final JobOpportunity jobOpportunity;
  final String matchId;

  const MatchedWithCompanyPopup({
    super.key,
    required this.student,
    required this.company,
    required this.jobOpportunity,
    required this.matchId,
  });

  Future<void> show(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return this;
        });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.close, color: Colors.black),
                ),
              ),
            ),
            Text(
              "Match-ani ste sa\n poslodavcem!",
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge!
                  .copyWith(color: FigmaColors.neutralBlack),
            ),
            const SizedBox(
              height: 24,
            ),
            Expanded(
              child: Stack(
                children: [
                  // some different emojis in text widget
                  Positioned(
                    left: 20,
                    child: Transform.scale(scale: 2, child: const Text("🔥")),
                  ),
                  Positioned.fill(
                    left: 40,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child:
                          Transform.scale(scale: 1.4, child: const Text("👔")),
                    ),
                  ),
                  const Positioned.fill(
                    left: 100,
                    top: 30,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("🤩"),
                    ),
                  ),
                  Positioned.fill(
                    left: 60,
                    bottom: 20,
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Transform.scale(scale: 2, child: const Text("🤩")),
                    ),
                  ),

                  Positioned(
                    right: 20,
                    child: Transform.scale(scale: 2, child: const Text("🔥")),
                  ),
                  Positioned.fill(
                    right: 40,
                    bottom: 40,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child:
                          Transform.scale(scale: 1.4, child: const Text("🤝")),
                    ),
                  ),
                  const Positioned.fill(
                    right: 100,
                    top: 10,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text("🔥"),
                    ),
                  ),
                  Positioned.fill(
                    right: 60,
                    bottom: 40,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Transform.scale(scale: 2, child: const Text("💼")),
                    ),
                  ),

                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      child: Column(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                    student.imageUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Assets.images.bolt.image(width: 40),
                          ),
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image:
                                    CachedNetworkImageProvider(company.logoUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text("${company.name} ${jobOpportunity.jobTitle}",
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(color: FigmaColors.neutralBlack)),
                ),
                const SizedBox(
                  width: 8,
                ),
                const Icon(Icons.arrow_forward_ios,
                    color: FigmaColors.neutralNeutral4, size: 14),
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            Text(
              "Na tebi je sada samo da kontaktiraš poslodavca i dogovoriš početak radnog odnosa. Sretno!",
              style: textStyles.paragraphBaseRegular
                  .copyWith(color: FigmaColors.neutralNeutral2),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 24,
            ),
            Consumer(
              builder: (context, ref, child) {
                return PrimaryButton(
                  onTap: () {
                    ref
                        .read(currentPageProvider.notifier)
                        .changePage(HomePages.chat);
                    Navigator.of(context).pop();

                    // Navigator.of(context).pop();
                    // CompleteApplicationBottomSheet(
                    //   matchId: matchId,
                    //   jobOpportunity: jobOpportunity,
                    // ).show(context);
                  },
                  text: ("Kontaktiraj poslodavca"),
                );
              },
            ),
            const SizedBox(
              height: 12,
            ),
            FirmusTextButton(
                onTap: () {
                  Navigator.of(context).pop();
                },
                text: "Odustani"),
            const SizedBox(
              height: 24,
            ),
          ],
        ),
      ),
    );
  }
}
