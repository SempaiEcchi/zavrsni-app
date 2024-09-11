//-------------------//
//VIDEO EDITOR SCREEN//
//-------------------//
import 'dart:io';

import 'package:firmus/gen/assets.gen.dart';
import 'package:firmus/helper/video_export_service.dart';
import 'package:firmus/router/router.dart';
import 'package:flutter/material.dart';
import 'package:firmus/helper/logger.dart';
import 'package:video_editor/video_editor.dart';

class VideoEditorPopup extends StatefulWidget {
  const VideoEditorPopup({super.key, required this.file});

  final File file;

  @override
  State<VideoEditorPopup> createState() => _VideoEditorState();

  Future<File?> show(BuildContext context) {
    return showDialog(
        context: context,
        useSafeArea: false,
        builder: (context) {
          return this;
        });
  }
}

class _VideoEditorState extends State<VideoEditorPopup> {
  final _exportingProgress = ValueNotifier<double>(0.0);
  final _isExporting = ValueNotifier<bool>(false);
  final double height = 60;

  late final VideoEditorController _controller = VideoEditorController.file(
    widget.file,
    minDuration: const Duration(seconds: 1),
    maxDuration: const Duration(seconds: 60),
  );

  @override
  void initState() {
    super.initState();
    _controller.initialize().then((_) => setState(() {})).catchError((error) {
      router.pop();
    }, test: (e) => e is VideoMinDurationError);
  }

  @override
  void dispose() async {
    _exportingProgress.dispose();
    _isExporting.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _showErrorSnackBar(String message) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 1),
        ),
      );

  bool exporting = false;
  void _exportVideo() async {
    setState(() {
      exporting = true;
    });
    _exportingProgress.value = 0;
    _isExporting.value = true;

    final config = VideoFFmpegVideoEditorConfig(
      _controller,
    );

    await ExportService.runFFmpegCommand(
      await config.getExecuteConfig(),
      onProgress: (stats) {
        _exportingProgress.value =
            config.getFFmpegProgress(stats.getTime().toInt());
      },
      onError: (e, s) {
        setState(() {
          exporting = false;
        });
        _showErrorSnackBar("Error on export video :(");
      },
      onCompleted: (file) {
        _isExporting.value = false;
        if (!mounted) return;

        router.pop(file);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: _controller.initialized
            ? SafeArea(
                child: Stack(
                  children: [
                    Column(
                      children: [
                        _topNavBar(),
                        Expanded(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              CropGridViewer.preview(controller: _controller),
                              AnimatedBuilder(
                                animation: _controller.video,
                                builder: (_, __) => AnimatedOpacity(
                                  opacity: _controller.isPlaying ? 0 : 1,
                                  duration: kThemeAnimationDuration,
                                  child: GestureDetector(
                                    onTap: _controller.video.play,
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.play_arrow,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 200,
                          margin: const EdgeInsets.only(top: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: _trimSlider(),
                          ),
                        ),
                        ValueListenableBuilder(
                          valueListenable: _isExporting,
                          builder: (_, bool export, Widget? child) =>
                              AnimatedSize(
                            duration: kThemeAnimationDuration,
                            child: export ? child : null,
                          ),
                          child: AlertDialog(
                            title: ValueListenableBuilder(
                              valueListenable: _exportingProgress,
                              builder: (_, double value, __) => Text(
                                "Exporting video ${(value * 100).ceil()}%",
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    if (exporting)
                      const Align(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator()),
                  ],
                ),
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _topNavBar() {
    return SafeArea(
        child: Row(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
              splashRadius: 0.01,
              iconSize: 30,
              color: Colors.white,
              onPressed: () {
                router.pop();
              },
              icon: Assets.images.arrowBack
                  .image(height: 30, color: Theme.of(context).iconTheme.color)),
        ),
        TextButton(
          onPressed: () {
            router.pop();
          },
          child: Text(
            "Odustani",
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(color: Theme.of(context).iconTheme.color),
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: () {
            _exportVideo();
          },
          child: Text(
            "Spremi",
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(color: Theme.of(context).iconTheme.color),
          ),
        ),
      ],
    ));
  }

  String formatter(Duration duration) => [
        duration.inMinutes.remainder(60).toString().padLeft(2, '0'),
        duration.inSeconds.remainder(60).toString().padLeft(2, '0')
      ].join(":");

  List<Widget> _trimSlider() {
    return [
      AnimatedBuilder(
        animation: Listenable.merge([
          _controller,
          _controller.video,
        ]),
        builder: (_, __) {
          final int duration = _controller.videoDuration.inSeconds;
          final double pos = _controller.trimPosition * duration;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: height / 4),
            child: Row(children: [
              Text(formatter(Duration(seconds: pos.toInt()))),
              const Expanded(child: SizedBox()),
              AnimatedOpacity(
                opacity: _controller.isTrimming ? 1 : 0,
                duration: kThemeAnimationDuration,
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Text(formatter(_controller.startTrim)),
                  const SizedBox(width: 10),
                  Text(formatter(_controller.endTrim)),
                ]),
              ),
            ]),
          );
        },
      ),
      Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(vertical: height / 4),
        child: TrimSlider(
          controller: _controller,
          height: height,
          horizontalMargin: height / 4,
          child: TrimTimeline(
            controller: _controller,
            padding: const EdgeInsets.only(top: 10),
          ),
        ),
      )
    ];
  }

  Widget _coverSelection() {
    return SingleChildScrollView( keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,

      child: Center(
        child: Container(
          margin: const EdgeInsets.all(15),
          child: CoverSelection(
            controller: _controller,
            size: height + 10,
            quantity: 8,
            selectedCoverBuilder: (cover, size) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  cover,
                  Icon(
                    Icons.check_circle,
                    color: const CoverSelectionStyle().selectedBorderColor,
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
