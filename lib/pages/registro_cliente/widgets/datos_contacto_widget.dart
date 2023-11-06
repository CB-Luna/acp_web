import 'package:acp_web/models/models.dart';
import 'package:acp_web/pages/registro_cliente/widgets/input_container.dart';
import 'package:acp_web/providers/providers.dart';
import 'package:acp_web/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DatosContactoWidget extends StatefulWidget {
  const DatosContactoWidget({
    super.key,
    required this.contactos,
  });

  final List<Contacto> contactos;

  @override
  State<DatosContactoWidget> createState() => _DatosGeneralesWidgetState();
}

class _DatosGeneralesWidgetState extends State<DatosContactoWidget> {
  @override
  Widget build(BuildContext context) {
    final ClientesProvider provider = Provider.of<ClientesProvider>(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFD7E9FB),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Datos de Contacto',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 16),
          InputContainer(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        Icons.add_outlined,
                        size: 21,
                        color: AppTheme.of(context).secondaryColor,
                      ),
                      splashRadius: 0.01,
                      onPressed: () {},
                    ),
                    const SizedBox(width: 5),
                    const Expanded(child: TitleLabelWidget(title: 'Puesto')),
                    const SizedBox(width: 5),
                    const Expanded(child: TitleLabelWidget(title: 'Nombre')),
                    const SizedBox(width: 5),
                    const Expanded(child: TitleLabelWidget(title: 'Correo')),
                    const SizedBox(width: 5),
                    const Expanded(child: TitleLabelWidget(title: 'Teléfono')),
                    const SizedBox(height: 20, width: 48.2),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TitleLabelWidget extends StatelessWidget {
  const TitleLabelWidget({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0x4D0090FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        title,
        style: AppTheme.of(context).subtitle1,
      ),
    );
  }
}

class ClienteDataWidget extends StatelessWidget {
  const ClienteDataWidget({
    super.key,
    required this.title,
    required this.data,
  });

  final String title;
  final String data;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.of(context).subtitle1.override(
                fontFamily: 'Gotham-Bold',
                useGoogleFonts: false,
                color: const Color(0x661C1C1C),
              ),
        ),
        const SizedBox(height: 16),
        Text(
          data,
          style: AppTheme.of(context).subtitle1.override(
                fontFamily: 'Gotham-Regular',
                useGoogleFonts: false,
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
        ),
      ],
    );
  }
}
