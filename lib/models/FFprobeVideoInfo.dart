import 'package:ffmpeg_kit_flutter/ffmpeg_session.dart';

class FFprobeVideoInfo {
  final int width;
  final int height;
  final double fps;
  final int size;
  final FFmpegSession session;

  FFprobeVideoInfo(this.width, this.height, this.fps, this.size, this.session);
}