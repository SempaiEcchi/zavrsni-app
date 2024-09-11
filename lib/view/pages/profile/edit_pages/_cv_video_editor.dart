import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fade_and_translate/fade_and_translate.dart';
import 'package:firmus/infra/stores/registration_store.dart';
import 'package:firmus/infra/stores/user_notifier.dart';
import 'package:firmus/models/job_offers.dart';
import 'package:firmus/theme/_light_theme.dart';
import 'package:firmus/view/pages/registration/widgets/constrained_body.dart';
import 'package:firmus/view/pages/student_home/widges/job_tag_chip.dart';
import 'package:firmus/view/shared/buttons/animated_tap_button.dart';
import 'package:firmus/view/shared/buttons/firmus_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../main.dart';
import '../../../shared/buttons/primary_button.dart';

class CvVideoEditor extends ConsumerStatefulWidget {
  final bool isNew;
  final thumbnail;
  final File? video;
  final List<int> jobProfiles;
  final String? id;

  const CvVideoEditor({
    super.key,
    required this.isNew,
    required this.thumbnail,
    required this.jobProfiles,
    this.video,
    this.id,
  });

  @override
  ConsumerState<CvVideoEditor> createState() => _CvVideoEditorState();
}

class _CvVideoEditorState extends ConsumerState<CvVideoEditor> {
  final key = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    final jobProfiles = ref.watch(jobProfilesProvider).valueOrNull ?? [];
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: true,
        child: FormBuilder(
          key: key,
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
                          'Detalji',
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
                      if (!widget.isNew)
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 125 + 16,
                              height: 125 + 16,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: FigmaColors.primaryPrimary100
                                      .withOpacity(0.1)),
                            ),
                            Container(
                              width: 125,
                              height: 125,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: _thumbnail(),
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
                          ],
                        ),
                      const SizedBox(
                        height: 24,
                      ),
                      ConstrainedBody(
                        center: false,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Za poslodavce u kojoj kategoriji je namijenjen video",
                              style: textStyles.paragraphSmallHeavy.copyWith(
                                color: FigmaColors.neutralNeutral3,
                              ),
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            FadeAndTranslate(
                              autoStart: true,
                              translate: const Offset(0.0, 20.0),
                              duration: const Duration(milliseconds: 300),
                              child: FormBuilderField<List<int>>(
                                initialValue: widget.jobProfiles,
                                builder: (state) {
                                  bool isSelected(int it) {
                                    return state.value!
                                        .any((element) => element == it);
                                  }

                                  return Wrap(
                                      runSpacing: 10,
                                      spacing: 8,
                                      children: jobProfiles
                                          .map((e) => SelectableJobProfileChip(
                                              inverted: true,
                                              staticTextColor: true,
                                              large: true,
                                              tag: e,
                                              isSelected: isSelected(e.id),
                                              onTap: () {
                                                var newState =
                                                    state.value!.toList();
                                                if (isSelected(e.id)) {
                                                  newState.removeWhere(
                                                      (element) =>
                                                          element == e.id);
                                                } else {
                                                  newState.add(e.id);
                                                }

                                                state.didChange(newState);
                                              }))
                                          .toList());
                                },
                                name: 'jobProfiles',
                              ),
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )),
                const SizedBox(
                  height: 32,
                ),
                PrimaryButton(
                    onTap: () async {
                      key.currentState!.save();
                      final ids =
                          key.currentState!.value['jobProfiles'] as List<int>;
                      if (widget.isNew) {
                        await ref
                            .read(studentNotifierProvider.notifier)
                            .uploadVideo(widget.video!, ids);
                        context.pop();
                      } else {
                        await ref
                            .read(studentNotifierProvider.notifier)
                            .updateVideo(widget.id!, ids);
                        context.pop();
                      }
                    },
                    text: 'Spremi'),
                const SizedBox(
                  height: 16,
                ),
                AnimatedTapButton(
                  onTap: () {
                    Navigator.of(context).pop(false);
                  },
                  child: SizedBox(
                    width: double.infinity,
                    height: 30,
                    child: Center(
                      child: Text(
                        "Odustani",
                        style:
                            Theme.of(context).textTheme.labelMedium!.copyWith(
                                  color: Theme.of(context).disabledColor,
                                ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ImageProvider _thumbnail() {
    return (widget.thumbnail is String
        ? CachedNetworkImageProvider(
            widget.thumbnail as String,
          )
        : FileImage(widget.thumbnail as File)) as ImageProvider;
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
