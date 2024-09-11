import 'package:cached_network_image/cached_network_image.dart';
import 'package:firmus/models/entity/cv_video.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firmus/helper/logger.dart';
import 'package:video_player/video_player.dart';

class CvVideoPlayerPopup extends StatefulWidget {
  final String videoUrl;
  final String? thumbnailUrl;

  const CvVideoPlayerPopup({
    super.key,
    required this.videoUrl,
    this.thumbnailUrl,
  });

  @override
  State<CvVideoPlayerPopup> createState() => _CvVideoPlayerPopupState();

  Future show(BuildContext context) {
    return showDialog(

      context: context,
      useSafeArea: false,
      builder: (context) {
        if(kIsWeb){
          return Center(child: ConstrainedBox(constraints: BoxConstraints(maxWidth: 450),child: this,));
        }

        return this;
      },
    );
  }
}

class _CvVideoPlayerPopupState extends State<CvVideoPlayerPopup> {
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) async {
        await _controller.setLooping(true);
          _controller.play();
        setState(() {
          loading = false;
        });
        Future.delayed(const Duration(milliseconds: 300),
            () => setState(() => hideLoader = true));
      });
  }

  bool loading = true;
  bool hideLoader = false;
  late VideoPlayerController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: Opacity(
                // duration: const Duration(milliseconds: 300),
                opacity: loading ? 0 : 1,
                child: _VideoPlayerStoryControls(
                  controller: _controller,
                  player: SizedBox(
                    width: _controller.value.size.width ?? 0,
                    height: _controller.value.size.height ?? 0,
                    child: VideoPlayer(_controller),
                  ),
                ),
              ),
            ),
          ),
          IgnorePointer(
            ignoring: true,
            child: SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: !hideLoader ? 1 : 0,
                  child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: widget.thumbnailUrl == null
                          ? null
                          : CachedNetworkImage(imageUrl: widget.thumbnailUrl!)),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton(
                  mini: true,
                  backgroundColor: Colors.white,
                  onPressed: Navigator.of(context).pop,
                  child: const Icon(
                    Icons.close,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }
}

class _VideoPlayerStoryControls extends StatelessWidget {
  final VideoPlayerController controller;
  final Widget player;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.deferToChild,
        onLongPressDown: (_) {
          controller.pause();
        },
        onLongPressCancel: () {
          controller.play();
        },
        onLongPressEnd: (_) {
          controller.play();
        },
        onTap: () {
          controller.setVolume(controller.value.volume == 0 ? 1 : 0);
        },
        child: player);
  }

  const _VideoPlayerStoryControls({
    required this.controller,
    required this.player,
  });
}
