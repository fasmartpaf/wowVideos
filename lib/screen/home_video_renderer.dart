import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class AppVideoPlayer extends StatefulWidget {
  String videoLink;
  AppVideoPlayer(this.videoLink);

  @override
  _AppVideoPlayerState createState() => _AppVideoPlayerState();
}

class _AppVideoPlayerState extends State<AppVideoPlayer> {
  late VideoPlayerController _controller;

  String videoLink = "";

  @override
  void initState() {
    super.initState();

    videoLink = widget.videoLink;

    print("player_videolink:$videoLink");

    _controller = VideoPlayerController.network(videoLink)
      ..initialize().then((value) => {setState(() {})});
    _controller.setLooping(true);
    _controller.setVolume(10.0);
    _controller.play();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: _controller.value.size.width,
            height: _controller.value.size.height,
            child: VideoPlayer(_controller),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
