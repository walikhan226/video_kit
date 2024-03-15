import 'package:ffmpeg_kit_flutter/ffmpeg_session.dart';

class FFprobeResult {
  final double duration;
  final FFmpegSession session;

  FFprobeResult(this.duration, this.session);
}