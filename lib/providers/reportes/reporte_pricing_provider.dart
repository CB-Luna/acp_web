import 'dart:developer';

import 'package:acp_web/models/usuarios/rol.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

class ReportePricingProvider extends ChangeNotifier {

  TextEditingController nombreController = TextEditingController();
  TextEditingController correoController = TextEditingController();
  TextEditingController apellidoPaternoController = TextEditingController();
  TextEditingController apellidoMaternoController = TextEditingController();
  TextEditingController telefonoController = TextEditingController();
  Rol? rolSeleccionado;
  TextEditingController codigoClienteController = TextEditingController();
  bool activo = true;
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
