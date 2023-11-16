import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InputContainer extends StatelessWidget {
  const InputContainer({
    super.key,
    required this.title,
    required this.child,
    this.width = 414,
    this.alignment = Alignment.center,
  });

  final String title;
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w400,
              fontSize: 12,
              color: const Color(0x661C1C1C),
            ),
          ),
          const SizedBox(height: 5),
          child,
        ],
      ),
    );
  }
}
