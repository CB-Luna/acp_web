import 'dart:convert';
import 'dart:developer';
//import 'dart:typed_data';

import 'package:acp_web/helpers/globals.dart';
import 'package:acp_web/models/pagos/pagos_model.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

class PagosProvider extends ChangeNotifier {
  PlutoGridStateManager? stateManager;

  List<Pagos> pagos = [];

  final controllerBusqueda = TextEditingController();

  bool gridSelected = false;

  Future<void> clearAll() async {
    pagos = [];

    controllerBusqueda.clear();

    return await getRecords();
  }

  Future<void> getRecords() async {
    if (stateManager != null) {
      stateManager!.setShowLoading(true);
    }

    try {
      var response = await supabase.rpc(
        'pagos',
        params: {
          'busqueda': controllerBusqueda.text,
          'ids_sociedades': [1, 2, 3], //TODO: Change
          'nom_monedas': ["GTQ", "USD"], //TODO: Change
        },
      ).select();

      pagos = (response as List<dynamic>).map((cliente) => Pagos.fromJson(jsonEncode(cliente))).toList();
    } catch (e) {
      log('Error en PagosProvider - getRecords() - $e');
    }
    return notifyListeners();
  }
}
