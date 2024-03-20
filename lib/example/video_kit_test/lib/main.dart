import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:video_kit/video_kit.dart';

void main() {
  runApp(VideoProcessingApp());
}

class VideoProcessingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Processing App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: VideoProcessingPage(),
    );
  }
}

class VideoProcessingPage extends StatefulWidget {
  @override
  _VideoProcessingPageState createState() => _VideoProcessingPageState();
}

class _VideoProcessingPageState extends State<VideoProcessingPage> {
  final ImagePicker _picker = ImagePicker();
   XFile? _videoFile;
  late VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.asset('assets/placeholder_video.mp4');
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  Future<void> _captureVideo() async {
    try {
      final media = await _picker.pickVideo(source: ImageSource.camera);
      if (media != null) {
        setState(() {
          _videoFile = media;
          _videoPlayerController = VideoPlayerController.file(File(_videoFile!.path));
          _videoPlayerController.initialize().then((_) {
            setState(() {});
          });
      _videoPlayerController.play();
      _videoPlayerController.setLooping(true);
        });
      }
    } catch (e) {
      print('Error capturing video: $e');
    }
  }

  updatevideo(String path){
   setState(() {
          _videoFile = XFile(path);
          _videoPlayerController = VideoPlayerController.file(File(path));
          _videoPlayerController.initialize().then((_) {
            setState(() {});
          });
      _videoPlayerController.play();
      _videoPlayerController.setLooping(true);
        });

  }

  Future<void> _muteVideo() async {
    if (_videoFile != null) {
      try {
        var result = await VideoKit.muteVideo(_videoFile!.path);
      await  updatevideo(result.outputPath);
        print('Muted video saved at: ${result.outputPath}');
      } catch (e) {
        print('Error muting video: $e');
      }
    }
  }

  Future<void> _trimVideo() async {
    if (_videoFile != null) {
      try {
        var result = await VideoKit.trimVideo(_videoFile!.path, 10, 5); // Trim from 10th second, 5 seconds duration
        print('Trimmed video saved at: ${result.outputPath}');
          await  updatevideo(result.outputPath);
      } catch (e) {
        print('Error trimming video: $e');
      }
    }
  }

  Future<void> _getVideoInfo() async {
    if (_videoFile != null) {
      try {
        var videoInfo = await VideoKit.getVideoInfo(_videoFile!.path);
        print('Video duration: ${videoInfo.duration} seconds');
      } catch (e) {
        print('Error getting video info: $e');
      }
    }
  }

  Future<void> _compressVideo() async {
    if (_videoFile != null) {
      try {
        var result = await VideoKit.compressVideo(_videoFile!.path, 1000); // Compress with bitrate of 1000 kbps
        print('Compressed video saved at: ${result.outputPath}');
          await  updatevideo(result.outputPath);
      } catch (e) {
        print('Error compressing video: $e');
      }
    }
  }

  Future<void> _splitVideo() async {
    if (_videoFile != null) {
      try {
        var outputPaths = await VideoKit.splitVideo(_videoFile!.path, 3); // Split into 3 segments
        outputPaths.forEach((outputPath) {
          print('Segment saved at: $outputPath');
        });
      } catch (e) {
        print('Error splitting video: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Processing'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_videoFile != null)
                AspectRatio(
        
                  aspectRatio: 1.6,
                  child: VideoPlayer(_videoPlayerController),
                )
              else
                Container(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _captureVideo,
                child: Text('Capture Video'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _muteVideo,
                child: Text('Mute Video'),
              ),
              ElevatedButton(
                onPressed: _trimVideo,
                child: Text('Trim Video'),
              ),
              ElevatedButton(
                onPressed: _getVideoInfo,
                child: Text('Get Video Info'),
              ),
              ElevatedButton(
                onPressed: _compressVideo,
                child: Text('Compress Video'),
              )])),
      ));
       
  }}