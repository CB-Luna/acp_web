import 'package:flutter/material.dart';

import 'package:video_player/video_player.dart';

class AnimatedLoginWidget extends StatefulWidget {
  const AnimatedLoginWidget({super.key});

  @override
  State<AnimatedLoginWidget> createState() => _AnimatedLoginWidgetState();
}

class _AnimatedLoginWidgetState extends State<AnimatedLoginWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(
      'videos/bgvideo.mp4',
      videoPlayerOptions: VideoPlayerOptions(allowBackgroundPlayback: true),
    )..initialize().then(
        (_) {
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          setState(() {});
        },
      );
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.value.isInitialized == true) {
      _controller.play();
      _controller.setLooping(true);
    }

    return _controller.value.isInitialized
        ? SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller.value.size.width,
                height: _controller.value.size.height,
                child: VideoPlayer(_controller),
              ),
            ),
          )
        : Container();

    // return _controller.value.isInitialized
    //     ? AspectRatio(
    //         aspectRatio: _controller.value.aspectRatio,
    //         child: VideoPlayer(_controller),
    //       )
    //     : Container();
  }
}
