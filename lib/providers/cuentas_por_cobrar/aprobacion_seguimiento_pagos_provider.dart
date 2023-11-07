import 'dart:convert';
import 'dart:developer';

import 'package:acp_web/helpers/globals.dart';
import 'package:acp_web/models/cuentas_por_cobrar/aprobacion_seguimineto_pagos_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:pluto_grid/pluto_grid.dart';

class AprobacionSeguimientoPagosProvider extends ChangeNotifier {
  List<AprobacionSegumientoPagosFuncion> clientes = [];
  PlutoGridStateManager? stateManager;
  final controllerBusqueda = TextEditingController();

  final controllerFondoDisp = MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',');
  final controllerFondoDispFake = TextEditingController();
  late List<PlutoGridStateManager> listStateManager;
  List<dynamic> listCarrito = [];

  bool ejecBloq = false;
  bool listOpenned = true;

  Future<void> clearAll() async {
    listStateManager;
    listOpenned = true;
    return notifyListeners();
  }

/*   void addCarrito() {
    listCarrito = [];
    sumComision = 0;
    sumAnticipo = 0;
    for (var element in clientes) {
      if (element.checked == true) {
        sumComision = sumComision + element.cells['Importe']!.value;
        sumAnticipo = sumAnticipo + element.cells['Comisión']!.value;
      }
    }
    notifyListeners();
  } */

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
          'nom_monedas': ["GTQ"],
        },
      ).select();
      clientes = (response as List<dynamic>).map((cliente) => AprobacionSegumientoPagosFuncion.fromJson(jsonEncode(cliente))).toList();

      for (var cliente in clientes) {
        for (var propuesta in cliente.propuestas) {
          for (var registro in propuesta.registrosPorDia) {
            propuesta.rows!.add(
              PlutoRow(
                cells: {
                  'id_factura_field': PlutoCell(value: registro.clienteId),
                  'cuenta_field': PlutoCell(value: registro.noDoc),
                  'importe_field': PlutoCell(value: registro.importe),
                  'beneficio_cant_field': PlutoCell(value: registro.beneficio),
                  'pago_anticipado_field': PlutoCell(value: registro.pagoAnticipado),
                  'dias_pago_field': PlutoCell(value: registro.estatus),
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

  /*  bool popupVisorPdfVisible = true;
  FilePickerResult? docProveedor;
  PdfController? pdfController;

  void verPdf(bool visible) {
    popupVisorPdfVisible = visible;
    notifyListeners();
  }

  Uint8List? imageBytes;
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
