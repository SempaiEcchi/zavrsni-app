import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:fade_and_translate/fade_and_translate.dart';
import 'package:firmus/helper/image_picker.dart';
import 'package:firmus/helper/open_settings.dart';
import 'package:firmus/infra/observables/job_creation_state.dart';
import 'package:firmus/infra/stores/job_creation_notifier.dart';
import 'package:firmus/localizations.dart';
import 'package:firmus/view/pages/registration/page_builders/video_creator.dart';
import 'package:firmus/view/pages/registration/registration_image_cropper.dart';
import 'package:firmus/view/pages/registration/widgets/constrained_body.dart';
import 'package:firmus/view/pages/registration/widgets/next_button.dart';
import 'package:firmus/view/shared/buttons/primary_button.dart';
import 'package:firmus/view/shared/popups/video_editor_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class JobVideo extends ConsumerStatefulWidget {
  static const video = "video";
  const JobVideo({super.key});

  @override
  ConsumerState createState() => _JobVideoState();
}

class _JobVideoState extends ConsumerState<JobVideo> {
  final type = JobCreationStatePage.video;

  @override
  Widget build(BuildContext context) {
    final formKey = ref.watch(formKeyProvider)[JobCreationStatePage.video];

    return FormBuilder(
      key: formKey,
      initialValue: initialValue(),
      child: ConstrainedBody(
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Prezentirajte oglas kroz kratki video 🎥",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Text(
                      "Vaš video igra veliku ulogu u selekciji kandidata. Pokušajte biti što kreativniji i originalniji.",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall!),
                  const SizedBox(
                    height: 24,
                  ),
                  Expanded(
                    child: FadeAndTranslate(
                      autoStart: true,
                      translate: const Offset(0.0, 20.0),
                      duration: const Duration(milliseconds: 300),
                      child: FormBuilderField<File?>(
                        onChanged: (value) async {
                          if (value != null) {
                            showLoadingDialog(context);
                            await ref
                                .read(jobOpCreationNotifierProvider.notifier)
                                .uploadVideo(value);
                            context.pop();
                          }
                        },
                        validator: FormBuilderValidators.required(),
                        initialValue: ref
                            .read(jobOpCreationNotifierProvider)
                            .state[type]?["video"],
                        name: 'video',
                        builder: (state) {
                          bool isImage =
                              state.value?.path.contains("jpg") == true;

                          final child = state.value == null
                              ? Container(
                                  height: double.infinity,
                                  color: Colors.black.withOpacity(0.02),
                                  child: const Center(
                                      child: Icon(
                                    Icons.camera_alt,
                                    color: Colors.grey,
                                  )),
                                )
                              : isImage
                                  ? Image.file(state.value!)
                                  : MinifiedVideoPlayer(state.value!);
                          return DottedBorder(
                              padding: const EdgeInsets.all(2),
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(20),
                              color: Colors.black.withOpacity(0.3),
                              child: GestureDetector(
                                onTap: () {
                                  handleVideoPick(state, formKey);
                                },
                                child: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(18)),
                                    child: child),
                              ));
                        },
                      ),
                    ),
                  ),
                  if (formKey.currentState?.fields["video"]?.hasError == true)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        formKey.currentState?.fields["video"]?.errorText ?? "",
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Theme.of(context).colorScheme.error),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(
              height: 52,
            ),
            NextButton(
              invertColors: true,
              onTap: () async {
                // final value = _formKey.currentState?.fields["video"]?.value;
                // if (value != null) {
                //   showLoadingDialog(context);
                //   await ref.read(jobOpCreationNotifierProvider.notifier).uploadVideo(value);
                //   context.pop();
                // }
                // return;

                bool valid = formKey.currentState!.saveAndValidate();
                setState(() {});

                if (valid) {
                  ref.read(jobOpCreationNotifierProvider.notifier).nextPage(
                        formKey.currentState!.value,
                      );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  initialValue() {
    return ref.read(jobOpCreationNotifierProvider).state[type];
  }

  handleVideoPick(FormFieldState<File?> state, formKey) {
    pickVideo().then((value) async {
      if (value == null) return;

      final previous = state.value;
      if (previous != null) {
        previous.delete();
      }

      final croppedVideo = await VideoEditorPopup(
        file: File(value.path),
      ).show(context);

      state.didChange(croppedVideo);
      formKey.currentState?.save();
      state.save();
      return;
      // final edited = await VideoEditorPopup().show(context);
      // state.didChange(edited);
    }).catchError((er) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Theme.of(context).canvasColor,
          content: Row(
            children: [
              Text(
                "Dozvolite pristup galeriji u postavkama.",
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              const Spacer(),
              SmallPrimaryButton(
                  onTap: () {
                    openSettings();
                  },
                  text: context.loc.openSettings)
            ],
          )));
    });
  }
}
