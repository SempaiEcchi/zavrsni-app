import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:fade_and_translate/fade_and_translate.dart';
import 'package:firmus/helper/image_picker.dart';
import 'package:firmus/helper/logger.dart';
import 'package:firmus/helper/open_settings.dart';
import 'package:firmus/infra/actions/registration_action.dart';
import 'package:firmus/infra/stores/registration_store.dart';
import 'package:firmus/localizations.dart';
import 'package:firmus/models/registration.dart';
import 'package:firmus/view/pages/registration/widgets/constrained_body.dart';
import 'package:firmus/view/pages/registration/widgets/next_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:video_player/video_player.dart';

import '../../../../infra/observables/registration_observable.dart';
import '../../../shared/buttons/primary_button.dart';
import '../../../shared/popups/video_editor_popup.dart';

class RegistrationVideoCreatorPage extends ConsumerStatefulWidget {
  const RegistrationVideoCreatorPage({super.key});

  @override
  ConsumerState<RegistrationVideoCreatorPage> createState() =>
      _CityPickerPageState();
}

class _CityPickerPageState extends ConsumerState<RegistrationVideoCreatorPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  final type = StudentRegistrationPage.video;

  @override
  Widget build(BuildContext context) {
    logger.info(ref.read(registrationOProvider).state[type]);

    final jobProfiles = ref.watch(jobProfilesProvider);
    return FormBuilder(
      key: _formKey,
      initialValue: ref.read(registrationOProvider).state[type] ?? {},
      child: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView( keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,

              child: ConstrainedBody(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 110,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          context.loc.videoCreationTitle,
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          context.loc.videoCreationsubtitle,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(color: Colors.white),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        if (jobProfiles.value != null)
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.45,
                            child: AspectRatio(
                              aspectRatio: 9 / 16,
                              child: FadeAndTranslate(
                                autoStart: true,
                                translate: const Offset(0.0, 20.0),
                                duration: const Duration(milliseconds: 300),
                                child: FormBuilderField<File?>(
                                  initialValue: ref
                                      .read(registrationOProvider)
                                      .state[type]?["video"],
                                  name: 'video',
                                  onChanged: (v) {
                                    setState(() {});
                                  },
                                  builder: (state) {
                                    final child = state.value == null
                                        ? Container(
                                            height: double.infinity,
                                            color:
                                                Colors.white.withOpacity(0.09),
                                            child: const Center(
                                                child: Icon(Icons.camera_alt)),
                                          )
                                        : Center(
                                            child: MinifiedVideoPlayer(
                                                state.value!));
                                    return DottedBorder(
                                        padding: const EdgeInsets.all(2),
                                        borderType: BorderType.RRect,
                                        radius: const Radius.circular(20),
                                        color: Colors.white,
                                        child: GestureDetector(
                                          onTap: () {
                                            handleVideoPick(state);
                                          },
                                          child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(18)),
                                              child: child),
                                        ));
                                  },
                                ),
                              ),
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            context.loc.videoOptional,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(color: Colors.white.withOpacity(0.8)),
                          ),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        NextButton(
                          showSkip: true && !hasVideo(),
                          onTap: () {
                            if (_formKey.currentState!.saveAndValidate()) {
                              RegistrationAction.of(ref).saveStateAndNext(
                                  type, _formKey.currentState!.value);
                            }
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 52,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool hasVideo() {
    try {
      return _formKey.currentState?.value["video"] != null;
    } catch (e) {
      return false;
    }
  }

  handleVideoPick(FormFieldState<File?> state) {
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
      _formKey.currentState?.save();
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

class MinifiedVideoPlayer extends StatefulWidget {
  final File videoFile;

  MinifiedVideoPlayer(this.videoFile) : super(key: ValueKey(videoFile.path));

  @override
  State<MinifiedVideoPlayer> createState() => _MinifiedVideoPlayerState();
}

class _MinifiedVideoPlayerState extends State<MinifiedVideoPlayer> {
  late final VideoPlayerController _controller = VideoPlayerController.file(
      widget.videoFile,
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true))
    ..initialize().then((_) async {
      setState(() {});
      await _controller.setVolume(0);
      await _controller.play();
      await _controller.seekTo(const Duration(milliseconds: 1));
      await _controller.pause();
    });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: VideoPlayer(_controller));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
