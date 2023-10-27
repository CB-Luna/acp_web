import 'package:acp_web/theme/theme.dart';
import 'package:flutter/material.dart';

class UsuariosHeader extends StatefulWidget {
  const UsuariosHeader({super.key, required this.encabezado});

  final String encabezado;

  @override
  State<UsuariosHeader> createState() => _UsuariosHeaderState();
}

class _UsuariosHeaderState extends State<UsuariosHeader> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.encabezado,
          style: AppTheme.of(context).subtitle1,
        ),
        const Spacer(),
      ],
    );
  }
}
