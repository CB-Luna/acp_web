import 'dart:convert';
import 'dart:developer';
//import 'dart:typed_data';

import 'package:acp_web/helpers/globals.dart';
import 'package:acp_web/models/seleccion_pagos_anticipados/seleccion_pagos_anticipados_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:pluto_grid/pluto_grid.dart';

class PagosProvider extends ChangeNotifier {
  PlutoGridStateManager? stateManager;

  List<SeleccionPagosAnticipados> pagos = [];

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
        'seleccion_pagos_anticipados',
        params: {
          'busqueda': controllerBusqueda.text,
          'ids_sociedades': [1, 2, 3], //TODO: Change
          'nom_monedas': ["GTQ", "USD"], //TODO: Change
        },
      ).select();

      pagos = (response as List<dynamic>).map((cliente) => SeleccionPagosAnticipados.fromJson(jsonEncode(cliente))).toList();

      for (var cliente in pagos) {
        cliente.facturas!.sort((a, b) => b.cantDpp!.compareTo(a.cantDpp!)); //TODO: Realizar ordenamiento mediante el query

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
                  'beneficio_porc_field': PlutoCell(value: factura.porcDpp),
                  'beneficio_cant_field': PlutoCell(value: factura.cantDpp),
                  'pago_anticipado_field': PlutoCell(value: factura.importe! - factura.cantDpp!), //TODO: Analizar Spec
                  'dias_pago_field': PlutoCell(value: 12), //TODO: Analizar Spec
                },
              ),
            );
          }
          cliente.rows = rows;
        }
      }
    } catch (e) {
      log('Error en PagosProvider - getRecords() - $e');
    }
  }
}
