import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class AnimatedLoginWidget extends StatelessWidget {
  const AnimatedLoginWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const ModelViewer(
      src: 'assets/3d_models/animation.gltf',
      alt: 'A 3D model',
      // animationName: ,
      // ar: true,
      // autoRotate: true,
      cameraControls: false,
    );
  }
}
