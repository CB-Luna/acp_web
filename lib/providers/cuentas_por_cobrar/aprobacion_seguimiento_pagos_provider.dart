import 'dart:convert';
import 'dart:developer';

import 'package:acp_web/functions/date_format.dart';
import 'package:acp_web/functions/money_format.dart';
import 'package:acp_web/helpers/constants.dart';
import 'package:acp_web/helpers/globals.dart';
import 'package:acp_web/models/cuentas_por_cobrar/aprobacion_seguimineto_pagos_view.dart';
import 'package:date_format/date_format.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart' as pdfcolor;
import 'package:pluto_grid/pluto_grid.dart';
import 'package:pdfx/pdfx.dart';
import 'dart:html' as html;
import 'package:pdf/widgets.dart' as pw;
import 'package:signature/signature.dart';
import 'package:http/http.dart' as http;

class AprobacionSeguimientoPagosProvider extends ChangeNotifier {
  List<AprobacionSegumientoPagosFuncion> clientes = [];
  PlutoGridStateManager? stateManager;
  final controllerBusqueda = TextEditingController();
  late List<PlutoGridStateManager> listStateManager;
  List<Registro> registros = [];
  List<List<String>> data = [];
  DateTime fecha = DateTime.now();

  bool ejecBloq = false;
  bool listOpenned = true;
  bool anexo = false;
  bool firmaAnexo = false;

  Future<void> clearAll() async {
    listStateManager;
    listOpenned = true;
    return notifyListeners();
  }

  Future<void> search() async {
    try {
      clientes = [];
    } catch (e) {
      log('Error en aprobacionSeguimientoPagos - search() - $e');
    }
    return aprobacionSeguimientoPagos();
  }

  Future<void> facturasSeleccionadas(int dia, int mes) async {
    try {
      for (var cliente in clientes) {
        for (var propuesta in cliente.propuestas) {
          if (propuesta.dia == dia && propuesta.mes == mes) {
            propuesta.sumAnticipo = 0;
            propuesta.sumComision = 0;
            data.clear();
            for (var row in propuesta.rows!) {
              if (row.checked == true) {
                propuesta.sumAnticipo = propuesta.sumAnticipo! + (row.cells["importe_field"]!.value - row.cells["comision_cant_field"]!.value);
                propuesta.sumComision = propuesta.sumComision! + row.cells["comision_cant_field"]!.value;
                registros = [
                  Registro(
                    cuenta: row.cells["cuenta_field"]!.value,
                    importe: '${row.cells["moneda_field"]!.value} ${moneyFormat(row.cells["importe_field"]!.value)}',
                    comision: '${row.cells["moneda_field"]!.value} ${moneyFormat(row.cells["comision_cant_field"]!.value)}',
                    pagoAnticipado: '${row.cells["moneda_field"]!.value} ${moneyFormat(row.cells["pago_anticipado_field"]!.value)}',
                    diasPago: row.cells["dias_pago_field"]!.value.toString(),
                  ),
                ];
                data.addAll(
                  registros.map(
                    (registro) => [
                      registro.cuenta,
                      registro.importe,
                      registro.comision,
                      registro.pagoAnticipado,
                      registro.diasPago,
                    ],
                  ),
                );
              }
              //data = registros.map((registro) => [registro.cuenta, registro.importe, registro.comision, registro.pagoAnticipado, registro.diasPago]).toList();
            }
          }
        }
      }

      notifyListeners();
    } catch (e) {
      log('Error en facturasSeleccionadas()- $e');
    }
  }

