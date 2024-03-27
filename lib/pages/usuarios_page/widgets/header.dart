import 'package:acp_web/providers/providers.dart';
import 'package:acp_web/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class UsuariosHeader extends StatefulWidget {
  const UsuariosHeader({super.key, required this.encabezado});

  final String encabezado;

  @override
  State<UsuariosHeader> createState() => _UsuariosHeaderState();
}

class _UsuariosHeaderState extends State<UsuariosHeader> {
  @override
  Widget build(BuildContext context) {
    final UsuariosProvider provider = Provider.of<UsuariosProvider>(context);

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
            ElevatedButton(
              onPressed: () async {
                provider.clearControllers(notify: false);
                await context.pushNamed('registro_usuario');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0A0859),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                padding: const EdgeInsets.all(18),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.add_outlined,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'Añadir Usuario',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          height: 44,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F9FB),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Icons.filter_list_outlined,
                  size: 24,
                  color: Color(0xFF0A0859),
                ),
                splashRadius: 0.01,
                onPressed: () {},
              ),
              IconButton(
                padding: EdgeInsets.zero,
                icon: const RotatedBox(
                  quarterTurns: 1,
                  child: Icon(
                    Icons.sync_alt_outlined,
                    size: 24,
                    color: Color(0xFF0A0859),
                  ),
                ),
                splashRadius: 0.01,
                onPressed: () {},
              ),
              IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Icons.filter_alt_outlined,
                  size: 24,
                  color: Color(0xFF0A0859),
                ),
                splashRadius: 0.01,
                onPressed: () {},
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
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
