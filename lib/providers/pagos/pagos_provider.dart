import 'dart:convert';
import 'dart:developer';
//import 'dart:typed_data';

import 'package:acp_web/functions/date_format.dart';
import 'package:acp_web/functions/money_format.dart';
import 'package:acp_web/helpers/globals.dart';
import 'package:acp_web/models/global/factura_model.dart';
import 'package:acp_web/models/pagos/pagos_model.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:http/http.dart' as http;

import 'dart:html' as html;

class PagosProvider extends ChangeNotifier {
  PlutoGridStateManager? stateManager;

  List<Pagos> pagos = [];

  final controllerBusqueda = TextEditingController();

  bool gridSelected = false;
  bool ejecBloq = false;

  Future<void> clearAll() async {
    pagos = [];

    controllerBusqueda.clear();

    return await getRecords();
  }

  Future<void> getRecords() async {
    ejecBloq = true;
    notifyListeners();
    if (stateManager != null) {
      stateManager!.setShowLoading(true);
    }

    try {
      var response = await supabase.rpc(
        'pagos',
        params: {
          'busqueda': controllerBusqueda.text,
          'nom_sociedades': [currentUser!.sociedadSeleccionada],
          'nom_monedas': currentUser!.monedaSeleccionada != null ? [currentUser!.monedaSeleccionada] : ["GTQ", "USD"], //TODO: Change
        },
      ).select();

      pagos = (response as List<dynamic>).map((cliente) => Pagos.fromJson(jsonEncode(cliente))).toList();

      for (var pago in pagos) {
        for (var cliente in pago.clientes!) {
          List<PlutoRow> rows = [];
          if (cliente.facturas != null && cliente.facturas!.isNotEmpty) {
            for (var factura in cliente.facturas!) {
              rows.add(
                PlutoRow(
                  cells: {
                    'id_factura_field': PlutoCell(value: factura.facturaId),
                    'cuenta_field': PlutoCell(value: factura.noDoc),
                    'moneda_field': PlutoCell(value: factura.moneda),
                    'importe_field': PlutoCell(value: factura.importe),
                    'comision_porc_field': PlutoCell(value: factura.porcComision),
                    'comision_cant_field': PlutoCell(value: factura.cantComision),
                    'pago_anticipado_field': PlutoCell(value: factura.pagoAnticipado),
                    'dias_pago_field': PlutoCell(value: factura.diasPago),
                    'dias_adicionales_field': PlutoCell(value: 0),
                    'fecha_pago_field': PlutoCell(value: factura.fechaPago),
                    'estatus_id_field': PlutoCell(value: factura.estatusId),
                  },
                ),
              );
            }

            cliente.rows = rows;
          }
        }
      }
    } catch (e) {
      log('Error en PagosProvider - getRecords() - $e');
    }
    ejecBloq = false;
    notifyListeners();
    return notifyListeners();
  }

  FilePickerResult? docProveedor;
  PdfController? pdfController;

  Future<void> pickAnexoDoc(String nombreAnexo) async {
    try {
      var url = supabase.storage.from('anexo').getPublicUrl(nombreAnexo);
      var bodyBytes = (await http.get(Uri.parse(url))).bodyBytes;
      pdfController = PdfController(document: PdfDocument.openData(bodyBytes));
    } catch (e) {
      log('Error en PagosProvider - pickAnexoDoc() - $e');
      return;
    }
    return;
  }

  Future<void> descargarAnexo(String nombreAnexo) async {
    try {
      String url = supabase.storage.from('anexo').getPublicUrl(nombreAnexo);

      final download = await supabase.storage.from('anexo').download(url.split('anexo/')[1]);
      final content = base64Encode(download);
      html.AnchorElement(href: "data:application/octet-stream;charset=utf-16le;base64,$content")
        ..setAttribute("download", url.split('anexo/')[1].contains(".pdf") ? url.split('anexo/')[1] : '${url.split('anexo/')[1]}.pdf')
        ..click();
    } catch (e) {
      log('Error en PagosProvider - descargarAnexo() - $e');
      return;
    }
    return;
  }

