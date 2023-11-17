import 'package:acp_web/helpers/globals.dart';
import 'package:acp_web/theme/theme.dart';
import 'package:flutter/material.dart';

class ClientImageContainer extends StatefulWidget {
  const ClientImageContainer({
    super.key,
    this.imageName,
    required this.size,
  });

  final String? imageName;
  final double size;

  @override
  State<ClientImageContainer> createState() => _ClientImageContainerState();
}

class _ClientImageContainerState extends State<ClientImageContainer> {
  String? url;

  @override
  void initState() {
    super.initState();
    if (widget.imageName != null) {
      url = supabase.storage.from('logos-cliente').getPublicUrl(widget.imageName!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size,
      height: widget.size,
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
      child: url != null
          ? Image.network(
              url!,
            )
          : Container(
              width: widget.size - 1,
              height: widget.size - 1,
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
                  size: widget.size - 10,
                ),
              ),
            ),
    );
  }
}
