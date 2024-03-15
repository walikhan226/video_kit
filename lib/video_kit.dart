library video_kit;

import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:video_kit/models/FFmpegResult.dart';
import 'package:video_kit/models/FFprobeResult.dart';
import 'package:video_kit/models/FFprobeVideoInfo.dart';

class VideoKit {
  Future<FFmpegResult> muteVideo(String inputPath) async {
    String extension = inputPath.split('.').last;
    String outputPath =
        inputPath.replaceAll('.$extension', '_muted.$extension');

    var session =
        await FFmpegKit.execute('-i $inputPath -an -c:v copy $outputPath');
    return FFmpegResult(outputPath, session);
  }

  static Future<FFmpegResult> trimVideo(
      String inputPath, int startTimeInSeconds, int durationInSeconds) async {
    String extension = inputPath.split('.').last;
    String outputPath =
        inputPath.replaceAll('.$extension', '_trimmed.$extension');

    // Construct FFmpeg command to trim the video
    String ffmpegCommand =
        '-i $inputPath -ss $startTimeInSeconds -t $durationInSeconds -c:v copy -c:a copy $outputPath';

    // Execute FFmpeg command
    var session = await FFmpegKit.execute(ffmpegCommand);

    return FFmpegResult(outputPath, session);
  }

  static Future<FFprobeResult> getVideoDuration(String inputPath) async {
    // Construct FFprobe command to get video duration

    // Execute FFprobe command
    var session = await FFmpegKit.execute(
        '-i $inputPath -show_entries format=duration -v quiet -of csv="p=0"');

    var output = await session.getOutput();
    // Extract duration from the output
    double durationInSeconds = double.parse(output!);

    return FFprobeResult(durationInSeconds, session);
  }

  static Future<List<String>> splitVideo(
      String inputPath, int numSegments) async {
    // Get video duration
    var durationResult = await getVideoDuration(inputPath);
    double videoDuration = durationResult.duration;

    // Calculate duration for each segment
    double segmentDuration = videoDuration / numSegments;

    // Construct FFmpeg commands to split the video
    List<String> outputPaths = [];
    for (int i = 0; i < numSegments; i++) {
      String outputPath = inputPath.replaceAll(
          '.mp4', '_segment_$i.mp4'); // Change output path for each segment
      outputPaths.add(outputPath);

      double startTime = i * segmentDuration;
      String ffmpegCommand =
          '-i $inputPath -ss $startTime -t $segmentDuration -c:v copy -c:a copy $outputPath';

      // Execute FFmpeg command
      await FFmpegKit.execute(ffmpegCommand);
    }

    return outputPaths; // FFmpeg session is not used in this case
  }

  static Future<FFmpegResult> compressVideo(
      String inputPath, String outputPath, int bitrate) async {
    // Construct FFmpeg command to compress the video
    String ffmpegCommand = '-i $inputPath -b:v ${bitrate}k $outputPath';

    // Execute FFmpeg command
    var session = await FFmpegKit.execute(ffmpegCommand);

    return FFmpegResult(outputPath, session);
  }

  Future<FFprobeVideoInfo> getVideoInfo(String inputPath) async {
    // Construct FFprobe command to get video information

    // Execute FFprobe command
    var session = await FFmpegKit.execute('-v error -select_streams v:0 -show_entries stream=width,height,r_frame_rate,size -of csv=s=x:p=0 $inputPath');
    String? output = await session.getOutput();
    if (output != null && output.isNotEmpty) {
      List<String> info = output.split('x');
      int width = int.parse(info[0]);
      int height = int.parse(info[1]);
      double fps = double.parse(info[2].split('/')[0]) /
          double.parse(info[2].split('/')[1]);
      int size = int.parse(info[3]);
      return FFprobeVideoInfo(width, height, fps, size, session);
    } else {
      throw Exception("Failed to retrieve video information");
    }
  }
}
