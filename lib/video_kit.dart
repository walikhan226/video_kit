library video_kit;

// ignore: depend_on_referenced_packages
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';

// ignore: depend_on_referenced_packages
import 'package:ffmpeg_kit_flutter/ffprobe_kit.dart';
import 'package:video_kit/models/FFmpegResult.dart';
import 'package:video_kit/models/FFprobeVideoInfo.dart';



class VideoKit {
 static Future<FFmpegResult> muteVideo(String inputPath) async {
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

  static Future<FFprobeVideoInfo> getVideoInfo(String inputPath) async {
    // Construct FFprobe command to get video duration
    var session = await FFprobeKit.getMediaInformation(inputPath);
    var information = session.getMediaInformation();

    var duration =  information?.getDuration();
    var properties = information?.getAllProperties();
    var size = information?.getSize();
    var bitrate = information?.getBitrate();
  
    var width = properties!["streams"][0]["width"];
    var height = properties["streams"][0]["height"];

    return FFprobeVideoInfo(width, height, duration, size, bitrate ,session);
  }
  static Future<double> getVideoDuration(String inputPath) async {
    // Construct FFprobe command to get video duration
    var session = await FFprobeKit.getMediaInformation(inputPath);
    var information = session.getMediaInformation();

    var duration =  information?.getDuration();

    return double.parse(duration!);
  }

  static Future<List<String>> splitVideo(
    String inputPath, int numSegments) async {
    var durationResult = await getVideoDuration(inputPath);
    double videoDuration = durationResult;

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
      String inputPath, int bitrate) async {
    // Construct FFmpeg command to compress the video

       String extension = inputPath.split('.').last;
    String outputPath =
        inputPath.replaceAll('.$extension', '_muted.$extension');

    String ffmpegCommand = '-i $inputPath -b:v ${bitrate}k $outputPath';

    // Execute FFmpeg command
    var session = await FFmpegKit.execute(ffmpegCommand);

    return FFmpegResult(outputPath, session);
  }


}
