import 'package:cached_network_image/cached_network_image.dart';
import 'package:fade_and_translate/fade_and_translate.dart';
import 'package:firmus/infra/services/analytics/analytics_service.dart';
import 'package:firmus/localizations.dart';
import 'package:firmus/main.dart';
import 'package:firmus/models/job_offers.dart';
import 'package:firmus/view/pages/company/company_offers.dart';
import 'package:firmus/view/pages/student_home/single_offer_page.dart';
import 'package:firmus/view/shared/buttons/animated_tap_button.dart';
import 'package:firmus/view/shared/buttons/firmus_back_button.dart';
import 'package:firmus/view/shared/lists/tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../theme/_light_theme.dart';

class CompanyDetailsPage extends ConsumerStatefulWidget {
  final SimpleCompany company;

  const CompanyDetailsPage({Key? key, required this.company}) : super(key: key);

  @override
  ConsumerState<CompanyDetailsPage> createState() => _CompanyDetailsPageState();
}

class _CompanyDetailsPageState extends ConsumerState<CompanyDetailsPage> {
  @override
  void initState() {
    super.initState();
    Future(() {
      ref.a.setPage("company_details");
      ref.a.logEvent(name: AnalyticsEvent.view_company_details, parameters: {
        "company_id": widget.company.id,
        "company_name": widget.company.name,
      });
    });
  }

  get company => widget.company;

  @override
  Widget build(BuildContext context) {
    final style = textStyles.paragraphXSmallHeavy
        .copyWith(color: FigmaColors.neutralNeutral4, height: 0);

    var jobs = ref.watch(companyOffersProvider(widget.company.id)).valueOrNull;
    return Scaffold(
        body: SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Container(
              height: 100,
              key: ValueKey(company.id),
              padding: const EdgeInsets.only(
                  left: 8, right: 16, top: 16, bottom: 16),
              decoration: BoxDecoration(
                  color: const Color(0xFFF4F6F9),
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const FirmusBackButton(
                    color: FigmaColors.neutralNeutral4,
                  ),
                  CircleAvatar(
                    radius: 24,
                    backgroundImage:
                        CachedNetworkImageProvider(company.logoUrl),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          company.name,
                          maxLines: 1,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(height: 0),
                        ),
                        Text(
                          context.loc
                              .companyOpenPositions(company.openPositions),
                          style: style,
                        ),
                      ],
                    ),
                  ),
                  if (company.isGreen)
                    const Icon(
                      Icons.energy_savings_leaf_rounded,
                      color: Colors.green,
                    ),
                  const SizedBox(
                    width: 12,
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        )
                      ],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.star,
                          color: Color(0xffEC8714),
                        ),
                        Text(company.rating.toStringAsFixed(1),
                            style: textStyles.paragraphTinyHeavy
                                .copyWith(color: FigmaColors.neutralNeutral2)),
                      ],
                    ),
                  )
                ],
              ),
            ),
            RoundedTabBar(tabs: ["Detalji", "Osvrti"]),
            if (jobs != null)
              Expanded(
                child: FadeAndTranslate(
                  autoStart: true,
                  translate: const Offset(0.0, 20.0),
                  duration: const Duration(milliseconds: 300),
                  child: TabBarView(
                    children: [
                      ListView.separated(
                          shrinkWrap: true,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 16),
                          itemCount: jobs.length,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          itemBuilder: (context, index) {
                            final job = jobs[index];
                            return LargeJobListTile(
                              job: job,
                            ).animate();
                          }),
                      SizedBox(),
                    ],
                  ),
                ),
              ),
            if (jobs == null)
              const Flexible(child: Center(child: CircularProgressIndicator())),
          ],
        ),
      ),
    ));
  }
}

class LargeJobListTile extends StatelessWidget {
  final JobOpportunity job;

  @override
  Widget build(BuildContext context) {
    final style = textStyles.paragraphXSmallHeavy
        .copyWith(color: FigmaColors.neutralNeutral4, height: 0);

    final company = job.company;

    final location = job.location.isEmpty ? "Kontaktirajte nas" : job.location;
    return AnimatedTapButton(
      onTap: () => SingleOfferPage(
        job,
        showControls: true,
      ).show(context),
      child: Container(
          height: 130,
          padding: const EdgeInsets.fromLTRB(9, 12, 9, 7),
          decoration: BoxDecoration(
            border:
                Border.all(color: FigmaColors.neutralNeutral4.withOpacity(0.1)),
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                job.jobTitle,
                maxLines: 1,
                style:
                    Theme.of(context).textTheme.titleLarge!.copyWith(height: 0),
              ),
              const SizedBox(
                height: 4,
              ),
              Container(
                // height: 65,
                key: ValueKey(company.id),
                padding: const EdgeInsets.symmetric(vertical: 13),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Lokacija: $location",
                    ),
                    const Expanded(
                      child: SizedBox(
                        width: 12,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
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
              Flexible(
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
              )),
            ],
          )),
    );
  }

  const LargeJobListTile({
    super.key,
    required this.job,
  });
}