  Future<void> aprobacionSeguimientoPagos() async {
    if (stateManager != null) {
      stateManager!.setShowLoading(true);
    }

    try {
      var response = await supabase.rpc(
        'aprobacion_segumiento_pagos',
        params: {
          'busqueda': controllerBusqueda.text,
          'nom_sociedades': [currentUser!.sociedadSeleccionada!],
          'nom_monedas': currentUser!.monedaSeleccionada != null ? [currentUser!.monedaSeleccionada] : ["GTQ", "USD"],
          'clienteid': currentUser!.cliente!.clienteId
        },
      ).select();
      clientes = (response as List<dynamic>).map((cliente) => AprobacionSegumientoPagosFuncion.fromJson(jsonEncode(cliente))).toList();
      for (var cliente in clientes) {
        for (var propuesta in cliente.propuestas) {
          for (var registro in propuesta.registrosPorDia) {
            propuesta.sumAnticipo = propuesta.sumAnticipo! + registro.pagoAnticipado!;
            propuesta.sumComision = propuesta.sumComision! + registro.cantComision!;
            propuesta.rows!.add(
              PlutoRow(
                cells: {
                  'id_factura_field': PlutoCell(value: registro.facturaId),
                  'cuenta_field': PlutoCell(value: registro.noDoc.toString()),
                  'importe_field': PlutoCell(value: registro.importe),
                  'comision_cant_field': PlutoCell(value: registro.cantComision),
                  'pago_anticipado_field': PlutoCell(value: registro.pagoAnticipado),
                  'dias_pago_field': PlutoCell(value: registro.diasPago),
                  'moneda_field': PlutoCell(value: registro.moneda),
                  'estatus_field': PlutoCell(value: registro.estatusId),
                  'cliente_field': PlutoCell(value: registro.clienteId),
                  'sociedad_field': PlutoCell(value: registro.sociedad),
                },
              ),
            );
          }
        }

        //cantidadFacturas = cantidadFacturas + cliente.facturas!.length;
      }

      notifyListeners();
    } catch (e) {
      log('Error en SeleccionaPagosanticipadosProvider - aprobacion_seguimiento_pagos() - $e');
    }
  }

  ///////////////////Excel/////////////////////////
  Future<bool> aprobacionseguimientoExcel(Propuesta propuesta) async {
    try {
      //Crear excel

      Excel excel = Excel.createExcel();
      Sheet sheet = excel['Aprobacion y seguimiento de pagos'];

      //Agregar primera lineas
      sheet.getColumnAutoFits;
      sheet.appendRow([
        'Aprobacion y seguimiento de pagos',
        '',
        'Usuario',
        '${currentUser?.nombreCompleto}',
        '',
        'Fecha:',
        dateFormat(DateTime.now()),
      ]);

      //Agregar linea vacia
      sheet.appendRow(['']);
      sheet.appendRow(['Cuenta', 'Importe', 'Comisión', 'Pago Anticipado', 'Días para pago']);
      for (var factura in propuesta.registrosPorDia) {
        sheet.appendRow([factura.noDoc, moneyFormat(factura.importe!), moneyFormat(factura.cantComision!), moneyFormat(factura.pagoAnticipado!), factura.diasPago]);

        //cantidadFacturas = cantidadFacturas + cliente.facturas!.length;
      }

      //Borrar Sheet1 default
      excel.delete('Sheet1');

      //Descargar
      final List<int>? fileBytes = excel.save(fileName: "Aprobacion_seguimiento_pagos.xlsx");
      if (fileBytes == null) return false;

      return true;
    } catch (e) {
      log('error in excel-$e');
      return false;
    }
  }

  ////////////////////////////////////////////////////////
  ///////////////////////////PDF//////////////////////////
  ////////////////////////////////////////////////////////

