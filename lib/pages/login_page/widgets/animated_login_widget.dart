import 'package:flutter/material.dart';

import 'package:video_player/video_player.dart';

class AnimatedLoginWidget extends StatefulWidget {
  const AnimatedLoginWidget({super.key});

  @override
  State<AnimatedLoginWidget> createState() => _AnimatedLoginWidgetState();
}

class _AnimatedLoginWidgetState extends State<AnimatedLoginWidget> {
  final VideoPlayerController _controller = VideoPlayerController.asset(
    'assets/videos/bgvideo.mp4',
    videoPlayerOptions: VideoPlayerOptions(allowBackgroundPlayback: true),
  );

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await _controller.initialize();
      // mutes the video
      _controller.setVolume(0);
      // Plays the video once the widget is build and loaded.
      _controller.play();
      _controller.setLooping(true);
      setState(() {});
    });
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.fill,
              child: SizedBox(
                width: _controller.value.size.width,
                height: _controller.value.size.height,
                child: VideoPlayer(_controller),
              ),
            ),
          )
        : Container();
  }
}
