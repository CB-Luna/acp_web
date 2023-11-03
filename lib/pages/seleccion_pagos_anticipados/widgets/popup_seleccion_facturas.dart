import 'package:acp_web/functions/money_format.dart';
import 'package:acp_web/functions/money_format_3_decimals.dart';
import 'package:acp_web/helpers/globals.dart';
import 'package:acp_web/models/seleccion_pagos_anticipados/seleccion_pagos_anticipados_model.dart';
import 'package:acp_web/pages/widgets/custom_image_container.dart';
import 'package:acp_web/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:provider/provider.dart';

import 'package:acp_web/providers/providers.dart';

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
      content: SizedBox(
        child: Column(
          children: [
            Container(
              width: width * 1100,
              height: height * 79,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: AppTheme.of(context).primaryColor,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.person,
                            size: 20,
                            color: AppTheme.of(context).primaryBackground,
                          ),
                          Text(
                            'Cliente',
                            style: AppTheme.of(context).subtitle1.override(
                                  fontFamily: 'Gotham',
                                  useGoogleFonts: false,
                                  color: AppTheme.of(context).primaryBackground,
                                ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.content_paste,
                            size: 20,
                            color: AppTheme.of(context).primaryBackground,
                          ),
                          Text(
                            'Num. Facturas',
                            style: AppTheme.of(context).subtitle1.override(
                                  fontFamily: 'Gotham',
                                  useGoogleFonts: false,
                                  color: AppTheme.of(context).primaryBackground,
                                ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.receipt_long,
                            color: AppTheme.of(context).primaryBackground,
                          ),
                          Text(
                            'Facturación',
                            style: AppTheme.of(context).subtitle1.override(
                                  fontFamily: 'Gotham',
                                  useGoogleFonts: false,
                                  color: AppTheme.of(context).primaryBackground,
                                ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.payments_outlined,
                            color: AppTheme.of(context).primaryBackground,
                          ),
                          Text(
                            'Beneficio',
                            style: AppTheme.of(context).subtitle1.override(
                                  fontFamily: 'Gotham',
                                  useGoogleFonts: false,
                                  color: AppTheme.of(context).primaryBackground,
                                ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shopping_bag,
                            color: AppTheme.of(context).primaryBackground,
                          ),
                          Text(
                            'Pago Adelantado',
                            style: AppTheme.of(context).subtitle1.override(
                                  fontFamily: 'Gotham',
                                  useGoogleFonts: false,
                                  color: AppTheme.of(context).primaryBackground,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 65),
                  ],
                ),
              ),
            ),
            Container(
              width: width * 1100,
              height: height * 338,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: AppTheme.of(context).secondaryColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Expanded(
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
                                style: AppTheme.of(context).bodyText2,
                              ),
                            ),
                          ],
                        ),
                        renderer: (rendererContext) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            child: Text(
                              rendererContext.cell.value,
                              style: AppTheme.of(context).bodyText2,
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
                                style: AppTheme.of(context).bodyText2.override(
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
                              style: AppTheme.of(context).bodyText2.override(
                                    fontFamily: AppTheme.of(context).bodyText2Family,
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
                                style: AppTheme.of(context).bodyText2,
                              ),
                            ),
                          ],
                        ),
                        renderer: (rendererContext) {
                          return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                              child: Text(
                                '${moneyFormat3Decimals(rendererContext.cell.value * 100)} %',
                                style: AppTheme.of(context).bodyText2,
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
                                style: AppTheme.of(context).bodyText2.override(
                                      fontFamily: AppTheme.of(context).bodyText2Family,
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
                              style: AppTheme.of(context).bodyText2.override(
                                    fontFamily: AppTheme.of(context).bodyText2Family,
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
                                style: AppTheme.of(context).bodyText2.override(
                                      fontFamily: AppTheme.of(context).bodyText2Family,
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
                              style: AppTheme.of(context).bodyText2.override(
                                    fontFamily: AppTheme.of(context).bodyText2Family,
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
                                style: AppTheme.of(context).bodyText2,
                              ),
                            ),
                          ],
                        ),
                        renderer: (rendererContext) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            child: Text(
                              rendererContext.cell.value.toString(),
                              style: AppTheme.of(context).bodyText2,
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
                                style: AppTheme.of(context).bodyText2,
                              ),
                            ),
                          ],
                        ),
                        renderer: (rendererContext) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            child: Text(
                              rendererContext.cell.value.toString(),
                              style: AppTheme.of(context).bodyText2,
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
