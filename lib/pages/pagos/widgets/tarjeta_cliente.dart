import 'package:acp_web/functions/day_month_format.dart';
import 'package:acp_web/functions/money_format.dart';
import 'package:acp_web/functions/money_format_3_decimals.dart';
import 'package:acp_web/helpers/globals.dart';
import 'package:acp_web/models/pagos/pagos_model.dart';
import 'package:acp_web/pages/pagos/widgets/pop_up_validacion_anexo.dart';
import 'package:acp_web/pages/widgets/custom_hover_icon.dart';
import 'package:acp_web/pages/widgets/custom_image_container.dart';
import 'package:acp_web/providers/providers.dart';
import 'package:acp_web/services/api_error_handler.dart';
import 'package:acp_web/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:provider/provider.dart';

class TarjetaCliente extends StatefulWidget {
  const TarjetaCliente({
    super.key,
    required this.cliente,
  });

  final Cliente cliente;

  @override
  State<TarjetaCliente> createState() => _TarjetaClienteState();
}

class _TarjetaClienteState extends State<TarjetaCliente> {
  late PlutoGridStateManager stateManager;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width / 1440;
    //double height = MediaQuery.of(context).size.height / 1024;
    final PagosProvider provider = Provider.of<PagosProvider>(context);

    String monedaSeleccionada = 'GTQ';

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: widget.cliente.isExpanded == true
              ? AppTheme.of(context).secondaryBackground
              : AppTheme.themeMode == ThemeMode.light
                  ? const Color(0xFFF7F9FB)
                  : const Color(0xFFD9D9D9),
        ),
        child: ExpansionPanelList(
          expandedHeaderPadding: EdgeInsets.zero,
          elevation: 0,
          expansionCallback: (panelIndex, isExpanded) {
            setState(() {
              widget.cliente.isExpanded = !widget.cliente.isExpanded;
            });
          },
          children: [
            ExpansionPanel(
              backgroundColor: Colors.transparent,
              canTapOnHeader: true,
              isExpanded: widget.cliente.isExpanded,
              headerBuilder: (context, expanded) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 6,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: width * 55,
                        child: Text(
                          widget.cliente.anexoId != null ? widget.cliente.anexoId!.toString() : 'Pendiente',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        width: width * 111,
                        child: Row(
                          children: [
                            ClientImageContainer(imageName: widget.cliente.logo, size: 20),
                            const SizedBox(width: 5),
                            SizedBox(
                              width: width * 90,
                              //height: 50,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    widget.cliente.nombreFiscal!,
                                    style: AppTheme.of(context).subtitle1,
                                    overflow: TextOverflow.fade,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: width * 61,
                        child: Text(
                          widget.cliente.cuentasAnticipadas.toString(),
                          style: AppTheme.of(context).subtitle1,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        width: width * 70,
                        child: Text(
                          dayMothFormat(widget.cliente.fechaPropuesta!),
                          style: AppTheme.of(context).subtitle1,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        width: width * 130,
                        child: Text(
                          '$monedaSeleccionada ${moneyFormat(widget.cliente.anticipo!)}',
                          style: AppTheme.of(context).subtitle1.override(
                                fontFamily: AppTheme.of(context).subtitle1Family,
                                useGoogleFonts: false,
                                color: AppTheme.of(context).secondaryColor,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        width: width * 108,
                        child: Text(
                          '$monedaSeleccionada ${moneyFormat(widget.cliente.comision!)}',
                          style: AppTheme.of(context).subtitle1.override(
                                fontFamily: AppTheme.of(context).subtitle1Family,
                                useGoogleFonts: false,
                                color: AppTheme.of(context).purple,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        width: width * 90,
                        child: Text(
                          widget.cliente.fechaPago != null ? dayMothFormat(widget.cliente.fechaPago!) : 'Pendiente',
                          style: AppTheme.of(context).subtitle1,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        width: width * 122,
                        height: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: AppTheme.of(context).yellow,
                        ),
                        child: Center(
                          child: Text(
                            widget.cliente.estatus!,
                            style: AppTheme.of(context).subtitle1.override(
                                  fontFamily: AppTheme.of(context).subtitle1Family,
                                  useGoogleFonts: false,
                                  color: AppTheme.of(context).tertiaryText,
                                ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: width * 79,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (widget.cliente.anexoDoc != null && widget.cliente.estatusId == 8)
                              Tooltip(
                                message: 'Validar',
                                child: CustomHoverIcon(
                                  icon: Icons.edit_square,
                                  size: 20,
                                  onTap: () async {
                                    await provider.pickAnexoDoc(widget.cliente.anexoDoc!);

                                    // ignore: use_build_context_synchronously
                                    await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return PopUpValidacionAnexo(
                                          cliente: widget.cliente,
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            if (widget.cliente.anexoDoc != null)
                              Tooltip(
                                message: 'Descargar',
                                child: CustomHoverIcon(
                                  icon: Icons.file_download_outlined,
                                  size: 20,
                                  onTap: () async {
                                    await provider.descargarAnexo(widget.cliente.anexoDoc!);
                                  },
                                ),
                              ),
                            if (widget.cliente.estatusId == 2)
                              Tooltip(
                                message: 'Cancelar Propuesta',
                                child: CustomHoverIcon(
                                  icon: Icons.cancel_schedule_send_outlined,
                                  size: 20,
                                  onTap: () async {
                                    int resp = await provider.cancelarPropuesta(widget.cliente.facturas!);
                                    if (resp == 1) {
                                      ApiErrorHandler.callToast('Error al realizar el proceso');
                                    } else if (resp == 2) {
                                      ApiErrorHandler.callToast('El anexo ya ha sido cargado');
                                    } else {
                                      ApiErrorHandler.callToast(
                                        'Propuesta cancelada con exito',
                                        // ignore: use_build_context_synchronously
                                        '#${AppTheme.of(context).green.value.toRadixString(16)}',
                                      );
                                    }
                                  },
                                ),
                              ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: widget.cliente.rows!.length * 60 + 55,
                  constraints: BoxConstraints(maxHeight: 500),
                  child: PlutoGrid(
                    key: UniqueKey(),
                    configuration: PlutoGridConfiguration(
                      localeText: const PlutoGridLocaleText.spanish(),
                      scrollbar: plutoGridScrollbarConfig(context),
                      style: plutoGridPopUpStyleConfig(context),
                    ),
                    columns: [
                      /*  PlutoColumn(
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
                        field: 'comision_porc_field',
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
                        field: 'comision_cant_field',
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
                        enableEditingMode: false,
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
                    onLoaded: (event) async {
                      stateManager = event.stateManager;
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
