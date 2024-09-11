import 'dart:io';

import 'package:firmus/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

final ImagePicker picker = ImagePicker();

Future<XFile?> pickImage() async {
  final XFile? image =
      await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
  if (image == null) return null;
  await precacheImage(FileImage(File(image.path)), navkey.currentContext!);
  return image;
}

Future<XFile?> pickVideo() async {
  final XFile? image = await picker.pickVideo(
    source: ImageSource.gallery,
  );

  return image;
}

class PathHelper {
  static late String documentsPath;
  static late String tmpPath;

  static Future init() async {
    if (kIsWeb) return;
    tmpPath = (await getApplicationCacheDirectory()).path;
    documentsPath = (await getApplicationDocumentsDirectory()).path;
  }

  static String tempPath() {
    return '$tmpPath/${DateTime.now().millisecondsSinceEpoch}.jpg';
  }

  static Future<File> createTmp(Uint8List result, String extension) async {
    return File('$tmpPath/${DateTime.now().millisecondsSinceEpoch}.$extension')
        .writeAsBytes(result);
  }
}

Future<File> saveFileToTmpDir(File file) async {
  final saved =
      await file.copy('${PathHelper.tmpPath}/${file.path.split('/').last}');
  return saved;
}
