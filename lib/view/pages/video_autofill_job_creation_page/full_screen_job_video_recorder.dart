import 'dart:async';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:firmus/helper/logger.dart';
import 'package:firmus/infra/stores/job_creation_video_hints.dart';
import 'package:firmus/view/pages/registration/widgets/constrained_body.dart';
import 'package:firmus/view/pages/video_autofill_job_creation_page/video_autofill_job_creation_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pausable_timer/pausable_timer.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../gen/assets.gen.dart';

class FullScreenJobVideoRecorder extends ConsumerStatefulWidget {
  const FullScreenJobVideoRecorder({Key? key}) : super(key: key);

  @override
  ConsumerState<FullScreenJobVideoRecorder> createState() =>
      _FullScreenJobVideoRecorderState();
}

class _FullScreenJobVideoRecorderState
    extends ConsumerState<FullScreenJobVideoRecorder> {
  CameraController? controller;
  late PausableTimer timer;
  Timer? _ticker;

  final formKey = GlobalKey<FormState>();

  XFile? recordingFile;
  bool _isRecording = false;
  bool isPaused = false;
  bool get isRecording => _isRecording;

  set isRecording(bool value) {
    setState(() {
      _isRecording = value;
    });
  }

  @override
  void initState() {
    super.initState();
    timer = PausableTimer(const Duration(seconds: 60), () async {
      _stopRecording();
    });
    timer.pause();
    Future(() async {
      cameras = await availableCameras();

      controller = CameraController(
          cameras!.firstWhere(
              (element) => element.lensDirection == CameraLensDirection.front),
          ResolutionPreset.high);
      await controller?.initialize();
      setState(() {});
    });
  }

  void _startRecording() async {
    isRecording = true;
    isPaused = false;
    logger.info("start recording");
    await controller!.startVideoRecording();
    _startTicking();
    timer.start();
  }

  void _pauseRecording() {
    isPaused = true;
    isRecording = false;
    controller!.pauseVideoRecording();
    _stopTicking();
    timer.pause();
  }

  void _stopRecording() async {
    isPaused = false;
    isRecording = false;
    _stopTicking();
    timer.pause();
    recordingFile = await controller!.stopVideoRecording();
  }

  void _resumeRecording() {
    isPaused = false;
    isRecording = true;
    controller!.resumeVideoRecording();
    _startTicking();
    timer.start();
  }

  void _reset() {
    controller?.stopVideoRecording();
    isPaused = false;
    isRecording = false;
    _stopTicking();
    recordingFile = null;
    timer.cancel();

    timer = PausableTimer(const Duration(seconds: 60), () async {
      _stopRecording();
    });
    timer.pause();

    setState(() {});
  }

  void _startTicking() {
    _ticker = Timer.periodic(const Duration(milliseconds: 1), (timer) {
      setState(() {});
    });
  }

  void _stopTicking() {
    _ticker?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: FittedBox(
              fit: BoxFit.cover,
              child: controller == null
                  ? const SizedBox()
                  : ClipRRect(
                      child: SizedBox(
                        // color: Colors.black,
                        width: controller!.value.previewSize!.height,
                        height: controller!.value.previewSize!.width,
                        child: CameraPreview(controller!),
                      ),
                    ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
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
          ),
          SafeArea(
            child: ConstrainedBody(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        AnimatedOpacity(
                          opacity: isRecording ? 0 : 1,
                          duration: const Duration(milliseconds: 300),
                          child: Text(
                            "Opišite oglas za posao unutar jedne\nminute s naglaskom na sljedeće detalje:",
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.5),
                                blurRadius: 2,
                                offset: const Offset(0, 2),
                              )
                            ]),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(
                          height: 29,
                        ),
                        Wrap(
                          runAlignment: WrapAlignment.center,
                          alignment: WrapAlignment.center,
                          spacing: 6,
                          runSpacing: 6,
                          children: ref
                                  .watch(jobCreationVideoHintsTags)
                                  .valueOrNull
                                  ?.map((e) => _VideoHintChip(e))
                                  .toList() ??
                              [],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (isRecording) {
                              _pauseRecording();
                            } else {
                              if (isPaused) {
                                _resumeRecording();
                              } else {
                                _startRecording();
                              }
                            }
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              CircularPercentIndicator(
                                radius: 75 / 2,
                                lineWidth: 4,
                                backgroundColor:
                                    const Color(0xffCC3838).withOpacity(0.5),
                                percent: min(
                                    timer.elapsed.inMilliseconds / 60000, 1),
                                progressColor: Colors.white,
                              ),
                              // Container(
                              //   width: 75,
                              //   height: 75,
                              //   decoration: BoxDecoration(
                              //     color: Colors.transparent,
                              //     border: Border.fromBorderSide(
                              //         BorderSide(color: Color(0xffCC3838).withOpacity(0.5), width: 4)),
                              //     shape: BoxShape.circle,
                              //   ),
                              // ),
                              Container(
                                width: 63,
                                height: 63,
                                decoration: const BoxDecoration(
                                  color: Color(0xffCC3838),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                    child: Icon(isRecording
                                        ? Icons.pause
                                        : Icons.videocam)),
                              ),
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: InkWell(
                                  onTap: () {
                                    _reset();
                                  },
                                  child: Container(
                                    width: 63,
                                    height: 63,
                                    decoration: const BoxDecoration(
                                      // color: Color(0xffCC3838),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Center(
                                        child: Icon(Icons.refresh)),
                                  ),
                                ),
                              ),
                              if (isPaused || isRecording)
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: InkWell(
                                    onTap: () {},
                                    child: Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Center(
                                          child: Icon(Icons.arrow_forward)),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    timer.cancel();
    _ticker?.cancel();
    super.dispose();
  }
}

class VideoRecordingState extends Equatable {
  final bool isRecording;
  final int secondsLeft;

  const VideoRecordingState({
    required this.isRecording,
    required this.secondsLeft,
  });

  @override
  List<Object?> get props => [
        isRecording,
        secondsLeft,
      ];
}

class VideoRecordController extends Notifier<VideoRecordingState> {
  @override
  VideoRecordingState build() {
    return const VideoRecordingState(isRecording: false, secondsLeft: 60);
  }
}

class _VideoHintChip extends StatelessWidget {
  final String text;

  const _VideoHintChip(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: ShapeDecoration(
          color: Colors.black.withOpacity(0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          )),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall!.copyWith(
          shadows: [
            Shadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 2,
              offset: const Offset(0, 2),
            )
          ],
        ),
      ),
    );
  }
}
