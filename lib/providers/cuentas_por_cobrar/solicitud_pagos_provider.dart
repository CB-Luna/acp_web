import 'dart:convert';
import 'dart:developer';

import 'package:acp_web/helpers/globals.dart';
import 'package:acp_web/models/cuentas_por_cobrar/solicitud_pagos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:pluto_grid/pluto_grid.dart';

class SolicitudPagosProvider extends ChangeNotifier {
  List<PlutoRow> rows = [];
  PlutoGridStateManager? stateManager;
  bool ischeck = false;

  final controllerBusqueda = TextEditingController();

  final controllerFondoDisp = MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',');
  final controllerFondoDispFake = TextEditingController();
  late List<PlutoGridStateManager> listStateManager;

  List<dynamic> listCarrito = [];
  List<SolicitudPagos> facturas = [];
  List fact = [];

  double montoFacturacion = 0;
  int cantidadFacturas = 0;
  double cantidadFacturasSeleccionadas = 0;
  double totalPagos = 0;
  double pagoAnticipado = 0;
  DateTime fecha = DateTime.now();

  bool ejecBloq = false;
  bool listOpenned = true;

  List<Map<String, dynamic>> listadoEjemplo1 = [
    {
      "factura": "F-2123123",
      "importe": 1213513.00,
      "comision": 135000.00,
      "diaspago": '40',
      "pagoAdelantado": 1078513.00,
      "Estatus": 'Aprobado',
    },
    {
      "factura": "F-2123123",
      "importe": 1213513.00,
      "comision": 135000.00,
      "diaspago": '40',
      "pagoAdelantado": 1078513.00,
      "Estatus": 'Aprobado',
    },
    {
      "factura": "F-2123123",
      "importe": 1213513.00,
      "comision": 135000.00,
      "diaspago": '40',
      "pagoAdelantado": 1078513.00,
      "Estatus": 'Aprobado',
    },
    {
      "factura": "F-2123123",
      "importe": 1213513.00,
      "comision": 135000.00,
      "diaspago": '40',
      "pagoAdelantado": 1078513.00,
      "Estatus": 'Aprobado',
    },
    {
      "factura": "F-2123123",
      "importe": 1213513.00,
      "comision": 135000.00,
      "diaspago": '40',
      "pagoAdelantado": 1078513.00,
      "Estatus": 'Aprobado',
    },
  ];

  Future<void> clearAll() async {
    controllerBusqueda.clear();
    montoFacturacion = 0;
    cantidadFacturasSeleccionadas = 0;
    totalPagos = 0;
    pagoAnticipado = 0;
    listStateManager;
    listOpenned = true;
    return await solicitudPagos();
  }

  //Traer info facturas
  Future<void> solicitudPagos() async {
    if (stateManager != null) {
      stateManager!.setShowLoading(true);
    }
    cantidadFacturas = 0;
    montoFacturacion = 0;
    cantidadFacturasSeleccionadas = 0;
    totalPagos = 0;
    pagoAnticipado = 0;
    try {
      var response = await supabase.rpc(
        'solicitud_pagos',
        params: {
          'busqueda': controllerBusqueda.text,
          'ids_sociedades': [1],
          'nom_monedas': ["GTQ", "USD"],
          'clienteid':currentUser!.cliente!.clienteId
        },
      ).select();
      facturas = (response as List<dynamic>).map((cliente) => SolicitudPagos.fromJson(jsonEncode(cliente))).toList();
      for (var factura in facturas) {
        factura.comision;
        cantidadFacturas = cantidadFacturas + facturas.length;
      }
      notifyListeners();
    } catch (e) {
      log('Error en SeleccionaPagosanticipadosProvider - getRecords() - $e');
    }
  }

  //Actualizar facturas seleccionadas
  Future<void> actualizarFacturasSeleccionadas() async {
    if (stateManager != null) {
      stateManager!.setShowLoading(true);
    }
    try {
      for (var factura in facturas) {
        if (factura.ischeck == true) {
          await supabase.rpc(
            'update_factura_estatus',
            params: {
              'factura_id': factura.factuaId,
              'estatus_id': 7,
            },
          );
        }
      }
    } catch (e) {
      log('Error en SeleccionaPagosanticipadosProvider - getRecords() - $e');
    }
    notifyListeners();
    return getRecords();
  }

  //Seleccionar Factuas
  Future<void> facturasSeleccionadas() async {
    try {
      montoFacturacion = 0;
      cantidadFacturasSeleccionadas = 0;
      totalPagos = 0;
      pagoAnticipado = 0;
      for (var factura in facturas) {
        if (factura.ischeck) {
          ischeck = true;
          montoFacturacion = montoFacturacion + factura.importe!;
          cantidadFacturasSeleccionadas = cantidadFacturasSeleccionadas + 1;
          totalPagos = totalPagos + factura.comision!;
          pagoAnticipado = pagoAnticipado + factura.pagoAnticipado!;
        }
      }
      notifyListeners();
    } catch (e) {
      log('Error en facturasSeleccionadas()- $e');
    }
  }

  Future<void> search() async {
    try {
      montoFacturacion = 0;
      cantidadFacturas = 0;
      cantidadFacturasSeleccionadas = 0;
      totalPagos = 0;
    } catch (e) {
      log('Error en SeleccionaPagosanticipadosProvider - search() - $e');
    }
    return solicitudPagos();
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
