import 'package:firmus/gen/assets.gen.dart';
import 'package:firmus/infra/observables/job_creation_state.dart';
import 'package:firmus/infra/stores/job_creation_notifier.dart';
import 'package:firmus/main.dart';
import 'package:firmus/view/pages/job_op_creation/basic_job_details.dart';
import 'package:firmus/view/pages/job_op_creation/job_skills.dart';
import 'package:firmus/view/pages/job_op_creation/job_video.dart';
import 'package:firmus/view/pages/job_op_creation/other_job_details.dart';
import 'package:firmus/view/pages/job_op_creation/widgets/page_indicator.dart';
import 'package:firmus/view/pages/video_autofill_job_creation_page/video_autofill_job_creation_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class JobOpCreationPage extends ConsumerWidget {
  const JobOpCreationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        resizeToAvoidBottomInset: true,
        body: Theme(
          data: Theme.of(context).copyWith(
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: Theme.of(context).primaryColor,
              selectionColor: Theme.of(context).primaryColor.withOpacity(0.5),
              selectionHandleColor: Theme.of(context).primaryColor,
            ),
          ),
          child: SafeArea(
            top: true,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                            iconSize: 24,
                            onPressed: () {
                              try {
                                ref
                                    .read(
                                        jobOpCreationNotifierProvider.notifier)
                                    .previousPage();
                              } catch (e) {
                                context.pop();
                              }
                            },
                            icon: Assets.images.arrowBack.image(
                              width: 24,
                              color: Theme.of(context).primaryColor,
                            )),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Novi oglas za posao',
                          style: textStyles.f6Regular1200,
                        ),
                      ),
                      //info button
                      if (ref
                              .watch(jobOpCreationNotifierProvider)
                              .currentPage ==
                          JobCreationStatePage.video)
                        Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              iconSize: 24,
                              onPressed: () {
                                const JobOpCreationInfoDialog().show(context);
                              },
                              icon: Icon(Icons.info_outline,
                                  color: Theme.of(context).primaryColor),
                            )),
                    ],
                  ),
                  JobCreationPageIndicator(
                      total: JobCreationStatePage.values.length,
                      current: ref
                              .watch(jobOpCreationNotifierProvider)
                              .currentPage
                              .index +
                          1),
                  const SizedBox(
                    height: 24,
                  ),
                  Expanded(
                      child: _body(ref
                          .watch(jobOpCreationNotifierProvider)
                          .currentPage)),
                ],
              ),
            ),
          ),
        ));
  }

  Widget _body(JobCreationStatePage page) {
    switch (page) {
      case JobCreationStatePage.basicJobDetails:
        return const BasicJobDetails();

      case JobCreationStatePage.skills:
        return const JobSkillPicker();

      case JobCreationStatePage.video:
        return const JobVideo();

      case JobCreationStatePage.otherDetails:
        return const OtherJobDetails();
    }
  }
}
