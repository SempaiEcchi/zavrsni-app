import 'dart:async';
import 'dart:io';

import 'package:crop_your_image/crop_your_image.dart';
import 'package:custom_image_crop/custom_image_crop.dart';
import 'package:fade_and_translate/fade_and_translate.dart';
import 'package:firmus/helper/image_picker.dart';
import 'package:firmus/helper/logger.dart';
import 'package:firmus/view/pages/registration/widgets/constrained_body.dart';
import 'package:firmus/view/pages/registration/widgets/next_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../gen/assets.gen.dart';

class RegistrationImageCropperPage extends StatefulWidget {
  final File uncroppedImage;

  Future<File> startCrop(BuildContext context) async {
    final obj = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => this));
    return obj as File;
  }

  @override
  State<RegistrationImageCropperPage> createState() =>
      _RegistrationImageCropperPageState();

  const RegistrationImageCropperPage({
    super.key,
    required this.uncroppedImage,
  });
}

class _RegistrationImageCropperPageState
    extends State<RegistrationImageCropperPage> {
  late CustomImageCropController controller = CustomImageCropController();
  final _controller = CropController();

  @override
  void initState() {
    final bytes = widget.uncroppedImage.readAsBytesSync();
      FlutterImageCompress.compressWithList(
      bytes,
      quality: 50,
    ).then((value) {
      logger.info("compressed image size: ${value.size}");
      setState(() {
        imageData = value;
      });
    });




    super.initState();
  }

  Uint8List? imageData;

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  late ImageProvider image = FileImage(widget.uncroppedImage);
  Completer<File> completer = Completer();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        top: true,
        child: ConstrainedBody(
          child: Stack(
            children: [
              buildAppBar(context),
              Column(
                children: [
                  const SizedBox(
                    height: 120,
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: AnimatedSwitcher(
                        transitionBuilder: (child, animation) => FadeTransition(
                          opacity: animation,
                          child: child,
                        ),
                        duration: const Duration(milliseconds: 300),
                        child: Stack(
                          children: [
                            SizedBox(
                                width: double.infinity,
                                height: double.infinity,
                                child: Image.file(widget.uncroppedImage,
                                    fit: BoxFit.cover)),
                            if (imageData != null)
                              Crop(
                                      interactive: true,
                                      initialSize: 0.8,
                                      withCircleUi: true,
                                      image: imageData!,
                                      controller: _controller,
                                      onCropped: (image) async {
                                        logger.info(
                                            "  image size: ${image.size}");

                                        var result = await FlutterImageCompress
                                            .compressWithList(
                                          image,
                                          quality: 50,
                                        );
                                        logger.info(
                                            "compressed image size: ${result.size}");
                                        final tmpFile =
                                            await PathHelper.createTmp(
                                                result, "png");
                                        completer.complete(tmpFile);
                                      }) ??
                                  CustomImageCrop(
                                    overlayColor: Colors.transparent,
                                    backgroundColor:
                                        Colors.white.withOpacity(0.3),
                                    cropController: controller,
                                    image: image,
                                    cropPercentage: 0.8,
                                    shape: CustomCropShape.Circle,
                                    canRotate: false,
                                    canMove: true,
                                    canScale: true,
                                    customProgressIndicator:
                                        const CupertinoActivityIndicator(),
                                  ),
                            IgnorePointer(
                              ignoring: true,
                              child: AnimatedOpacity(
                                opacity: imageData == null ? 1 : 0,
                                duration: const Duration(milliseconds: 300),
                                child: SizedBox(
                                    width: double.infinity,
                                    height: double.infinity,
                                    child: Image.file(widget.uncroppedImage,
                                        fit: BoxFit.cover)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Consumer(
                    builder:
                        (BuildContext context, WidgetRef ref, Widget? child) {
                      return NextButton(onTap: () async {
                        await Future.delayed(const Duration(milliseconds: 300));
                        _controller.cropCircle();
                        GoRouter.of(context).pop(await completer.future);

                        // return;
                        // final image = await controller.onCropImage();
                        // logger.info("  image size: ${image!.bytes.size}");
                        //
                        // var result = await FlutterImageCompress.compressWithList(
                        //   image.bytes,
                        //   quality: 50,
                        // );
                        // logger.info("compressed image size: ${result.size}");
                        //
                        // GoRouter.of(context).pop(result);
                      });
                    },
                  ),
                  const SizedBox(
                    height: 52,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Positioned buildAppBar(BuildContext context) {
    return Positioned(
      top: 0,
      child: SizedBox(
        height: 40,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
                splashRadius: 0.01,
                iconSize: 30,
                color: Colors.white,
                onPressed: () {
                  GoRouter.of(context).pop();
                },
                icon: Assets.images.arrowBack.image(
                    height: 30, color: Theme.of(context).iconTheme.color)),
            FadeAndTranslate(
              autoStart: true,
              translate: const Offset(10.0, 0.0),
              duration: const Duration(milliseconds: 300),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  "Odustani",
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

extension FileSize on Uint8List {
  String get size {
    final kb = length / 1024;
    if (kb < 1024) {
      return "${kb.toStringAsFixed(2)} KB";
    } else {
      final mb = kb / 1024;
      return "${mb.toStringAsFixed(2)} MB";
    }
  }
}

void showLoadingDialog(BuildContext context, [bool white = false]) {
  showDialog(
    context: context,
    barrierColor: Colors.transparent,
    barrierDismissible: kDebugMode,
    builder: (BuildContext context) {
      return Center(
        child: CircularProgressIndicator(
          color: white ? Colors.white : null,
        ),
      );
    },
  );
}

extension R on GoRouter {
  void popPop() {
    pop();
    pop();
  }
}
