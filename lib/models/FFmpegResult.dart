import 'package:ffmpeg_kit_flutter/ffmpeg_session.dart';

class FFmpegResult {
  final String outputPath;
  final FFmpegSession session;

  FFmpegResult(this.outputPath, this.session);
}