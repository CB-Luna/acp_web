import 'package:acp_web/functions/money_format.dart';
import 'package:acp_web/helpers/globals.dart';
import 'package:acp_web/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

class CustomListCard extends StatefulWidget {
  const CustomListCard({
    super.key,
    required this.nombreCliente,
    required this.moneda,
    required this.facturacion,
    required this.beneficio,
    required this.pagoAdelantado,
    required this.cantidadFacturas,
    required this.cantidadFacturasSeleccionadas,
  });

  final String nombreCliente;
  final String moneda;
  final double facturacion;
  final double beneficio;
  final double pagoAdelantado;
  final int cantidadFacturas;
  final int cantidadFacturasSeleccionadas;

  @override
  State<CustomListCard> createState() => _CustomListCardState();
}

class _CustomListCardState extends State<CustomListCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<PlutoGridStateManager> listStateManager;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool opened = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width / 1440;
    //double height = MediaQuery.of(context).size.height / 1024;
    double porcentajeSeleccionadas = widget.cantidadFacturasSeleccionadas * 100 / widget.cantidadFacturas;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ExpansionPanelList(
        expandedHeaderPadding: EdgeInsets.zero,
        elevation: 0,
        children: [
          ExpansionPanel(
            canTapOnHeader: true,
            headerBuilder: (context, expanded) {
              return Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(6),
                    topRight: const Radius.circular(6),
                    bottomRight: opened ? Radius.zero : const Radius.circular(6),
                    bottomLeft: opened ? Radius.zero : const Radius.circular(6),
                  ),
                  color: opened == true
                      ? AppTheme.of(context).secondaryColor
                      : AppTheme.themeMode == ThemeMode.light
                          ? AppTheme.of(context).secondaryText
                          : Colors.grey,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
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
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red,
                              ),
                            ),
                            const SizedBox(width: 5),
                            SizedBox(
                              width: width * 135,
                              child: Text(
                                widget.nombreCliente,
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
                            /* Text(
                              'Facturas Seleccionadas:',
                              style: AppTheme.of(context).subtitle1.override(
                                    fontFamily: 'Gotham',
                                    useGoogleFonts: false,
                                  ),
                            ), */
                            Text(
                              widget.cantidadFacturasSeleccionadas.toString(),
                              style: AppTheme.of(context).subtitle1.override(
                                    fontFamily: 'Gotham',
                                    useGoogleFonts: false,
                                    color: porcentajeSeleccionadas < 50
                                        ? Colors.red
                                        : porcentajeSeleccionadas < 75
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
                              widget.cantidadFacturas.toString(),
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
                            /* Text(
                              'Facturación:',
                              style: AppTheme.of(context).subtitle1.override(
                                    fontFamily: 'Gotham',
                                    useGoogleFonts: false,
                                  ),
                            ), */
                            Text(
                              'GTQ ${moneyFormat(widget.facturacion)}',
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
                            /*  Text(
                              'Beneficio:',
                              style: AppTheme.of(context).subtitle1.override(
                                    fontFamily: 'Gotham',
                                    useGoogleFonts: false,
                                  ),
                            ), */
                            Text(
                              'GTQ ${moneyFormat(widget.beneficio)}',
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
                            /* Text(
                              'Pago Adelantado:',
                              style: AppTheme.of(context).subtitle1.override(
                                    fontFamily: 'Gotham',
                                    useGoogleFonts: false,
                                  ),
                            ), */
                            Text(
                              'GTQ ${moneyFormat(widget.pagoAdelantado)}',
                              style: AppTheme.of(context).subtitle1.override(
                                    fontFamily: 'Gotham',
                                    useGoogleFonts: false,
                                    color: AppTheme.of(context).tertiaryColor,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            body: Container(
              height: 300,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.zero,
                  topRight: Radius.circular(6),
                  bottomRight: Radius.circular(6),
                  bottomLeft: Radius.circular(6),
                ),
                color: AppTheme.of(context).secondaryColor,
              ),
              child: Row(
                children: [
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
                          title: 'ID Partida',
                          titleTextAlign: PlutoColumnTextAlign.center,
                          textAlign: PlutoColumnTextAlign.center,
                          field: 'id_partida',
                          type: PlutoColumnType.text(),
                          width: 0,
                          hide: true,
                          enableColumnDrag: false,
                          enableEditingMode: false,
                          renderer: (rendererContext) {
                            return Text(
                              rendererContext.cell.value.toString(),
                              style: AppTheme.of(context).contenidoTablas.override(
                                    fontFamily: 'Gotham-Light',
                                    useGoogleFonts: false,
                                    color: AppTheme.of(context).primaryColor,
                                  ),
                            );
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
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppTheme.of(context).primaryColor,
                              ),
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                  child: Text(
                                    '${rendererContext.row.cells["moneda_field"]!.value} ${moneyFormat(rendererContext.cell.value)}',
                                    style: AppTheme.of(context).contenidoTablas,
                                    textAlign: TextAlign.center,
                                  )),
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
                                        color: AppTheme.of(context).primaryColor,
                                      ),
                                ),
                              ),
                            ],
                          ),
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
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color(0XFF262626),
                              ),
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                  child: Text(
                                    '${moneyFormat(rendererContext.cell.value)} %',
                                    style: AppTheme.of(context).contenidoTablas.override(
                                          useGoogleFonts: false,
                                          fontFamily: 'Gotham-Light',
                                          color: Colors.white,
                                        ),
                                    textAlign: TextAlign.center,
                                  )),
                            );
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
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppTheme.of(context).tertiaryColor,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                child: Text(
                                  '${rendererContext.row.cells["moneda_field"]!.value} ${moneyFormat(rendererContext.cell.value)}',
                                  style: AppTheme.of(context).contenidoTablas.override(
                                        useGoogleFonts: false,
                                        fontFamily: 'Gotham-Light',
                                        color: Colors.white,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
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
                                        color: AppTheme.of(context).tertiaryColor,
                                      ),
                                ),
                              ),
                            ],
                          ),
                          renderer: (rendererContext) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppTheme.of(context).secondaryColor,
                              ),
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                  child: Text(
                                    '${rendererContext.row.cells["moneda_field"]!.value} ${moneyFormat(rendererContext.cell.value)}',
                                    style: AppTheme.of(context).contenidoTablas,
                                    textAlign: TextAlign.center,
                                  )),
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
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppTheme.of(context).secondaryColor,
                              ),
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                  child: Text(
                                    '${rendererContext.row.cells["moneda_field"]!.value} ${moneyFormat(rendererContext.cell.value)}',
                                    style: AppTheme.of(context).contenidoTablas,
                                    textAlign: TextAlign.center,
                                  )),
                            );
                          },
                        ),
                      ],
                      rows: [],
                      createFooter: (stateManager) {
                        stateManager.setPageSize(100, notify: false);
                        return SizedBox();
                      },
                      onLoaded: (event) async {
                        listStateManager.add(event.stateManager);
                      },
                      onRowChecked: (event) async {
                        //await provider.addCarrito();
                      },
                    ),
                  ),
                ],
              ),
            ),
            isExpanded: opened,
          ),
        ],
        expansionCallback: (panelIndex, isExpanded) {
          setState(() {
            opened = !isExpanded;
          });
        },
      ),
    );
  }
}
