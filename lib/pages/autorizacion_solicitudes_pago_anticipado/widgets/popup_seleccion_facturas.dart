import 'package:acp_web/functions/money_format.dart';
import 'package:acp_web/functions/money_format_3_decimals.dart';
import 'package:acp_web/helpers/globals.dart';
import 'package:acp_web/models/autorizacion_solicitudes_pago_anticipado/autorizacion_solicitudes_pago_anticipado_model.dart';
import 'package:acp_web/pages/widgets/custom_image_container.dart';
import 'package:acp_web/providers/providers.dart';
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

  final AutorizacionSolicitudesPagoanticipado cliente;
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

    final AutorizacionAolicitudesPagoAnticipadoProvider provider = Provider.of<AutorizacionAolicitudesPagoAnticipadoProvider>(context);

    return AlertDialog(
      backgroundColor: Colors.transparent,
      content: SizedBox(
        width: width * 1100,
        height: height * 435,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
                            size: 25,
                            color: AppTheme.of(context).primaryBackground,
                          ),
                          Text(
                            'Cliente',
                            style: AppTheme.of(context).title3.override(
                                  fontFamily: AppTheme.of(context).title3Family,
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
                            size: 25,
                            color: AppTheme.of(context).primaryBackground,
                          ),
                          Text(
                            'Num. Facturas',
                            style: AppTheme.of(context).title3.override(
                                  fontFamily: AppTheme.of(context).title3Family,
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
                            size: 25,
                            color: AppTheme.of(context).primaryBackground,
                          ),
                          Text(
                            'Facturación',
                            style: AppTheme.of(context).title3.override(
                                  fontFamily: AppTheme.of(context).title3Family,
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
                            size: 25,
                            color: AppTheme.of(context).primaryBackground,
                          ),
                          Text(
                            'Comisión',
                            style: AppTheme.of(context).title3.override(
                                  fontFamily: AppTheme.of(context).title3Family,
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
                            size: 25,
                            color: AppTheme.of(context).primaryBackground,
                          ),
                          Text(
                            'Pago Adelantado',
                            style: AppTheme.of(context).title3.override(
                                  fontFamily: AppTheme.of(context).title3Family,
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
            const SizedBox(height: 16),
            Container(
              width: width * 1100,
              height: height * 338,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: AppTheme.of(context).secondaryBackground,
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //Cliente
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1440 * 160,
                          child: Row(
                            children: [
                              ClientImageContainer(imageName: widget.cliente.logo, size: 20),
                              const SizedBox(width: 5),
                              SizedBox(
                                width: width * 135,
                                child: Text(
                                  widget.cliente.nombreFiscal!,
                                  style: AppTheme.of(context).title3.override(
                                        fontFamily: AppTheme.of(context).title3Family,
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
                                style: AppTheme.of(context).title3.override(
                                      fontFamily: AppTheme.of(context).title3Family,
                                      useGoogleFonts: false,
                                      color: porcentajeSeleccionadas == 0
                                          ? AppTheme.of(context).red
                                          : porcentajeSeleccionadas != 100
                                              ? AppTheme.of(context).yellow
                                              : AppTheme.of(context).green,
                                    ),
                              ),
                              Text(
                                '/',
                                style: AppTheme.of(context).subtitle1,
                              ),
                              Text(
                                widget.cliente.facturas!.length.toString(),
                                style: AppTheme.of(context).title3,
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
                                '${widget.moneda} ${moneyFormat(widget.cliente.facturacion!)}',
                                style: AppTheme.of(context).title3.override(
                                      fontFamily: AppTheme.of(context).title3Family,
                                      useGoogleFonts: false,
                                      color: AppTheme.of(context).tertiaryColor,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        //Comisión
                        SizedBox(
                          width: width * 126,
                          child: Row(
                            children: [
                              /*  Text(
                              'Comisión:',
                              style: AppTheme.of(context).subtitle1.override(
                                    fontFamily: 'Gotham',
                                    useGoogleFonts: false,
                                  ),
                            ), */
                              Text(
                                '${widget.moneda} ${moneyFormat(widget.cliente.beneficio!)}',
                                style: AppTheme.of(context).title3.override(
                                      fontFamily: AppTheme.of(context).title3Family,
                                      useGoogleFonts: false,
                                      color: AppTheme.of(context).green,
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
                                '${widget.moneda} ${moneyFormat(widget.cliente.pagoAdelantado!)}',
                                style: AppTheme.of(context).title3.override(
                                      fontFamily: AppTheme.of(context).title3Family,
                                      useGoogleFonts: false,
                                      color: AppTheme.of(context).primaryColor,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Expanded(
                      child: PlutoGrid(
                        key: UniqueKey(),
                        configuration: PlutoGridConfiguration(
                          localeText: const PlutoGridLocaleText.spanish(),
                          scrollbar: plutoGridScrollbarConfig(context),
                          style: plutoGridPopUpStyleConfig(context),
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
                            width: 180,
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
                            width: 180,
                            titleSpan: TextSpan(
                              children: [
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: Text(
                                    'Importe',
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
                            title: '%Comisión',
                            titleTextAlign: PlutoColumnTextAlign.center,
                            textAlign: PlutoColumnTextAlign.center,
                            field: 'beneficio_porc_field',
                            type: PlutoColumnType.text(),
                            enableEditingMode: false,
                            width: 150,
                            titleSpan: TextSpan(
                              children: [
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: Text(
                                    '%Comisión',
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
                            title: 'Comisión',
                            titleTextAlign: PlutoColumnTextAlign.center,
                            textAlign: PlutoColumnTextAlign.center,
                            field: 'beneficio_cant_field',
                            type: PlutoColumnType.text(),
                            enableEditingMode: false,
                            width: 150,
                            titleSpan: TextSpan(
                              children: [
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: Text(
                                    'Comisión',
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
                            title: 'Pago Anticipado',
                            titleTextAlign: PlutoColumnTextAlign.center,
                            textAlign: PlutoColumnTextAlign.center,
                            field: 'pago_anticipado_field',
                            type: PlutoColumnType.text(),
                            enableEditingMode: false,
                            width: 180,
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
                            width: 100,
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
                            title: 'DAC',
                            titleTextAlign: PlutoColumnTextAlign.center,
                            textAlign: PlutoColumnTextAlign.center,
                            field: 'dias_adicionales_field',
                            type: PlutoColumnType.number(),
                            enableEditingMode: true,
                            width: 100,
                            titleSpan: TextSpan(
                              children: [
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: Tooltip(
                                    message: 'Días Adicionales para Comisión',
                                    child: Text(
                                      'DAC',
                                      style: AppTheme.of(context).bodyText2,
                                    ),
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
                          await provider.updateClientRows(widget.cliente);
                          if (widget.cliente.facturasSeleccionadas == 0) {
                            await provider.blockClient(widget.cliente, false);
                          } else {
                            await provider.blockClient(widget.cliente, true);
                          }
                        },
                        onChanged: (event) async {
                          await provider.updateClientRows(widget.cliente);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
