import 'package:acp_web/functions/money_format.dart';
import 'package:acp_web/pages/seleccion_pagos_anticipados/widgets/popup_ejecucion.dart';
import 'package:acp_web/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:acp_web/providers/providers.dart';

class ContenedoresPagosAnticipados extends StatefulWidget {
  const ContenedoresPagosAnticipados({super.key});

  @override
  State<ContenedoresPagosAnticipados> createState() => _ContenedoresPagosAnticipadosState();
}

class _ContenedoresPagosAnticipadosState extends State<ContenedoresPagosAnticipados> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width / 1440;

    final SeleccionaPagosanticipadosProvider provider = Provider.of<SeleccionaPagosanticipadosProvider>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: width * 432,
          height: 200,
          constraints: const BoxConstraints(minWidth: 400),
          decoration: BoxDecoration(
            color: const Color(0xFFE5ECF6),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Wrap(
              runSpacing: 16,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Ganancias',
                      style: AppTheme.of(context).title3,
                    ),
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(
                          Icons.monetization_on_outlined,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Monto de Facturación',
                          style: AppTheme.of(context).bodyText1,
                        ),
                        Text(
                          'GTQ ${moneyFormat(provider.montoFacturacion)}',
                          style: AppTheme.of(context).title2,
                        ),
                      ],
                    ),
                    Container(color: AppTheme.of(context).secondaryText, width: 1, height: 55),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CxP',
                          style: AppTheme.of(context).bodyText1,
                        ),
                        Text(
                          '${provider.cantidadFacturasSeleccionadas} de ${provider.cantidadFacturas}',
                          style: AppTheme.of(context).title2,
                        ),
                      ],
                    ),
                    Container(color: AppTheme.of(context).secondaryText, width: 1, height: 55),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total de pagos',
                          style: AppTheme.of(context).bodyText1,
                        ),
                        Text(
                          'GTQ ${moneyFormat(provider.totalPagos)}',
                          style: AppTheme.of(context).title2,
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Ganancias calculadas de los ultimos 30 dias',
                      style: AppTheme.of(context).bodyText2,
                    ),
                    Container(
                      height: 30,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        Container(
          width: width * 432,
          height: 200,
          constraints: const BoxConstraints(minWidth: 400),
          decoration: BoxDecoration(
            color: const Color(0xFFE3F5FF),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Wrap(
              runSpacing: 16,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Facturas Seleccionadas',
                      style: AppTheme.of(context).title3,
                    ),
                    Wrap(
                      spacing: 16,
                      children: [
                        Tooltip(
                          message: 'Actualización de Cuentas',
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(4),
                              child: Icon(
                                Icons.sync,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                        Tooltip(
                          message: 'Selección Automatica',
                          child: InkWell(
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(4),
                                child: Icon(
                                  Icons.flash_auto_outlined,
                                  size: 20,
                                ),
                              ),
                            ),
                            onTap: () async {
                              await provider.seleccionAutomatica();
                            },
                          ),
                        ),
                        Tooltip(
                          message: 'Ejecutar',
                          child: InkWell(
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(4),
                                child: Icon(
                                  Icons.play_arrow_outlined,
                                  size: 20,
                                ),
                              ),
                            ),
                            onTap: () async {
                              if (provider.ejecBloq) {
                                const SnackBar(
                                  content: Text('Proceso ejecutandose.'),
                                );
                              } else {
                                if (provider.fondoDisponibleRestante < 0) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('El fondo disponible restante no puede ser menor a 0.'),
                                    ),
                                  );
                                } else if (provider.cantidadFacturasSeleccionadas == 0) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Debe de seleccionar por lo menos una cuenta para realizar este proceso.'),
                                    ),
                                  );
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return StatefulBuilder(
                                        builder: (context, setState) {
                                          return const PopUpEjecucion();
                                        },
                                      );
                                    },
                                  );
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Fondo Disponible Restante',
                          style: AppTheme.of(context).bodyText1,
                        ),
                        Text(
                          'GTQ ${moneyFormat(provider.fondoDisponibleRestante)}',
                          style: AppTheme.of(context).title2.override(
                                fontFamily: AppTheme.of(context).title2Family,
                                useGoogleFonts: false,
                                color: provider.fondoDisponibleRestante < 0 ? AppTheme.of(context).red : AppTheme.of(context).primaryText,
                              ),
                        ),
                      ],
                    ),
                    Container(color: AppTheme.of(context).secondaryText, width: 1, height: 55),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Beneficio Total',
                          style: AppTheme.of(context).bodyText1,
                        ),
                        Text(
                          'GTQ ${moneyFormat(provider.beneficioTotal)}',
                          style: AppTheme.of(context).title2,
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Fondo disponible:',
                      style: AppTheme.of(context).subtitle1,
                    ),
                    Container(
                      width: 185,
                      height: 30,
                      decoration: BoxDecoration(
                        color: AppTheme.of(context).primaryBackground,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 4),
                        child: TextField(
                          //enabled: monedaSeleccionada != null,
                          controller:
                              provider.controllerFondoDispFake.text.isEmpty || provider.controllerFondoDispFake.text == '0.00' ? provider.controllerFondoDispFake : provider.controllerFondoDisp,
                          keyboardType: TextInputType.number, // Asegura que el teclado sea numérico.
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly, // Solo permite dígitos.
                          ],
                          style: AppTheme.of(context).subtitle1.override(
                                fontFamily: AppTheme.of(context).subtitle1Family,
                                useGoogleFonts: false,
                              ),
                          decoration: InputDecoration(
                            hintText: 'Captura Fondo',
                            hintStyle: AppTheme.of(context).bodyText2.override(
                                  fontFamily: AppTheme.of(context).bodyText2Family,
                                  useGoogleFonts: false,
                                  color: AppTheme.of(context).secondaryText,
                                ),
                            border: InputBorder.none,
                            prefixText: '',
                            prefixStyle: AppTheme.of(context).subtitle1,
                          ),
                          onChanged: (value) {
                            if (value.isEmpty || value == '0.00') {
                              provider.controllerFondoDisp.text = '0.00';
                              provider.controllerFondoDispFake.text = '';

                              provider.fondoDisponibleRestante = double.parse((provider.controllerFondoDisp.numberValue - provider.totalPagos).toStringAsFixed(2));
                            } else {
                              if (value.length == 1) {
                                if (value == '0') {
                                  provider.controllerFondoDisp.text = '0.00';
                                  provider.controllerFondoDispFake.text = '';
                                } else {
                                  provider.controllerFondoDispFake.text = value;
                                  provider.controllerFondoDisp.text = '0.0$value';
                                }
                              } else {
                                provider.controllerFondoDisp.text = value;
                              }

                              provider.controllerFondoDisp.selection = TextSelection.collapsed(offset: provider.controllerFondoDisp.text.length);

                              provider.fondoDisponibleRestante = double.parse((provider.controllerFondoDisp.numberValue - provider.totalPagos).toStringAsFixed(2));
                            }

                            setState(() {});
                          },
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