  Future<void> updateRecords(List<Factura> list) async {
    try {
      for (var factura in list) {
        await supabase.from('bitacora_estatus_facturas').insert(
          {
            'factura_id': factura.facturaId,
            'prev_estatus_id': factura.estatusId,
            'post_estatus_id': 9,
            'pantalla': 'Pagos',
            'descripcion': 'Anexo validado en pantalla de Pagos',
            'rol_id': currentUser!.rol.rolId,
            'usuario_id': currentUser!.id,
          },
        );

        await supabase.rpc(
          'update_factura_estatus',
          params: {
            'factura_id': factura.facturaId,
            'estatus_id': 9,
          },
        );
      }
    } catch (e) {
      log('Error en PagosProvider - updateRecords() - $e');
      return;
    }
    return getRecords();
  }

  Future<int> cancelarPropuesta(List<Factura> list) async {
    try {
      //Revisamos no se haya realizado la carga del Anexo por parte del cliente antes de proceder con la cancelación del proceso
      bool anexoCreado = false;
      for (var factura in list) {
        var response = await supabase.from('facturas').select('estatus_id').eq('factura_id', factura.facturaId);
        if (response[0]["estatus_id"] == 8) {
          anexoCreado = true;
        }
      }

      if (anexoCreado == false) {
        for (var factura in list) {
          await supabase.from('bitacora_estatus_facturas').insert(
            {
              'factura_id': factura.facturaId,
              'prev_estatus_id': factura.estatusId,
              'post_estatus_id': 1,
              'pantalla': 'Pagos',
              'descripcion': 'Propuesta Cancelada',
              'rol_id': currentUser!.rol.rolId,
              'usuario_id': currentUser!.id,
            },
          );

          await supabase.rpc(
            'update_factura_estatus',
            params: {
              'factura_id': factura.facturaId,
              'estatus_id': 1,
            },
          );
        }
      } else {
        await getRecords();
        return 2;
      }
    } catch (e) {
      log('Error en PagosProvider - cancelarPropuesta() - $e');
      return 1;
    }
    await getRecords();
    return 0;
  }

  ///////////////////Excel/////////////////////////
  Future<bool> pagosExcel(List<PlutoRow> facturas, String name) async {
    try {
      //Crear excel

      Excel excel = Excel.createExcel();
      Sheet sheet = excel['Pagos'];

      //Agregar primera lineas
      sheet.getColumnAutoFits;
      sheet.appendRow([
        'Pagos',
        '',
        'Usuario',
        '${currentUser?.nombreCompleto}',
        '',
        'Fecha:',
        dateFormat(DateTime.now()),
        'Sociedad:',
        currentUser!.sociedadSeleccionada!,
      ]);

      //Agregar linea vacia
      sheet.appendRow(['']);
      sheet.appendRow(['Cuenta', 'Importe', '% Comisión', 'Comisión', 'Pago Anticipado', 'Días para pago', 'DAC']);

      for (var factura in facturas) {
        sheet.appendRow([
          factura.cells['cuenta_field']!.value,
          '${currentUser!.monedaSeleccionada!} ${moneyFormat(factura.cells['importe_field']!.value)}',
          '${moneyFormat(factura.cells['comision_porc_field']!.value * 100)} %',
          '${currentUser!.monedaSeleccionada!} ${moneyFormat(factura.cells['comision_cant_field']!.value)}',
          '${currentUser!.monedaSeleccionada!} ${moneyFormat(factura.cells['pago_anticipado_field']!.value)}',
          factura.cells['dias_pago_field']!.value,
          factura.cells['dias_adicionales_field']!.value,
        ]);
      }

      //Borrar Sheet1 default
      excel.delete('Sheet1');

      //Descargar
      final List<int>? fileBytes = excel.save(fileName: "Pagos_$name.xlsx");
      if (fileBytes == null) return false;

      return true;
    } catch (e) {
      log('error in excel-$e');
      return false;
    }
  }
}
