import 'package:acp_web/functions/money_format.dart';
import 'package:acp_web/functions/money_format_3_decimals.dart';
import 'package:acp_web/helpers/globals.dart';
import 'package:acp_web/models/autorizacion_solicitudes_pago_anticipado/autorizacion_solicitudes_pago_anticipado_model.dart';
import 'package:acp_web/pages/widgets/custom_image_container.dart';
import 'package:acp_web/providers/providers.dart';
import 'package:acp_web/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:provider/provider.dart';

class CustomListCard extends StatefulWidget {
  const CustomListCard({
    super.key,
    required this.moneda,
    required this.cliente,
  });

  final AutorizacionSolicitudesPagoanticipado cliente;
  final String moneda;

  @override
  State<CustomListCard> createState() => _CustomListCardState();
}

class _CustomListCardState extends State<CustomListCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late PlutoGridStateManager stateManager;

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
    double porcentajeSeleccionadas = widget.cliente.facturasSeleccionadas! * 100 / widget.cliente.facturas!.length;

    final AutorizacionAolicitudesPagoAnticipadoProvider provider = Provider.of<AutorizacionAolicitudesPagoAnticipadoProvider>(context);

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
                            Tooltip(
                              message: 'Seleccionar',
                              child: InkWell(
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: Icon(
                                      widget.cliente.facturasSeleccionadas! == widget.cliente.rows!.length ? Icons.check_box : Icons.check_box_outline_blank,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                onTap: () async {
                                  //Ya están marcadas todas
                                  if (widget.cliente.facturasSeleccionadas! == widget.cliente.rows!.length) {
                                    provider.checkClient(widget.cliente.nombreFiscal!, false);
                                  } else {
                                    provider.checkClient(widget.cliente.nombreFiscal!, true);
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            ImageContainer(imageUrl: widget.cliente.logoUrl, size: 20),
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
                            /* Text(
                              'Facturas Seleccionadas:',
                              style: AppTheme.of(context).subtitle1.override(
                                    fontFamily: 'Gotham',
                                    useGoogleFonts: false,
                                  ),
                            ), */
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
                            /* Text(
                              'Facturación:',
                              style: AppTheme.of(context).subtitle1.override(
                                    fontFamily: 'Gotham',
                                    useGoogleFonts: false,
                                  ),
                            ), */
                            Text(
                              'GTQ ${moneyFormat(widget.cliente.facturacion!)}',
                              style: AppTheme.of(context).subtitle1.override(
                                    fontFamily: 'Gotham',
                                    useGoogleFonts: false,
                                    color: AppTheme.of(context).tertiaryColor,
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
                            /* Text(
                              'Pago Adelantado:',
                              style: AppTheme.of(context).subtitle1.override(
                                    fontFamily: 'Gotham',
                                    useGoogleFonts: false,
                                  ),
                            ), */
                            Text(
                              'GTQ ${moneyFormat(widget.cliente.pagoAdelantado!)}',
                              style: AppTheme.of(context).subtitle1.override(
                                    fontFamily: 'Gotham',
                                    useGoogleFonts: false,
                                    color: AppTheme.of(context).primaryColor,
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
                      onLoaded: (event) async {
                        stateManager = event.stateManager;
                      },
                      onRowChecked: (event) async {
                        await provider.updateClientRows(widget.cliente.nombreFiscal!);
                      },
                      onChanged: (event) async {
                        await provider.updateClientRows(widget.cliente.nombreFiscal!);
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