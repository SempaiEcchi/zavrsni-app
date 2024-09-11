import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firmus/helper/image_picker.dart';
import 'package:firmus/main.dart';
import 'package:firmus/view/pages/profile/profile_page.dart';
import 'package:firmus/view/pages/registration/page_builders/video_creator.dart';
import 'package:firmus/view/pages/registration/widgets/constrained_body.dart';
import 'package:firmus/view/shared/popups/video_editor_popup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pausable_timer/pausable_timer.dart';

import '../../../gen/assets.gen.dart';

List<CameraDescription>? cameras;

@Deprecated("debug only")
class VideoAutoFillJobCreationPage extends ConsumerStatefulWidget {
  const VideoAutoFillJobCreationPage({Key? key}) : super(key: key);

  @override
  ConsumerState<VideoAutoFillJobCreationPage> createState() =>
      _VideoAutoFillJobCreationPageState();
}

class _VideoAutoFillJobCreationPageState
    extends ConsumerState<VideoAutoFillJobCreationPage> {
  CameraController? controller;

  final formKey = GlobalKey<FormState>();

  late PausableTimer timer;

  @override
  void initState() {
    super.initState();
    Future(() async {
      timer = PausableTimer(const Duration(seconds: 60), () async {
        _stopRecording();
      });
      cameras = await availableCameras();

      controller = CameraController(cameras![0], ResolutionPreset.medium);
      await controller?.initialize();
      setState(() {});
    });
  }

  void _stopRecording() {}

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
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
          child: FormBuilder(
            key: formKey,
            child: SafeArea(
              top: true,
              child: ConstrainedBody(
                center: true,
                child: FormBuilderField<File?>(
                    name: "video",
                    builder: (state) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
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
                                      GoRouter.of(context).pop();
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
                              Align(
                                  alignment: Alignment.centerRight,
                                  child: IconButton(
                                    iconSize: 24,
                                    onPressed: () {
                                      const JobOpCreationInfoDialog()
                                          .show(context);
                                    },
                                    icon: Icon(Icons.info_outline,
                                        color: Theme.of(context).primaryColor),
                                  )),
                            ],
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          Flexible(
                            child: IntrinsicWidth(
                              child: Column(
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(18)),
                                      child: AspectRatio(
                                        aspectRatio: 9 / 16,
                                        child: DottedBorder(
                                          stackFit: StackFit.expand,
                                          padding: const EdgeInsets.all(4),
                                          borderType: BorderType.RRect,
                                          radius: const Radius.circular(20),
                                          color: Colors.black.withOpacity(0.3),
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(18)),
                                            child: FittedBox(
                                              fit: BoxFit.cover,
                                              child: ClipRRect(
                                                child: controller == null ||
                                                        state.value != null
                                                    ? state.value == null
                                                        ? const Text(
                                                            "Unesi video")
                                                        : SizedBox(
                                                            width: 100,
                                                            child:
                                                                MinifiedVideoPlayer(
                                                                    state
                                                                        .value!))
                                                    : SizedBox(
                                                        // color: Colors.black,
                                                        width: controller!
                                                            .value
                                                            .previewSize!
                                                            .height,
                                                        height: controller!
                                                            .value
                                                            .previewSize!
                                                            .width,
                                                        child: CameraPreview(
                                                            controller!),
                                                      ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Imaš već snimljen video?",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall!,
                                        ),
                                        TextButton(
                                            onPressed: () async {
                                              final video =
                                                  await handleVideoPick();
                                              if (video == null) return;
                                              final croppedVideo =
                                                  await VideoEditorPopup(
                                                file: video,
                                              ).show(context);
                                              state.didChange(croppedVideo);
                                            },
                                            child: Text(
                                              "Učitaj video",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineSmall!
                                                  .copyWith(
                                                      color: Theme.of(context)
                                                          .primaryColor),
                                            )),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          if (controller != null)
                            RecordButton(
                              controller: controller!,
                            ),
                          const SizedBox(
                            height: 52,
                          ),
                        ],
                      );
                    }),
              ),
            ),
          ),
        ));
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

class FlipCameraButton extends StatelessWidget {
  final CameraController controller;
  const FlipCameraButton(this.controller, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final currentCamera = controller.description;
        final newCamera = cameras!.firstWhere(
            (element) => element.lensDirection != currentCamera.lensDirection);
        controller.value = controller.value.copyWith(description: newCamera);
        controller.initialize();
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          shape: BoxShape.circle,
        ),
        child: const Center(child: Icon(CupertinoIcons.arrow_2_circlepath)),
      ),
    );
  }
}

class RecordButton extends HookWidget {
  final CameraController controller;
  @override
  Widget build(BuildContext context) {
    var recording = useState(false);
    return GestureDetector(
        onTapDown: (_) async {
          if (recording.value) return stopRecording(recording);
          recording.value = true;

          controller.startVideoRecording();
        },
        onTapUp: (_) async {
          await stopRecording(recording);
        },
        child: Container(
          width: 63,
          height: 63,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            shape: BoxShape.circle,
          ),
          child: Center(
              child: recording.value
                  ? const Text("snimam")
                  : const Icon(CupertinoIcons.videocam_circle)),
        ));
  }

  Future<void> stopRecording(ValueNotifier<bool> recording) async {
    final recordedFile = await controller.stopVideoRecording();

    recording.value = false;
  }

  const RecordButton({
    super.key,
    required this.controller,
  });
}

Future<File> moveFileToTmpDir(File file) async {
  final tmpdirpath = PathHelper.tempPath();

  final tmpdir = Directory(tmpdirpath);

  if (!tmpdir.existsSync()) {
    tmpdir.createSync(recursive: true);
  }
  final filename = file.path.split("/").last;
  final newFile = await file.copy(tmpdirpath + filename);
  await file.delete();
  return (newFile);
}

class JobOpCreationInfoDialog extends StatelessWidget {
  const JobOpCreationInfoDialog({super.key});

  Future<void> show(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (context) => this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Center(child: Text("Kako da napravim dobar video?")),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '''U kratkim crtama opišite poziciju.
Odgovornosti i zadaci posloprimca?
Koji su jezici potrebni za posao?
Lokacija posla?
Plaća? Bonusi ili benefiti?
Datum roka za prijavu?
Datum početka rada?
Datum kraja radnog odnosa, za poslove na određeno vrijeme?
Radno vrijeme? Puno ili nepuno?
Tip posla? Projektni, volonterski, praksa?
Broj zaposlenika koji tražite?
Nudite li smještaj? Opišite uvjete?
Jesu li obroci osigurani?
Nudite li prijevoz zaposlenicima?
Je li posao ograničen na ljetnu sezonu?
Primarni kontakt?
Dodatne informacije koje smatrate bitnima?''',
            textAlign: TextAlign.center,
          )
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text("Zatvori"),
        ),
      ],
    );
  }
}
