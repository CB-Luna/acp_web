import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomInputField extends StatefulWidget {
  const CustomInputField({
    super.key,
    required this.label,
    required this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.formatters,
    this.onChanged,
    this.readOnly = false,
    this.height = 45,
  });

  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? formatters;
  final void Function(String)? onChanged;
  final bool readOnly;
  final double? height;

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      alignment: Alignment.center,
      child: TextFormField(
        controller: widget.controller,
        validator: widget.validator,
        keyboardType: widget.keyboardType,
        inputFormatters: widget.formatters,
        readOnly: widget.readOnly,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          hintText: widget.label,
          isCollapsed: true,
          isDense: true,
          hintStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: const Color.fromARGB(204, 0, 0, 0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.white,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.white,
              width: 1,
            ),
          ),
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
        ),
        style: GoogleFonts.inter(
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: const Color.fromARGB(204, 0, 0, 0),
        ),
      ),
    );
  }
}
