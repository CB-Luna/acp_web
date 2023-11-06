import 'package:flutter/material.dart';

class InputContainer extends StatelessWidget {
  const InputContainer({
    super.key,
    required this.child,
    this.width = double.infinity,
    this.alignment = Alignment.center,
  });

  final Widget child;
  final double width;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}
