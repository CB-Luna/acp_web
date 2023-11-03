import 'package:acp_web/functions/money_format.dart';
import 'package:acp_web/theme/theme.dart';
import 'package:flutter/material.dart';

class PopupSolicitudPagos extends StatefulWidget {
  const PopupSolicitudPagos({
    super.key,
    required this.moneda,
    required this.comision,
    required this.pagoanticipado,
    required this.cantidadFacturas,
    required this.cantidadFacturasSeleccionadas,
  });
  final int cantidadFacturas;
  final String moneda;
  final double comision;
  final double pagoanticipado;
  final int cantidadFacturasSeleccionadas;

  @override
  State<PopupSolicitudPagos> createState() => PopupSolicitudPagosState();
}

class PopupSolicitudPagosState extends State<PopupSolicitudPagos> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width / 1440;
    double height = MediaQuery.of(context).size.height / 1024;

    return AlertDialog(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      content: Container(
        width: width * 500,
        height: height * 490,
        decoration: BoxDecoration(
          color: const Color(0xFFD7E9FB),
          borderRadius: const BorderRadius.all(
            Radius.circular(35),
          ),
          border: Border.all(
            color: const Color(0xFFD1D1D1),
          ),
        ),
        child: Column(
          children: [
            //titulo
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Por favor revisa la selección de facturas antes de continuar',
                textAlign: TextAlign.center,
                style: AppTheme.of(context).subtitle1.override(
                      fontFamily: AppTheme.of(context).subtitle1Family,
                      useGoogleFonts: false,
                      fontSize: 30,
                      color: AppTheme.of(context).primaryText,
                    ),
              ),
            ),
            //Informacion
            Padding(
              padding: const EdgeInsets.all(20),
              child: Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Text(
                            'Total de Facturas:',
                            style: AppTheme.of(context).bodyText2,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Text(
                            'Moneda:',
                            style: AppTheme.of(context).bodyText2,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Text(
                            'Comisión:',
                            style: AppTheme.of(context).bodyText2,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Text(
                            'Pago Anticipado:',
                            style: AppTheme.of(context).bodyText2,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Text(
                            '${widget.cantidadFacturasSeleccionadas}',
                            style: AppTheme.of(context).bodyText2,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Text(
                            widget.moneda,
                            style: AppTheme.of(context).bodyText2,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Text(
                            'GTQ ${moneyFormat(widget.comision)}',
                            style: AppTheme.of(context).bodyText2.override(
                                  fontFamily: AppTheme.of(context).bodyText2Family,
                                  useGoogleFonts: false,
                                  color: AppTheme.of(context).green,
                                ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Text(
                            'GTQ ${moneyFormat(widget.pagoanticipado)}',
                            style: AppTheme.of(context).bodyText2.override(
                                  fontFamily: AppTheme.of(context).bodyText2Family,
                                  useGoogleFonts: false,
                                  color: AppTheme.of(context).primaryColor,
                                ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            //Botones
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 8,
                    shadowColor: AppTheme.of(context).primaryBackground.withOpacity(0.8),
                    backgroundColor: AppTheme.of(context).tertiaryColor,
                  ),
                  child: SizedBox(
                    width: width * 180,
                    height: height * 60,
                    child: Center(
                      child: Text(
                        'Cancelar',
                        style: AppTheme.of(context).bodyText1.override(
                              fontFamily: AppTheme.of(context).bodyText2Family,
                              useGoogleFonts: false,
                              color: AppTheme.of(context).primaryBackground,
                            ),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 8,
                    shadowColor: AppTheme.of(context).primaryBackground.withOpacity(0.8),
                    backgroundColor: AppTheme.of(context).primaryColor,
                  ),
                  child: SizedBox(
                    width: width * 180,
                    height: height * 60,
                    child: Center(
                      child: Text(
                        'Aceptar',
                        style: AppTheme.of(context).bodyText1.override(
                              fontFamily: AppTheme.of(context).bodyText2Family,
                              useGoogleFonts: false,
                              color: AppTheme.of(context).primaryBackground,
                            ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
