# VideoKit

VideoKit is a Dart package for manipulating video files using FFmpeg and FFprobe commands. It provides a variety of features such as muting, trimming, splitting, compressing, and retrieving video information.

## Features

- Mute video
- Trim video
- Get video duration
- Split video
- Compress video
- Get video information

## Getting started

Before using VideoKit, ensure you have FFmpeg and FFprobe installed on your system and properly configured. You can download FFmpeg from [ffmpeg.org](https://ffmpeg.org/) and follow the installation instructions.

To use VideoKit in your Dart project, add it to your `pubspec.yaml` file:

```yaml
dependencies:
  videokit: ^1.0.0


Then, run flutter pub get to install the package.

Usage
Here's a quick example of how to use VideoKit to mute a video:

import 'package:videokit/videokit.dart';

void main() async {
  String inputPath = 'path/to/input/video.mp4';
  var result = await VideoKit().muteVideo(inputPath);
}

