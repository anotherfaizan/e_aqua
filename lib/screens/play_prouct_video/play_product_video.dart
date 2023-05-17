import 'package:aquatic_vendor_app/app_resources/flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PlayProductVideo extends StatefulWidget {
  final String videoUrl;
  PlayProductVideo({Key? key, required this.videoUrl}) : super(key: key);

  @override
  State<PlayProductVideo> createState() => _PlayProductVideoState();
}

class _PlayProductVideoState extends State<PlayProductVideo> {
  late FlickManager flickManager;
  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.network(widget.videoUrl),
    );
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: FlickVideoPlayer(flickManager: flickManager),
          ),
        ),
      ),
    );
  }
}
