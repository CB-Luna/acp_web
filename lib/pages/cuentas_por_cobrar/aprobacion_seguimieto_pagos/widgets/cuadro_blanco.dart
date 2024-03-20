import 'package:acp_web/functions/money_format.dart';
import 'package:acp_web/functions/month_name.dart';
import 'package:acp_web/helpers/globals.dart';
import 'package:acp_web/models/cuentas_por_cobrar/aprobacion_seguimineto_pagos_view.dart';
import 'package:acp_web/pages/cuentas_por_cobrar/aprobacion_seguimieto_pagos/widgets/popup_aprobacion_seguimiento_pagos.dart';
import 'package:acp_web/providers/cuentas_por_cobrar/aprobacion_seguimiento_pagos_provider.dart';
import 'package:acp_web/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:provider/provider.dart';

class CuadroBlanco extends StatefulWidget {
  const CuadroBlanco({
    super.key,
    required this.propuesta,
  });
  final Propuesta propuesta;

  @override
  State<CuadroBlanco> createState() => _CuadroBlancoState();
}

class _CuadroBlancoState extends State<CuadroBlanco> with SingleTickerProviderStateMixin {
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

  late PlutoGridStateManager stateManager;

  @override
  Widget build(BuildContext context) {
    final AprobacionSeguimientoPagosProvider provider = Provider.of<AprobacionSeguimientoPagosProvider>(context);
    double width = MediaQuery.of(context).size.width / 1440;
    //double height = MediaQuery.of(context).size.height / 1024;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: widget.propuesta.isExpanded == true
              ? AppTheme.of(context).secondaryBackground
              : AppTheme.themeMode == ThemeMode.light
                  ? const Color(0xFFF7F9FB)
                  : const Color(0xFFD9D9D9),
          borderRadius: const BorderRadius.all(
            Radius.circular(16),
          ),
        ),
        child: ExpansionPanelList(
          expandedHeaderPadding: EdgeInsets.zero,
          elevation: 0,
          children: [
            ExpansionPanel(
              backgroundColor: Colors.transparent,
              canTapOnHeader: true,
              headerBuilder: (context, expanded) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //Fecha facturacion
                      SizedBox(
                        width: width * 135,
                        child: Text(
                          '${monthName(widget.propuesta.mes)} ${widget.propuesta.dia}',
                          style: AppTheme.of(context).subtitle1,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                      //Descripcion
                      SizedBox(
                        width: width * 200,
                        child: Text(
                          widget.propuesta.estatus == 2
                              ? 'Propuesta de Pago Anticipado'
                              : widget.propuesta.estatus == 3
                                  ? 'Propuesta de Pago Anticipado'
                                  : widget.propuesta.estatus == 4
                                      ? 'Propuesta de Pago Anticipado'
                                      : widget.propuesta.estatus == 5
                                          ? 'Propuesta de Pago Anticipado'
                                          : 'Propuesta de Pago Anticipado',
                          style: AppTheme.of(context).subtitle1,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                      //anticipo
                      SizedBox(
                        width: width * 135,
                        child: Row(
                          children: [
                            Text(
                              '${widget.propuesta.moneda} ${moneyFormat(widget.propuesta.sumAnticipo!)}',
                              style: AppTheme.of(context).subtitle1.override(
                                    fontFamily: AppTheme.of(context).subtitle1Family,
                                    useGoogleFonts: false,
                                    color: AppTheme.of(context).primaryColor,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      //comision
                      SizedBox(
                        width: width * 130,
                        child: Row(
                          children: [
                            Text(
                              '${widget.propuesta.moneda} ${moneyFormat(widget.propuesta.sumComision!)}',
                              style: AppTheme.of(context).subtitle1.override(
                                    fontFamily: AppTheme.of(context).subtitle1Family,
                                    useGoogleFonts: false,
                                    color: AppTheme.of(context).purple,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      //Estatus
                      Container(
                        width: width * 122,
                        height: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: widget.propuesta.estatus == 2 || widget.propuesta.estatus == 7 || widget.propuesta.estatus == 8 || widget.propuesta.estatus == 9 || widget.propuesta.estatus == 10
                              ? AppTheme.of(context).yellow
                              : widget.propuesta.estatus == 3
                                  ? AppTheme.of(context).tertiaryColor
                                  : widget.propuesta.estatus == 4
                                      ? AppTheme.of(context).green
                                      : AppTheme.of(context).red,
                        ),
                        child: Center(
                          child: Text(
                            widget.propuesta.estatus == 2
                                ? 'Anexo Pendiente'
                                : widget.propuesta.estatus == 3
                                    ? 'Aprobada'
                                    : widget.propuesta.estatus == 4
                                        ? 'Pagada'
                                        : widget.propuesta.estatus == 5
                                            ? 'Rechazada'
                                            : widget.propuesta.estatus == 6
                                                ? 'Cancelada'
                                                : widget.propuesta.estatus == 7
                                                    ? 'Autoización Solicitud'
                                                    : widget.propuesta.estatus == 8
                                                        ? 'Por Validar'
                                                        : widget.propuesta.estatus == 9
                                                            ? 'SAP en Proceso'
                                                            : 'Pago En Proceso',
                            textAlign: TextAlign.center,
                            style: AppTheme.of(context).subtitle1.override(
                                  fontFamily: AppTheme.of(context).subtitle1Family,
                                  useGoogleFonts: false,
                                  color: AppTheme.of(context).tertiaryText,
                                ),
                            overflow: TextOverflow.fade,
                          ),
                        ),
                      ),
                      //Acciones
                      SizedBox(
                        width: width * 120,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            //Cargar Anexo
                            if (widget.propuesta.estatus == 2) // && provider.doc==true
                              IconButton(
                                tooltip: 'Cargar Anexo',
                                onPressed: () async {
                                  await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return PopupAprobacionSeguimientoPagos(
                                        propuesta: widget.propuesta,
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(Icons.file_open),
                                color: AppTheme.of(context).primaryColor,
                              ),
                            //Ver Anexo
                            if (widget.propuesta.estatus == 3)
                              IconButton(
                                onPressed: () async {
                                  await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return PopupAprobacionSeguimientoPagos(
                                        propuesta: widget.propuesta,
                                      );
                                    },
                                  );
                                },
                                tooltip: 'Ver Anexo',
                                icon: const Icon(Icons.picture_as_pdf),
                                color: AppTheme.of(context).primaryColor,
                              ),
                            //Ver Factura
                            if (widget.propuesta.estatus == 4)
                              IconButton(
                                tooltip: 'Ver Factura',
                                onPressed: () async {
                                  await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return PopupAprobacionSeguimientoPagos(
                                        propuesta: widget.propuesta,
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(Icons.receipt_long),
                                color: AppTheme.of(context).primaryColor,
                              ),
                            //Descargar Excel
                            IconButton(
                              tooltip: 'Descargar Listado Excel',
                              onPressed: () async {
                               await provider.aprobacionseguimientoExcel(widget.propuesta);
                              },
                              icon: const Icon(Icons.download),
                              color: AppTheme.of(context).primaryColor,
                            ),
                            //Descargar Anexo
                            if (widget.propuesta.estatus == 3 || widget.propuesta.estatus == 4 || widget.propuesta.estatus == 5 || widget.propuesta.estatus == 6)
                              IconButton(
                                tooltip: 'Descargar',
                                onPressed: () {},
                                icon: const Icon(Icons.file_download_outlined),
                                color: AppTheme.of(context).primaryColor,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
              body: SizedBox(
                height: 300,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PlutoGrid(
                    key: UniqueKey(),
                    configuration: PlutoGridConfiguration(
                      localeText: const PlutoGridLocaleText.spanish(),
                      scrollbar: plutoGridScrollbarConfig(context),
                      style: plutoGridPopUpStyleConfig(context),
                    ),
                    columns: [
                      if (widget.propuesta.estatus == 2)
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
                        title: 'Beneficio',
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
                    ],
                    rows: widget.propuesta.rows!,
                    createFooter: (stateManager) {
                      stateManager.setPageSize(100, notify: false);
                      return const SizedBox();
                    },
                    onLoaded: (event) async {
                      stateManager = event.stateManager;
                    },
                    onRowChecked: (event) async {
                      provider.facturasSeleccionadas(widget.propuesta.dia, widget.propuesta.mes);
                    },
                  ),
                ),
              ),
              isExpanded: widget.propuesta.isExpanded,
            ),
          ],
          expansionCallback: (panelIndex, isExpanded) {
            setState(() {
              widget.propuesta.isExpanded = !widget.propuesta.isExpanded;
            });
          },
        ),
      ),
    );
  }
}
