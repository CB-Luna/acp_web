// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class IFrame extends StatelessWidget {
  final String src;
  final double height;
  final double width;

  const IFrame(
      {Key? key, required this.src, this.height = 1000, this.width = 650})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final IFrameElement iframeElement = IFrameElement();

    iframeElement.height = height.toString();
    iframeElement.width = width.toString();
    iframeElement.src = src;
    iframeElement.style.border = 'none';

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      src,
      (int viewId) => iframeElement,
    );

    return SizedBox(
        height: height, width: width, child: HtmlElementView(viewType: src));
  }
}
