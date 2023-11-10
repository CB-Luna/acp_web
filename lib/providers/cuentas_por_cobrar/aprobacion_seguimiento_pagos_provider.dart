import 'dart:convert';
import 'dart:developer';

import 'package:acp_web/helpers/globals.dart';
import 'package:acp_web/models/cuentas_por_cobrar/aprobacion_seguimineto_pagos_view.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:pdfx/pdfx.dart';
import 'dart:html' as html;

class AprobacionSeguimientoPagosProvider extends ChangeNotifier {
  List<AprobacionSegumientoPagosFuncion> clientes = [];
  PlutoGridStateManager? stateManager;
  final controllerBusqueda = TextEditingController();
  late List<PlutoGridStateManager> listStateManager;
  List<dynamic> listCarrito = [];

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
            for (var row in propuesta.rows!) {
              if (row.checked == true) {
                propuesta.sumAnticipo = propuesta.sumAnticipo! + (row.cells["importe_field"]!.value - row.cells["beneficio_cant_field"]!.value);
                propuesta.sumComision = propuesta.sumComision! + row.cells["beneficio_cant_field"]!.value;
              }
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
          'ids_sociedades': [1, 2, 3],
          'nom_monedas': currentUser!.monedaSeleccionada != null ? [currentUser!.monedaSeleccionada] : ["GTQ", "USD"],
          'clienteid': currentUser!.cliente!.clienteId
        },
      ).select();
      clientes = (response as List<dynamic>).map((cliente) => AprobacionSegumientoPagosFuncion.fromJson(jsonEncode(cliente))).toList();

      for (var cliente in clientes) {
        for (var propuesta in cliente.propuestas) {
          for (var registro in propuesta.registrosPorDia) {
            propuesta.rows!.add(
              PlutoRow(
                cells: {
                  'id_factura_field': PlutoCell(value: registro.facturaId),
                  'cuenta_field': PlutoCell(value: registro.noDoc),
                  'importe_field': PlutoCell(value: registro.importe),
                  'beneficio_cant_field': PlutoCell(value: registro.cantDpp),
                  'pago_anticipado_field': PlutoCell(value: registro.pagoAnticipado),
                  'dias_pago_field': PlutoCell(value: registro.estatusId),
                  'moneda_field': PlutoCell(value: registro.moneda),
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

  ////////////////////////////////////////////////////////
  ///////////////////////////PDF//////////////////////////
  ////////////////////////////////////////////////////////

  /* bool popupVisorPdfVisible = true;
  FilePickerResult? docProveedor;
  PdfController? pdfController;

  void verPdf(bool visible) {
    popupVisorPdfVisible = visible;
    notifyListeners();
  }
 */
  /* Uint8List? imageBytes;
  Future<void> pickDoc() async {
    FilePickerResult? picker = await FilePickerWeb.platform.pickFiles(type: FileType.custom, allowedExtensions: ['jpg', 'png']);
    //get and load pdf
    if (picker != null) {
      docProveedor = picker;
      imageBytes = picker.files.single.bytes;
    } else {
      imageBytes = null;
    }

    notifyListeners();
    return;
  } */

  Future<void> actualizarFacturasSeleccionadas(Propuesta propuesta) async {
    if (stateManager != null) {
      stateManager!.setShowLoading(true);
    }
    try {
      var idAnexo = (await supabase.from('anexo').insert(
        {
          'anticipo': propuesta.sumAnticipo,
          'comision': propuesta.sumComision,
          'cliente_id': currentUser!.cliente!.clienteId,
        },
      ).select())[0]['anexo_id'];

      await supabase.storage.from('anexo').uploadBinary('anexo_$idAnexo.pdf', docProveedor!.files[0].bytes!);
      await supabase.from('anexo').update({'documento': 'anexo_$idAnexo.pdf'}).eq('anexo_id', idAnexo);

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
        } /*  else {
          await supabase.rpc(
            'update_factura_estatus',
            params: {
              'factura_id': row.cells["id_factura_field"]!.value,
              'estatus_id': 1,
            },
          );
        } */
      }
    } catch (e) {
      log('Error en SeleccionaPagosanticipadosProvider - getRecords() - $e');
    }
    notifyListeners();
    return aprobacionSeguimientoPagos();
  }

  FilePickerResult? docProveedor;
  PdfController pdfController = PdfController(document: PdfDocument.openAsset('assets/docs/Anexo .pdf'));

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
  final String pdfUrl = 'assets/docs/Anexo .pdf'; // Reemplaza con la URL real del archivo PDF

  void descargarPDF() {
    html.AnchorElement(href: pdfUrl)
      ..target = 'blank'
      ..download = 'Anexo.pdf'
      ..click();
    anexo = true;
    notifyListeners();
    return;
  }

  /* Future<void> getRecords() async {
    if (stateManager != null) {
      stateManager!.setShowLoading(true);
    }
    try {
      await checkInList();
    } catch (e) {
      log('Error en getPartidasPull() - $e');
    }
  }

  Future<bool> updateRecords() async {
    try {
      await clearAll();
      return true;
    } catch (e) {
      log('Error en UpdatePartidasSolicitadas() - $e');
      return false;
    }
  }

  Future<void> checkInList() async {
    for (var element in rows) {
      if (element.checked == true) {}
    }
    return notifyListeners();
  }

  Future<void> uncheckAll() async {
    for (var element in rows) {
      element.setChecked(false);
    }
    await checkInList();
  } */
}
