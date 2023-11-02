import 'package:acp_web/pages/widgets/custom_hover_icon.dart';
import 'package:acp_web/providers/autorizacion_solicitudes_pago_anticipado/autorizacion_solicitudes_pago_anticipado_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:acp_web/theme/theme.dart';

class PopUpEjecucion extends StatefulWidget {
  const PopUpEjecucion({super.key});

  @override
  State<PopUpEjecucion> createState() => _PopUpEjecucionState();
}

class _PopUpEjecucionState extends State<PopUpEjecucion> {
  @override
  Widget build(BuildContext context) {
    //double width = MediaQuery.of(context).size.width / 1440;
    //double height = MediaQuery.of(context).size.height / 1024;

    final AutorizacionAolicitudesPagoAnticipadoProvider provider = Provider.of<AutorizacionAolicitudesPagoAnticipadoProvider>(context);

    //String? monedaSeleccionada = currentUser!.monedaSeleccionada;

    return AlertDialog(
      backgroundColor: Colors.transparent,
      content: Container(
        key: UniqueKey(),
        width: 550,
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppTheme.of(context).secondaryColor,
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.all(24),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    width: 60,
                  ),
                  Text(
                    'Ejecución',
                    style: AppTheme.of(context).title3.override(
                          fontFamily: 'Gotham-Bold',
                          color: AppTheme.of(context).primaryColor,
                          fontSize: 35,
                          useGoogleFonts: false,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(
                    width: 60,
                    child: Tooltip(
                      message: 'Cerrar',
                      child: CustomHoverIcon(
                        icon: Icons.close,
                        isRed: false,
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '¿Estás seguro de que deseas confirmar la selección?',
                      style: AppTheme.of(context).textoResaltado.override(
                            useGoogleFonts: false,
                            fontFamily: 'Gotham-Regular',
                            fontWeight: FontWeight.w400,
                            color: AppTheme.of(context).primaryText,
                          ),
                    ),
                    /* RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '¿ Desea proceder con la ejecución de las facturas seleccionadas por un monto de ',
                            style: AppTheme.of(context).textoResaltado.override(
                                  useGoogleFonts: false,
                                  fontFamily: 'Gotham-Regular',
                                  fontWeight: FontWeight.w400,
                                  color: AppTheme.of(context).primaryText,
                                ),
                          ),
                          TextSpan(
                            text: '$monedaSeleccionada ${moneyFormat(provider.montoFacturacion)}',
                            style: AppTheme.of(context).textoResaltado.override(
                                  useGoogleFonts: false,
                                  fontFamily: 'Gotham-Regular',
                                  color: AppTheme.of(context).primaryText,
                                ),
                          ),
                          TextSpan(
                            text: ' ?',
                            style: AppTheme.of(context).textoResaltado.override(
                                  useGoogleFonts: false,
                                  fontFamily: 'Gotham-Regular',
                                  fontWeight: FontWeight.w400,
                                  color: AppTheme.of(context).primaryText,
                                ),
                          )
                        ],
                      ),
                    ), */
                    /* Padding(
                      padding: const EdgeInsetsDirectional.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '¿Deseas Continuar?',
                            style: AppTheme.of(context).textoResaltado.override(
                                  useGoogleFonts: false,
                                  fontFamily: 'Gotham-Bold',
                                  color: AppTheme.of(context).primaryColor,
                                ),
                          ),
                        ],
                      ),
                    ), */
                    Padding(
                      padding: const EdgeInsetsDirectional.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          provider.ejecBloq
                              ? GestureDetector(
                                  onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Proceso ejecutandose'),
                                      ),
                                    );
                                  },
                                  child: CircularProgressIndicator(
                                    color: AppTheme.of(context).primaryColor,
                                  ),
                                )
                              : Tooltip(
                                  message: 'Aceptar',
                                  child: CustomHoverIcon(
                                    icon: Icons.check_outlined,
                                    onTap: () async {
                                      if (provider.ejecBloq) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Proceso ejecutandose'),
                                          ),
                                        );
                                      } else {
                                        if (await provider.updateRecords()) {
                                          if (!mounted) return;
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('Proceso realizado con exito'),
                                            ),
                                          );

                                          setState(() {
                                            provider.ejecBloq = false;
                                          });
                                        } else {
                                          if (!mounted) return;
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('Proceso fallido'),
                                            ),
                                          );
                                        }
                                      }
                                    },
                                  ),
                                ),
                          if (!provider.ejecBloq) const SizedBox(width: 20),
                          if (!provider.ejecBloq)
                            Tooltip(
                              message: 'Cancelar',
                              child: CustomHoverIcon(
                                icon: Icons.close,
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
