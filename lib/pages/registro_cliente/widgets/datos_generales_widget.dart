import 'package:acp_web/pages/widgets/sociedad_drop_down.dart';
import 'package:acp_web/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:acp_web/pages/registro_cliente/widgets/input_container.dart';
import 'package:acp_web/pages/widgets/get_image_widget.dart';
import 'package:acp_web/providers/providers.dart';

class DatosGeneralesWidget extends StatefulWidget {
  const DatosGeneralesWidget({super.key});

  @override
  State<DatosGeneralesWidget> createState() => _DatosGeneralesWidgetState();
}

class _DatosGeneralesWidgetState extends State<DatosGeneralesWidget> {
  String? imageUrl;

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
              'Datos Generales',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            height: 210,
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                InkWell(
                  onTap: () async {
                    await provider.selectImage();
                  },
                  child: Container(
                    width: 175,
                    height: 175,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: getUserImage(
                      height: 145,
                      provider.webImage ?? imageUrl,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InputContainer(
                        child: Row(
                          children: [
                            Expanded(
                              child: ClienteDataWidget(
                                title: 'Código de cliente',
                                data: provider.cliente!.codigoCliente,
                              ),
                            ),
                            const Expanded(child: ClienteSociedadWidget()),
                            Expanded(
                              child: ClienteDataWidget(
                                title: 'Dirección',
                                data: provider.cliente!.direccion,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      InputContainer(
                        child: Row(
                          children: [
                            Expanded(
                              child: ClienteDataWidget(
                                title: 'Identificación Fiscal',
                                data: provider.cliente!.identificadorFiscal,
                              ),
                            ),
                            Expanded(
                              child: ClienteDataWidget(
                                title: 'Cuenta',
                                data: provider.cliente!.tipoCuenta ?? '',
                              ),
                            ),
                            Expanded(
                              child: ClienteDataWidget(
                                title: 'Condición Pago',
                                data: provider.cliente!.condicionPago.toString(),
                              ),
                            ),
                            Expanded(
                              child: ClienteDataWidget(
                                title: 'Banco',
                                data: provider.cliente!.bancoIndustrial ?? '',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
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

class ClienteSociedadWidget extends StatelessWidget {
  const ClienteSociedadWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ClientesProvider provider = Provider.of<ClientesProvider>(context);
    final sociedadesCliente = provider.cliente!.sociedades;

    final bool isMultiple = sociedadesCliente.length > 1;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isMultiple ? 'Sociedades' : 'Sociedad',
          style: AppTheme.of(context).subtitle1.override(
                fontFamily: 'Gotham-Bold',
                useGoogleFonts: false,
                color: const Color(0x661C1C1C),
              ),
        ),
        const SizedBox(height: 16),
        isMultiple
            ? SociedadDropDown(
                sociedadSeleccionada: provider.sociedadSeleccionada,
                sociedades: sociedadesCliente,
                onSelect: (sociedad) async {
                  if (sociedad == null) return;
                  await provider.cambiarCliente(sociedad);
                },
              )
            : Text(
                sociedadesCliente.first,
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
