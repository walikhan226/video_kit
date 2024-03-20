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
This package supports both Main and [LTS version](https://github.com/arthenica/ffmpeg-kit/wiki/LTS-Releases) of the FFmpeg implementation.

<table>
<thead>
    <tr>
        <th align="center"></th>
        <th align="center">Main Release</th>
        <th align="center">LTS Release</th>
    </tr>
</thead>
<tbody>
    <tr>
        <td align="center">Android API Level</td>
        <td align="center">24</td>
        <td align="center">16</td>
    </tr>
    <tr>
        <td align="center">Android Camera Access</td>
        <td align="center">Yes</td>
        <td align="center">-</td>
    </tr>
    <tr>
        <td align="center">Android Architectures</td>
        <td align="center">arm-v7a-neon<br>arm64-v8a<br>x86<br>x86-64</td>
        <td align="center">arm-v7a<br>arm-v7a-neon<br>arm64-v8a<br>x86<br>x86-64</td>
    </tr>
    <tr>
        <td align="center">iOS Min SDK</td>
        <td align="center">12.1</td>
        <td align="center">10</td>
    </tr>
    <tr>
        <td align="center">iOS Architectures</td>
        <td align="center">arm64<br>arm64-simulator<br>arm64-mac-catalyst<br>x86-64<br>x86-64-mac-catalyst</td>
        <td align="center">armv7<br>arm64<br>i386<br>x86-64</td>
    </tr>
</tbody>
</table>

To use VideoKit in your Dart project, add it to your `pubspec.yaml` file:

```yaml
dependencies:
  videokit: ^1.0.0


Then, run flutter pub get to install the package.

Usage
Here's a quick example of how to use VideoKit:

// Mute a video
await VideoKit.muteVideo('input_video.mp4');

// Trim a video
await VideoKit.trimVideo('input_video.mp4', 10, 5); // Trims 5 seconds starting from the 10th second

// Get video information
var videoInfo = await VideoKit.getVideoInfo('input_video.mp4');
print('Video duration: ${videoInfo.duration} seconds');

// Compress a video
await VideoKit.compressVideo('input_video.mp4', 1000); // Compress with a bitrate of 1000 kbps

