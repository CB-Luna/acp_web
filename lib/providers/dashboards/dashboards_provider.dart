import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

class DashboardsProvider extends ChangeNotifier {
  final controllerBusqueda = TextEditingController();
  double montoFacturacion = 0;
  int cantidadFacturas = 0;
  int cantidadFacturasSeleccionadas = 0;
  double numAnexos=0;
  double totalPagos = 0;
  bool ejecBloq = false;
  List<PlutoRow> rows=[];

  double fondoDisponibleRestante = 0;
  double beneficioTotal = 0;
  Future<void> search() async {
    try {} catch (e) {
      log('Error en aprobacionSeguimientoPagos - search() - $e');
    }
    return;
  }
}
