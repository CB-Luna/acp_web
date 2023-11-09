import 'package:acp_web/theme/theme.dart';
import 'package:flutter/material.dart';

class ImageContainer extends StatelessWidget {
  const ImageContainer({
    super.key,
    this.imageUrl,
    required this.size,
  });

  final String? imageUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppTheme.of(context).primaryBackground,
        border: Border.all(
          width: 1,
          color: AppTheme.of(context).secondaryColor,
          strokeAlign: BorderSide.strokeAlignOutside,
        ),
        shape: BoxShape.circle,
      ),
      clipBehavior: Clip.antiAlias,
      child: imageUrl != null
          ? Image.network(
              imageUrl!,
            )
          : Container(
              width: size - 1,
              height: size - 1,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: AppTheme.of(context).primaryBackground,
                ),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.image_outlined,
                  size: size - 10,
                ),
              ),
            ),
    );
  }
}