  Future<bool> actualizarFacturasSeleccionadas(Propuesta propuesta) async {
    ejecBloq = true;
    notifyListeners();
    try {
      bool estatus2 = false;
      for (var row in propuesta.rows!) {
        var response = await supabase.from('facturas').select('estatus_id').eq('factura_id', row.cells["id_factura_field"]!.value);
        if (response[0]["estatus_id"] == 2) {
          estatus2 = true;
        }
      }
      if (estatus2 == true) {
        var idAnexo = (await supabase.from('anexo').insert(
          {
            'anticipo': propuesta.sumAnticipo,
            'comision': propuesta.sumComision,
            'cliente_id': currentUser!.cliente!.clienteId,
          },
        ).select())[0]['anexo_id'];
        if (docProveedor != null) {
          await supabase.storage.from('anexo').uploadBinary('${dateFormat(fecha)}_${idAnexo}_${currentUser!.nombreCompleto}.pdf', docProveedor!.files[0].bytes!);
          await supabase.from('anexo').update({'documento': '${dateFormat(fecha)}_${idAnexo}_${currentUser!.nombreCompleto}.pdf'}).eq('anexo_id', idAnexo);
        } else {
          await supabase.storage.from('anexo').uploadBinary('${dateFormat(fecha)}_${idAnexo}_${currentUser!.nombreCompleto}.pdf', documento);
          await supabase.from('anexo').update({'documento': '${dateFormat(fecha)}_${idAnexo}_${currentUser!.nombreCompleto}.pdf'}).eq('anexo_id', idAnexo);
        }
        for (var row in propuesta.rows!) {
          if (row.checked == true) {
            await supabase.from('facturas').update({'anexo_id': idAnexo}).eq('factura_id', row.cells["id_factura_field"]!.value);
            await supabase.rpc(
              'update_factura_estatus',
              params: {
                'factura_id': row.cells["id_factura_field"]!.value,
                'estatus_id': 8,
              },
            );
          }
        }
        final correos = await supabase.rpc('correos_gerentes', params: {});
        for (var correo in correos) {
          final response = await http.post(
            Uri.parse(apiGatewayUrl),
            body: json.encode(
              {
                "user": "Web",
                "action": "bonitaBpmCaseVariables",
                "process": "ACP_Validacion_de_Anexo",
                'data': {
                  'variables': [
                    {
                      'name': 'fecha',
                      'value': dateFormat(DateTime.now()),
                    },
                    {
                      'name': 'cliente',
                      'value': currentUser!.nombreCompleto,
                    },
                    {
                      'name': 'cliente_correo',
                      'value': correo,
                    },
                  ]
                },
              },
            ),
          );
          if (response.statusCode > 204) {
            return false;
          }
        }
      }
    } catch (e) {
      log('Error en SeleccionaPagosanticipadosProvider - getRecords() - $e');
      ejecBloq = false;
      notifyListeners();
      return false;
    }
    await aprobacionSeguimientoPagos();
    ejecBloq = false;
    notifyListeners();
    return true;
  }

  FilePickerResult? docProveedor;
  PdfController? pdfController; //= PdfController(document: PdfDocument.openAsset('assets/docs/Anexo .pdf'));

  Future<void> pickProveedorDoc() async {
    FilePickerResult? picker = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf', 'xml']);

    //get and load pdf
    if (picker != null) {
      docProveedor = picker;
      pdfController = PdfController(
        document: PdfDocument.openData(picker.files.single.bytes!),
      );
    } else {
      pdfController = PdfController(document: PdfDocument.openAsset('assets/docs/Anexo .pdf'));
    }
    firmaAnexo = true;
    return notifyListeners();
  }

  //Descargar PDF
  String pdfUrl = '';

  void descargarArchivo(Uint8List datos, String nombreArchivo) {
    // Crear un Blob con los datos
    final blob = html.Blob([datos]);

    // Crear una URL para el Blob
    final url = html.Url.createObjectUrlFromBlob(blob);

    // Crear un enlace HTML para la descarga
    final anchor = html.AnchorElement(href: url)
      ..target = 'web'
      ..download = nombreArchivo;

    // Hacer clic en el enlace para iniciar la descarga
    html.document.body?.children.add(anchor);
    anchor.click();

    // Limpiar después de la descarga
    html.document.body?.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  }

  final SignatureController controller = SignatureController(penColor: Colors.black, penStrokeWidth: 5);
  Uint8List? signature;
  Future<Uint8List> exportSignature() async {
    pdfController = null;
    notifyListeners();
    final exportController = SignatureController(penStrokeWidth: 2, penColor: Colors.black, exportBackgroundColor: Colors.white, points: controller.points);
    signature = await exportController.toPngBytes();
    exportController.dispose();
    firmaAnexo = true;
    return signature!;
  }

