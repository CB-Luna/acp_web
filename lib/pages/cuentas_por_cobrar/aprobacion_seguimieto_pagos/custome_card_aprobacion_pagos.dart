import 'package:acp_web/functions/money_format.dart';
import 'package:acp_web/helpers/globals.dart';
import 'package:acp_web/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

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

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width / 1440;
    //double height = MediaQuery.of(context).size.height / 1024;
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
                          ? Colors.white
                          : Colors.grey,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //Fecha facturacion
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1440 * 160,
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
                        width: MediaQuery.of(context).size.width / 1440 * 160,
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
                        width: width * 160,
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
                        width: width * 126,
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
                      SizedBox(
                        width: width * 135,
                        child: Row(
                          children: [
                            Container(
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
                              width: width * 135,
                              child: Text(
                                widget.estatus,
                                textAlign: TextAlign.center,
                                style: AppTheme.of(context).subtitle1.override(fontFamily: 'Gotham', useGoogleFonts: false, color: Colors.white),
                                overflow: TextOverflow.fade,
                              ),
                            ),
                          ],
                        ),
                      ),
                      //Acciones
                      SizedBox(
                        width: width * 135,
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
                                                    icon: Icon(Icons.note_alt, color: AppTheme.of(context).primaryColor),
                                                    tooltip: 'Firmar Documento',
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
                                                    tooltip: 'Descargar Archivo',
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
                              icon: const Icon(Icons.note_alt),
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
                              title: 'Comisión',
                              titleTextAlign: PlutoColumnTextAlign.center,
                              textAlign: PlutoColumnTextAlign.center,
                              field: 'Comisión_field',
                              type: PlutoColumnType.text(),
                              enableEditingMode: false,
                              titleSpan: TextSpan(
                                children: [
                                  WidgetSpan(
                                    alignment: PlaceholderAlignment.middle,
                                    child: Text(
                                      'Comisión',
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
                            return const SizedBox();
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
