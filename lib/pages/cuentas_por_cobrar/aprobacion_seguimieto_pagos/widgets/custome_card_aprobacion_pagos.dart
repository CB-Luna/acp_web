import 'package:acp_web/functions/money_format.dart';
import 'package:acp_web/helpers/globals.dart';
import 'package:acp_web/providers/cuentas_por_cobrar/aprobacion_seguimiento_pagos_provider.dart';
import 'package:acp_web/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:provider/provider.dart';

class CustomeCardAprobacionPagos extends StatefulWidget {
  const CustomeCardAprobacionPagos({
    super.key,
    required this.fechaEjecucion,
    required this.descripcion,
    required this.estatus,
    required this.moneda,
    required this.anticipo,
    required this.comision,
  });

  final String fechaEjecucion;
  final String descripcion;
  final String estatus;
  final String moneda;
  final double anticipo;
  final double comision;

  @override
  State<CustomeCardAprobacionPagos> createState() => _CustomeCardAprobacionPagosState();
}

class _CustomeCardAprobacionPagosState extends State<CustomeCardAprobacionPagos> with SingleTickerProviderStateMixin {
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
  late PlutoGridStateManager stateManager;

  @override
  Widget build(BuildContext context) {
    final AprobacionSeguimientoPagosProvider provider = Provider.of<AprobacionSeguimientoPagosProvider>(context);
    double width = MediaQuery.of(context).size.width / 1440;
    //double height = MediaQuery.of(context).size.height / 1024;
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 8.0,
        left: 16,
        right: 16,
      ),
      child: ExpansionPanelList(
        expandedHeaderPadding: EdgeInsets.zero,
        elevation: 0,
        children: [
          ExpansionPanel(
            backgroundColor: opened == true
                ? AppTheme.of(context).secondaryColor
                : AppTheme.themeMode == ThemeMode.light
                    ? const Color(0xFFF7F9FB)
                    : const Color(0xFFD9D9D9),
            canTapOnHeader: true,
            headerBuilder: (context, expanded) {
              return Container(
                width: double.infinity,
                // height: height,
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
                            ? const Color(0xFFF7F9FB)
                            : const Color(0xFFD9D9D9)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //Fecha facturacion
                      SizedBox(
                        width: width * 160,
                        child: Row(
                          children: [
                            SizedBox(
                              width: width * 135,
                              child: Text(
                                widget.fechaEjecucion,
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
                      //Descripcion
                      SizedBox(
                        width: width * 160,
                        child: Row(
                          children: [
                            SizedBox(
                              width: width * 135,
                              child: Text(
                                widget.descripcion,
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
                      //anticipo
                      SizedBox(
                        width: width * 135,
                        child: Row(
                          children: [
                            Text(
                              'GTQ ${moneyFormat(widget.anticipo)}',
                              style: AppTheme.of(context).subtitle1.override(
                                    fontFamily: 'Gotham',
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
                              'GTQ ${moneyFormat(widget.comision)}',
                              style: AppTheme.of(context).subtitle1.override(
                                    fontFamily: 'Gotham',
                                    useGoogleFonts: false,
                                    color: AppTheme.of(context).tertiaryColor,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      //Estatus
                      Container(
                        width: width * 126,
                        height: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: widget.estatus == 'Aprobado'
                              ? const Color(0xFF0070C0)
                              : widget.estatus == 'Anexo Pendiente'
                                  ? const Color(0xFFFFC000)
                                  : widget.estatus == 'Pagada'
                                      ? const Color(0xFF00B001)
                                      : const Color(0xFFFF0000),
                        ),
                        child: Text(
                          widget.estatus,
                          textAlign: TextAlign.center,
                          style: AppTheme.of(context).subtitle1.override(fontFamily: 'Gotham', useGoogleFonts: false, color: Colors.white),
                          overflow: TextOverflow.fade,
                        ),
                      ),
                      //Acciones
                      SizedBox(
                        width: width * 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              onPressed: () async {
                                await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      content: Container(
                                        width: 750,
                                        height: 750,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(21),
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                const Spacer(),
                                                Padding(
                                                  padding: const EdgeInsets.all(20),
                                                  child: IconButton(
                                                    icon: Icon(Icons.history_edu, color: AppTheme.of(context).primaryColor),
                                                    tooltip: 'Firmar Anexo',
                                                    color: AppTheme.of(context).primaryColor,
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(20),
                                                  child: IconButton(
                                                    icon: Icon(Icons.file_download_outlined, color: AppTheme.of(context).primaryColor),
                                                    tooltip: 'Descargar Anexo',
                                                    color: AppTheme.of(context).primaryColor,
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(20),
                                                  child: IconButton(
                                                    icon: Icon(Icons.print, color: AppTheme.of(context).primaryColor),
                                                    tooltip: 'Imprimir',
                                                    color: AppTheme.of(context).primaryColor,
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ),
                                                const Spacer(),
                                                Padding(
                                                  padding: const EdgeInsets.all(20),
                                                  child: IconButton(
                                                    icon: Icon(Icons.close, color: AppTheme.of(context).primaryColor),
                                                    tooltip: 'Salir',
                                                    color: AppTheme.of(context).primaryColor,
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Expanded(
                                                child: Container(
                                              color: Colors.blue,
                                            ))
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              icon: const Icon(Icons.picture_as_pdf),
                              color: AppTheme.of(context).primaryColor,
                            ),
                            //popup
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.file_download_outlined),
                              color: AppTheme.of(context).primaryColor,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            body: Column(
              children: [
                Container(
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
                                ' ${moneyFormat(rendererContext.cell.value)}',
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
                                ' ${moneyFormat(rendererContext.cell.value)}',
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
                                ' ${moneyFormat(rendererContext.cell.value)}',
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
                      ],
                      rows: provider.rows,
                      createFooter: (stateManager) {
                        stateManager.setPageSize(100, notify: false);
                        return SizedBox();
                      },
                      onLoaded: (event) async {
                        stateManager = event.stateManager;
                      },
                      onRowChecked: (event) async {
                       // await provider.updateClientRows(widget.cliente.nombreFiscal!);
                      },
                    ),
                  ),
                    ],
                  ),
                ),
              ],
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
