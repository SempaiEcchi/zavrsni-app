import 'package:cached_network_image/cached_network_image.dart';
import 'package:firmus/models/job_offers.dart';
import 'package:firmus/view/pages/job_op_edit/markdown_editor/widgets/markdown_auto_preview.dart';
import 'package:firmus/view/pages/job_op_edit/widgets/basic_info_bottom_sheet.dart';
import 'package:firmus/view/pages/registration/widgets/constrained_body.dart';
import 'package:firmus/view/shared/buttons/animated_tap_button.dart';
import 'package:firmus/view/shared/buttons/firmus_back_button.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';
import '../../../theme/_light_theme.dart';

class JobOpEdit extends StatefulWidget {
  final JobOpportunity jobOpportunity;

  const JobOpEdit({
    super.key,
    required this.jobOpportunity,
  });
  @override
  State<JobOpEdit> createState() => _JobOpEditState();
}

class _JobOpEditState extends State<JobOpEdit> {
  late TextEditingController controller = TextEditingController(text: text);

  late String text = widget.jobOpportunity.jobDescription;
  @override
  Widget build(BuildContext context) {
    final jobOp = widget.jobOpportunity;
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
                        'Detalji oglasa',
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
                      height: 24,
                    ),
                    Container(
                      width: 125,
                      height: 125,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(
                            jobOp.company.logoUrl,
                          ),
                        ),
                      ),
                      child: Center(
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.play_circle,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    ConstrainedBody(
                      center: false,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AnimatedTapButton(
                            onTap: () {
                              BasicJobInfoEditSheet(
                                jobOpportunity: jobOp,
                              ).show(context);
                            },
                            child: Row(
                              children: [
                                Text(jobOp.jobTitle,
                                    style: textStyles.f5Heavy1200),
                                const _EditPen(),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          buildLocationAndRate(jobOp, context),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              Transform.translate(
                                offset: const Offset(0, 1),
                                child: Icon(
                                  Icons.calendar_month,
                                  color: jobOp.applicationDeadlineColor ??
                                      FigmaColors.neutralNeutral4,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(
                                jobOp.formattedApllicationDeadline,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: jobOp.applicationDeadlineColor,
                                    ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              if (jobOp.daysLeft == 0)
                                const Text("Oglas je istekao")
                              else
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: 'Aktivno još: ',
                                        style: TextStyle(
                                          color: Color(0xFF6C7580),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      TextSpan(
                                        text: jobOp.daysLeft == 1
                                            ? '1 dan'
                                            : '${jobOp.daysLeft} dana',
                                        style: const TextStyle(
                                          color: Color(0xFF6C7580),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(),
                                )
                            ],
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          Row(
                            children: [
                              Text("Opis posla", style: textStyles.f5Heavy1200),
                              const _EditPen(),
                            ],
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          // editable text with toolbar by default
                          MarkdownAutoPreview(
                            showEmojiSelection: false,
                            onChanged: (val) {
                              text = val;
                            },
                            controller: controller,
                            emojiConvert: true,
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

Row buildLocationAndRate(JobOpportunity jobOp, BuildContext context) {
  return Row(
    children: [
      if (jobOp.location.isNotEmpty) ...[
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
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(),
        ),
        const SizedBox(
          width: 8,
        ),
      ],
      Transform.translate(
        offset: const Offset(0, 1),
        child: const Icon(
          Icons.euro,
          color: FigmaColors.neutralNeutral4,
          size: 18,
        ),
      ),
      const SizedBox(
        width: 4,
      ),
      Text(
        jobOp.rateText,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: FigmaColors.neutralNeutral1, fontWeight: FontWeight.bold),
      ),
    ],
  );
}

class _EditPen extends StatelessWidget {
  const _EditPen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: Icon(
          Icons.edit,
          color: Theme.of(context).primaryColor,
          size: 22,
        ));
  }
}
