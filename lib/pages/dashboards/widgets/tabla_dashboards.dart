import 'package:acp_web/providers/dashboards/dashboards_provider.dart';
import 'package:acp_web/theme/theme.dart';
import 'package:acp_web/functions/money_format.dart';
import 'package:acp_web/helpers/globals.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:provider/provider.dart';

class TablaDashboards extends StatefulWidget {
  const TablaDashboards({
    super.key,
  });
  @override
  State<TablaDashboards> createState() => _TablaDashboardsState();
}

class _TablaDashboardsState extends State<TablaDashboards> {
  late PlutoGridStateManager stateManager;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width / 1440;
    double height = MediaQuery.of(context).size.height / 1024;

    final DashboardsProvider provider = Provider.of<DashboardsProvider>(context);

    return Container(
      width: width * 800, //width * 490,
      height: height * 224,
      constraints: const BoxConstraints(minWidth: 400),
      decoration: BoxDecoration(
        color: AppTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              'Clientes con más Comisión',
              style: AppTheme.of(context).title2,
            ),
            //Cambiar por Tabla
            SizedBox(
              //width: width * 490,
              height: height * 168,
              child: PlutoGrid(
                key: UniqueKey(),
                configuration: PlutoGridConfiguration(
                  localeText: const PlutoGridLocaleText.spanish(),
                  scrollbar: plutoGridScrollbarConfig(context),
                  style: plutoGridPopUpStyleConfig(context),
                ),
                columns: [
                  /* PlutoColumn(
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
                  ), */
                  PlutoColumn(
                    title: 'Cliente',
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
                            'Cliente',
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
                    title: 'Moneda',
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
                            'Moneda',
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
                    title: 'Tasa',
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
                            'Tasa',
                            style: AppTheme.of(context).bodyText2.override(
                                  fontFamily: AppTheme.of(context).bodyText2Family,
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
                    title: '% Comisión',
                    titleTextAlign: PlutoColumnTextAlign.center,
                    textAlign: PlutoColumnTextAlign.center,
                    field: 'comision_cant_field',
                    type: PlutoColumnType.text(),
                    enableEditingMode: false,
                    titleSpan: TextSpan(
                      children: [
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Text(
                            '% Comisión',
                            style: AppTheme.of(context).bodyText2.override(
                                  fontFamily: AppTheme.of(context).bodyText2Family,
                                  useGoogleFonts: false,
                                  color: AppTheme.of(context).green,
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
                                color: AppTheme.of(context).green,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                  ),
                  PlutoColumn(
                    width: width * 160,
                    title: 'Suma de Importe en moneda',
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
                            'Suma de Importe en moneda',
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
                ],
                rows: provider.rows,
                createFooter: (stateManager) {
                  stateManager.setPageSize(100, notify: false);
                  return const SizedBox();
                },
                onLoaded: (event) async {
                  stateManager = event.stateManager;
                },
                onRowChecked: (event) async {
                  // provider.facturasSeleccionadas(widget.propuesta.dia, widget.propuesta.mes);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
