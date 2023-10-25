import 'package:acp_web/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class CustomScrollBar extends StatefulWidget {
  const CustomScrollBar({
    super.key,
    required this.child,
    required this.scrollDirection,
    this.clipBehavior = Clip.hardEdge,
    this.allwaysVisible = false,
  });

  final Widget child;
  final Axis scrollDirection;
  final Clip clipBehavior;
  final bool allwaysVisible;

  @override
  State<CustomScrollBar> createState() => _CustomScrollBarState();
}

class _CustomScrollBarState extends State<CustomScrollBar> {
  final yourScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      if (yourScrollController.hasClients) {
        yourScrollController.animateTo(
          yourScrollController.position.minScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return RawScrollbar(
      controller: yourScrollController,
      thumbColor: AppTheme.of(context).primaryColor,
      radius: const Radius.circular(15),
      thickness: 5,
      thumbVisibility: widget.allwaysVisible,
      child: SingleChildScrollView(
        scrollDirection: widget.scrollDirection,
        controller: yourScrollController,
        clipBehavior: widget.clipBehavior,
        child: widget.child,
      ),
    );
  }
}
