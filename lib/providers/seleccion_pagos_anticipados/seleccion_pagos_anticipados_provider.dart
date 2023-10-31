import 'dart:convert';
import 'dart:developer';
//import 'dart:typed_data';

import 'package:acp_web/helpers/globals.dart';
import 'package:acp_web/models/seleccion_pagos_anticipados/seleccion_pagos_anticipados_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:pluto_grid/pluto_grid.dart';

class SeleccionaPagosanticipadosProvider extends ChangeNotifier {
  PlutoGridStateManager? stateManager;

  List<SeleccionPagosAnticipados> clientes = [];
  double montoFacturacion = 0;
  int cantidadFacturas = 0;
  int cantidadFacturasSeleccionadas = 0;
  double totalPagos = 0;

  double fondoDisponibleRestante = 0;
  double beneficioTotal = 0;
  final controllerFondoDisp = MoneyMaskedTextController(initialValue: 100000, decimalSeparator: '.', thousandSeparator: ',');
  final controllerFondoDispFake = TextEditingController();

  final controllerBusqueda = TextEditingController();

  List<dynamic> listCarrito = [];

  bool ejecBloq = false;

  Future<void> clearAll() async {
    clientes = [];

    montoFacturacion = 0;
    cantidadFacturas = 0;
    cantidadFacturasSeleccionadas = 0;
    totalPagos = 0;
    fondoDisponibleRestante = 0;
    beneficioTotal = 0;
    controllerFondoDisp.text = '0.00';
    controllerFondoDispFake.text = '';

    ejecBloq = false;
    controllerBusqueda.clear();

    return await getRecords();
  }

  Future<void> getRecords() async {
    if (stateManager != null) {
      stateManager!.setShowLoading(true);
    }

    cantidadFacturas = 0;
    fondoDisponibleRestante = controllerFondoDisp.numberValue;

    try {
      var response = await supabase.rpc(
        'seleccion_pagos_anticipados',
        params: {
          'busqueda': controllerBusqueda.text,
          'ids_sociedades': [1, 2, 3], //TODO: Change
          'nom_monedas': ["GTQ", "USD"], //TODO: Change
        },
      ).select();

      clientes = (response as List<dynamic>).map((cliente) => SeleccionPagosAnticipados.fromJson(jsonEncode(cliente))).toList();

      for (var cliente in clientes) {
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
          cantidadFacturas = cantidadFacturas + cliente.facturas!.length;
        }
      }
      await checkInList();
    } catch (e) {
      log('Error en SeleccionaPagosanticipadosProvider - getRecords() - $e');
    }
  }

  Future<void> seleccionAutomatica() async {
    await getRecords();

    ejecBloq = true;
    notifyListeners();

    try {
      double valorMayor = 0;
      int idFactura = 0;
      bool exit = false;

      int vuelta = 0;

      while (exit != true) {
        for (var cliente in clientes) {
          for (var row in cliente.rows!) {
            double calculo = (row.cells["importe_field"]!.value - row.cells["beneficio_cant_field"]!.value);
            if (row.checked == false) {
              if (valorMayor < calculo && calculo < fondoDisponibleRestante) {
                valorMayor = calculo;
                idFactura = row.cells["id_factura_field"]!.value;
              }

              if (vuelta == 1 && row.cells["id_factura_field"]!.value == idFactura) {
                row.setChecked(true);
                updateClientRows(cliente.rows!, cliente.nombreFiscal!);

                valorMayor = 0;
                idFactura = 0;
              }
            }
          }
        }
        vuelta++;
        if (vuelta == 2) {
          exit = true;
        }
      }
    } catch (e) {
      log('Error en SeleccionaPagosanticipadosProvider - seleccionAutomatica() - $e');
      ejecBloq = false;
      notifyListeners();
    }
    ejecBloq = false;
    notifyListeners();
  }

  Future<void> updateClientRows(List<PlutoRow> rows, String nombrecliente) async {
    try {
      for (var cliente in clientes) {
        if (cliente.nombreFiscal == nombrecliente) {
          cliente.facturasSeleccionadas = 0;
          cliente.facturacion = 0;
          cliente.beneficio = 0;
          cliente.pagoAdelantado = 0;
          for (var row in rows) {
            if (row.checked == true) {
              cliente.facturacion = cliente.facturacion! + row.cells["importe_field"]!.value;
              cliente.beneficio = cliente.beneficio! + row.cells["beneficio_cant_field"]!.value;
              cliente.pagoAdelantado = cliente.pagoAdelantado! + (row.cells["importe_field"]!.value - row.cells["beneficio_cant_field"]!.value);

              cliente.facturasSeleccionadas = cliente.facturasSeleccionadas! + 1;
            }
          }
        }
      }
    } catch (e) {
      log('Error en SeleccionaPagosanticipadosProvider - updateClientRows() - $e');
    }

    return await checkInList();
  }

  Future<void> checkInList() async {
    montoFacturacion = 0;
    cantidadFacturasSeleccionadas = 0;
    totalPagos = 0;
    fondoDisponibleRestante = 0;
    beneficioTotal = 0;
    try {
      for (var cliente in clientes) {
        montoFacturacion = montoFacturacion + cliente.facturacion!;
        cantidadFacturasSeleccionadas = cantidadFacturasSeleccionadas + cliente.facturasSeleccionadas!;
        beneficioTotal = beneficioTotal + cliente.beneficio!;
        totalPagos = montoFacturacion - beneficioTotal;

        fondoDisponibleRestante = controllerFondoDisp.numberValue - totalPagos;
      }
    } catch (e) {
      log('Error en SeleccionaPagosanticipadosProvider - checkInList() - $e');
    }

    return notifyListeners();
  }

  Future<void> uncheckAll() async {
    try {
      /* for (var element in rows) {
        element.setChecked(false);
      } */
    } catch (e) {
      log('Error en SeleccionaPagosanticipadosProvider - uncheckAll() - $e');
    }
    return await checkInList();
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
}
