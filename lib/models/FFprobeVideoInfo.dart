
import 'package:ffmpeg_kit_flutter/media_information_session.dart';

class FFprobeVideoInfo {
  final int width;
  final int height;
  final String? duration;
  final String? size;  
  final String? bitrate;
  final MediaInformationSession  session;
  FFprobeVideoInfo(this.width, this.height, this.duration, this.size, this.bitrate,this.session);
}