  Future<PdfController?> crearPDF(Propuesta propuesta) async {
    DateTime fechaContrato;
    var response = await supabase.from('cliente').select('fecha_contrato').eq('cliente_id', currentUser!.cliente!.clienteId);
    fechaContrato = DateTime.parse(response[0]['fecha_contrato'].toString());
    final headers = ['Cuenta', 'Importe', 'Comisión', 'Pago Anticipado', 'Días para Pago'];
    //final data = registros.map((registro) => [registro.cuenta, registro.importe, registro.comision, registro.pagoAnticipado, registro.diasPago]).toList();
    final logo = (await rootBundle.load('assets/images/Logo.png')).buffer.asUint8List();
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          children: [
            //Titulo
            pw.Row(
              children: [
                pw.Expanded(
                  child: pw.Container(
                    alignment: pw.Alignment.topLeft,
                    height: 80,
                    child: pw.Image(pw.MemoryImage(logo), fit: pw.BoxFit.cover),
                  ),
                ),
                pw.Expanded(
                  child: pw.Column(
                    children: [
                      pw.Text(
                        'Anexo',
                        style: const pw.TextStyle(
                          fontSize: 30,
                          color: pdfcolor.PdfColor.fromInt(0XFF0A0859),
                        ),
                      ),
                      pw.Container(
                        decoration: const pw.BoxDecoration(
                          borderRadius: pw.BorderRadius.all(pw.Radius.circular(2)),
                          color: pdfcolor.PdfColor.fromInt(0XFF0A0859),
                        ),
                        padding: const pw.EdgeInsets.only(left: 40, top: 10, bottom: 10, right: 20),
                        alignment: pw.Alignment.centerLeft,
                        height: 50,
                        child: pw.DefaultTextStyle(
                          style: const pw.TextStyle(
                            color: pdfcolor.PdfColor.fromInt(0xFFFFFFFF),
                            fontSize: 12,
                          ),
                          child: pw.GridView(
                            crossAxisCount: 2,
                            children: [
                              pw.Text('Anexo #'),
                              pw.Text('Anexo'),
                              pw.Text('Fecha Anexo:'),
                              pw.Text(formatDate(
                                fecha,
                                [dd, '/', m, '/', yyyy],
                                locale: const SpanishDateLocale(),
                              )),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            //Total
            pw.Row(
              children: [
                pw.Expanded(
                  child: pw.Row(
                    children: [
                      pw.Container(
                        margin: const pw.EdgeInsets.only(left: 10, right: 10),
                        height: 70,
                        child: pw.Text(
                          'Invoice to:',
                          style: const pw.TextStyle(
                            color: pdfcolor.PdfColor.fromInt(0XFF0A0859),
                            fontSize: 12,
                          ),
                        ),
                      ),
                      pw.Expanded(
                        child: pw.Container(
                          height: 70,
                          child: pw.RichText(
                              text: pw.TextSpan(
                                  text: '${currentUser!.nombreCompleto}\n',
                                  style: const pw.TextStyle(
                                    color: pdfcolor.PdfColor.fromInt(0XFF0A0859),
                                    fontSize: 12,
                                  ),
                                  children: [
                                const pw.TextSpan(
                                  text: '\n',
                                  style: pw.TextStyle(
                                    fontSize: 5,
                                  ),
                                ),
                                pw.TextSpan(
                                  text: currentUser!.email,
                                  style: const pw.TextStyle(
                                    fontSize: 10,
                                  ),
                                ),
                              ])),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            //Contenido
            pw.Text(
              'Que con fecha, el ${formatDate(
                fechaContrato,
                [obtenerDiaEnLetras(fechaContrato.day), ' de ', MM, ' del ', obtenerDiaEnLetras(fechaContrato.year)],
                locale: const SpanishDateLocale(),
              )} se formalizó Contrato de Factoraje con anticipo de contraseñas celebrado entre Cliente con NIT ${currentUser!.cliente!.clienteId} y código de cliente No. ${currentUser!.cliente!.codigoCliente}.',
              style: const pw.TextStyle(
                fontSize: 20,
                color: pdfcolor.PdfColor.fromInt(0xFF060606),
              ),
            ),
            pw.Text(
              'Por lo tanto solicita a la entidad ${currentUser!.compania}, se me efectúe el pago anticipado de las siguiente facturas:',
              style: const pw.TextStyle(
                fontSize: 20,
                color: pdfcolor.PdfColor.fromInt(0xFF060606),
              ),
            ),
            pw.Spacer(),
            pw.TableHelper.fromTextArray(headers: headers, data: data),
            pw.SizedBox(height: 20),
            pw.Row(children: [
              pw.Expanded(
                flex: 2,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Gracias por hacer negocios',
                      style: pw.TextStyle(
                        color: const pdfcolor.PdfColor.fromInt(0xFF060606),
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Container(
                      margin: const pw.EdgeInsets.only(top: 20, bottom: 8),
                      child: pw.Text(
                        'Informacion de Pago:',
                        style: pw.TextStyle(
                          color: const pdfcolor.PdfColor.fromInt(0xFF060606),
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              pw.Expanded(
                flex: 1,
                child: pw.DefaultTextStyle(
                  style: const pw.TextStyle(
                    fontSize: 10,
                    color: pdfcolor.PdfColor.fromInt(0XFF0A0859),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('Comisión:'),
                          pw.Text('${propuesta.moneda} ${moneyFormat(propuesta.sumComision!)}'),
                        ],
                      ),
                      pw.Divider(
                        color: const pdfcolor.PdfColor.fromInt(0XFF0A0859),
                      ),
                      pw.DefaultTextStyle(
                        style: pw.TextStyle(
                          color: const pdfcolor.PdfColor.fromInt(0XFF0A0859),
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                        ),
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text('Total:'),
                            pw.Text('${propuesta.moneda} ${moneyFormat(propuesta.sumAnticipo!)}'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
            pw.Spacer(),
            //Foother
            controller.isNotEmpty
                ? pw.Image(
                    pw.MemoryImage(signature!),
                    height: 250,
                    width: 350,
                    fit: pw.BoxFit.fill,
                    alignment: pw.Alignment.center,
                  )
                : pw.Text(
                    'F. ________________________________________ .',
                    style: const pw.TextStyle(
                      fontSize: 20,
                      color: pdfcolor.PdfColor.fromInt(0xFF060606),
                    ),
                  ),
            pw.Text(
              'AUTORIZADO POR: ${currentUser!.nombreCompleto}',
              style: const pw.TextStyle(
                fontSize: 20,
                color: pdfcolor.PdfColor.fromInt(0xFF060606),
              ),
            ),
            pw.Text(
              'En virtud del artículo...',
              style: const pw.TextStyle(
                fontSize: 20,
                color: pdfcolor.PdfColor.fromInt(0xFF060606),
              ),
            ),
          ],
        ),
      ),
    );
    pdf.save();
    pdfController = PdfController(
      document: PdfDocument.openData(pdf.save()),
    );
    documento = await pdf.save();
    notifyListeners();
    return pdfController;
  }

  late Uint8List documento;
  String obtenerDiaEnLetras(int numeroDia) {
    switch (numeroDia) {
      case 1:
        return 'uno';
      case 2:
        return 'dos';
      case 3:
        return 'tres';
      case 4:
        return 'cuatro';
      case 5:
        return 'cinco';
      case 6:
        return 'seis';
      case 7:
        return 'siete';
      case 8:
        return 'ocho';
      case 9:
        return 'nueve';
      case 10:
        return 'diez';
      case 11:
        return 'once';
      case 12:
        return 'doce';
      case 13:
        return 'trece';
      case 14:
        return 'catorce';
      case 15:
        return 'quince';
      case 16:
        return 'dieciséis';
      case 17:
        return 'diecisiete';
      case 18:
        return 'dieciocho';
      case 19:
        return 'diecinueve';
      case 20:
        return 'veinte';
      case 21:
        return 'veintiuno';
      case 22:
        return 'veintidós';
      case 23:
        return 'veintitrés';
      case 24:
        return 'veinticuatro';
      case 25:
        return 'veinticinco';
      case 26:
        return 'veintiséis';
      case 27:
        return 'veintisiete';
      case 28:
        return 'veintiocho';
      case 29:
        return 'veintinueve';
      case 30:
        return 'treinta';
      case 31:
        return 'treinta y uno';
      case 2023:
        return 'dos mil veintitrés';
      case 2024:
        return 'dos mil veinticuatro';
      case 2025:
        return 'dos mil veinticinco';
      case 2026:
        return 'dos mil veintiseis';
      case 2027:
        return 'dos mil veintisiete';
      default:
        return '';
    }
  }
}

class Registro {
  final String cuenta;
  final String importe;
  final String comision;
  final String pagoAnticipado;
  final String diasPago;
  const Registro({required this.cuenta, required this.importe, required this.comision, required this.pagoAnticipado, required this.diasPago});
}
