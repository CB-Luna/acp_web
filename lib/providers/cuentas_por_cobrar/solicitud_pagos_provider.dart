import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:pluto_grid/pluto_grid.dart';

class SolicitudPagosProvider extends ChangeNotifier {
  List<PlutoRow> rows = [];
  PlutoGridStateManager? stateManager;
  bool ischeck=false;

  final controllerBusqueda = TextEditingController();

  final controllerFondoDisp = MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',');
  final controllerFondoDispFake = TextEditingController();
  late List<PlutoGridStateManager> listStateManager;

  List<dynamic> listCarrito = [];

  double montoFacturacion = 0;
  int cantidadFacturas = 0;
  int cantidadFacturasSeleccionadas = 0;
  double totalPagos = 0;
  double pagoAnticipado=0;
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
    montoFacturacion = 0;
    listStateManager;
    listOpenned = true;
    return notifyListeners();
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
