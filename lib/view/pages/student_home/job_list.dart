import 'package:cached_network_image/cached_network_image.dart';
import 'package:fade_and_translate/fade_and_translate.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firmus/infra/stores/job_offer_store.dart';
import 'package:firmus/main.dart';
import 'package:firmus/models/job_offers.dart';
import 'package:firmus/theme/_light_theme.dart';
import 'package:firmus/view/pages/employeer_home/company_active_job_list.dart';
import 'package:firmus/view/pages/student_home/single_offer_page.dart';
import 'package:firmus/view/shared/buttons/animated_tap_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../shared/tiles/jobs/basic_info_job_tile.dart';

class JobsList extends ConsumerWidget {
  const JobsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(jobOfferStoreProvider).when(
        skipLoadingOnRefresh: true,
        skipLoadingOnReload: true,
        skipError: true,
        data: (response) {
          return RefreshIndicator.adaptive(
            onRefresh: () async {
              HapticFeedback.lightImpact();
              await ref.refresh(jobOfferStoreProvider.future);
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
                    itemCount: response.response.offers.length,
                    itemBuilder: (context, index) {
                      return BasicInfoJobTile(
                          job: response.response.offers.elementAt(index));
                    })),
          );
        },
        error: (err, st) {
          FirebaseCrashlytics.instance.recordError(err, st, fatal: true);
          debugPrintStack(stackTrace: st);
          return const Text(
              "Učitavanje oglasa nije uspjelo, pokušajte ponovno kasnije.");
        },
        loading: () {
          return const LargeJobsShimmerList(
            height: 85,
          );
        });
  }
}

class JobListTile extends StatelessWidget {
  final JobOpportunity job;
  const JobListTile({Key? key, required this.job}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final style = textStyles.paragraphXSmallHeavy
        .copyWith(color: FigmaColors.neutralNeutral4, height: 0);

    final company = job.company;

    final location =
        job.location.trim().isEmpty ? "Kontaktirajte nas" : job.location;
    return AnimatedTapButton(
      onTap: () => SingleOfferPage(
        job,
        showControls: true,
      ).show(context),
      child: Container(
          height: 110,
          padding: const EdgeInsets.fromLTRB(9, 12, 9, 7),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: "${company.id}${job.id}+company",
                child: Container(
                  height: 65,
                  key: ValueKey(company.id),
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
                              CachedNetworkImageProvider(company.logoUrl),
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
                              job.jobTitle,
                              maxLines: 1,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(height: 0),
                            ),
                            Flexible(
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      company.name,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Transform.translate(
                                    offset: const Offset(0, 2),
                                    child: const Icon(
                                      Icons.location_on,
                                      color: FigmaColors.neutralNeutral4,
                                      size: 16,
                                    ),
                                  ),
                                  Text(
                                    location,
                                    overflow: TextOverflow.ellipsis,
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
                      Container(
                        width: 57,
                        height: 21,
                        decoration: ShapeDecoration(
                          color: const Color(0x190B9C40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            job.rateText,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2D6A6A),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Flexible(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Row(
                  children: [
                    Center(
                        child: Text(
                      "Aktivno još: ${job.daysLeft} dana",
                    )),
                    const Spacer(),
                    const Center(
                        child: Icon(Icons.arrow_forward_ios,
                            size: 12, color: FigmaColors.neutralNeutral4))
                  ],
                ),
              )),
            ],
          )),
    );
  }
}
