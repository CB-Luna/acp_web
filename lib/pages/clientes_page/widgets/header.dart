import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:acp_web/providers/providers.dart';
import 'package:acp_web/pages/widgets/sociedad_drop_down.dart';
import 'package:acp_web/theme/theme.dart';

class ClientesHeader extends StatefulWidget {
  const ClientesHeader({super.key, required this.encabezado});

  final String encabezado;

  @override
  State<ClientesHeader> createState() => _ClientesHeaderState();
}

class _ClientesHeaderState extends State<ClientesHeader> {
  bool warningVisible = false;

  @override
  Widget build(BuildContext context) {
    final ClientesProvider provider = Provider.of<ClientesProvider>(context);

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
            //SearchBar
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 150,
                  height: 35,
                  alignment: Alignment.center,
                  child: TextField(
                    controller: provider.codigoClienteController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[0-9]'),
                      )
                    ],
                    onChanged: (value) async {
                      await provider.getSociedadesCliente();
                    },
                    decoration: InputDecoration(
                      isDense: true,
                      filled: true,
                      fillColor: Colors.grey[300],
                      hintText: 'Código Cliente',
                      hintStyle: AppTheme.of(context).bodyText1.override(
                            fontFamily: AppTheme.of(context).bodyText1Family,
                            useGoogleFonts: false,
                            color: AppTheme.of(context).secondaryText,
                          ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.white,
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.white,
                          width: 1,
                        ),
                      ),
                      prefixIcon: Icon(
                        Icons.person_outline_outlined,
                        color: AppTheme.of(context).secondaryText,
                      ),
                      focusColor: AppTheme.of(context).primaryColor,
                    ),
                    cursorColor: AppTheme.of(context).primaryColor,
                  ),
                ),
                Positioned(
                  left: 5,
                  bottom: -20,
                  child: Visibility(
                    visible: warningVisible,
                    child: Text(
                      'El código de cliente es requerido',
                      style: AppTheme.of(context).bodyText1.override(
                            useGoogleFonts: false,
                            fontFamily: AppTheme.of(context).bodyText1Family,
                            color: Colors.red,
                            fontSize: 12,
                          ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
            provider.sociedadesValidacion.isNotEmpty
                ? SociedadDropDown(
                    sociedadSeleccionada: provider.sociedadSeleccionada,
                    sociedades: provider.sociedadesValidacion,
                    onSelect: (sociedad) async {
                      provider.sociedadSeleccionada = sociedad;
                    },
                  )
                : const SizedBox.shrink(),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () async {
                if (provider.codigoClienteController.text.isEmpty) {
                  warningVisible = true;
                  setState(() {});
                  return;
                }

                warningVisible = false;
                setState(() {});

                final res = await provider.getCliente();

                if (!res) {
                  return;
                }

                provider.clearControllers();

                if (!mounted) return;
                await context.pushNamed('registro_cliente', extra: true);
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
                    'Añadir Cliente',
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
