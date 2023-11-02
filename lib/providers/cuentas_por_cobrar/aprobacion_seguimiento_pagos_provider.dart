import 'dart:convert';
import 'dart:developer';

import 'package:acp_web/helpers/globals.dart';
import 'package:acp_web/models/cuentas_por_cobrar/aprobacion_seguimiento_pagos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:pluto_grid/pluto_grid.dart';

class AprobacionSeguimientoPagosProvider extends ChangeNotifier {
  List<AprobacionSeguimientoPagos> clientes = [];
  PlutoGridStateManager? stateManager;
  List<PlutoRow> rows = [];

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

  Future<void> aprobacionSeguimientoPagos() async {
    if (stateManager != null) {
      stateManager!.setShowLoading(true);
    }

    try {
      var response = await supabase.rpc(
        'aprobacion_segumiento_pagos',
        params: {
          'ids_sociedades': [1],
          'nom_monedas': ["GTQ", "USD"],
        },
      ).select();
      clientes = (response as List<dynamic>).map((cliente) => AprobacionSeguimientoPagos.fromJson(jsonEncode(cliente))).toList();

      for (var factura in clientes) {
        rows.add(
          PlutoRow(
            cells: {
              'id_factura_field': PlutoCell(value: factura.factuaId),
              'cuenta_field': PlutoCell(value: factura.noDoc),
              'importe_field': PlutoCell(value: factura.importe),
              'beneficio_cant_field': PlutoCell(value: factura.comision),
              'pago_anticipado_field': PlutoCell(value: factura.pagoAnticipado),
              'dias_pago_field': PlutoCell(value: factura.diasPago),
            },
          ),
        );
      }

      /*  cliente.rows = rows;
      cantidadFacturas = cantidadFacturas + cliente.facturas!.length; */

      notifyListeners();
    } catch (e) {
      log('Error en SeleccionaPagosanticipadosProvider - aprobacion_seguimiento_pagos() - $e');
    }
  }

  Future<void> getRecords() async {
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
  }
}
