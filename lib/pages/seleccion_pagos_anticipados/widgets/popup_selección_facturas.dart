import 'package:acp_web/functions/money_format.dart';
import 'package:acp_web/functions/money_format_3_decimals.dart';
import 'package:acp_web/helpers/globals.dart';
import 'package:acp_web/models/seleccion_pagos_anticipados/seleccion_pagos_anticipados_model.dart';
import 'package:acp_web/providers/seleccion_pagos_anticipados/seleccion_pagos_anticipados_provider.dart';
import 'package:acp_web/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:provider/provider.dart';

class PopUpSeleccionfacturas extends StatefulWidget {
  const PopUpSeleccionfacturas({
    super.key,
    required this.moneda,
    required this.cliente,
  });

  final SeleccionPagosAnticipados cliente;
  final String moneda;

  @override
  State<PopUpSeleccionfacturas> createState() => PopUpSeleccionfacturasState();
}

class PopUpSeleccionfacturasState extends State<PopUpSeleccionfacturas> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width / 1440;
    double height = MediaQuery.of(context).size.height / 1024;
    double porcentajeSeleccionadas = widget.cliente.facturasSeleccionadas! * 100 / widget.cliente.facturas!.length;

    final SeleccionaPagosanticipadosProvider provider = Provider.of<SeleccionaPagosanticipadosProvider>(context);

    return AlertDialog(
      backgroundColor: Colors.transparent,
      content: Container(
        width: width * 1100,
        height: height * 338,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppTheme.of(context).secondaryColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //Cliente
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1440 * 160,
                    child: Row(
                      children: [
                        Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppTheme.of(context).primaryColor,
                              width: 1,
                            ),
                          ),
                          child: /* widget.cliente.logoUrl != null ? */ Image.network(widget.cliente.logoUrl!) /* :  */,
                        ),
                        const SizedBox(width: 5),
                        SizedBox(
                          width: width * 135,
                          child: Text(
                            widget.cliente.nombreFiscal!,
                            style: AppTheme.of(context).subtitle1.override(
                                  fontFamily: 'Gotham',
                                  useGoogleFonts: false,
                                ),
                            overflow: TextOverflow.fade,
                          ),
                        ),
                      ],
                    ),
                  ),
                  //Num. Facturas
                  SizedBox(
                    width: width * 190,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Facturas Seleccionadas:',
                          style: AppTheme.of(context).subtitle1.override(
                                fontFamily: 'Gotham',
                                useGoogleFonts: false,
                              ),
                        ),
                        Text(
                          widget.cliente.facturasSeleccionadas!.toString(),
                          style: AppTheme.of(context).subtitle1.override(
                                fontFamily: 'Gotham',
                                useGoogleFonts: false,
                                color: porcentajeSeleccionadas == 0
                                    ? Colors.red
                                    : porcentajeSeleccionadas != 100
                                        ? Colors.amber
                                        : Colors.green,
                              ),
                        ),
                        Text(
                          '/',
                          style: AppTheme.of(context).subtitle1.override(
                                fontFamily: 'Gotham',
                                useGoogleFonts: false,
                              ),
                        ),
                        Text(
                          widget.cliente.facturas!.length.toString(),
                          style: AppTheme.of(context).subtitle1.override(
                                fontFamily: 'Gotham',
                                useGoogleFonts: false,
                              ),
                        ),
                      ],
                    ),
                  ),
                  //Facturación
                  SizedBox(
                    width: width * 160,
                    child: Row(
                      children: [
                        Text(
                          'Facturación:',
                          style: AppTheme.of(context).subtitle1.override(
                                fontFamily: 'Gotham',
                                useGoogleFonts: false,
                              ),
                        ),
                        Text(
                          'GTQ ${moneyFormat(widget.cliente.facturacion!)}',
                          style: AppTheme.of(context).subtitle1.override(
                                fontFamily: 'Gotham',
                                useGoogleFonts: false,
                                color: AppTheme.of(context).primaryColor,
                              ),
                        ),
                      ],
                    ),
                  ),
                  //Beneficio
                  SizedBox(
                    width: width * 126,
                    child: Row(
                      children: [
                        Text(
                          'Beneficio:',
                          style: AppTheme.of(context).subtitle1.override(
                                fontFamily: 'Gotham',
                                useGoogleFonts: false,
                              ),
                        ),
                        Text(
                          'GTQ ${moneyFormat(widget.cliente.beneficio!)}',
                          style: AppTheme.of(context).subtitle1.override(
                                fontFamily: 'Gotham',
                                useGoogleFonts: false,
                                color: Colors.green,
                              ),
                        ),
                      ],
                    ),
                  ),
                  //Pago Anticipado
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1440 * 196,
                    child: Row(
                      children: [
                        Text(
                          'Pago Adelantado:',
                          style: AppTheme.of(context).subtitle1.override(
                                fontFamily: 'Gotham',
                                useGoogleFonts: false,
                              ),
                        ),
                        Text(
                          'GTQ ${moneyFormat(widget.cliente.pagoAdelantado!)}',
                          style: AppTheme.of(context).subtitle1.override(
                                fontFamily: 'Gotham',
                                useGoogleFonts: false,
                                color: AppTheme.of(context).tertiaryColor,
                              ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    child: Icon(
                      Icons.close,
                      size: 25,
                      color: AppTheme.of(context).tertiaryColor,
                    ),
                    onTap: () {
                      context.pop();
                    },
                  ),
                ],
              ),
              Expanded(
                child: PlutoGrid(
                  key: UniqueKey(),
                  configuration: PlutoGridConfiguration(
                    localeText: const PlutoGridLocaleText.spanish(),
                    scrollbar: plutoGridScrollbarConfig(context),
                    style: plutoGridStyleConfig(context),
                  ),
                  columns: [
                    PlutoColumn(
                      title: '',
                      titleTextAlign: PlutoColumnTextAlign.center,
                      textAlign: PlutoColumnTextAlign.center,
                      field: 'id_factura_field',
                      type: PlutoColumnType.text(),
                      width: 55,
                      enableRowChecked: true,
                      enableColumnDrag: false,
                      enableEditingMode: false,
                      enableSetColumnsMenuItem: false,
                      enableFilterMenuItem: false,
                      enableContextMenu: false,
                      enableHideColumnMenuItem: false,
                      enableDropToResize: false,
                      enableSorting: false,
                      renderer: (rendererContext) {
                        return const SizedBox.shrink();
                      },
                    ),
                    PlutoColumn(
                      title: 'Cuenta',
                      titleTextAlign: PlutoColumnTextAlign.center,
                      textAlign: PlutoColumnTextAlign.center,
                      field: 'cuenta_field',
                      type: PlutoColumnType.text(),
                      enableEditingMode: false,
                      titleSpan: TextSpan(
                        children: [
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Text(
                              'Cuenta',
                              style: AppTheme.of(context).subtitle3,
                            ),
                          ),
                        ],
                      ),
                      renderer: (rendererContext) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          child: Text(
                            rendererContext.cell.value,
                            style: AppTheme.of(context).subtitle3,
                            textAlign: TextAlign.center,
                          ),
                        );
                      },
                    ),
                    PlutoColumn(
                      title: 'Importe',
                      titleTextAlign: PlutoColumnTextAlign.center,
                      textAlign: PlutoColumnTextAlign.center,
                      field: 'importe_field',
                      type: PlutoColumnType.text(),
                      enableEditingMode: false,
                      titleSpan: TextSpan(
                        children: [
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Text(
                              'Importe',
                              style: AppTheme.of(context).subtitle3.override(
                                    fontFamily: 'Gotham',
                                    useGoogleFonts: false,
                                    color: AppTheme.of(context).tertiaryColor,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      renderer: (rendererContext) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          child: Text(
                            '${rendererContext.row.cells["moneda_field"]!.value} ${moneyFormat(rendererContext.cell.value)}',
                            style: AppTheme.of(context).subtitle3.override(
                                  fontFamily: 'Gotham',
                                  useGoogleFonts: false,
                                  color: AppTheme.of(context).tertiaryColor,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        );
                      },
                    ),
                    PlutoColumn(
                      title: '%Beneficio',
                      titleTextAlign: PlutoColumnTextAlign.center,
                      textAlign: PlutoColumnTextAlign.center,
                      field: 'beneficio_porc_field',
                      type: PlutoColumnType.text(),
                      enableEditingMode: false,
                      titleSpan: TextSpan(
                        children: [
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Text(
                              '%Beneficio',
                              style: AppTheme.of(context).subtitle3,
                            ),
                          ),
                        ],
                      ),
                      renderer: (rendererContext) {
                        return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            child: Text(
                              '${moneyFormat3Decimals(rendererContext.cell.value * 100)} %',
                              style: AppTheme.of(context).subtitle3,
                              textAlign: TextAlign.center,
                            ));
                      },
                    ),
                    PlutoColumn(
                      title: 'Beneficio',
                      titleTextAlign: PlutoColumnTextAlign.center,
                      textAlign: PlutoColumnTextAlign.center,
                      field: 'beneficio_cant_field',
                      type: PlutoColumnType.text(),
                      enableEditingMode: false,
                      titleSpan: TextSpan(
                        children: [
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Text(
                              'Beneficio',
                              style: AppTheme.of(context).subtitle3.override(
                                    fontFamily: 'Gotham',
                                    useGoogleFonts: false,
                                    color: Colors.green,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      renderer: (rendererContext) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          child: Text(
                            '${rendererContext.row.cells["moneda_field"]!.value} ${moneyFormat(rendererContext.cell.value)}',
                            style: AppTheme.of(context).subtitle3.override(
                                  fontFamily: 'Gotham',
                                  useGoogleFonts: false,
                                  color: Colors.green,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        );
                      },
                    ),
                    PlutoColumn(
                      title: 'Pago Anticipado',
                      titleTextAlign: PlutoColumnTextAlign.center,
                      textAlign: PlutoColumnTextAlign.center,
                      field: 'pago_anticipado_field',
                      type: PlutoColumnType.text(),
                      enableEditingMode: false,
                      titleSpan: TextSpan(
                        children: [
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Text(
                              'Pago Anticipado',
                              style: AppTheme.of(context).subtitle3.override(
                                    fontFamily: 'Gotham',
                                    useGoogleFonts: false,
                                    color: AppTheme.of(context).primaryColor,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      renderer: (rendererContext) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          child: Text(
                            '${rendererContext.row.cells["moneda_field"]!.value} ${moneyFormat(rendererContext.cell.value)}',
                            style: AppTheme.of(context).subtitle3.override(
                                  fontFamily: 'Gotham',
                                  useGoogleFonts: false,
                                  color: AppTheme.of(context).primaryColor,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        );
                      },
                    ),
                    PlutoColumn(
                      title: 'Días para Pago',
                      titleTextAlign: PlutoColumnTextAlign.center,
                      textAlign: PlutoColumnTextAlign.center,
                      field: 'dias_pago_field',
                      type: PlutoColumnType.text(),
                      enableEditingMode: false,
                      titleSpan: TextSpan(
                        children: [
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Text(
                              'Días para Pago',
                              style: AppTheme.of(context).subtitle3,
                            ),
                          ),
                        ],
                      ),
                      renderer: (rendererContext) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          child: Text(
                            rendererContext.cell.value.toString(),
                            style: AppTheme.of(context).subtitle3,
                            textAlign: TextAlign.center,
                          ),
                        );
                      },
                    ),
                    PlutoColumn(
                      title: 'Días Adicionales para Comisión',
                      titleTextAlign: PlutoColumnTextAlign.center,
                      textAlign: PlutoColumnTextAlign.center,
                      field: 'dias_adicionales_field',
                      type: PlutoColumnType.number(),
                      enableEditingMode: true,
                      titleSpan: TextSpan(
                        children: [
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Text(
                              'Días Adicionales para Comisión',
                              style: AppTheme.of(context).subtitle3,
                            ),
                          ),
                        ],
                      ),
                      renderer: (rendererContext) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          child: Text(
                            rendererContext.cell.value.toString(),
                            style: AppTheme.of(context).subtitle3,
                            textAlign: TextAlign.center,
                          ),
                        );
                      },
                    ),
                  ],
                  rows: widget.cliente.rows!,
                  createFooter: (stateManager) {
                    stateManager.setPageSize(100, notify: false);
                    return const SizedBox();
                  },
                  onLoaded: (event) async {},
                  onRowChecked: (event) async {
                    await provider.updateClientRows(widget.cliente.nombreFiscal!);
                  },
                  onChanged: (event) async {
                    await provider.updateClientRows(widget.cliente.nombreFiscal!);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
