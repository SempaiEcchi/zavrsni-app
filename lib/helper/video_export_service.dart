import 'dart:async';
import 'dart:developer';
import 'dart:io';


import 'package:ffmpeg_kit_flutter_min_gpl/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_min_gpl/ffmpeg_kit_config.dart';
import 'package:ffmpeg_kit_flutter_min_gpl/ffmpeg_session.dart';
import 'package:ffmpeg_kit_flutter_min_gpl/return_code.dart';
import 'package:ffmpeg_kit_flutter_min_gpl/statistics.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_editor/video_editor.dart';
import 'dart:async';
import 'dart:io' as io;

 import 'package:flutter/foundation.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
class ExportService {
  static Future<void> dispose() async {
    final executions = await FFmpegKit.listSessions();
    if (executions.isNotEmpty) await FFmpegKit.cancel();
  }

  static Future<FFmpegSession> runFFmpegCommand(
    FFmpegVideoEditorExecute execute, {
    required void Function(File file) onCompleted,
    void Function(Object, StackTrace)? onError,
    void Function(Statistics)? onProgress,
  }) {
    log('FFmpeg start process with command = ${execute.command}');
    return FFmpegKit.executeAsync(
      execute.command,
      (session) async {
        final state =
            FFmpegKitConfig.sessionStateToString(await session.getState());
        final code = await session.getReturnCode();

        if (ReturnCode.isSuccess(code)) {
          onCompleted(File(execute.outputPath));
        } else {
          if (onError != null) {
            onError(
              Exception(
                  'FFmpeg process exited with state $state and return code $code.\n${await session.getOutput()}'),
              StackTrace.current,
            );
          }
          return;
        }
      },
      null,
      onProgress,
    );
  }

  static Future<File?> getAudioFromVideo(String path) async {
    final inputVideoPath = path;
    final outputAudioPath = await _getTmpAudioPath();

    final ffmpegCommand = '-i \'$inputVideoPath\' \'$outputAudioPath\'';

    final session = await FFmpegKit.execute(ffmpegCommand);
    final rc = await session.getReturnCode();
    if (ReturnCode.isSuccess(rc)) {
      return File(outputAudioPath);
    } else {
      return null;
    }
  }

  static Future<String> _getTmpAudioPath() async {
    final tmpDir = await getTemporaryDirectory();
    final tmpPath = tmpDir.path;
    final tmpAudioPath =
        '$tmpPath/${DateTime.now().millisecondsSinceEpoch}.wav';

    return tmpAudioPath;
  }
}




enum FfmpegCompressScale {
  none(null),
  half(4),
  oneThird(6),
  oneQuarter(8),
  oneFifth(10);

  const FfmpegCompressScale(this.value);

  final int? value;
}

enum FfmpegPreset {
  ultrafast,
  superfast,
  veryFast,
  faster,
  fast,
  medium,
  slow,
  slower,
  verySlow,
}

class FfmpegService {
  const FfmpegService();

  Future<io.Directory> get _tempVideoDir async {
    final temp = await getTemporaryDirectory();
    return await io.Directory(p.join(temp.path, 'video')).create();
  }

  Future<String?> compressVideo(
      String path, {
        FfmpegPreset preset = FfmpegPreset.veryFast,
        FfmpegCompressScale scale = FfmpegCompressScale.none,
        int crf = 28,
        void Function(int)? progressCallback,
      }) async {
    try {
      final name = p.basenameWithoutExtension(path);
      final epoch = DateTime.now().millisecondsSinceEpoch;
      final flutterVideoInfo = FlutterVideoInfo();
      final videoInfo = await flutterVideoInfo.getVideoInfo(path);

      final outputPath = [(await _tempVideoDir).path, '${name}_$epoch.mp4']
          .join(io.Platform.pathSeparator);
      final command = [
        '-y -i $path -preset ${preset.name}',
        if (scale.value != null)
          '-vf scale="trunc(iw/${scale.value})*2:trunc(ih/${scale.value})*2"',
        '-c:v libx264 -crf $crf',
        '-c:a copy $outputPath',
      ].join(' ');
      final completer = Completer<String?>();
      await FFmpegKit.executeAsync(
          command,
              (session) async {
            final code = await session.getReturnCode();
            if (ReturnCode.isSuccess(code)) {
              return completer.complete(outputPath);
            } else if (ReturnCode.isCancel(code)) {
              return completer.complete(null);
            }
            final state = await session.getState();
            return completer.completeError(Exception(
              'FFmpeg process exited with state ${state.name} '
                  'and return code $code.',
            ));
          },
              (log) => debugPrint(log.getMessage()),
              (statistics) {
            if (progressCallback == null) return;
            final time = statistics.getTime();
            if (time > 0 && videoInfo?.duration != null) {
              final progress = (time / videoInfo!.duration! * 100).toInt();
              progressCallback(progress);
            }
          });
      return await completer.future;
    } catch (e, s) {
      debugPrint('Failed to compress video $e $s');
      rethrow;
    }
  }
}
