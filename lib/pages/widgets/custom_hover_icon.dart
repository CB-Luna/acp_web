import 'package:acp_web/theme/theme.dart';
import 'package:flutter/material.dart';

class CustomHoverIcon extends StatefulWidget {
  const CustomHoverIcon({
    Key? key,
    required this.icon,
    this.isRed = false,
    this.size = 30,
    required this.onTap,
  }) : super(key: key);

  final IconData icon;
  final bool isRed;
  final double size;
  final Function() onTap;

  @override
  State<CustomHoverIcon> createState() => _CustomHoverIconState();
}

class _CustomHoverIconState extends State<CustomHoverIcon> {
  Color iconColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: MouseRegion(
        onHover: (_) {
          setState(() {
            if (widget.isRed) {
              iconColor = AppTheme.of(context).red;
            } else {
              iconColor = AppTheme.of(context).primaryColor;
            }
          });
        },
        onExit: (_) {
          setState(() {
            iconColor = Colors.grey;
          });
        },
        child: Icon(
          widget.icon,
          color: iconColor,
          size: widget.size,
        ),
      ),
    );
  }
}
