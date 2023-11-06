import 'package:flutter/material.dart';

import 'package:acp_web/theme/theme.dart';

class RegistroClientesHeader extends StatefulWidget {
  const RegistroClientesHeader({super.key, required this.encabezado});

  final String encabezado;

  @override
  State<RegistroClientesHeader> createState() => _RegistroClientesHeaderState();
}

class _RegistroClientesHeaderState extends State<RegistroClientesHeader> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.encabezado,
              style: AppTheme.of(context).subtitle1,
            ),
            const Spacer(),
            IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.more_horiz_outlined,
                size: 24,
                color: Color(0xFF0A0859),
              ),
              splashRadius: 0.01,
              onPressed: () {},
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
