import 'dart:convert';
import 'dart:developer';
//import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:pluto_grid/pluto_grid.dart';

import 'package:acp_web/helpers/globals.dart';
import 'package:acp_web/models/autorizacion_solicitudes_pago_anticipado/autorizacion_solicitudes_pago_anticipado_model.dart';

class AutorizacionAolicitudesPagoAnticipadoProvider extends ChangeNotifier {
  PlutoGridStateManager? stateManager;

  List<AutorizacionSolicitudesPagoanticipado> clientes = [];
  double montoFacturacion = 0;
  int cantidadFacturas = 0;
  int cantidadFacturasSeleccionadas = 0;
  double totalPagos = 0;

  double fondoDisponibleRestante = 0;
  double beneficioTotal = 0;
  final controllerFondoDisp = MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',');
  final controllerFondoDispFake = TextEditingController();

  final controllerBusqueda = TextEditingController();

  bool ejecBloq = false;
  bool gridSelected = true;

  Future<void> clearAll() async {
    clientes = [];

    montoFacturacion = 0;
    cantidadFacturas = 0;
    cantidadFacturasSeleccionadas = 0;
    totalPagos = 0;
    beneficioTotal = 0;
    fondoDisponibleRestante = 0;

    controllerFondoDisp.text = '0.00';
    controllerFondoDispFake.text = '';

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

      clientes = (response as List<dynamic>).map((cliente) => AutorizacionSolicitudesPagoanticipado.fromJson(jsonEncode(cliente))).toList();

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
                  'pago_anticipado_field': PlutoCell(value: factura.pagoAnticipado),
                  'dias_pago_field': PlutoCell(value: factura.diasPago),
                  'dias_adicionales_field': PlutoCell(value: 0),
                  'fecha_pago_field': PlutoCell(value: factura.fechaPago),
                  'estatus_id_field': PlutoCell(value: factura.estatusId),
                },
              ),
            );
          }

          cliente.rows = rows;
          cantidadFacturas = cantidadFacturas + cliente.facturas!.length;
        }
      }
    } catch (e) {
      log('Error en AutorizacionAolicitudesPagoAnticipadoProvider - getRecords() - $e');
    }
    return await calcClients();
  }

  Future<void> search() async {
    try {
      fondoDisponibleRestante = controllerFondoDisp.numberValue;
      montoFacturacion = 0;
      cantidadFacturas = 0;
      cantidadFacturasSeleccionadas = 0;
      totalPagos = 0;
      beneficioTotal = 0;
      clientes = [];
    } catch (e) {
      log('Error en AutorizacionAolicitudesPagoAnticipadoProvider - search() - $e');
    }
    return getRecords();
  }

  Future<void> seleccionAutomatica() async {
    //await uncheckAll();

    ejecBloq = true;
    notifyListeners();

    try {
      double beneficioMayor = 0;
      int idFactura = 0;
      bool exit = false;

      int vuelta = 0;

      while (exit != true) {
        for (var cliente in clientes) {
          for (var row in cliente.rows!) {
            if (row.checked == false) {
              if (beneficioMayor < row.cells["beneficio_cant_field"]!.value && row.cells["pago_anticipado_field"]!.value < fondoDisponibleRestante) {
                beneficioMayor = row.cells["beneficio_cant_field"]!.value;
                idFactura = row.cells["id_factura_field"]!.value;
              }

              if (vuelta == 1 && row.cells["id_factura_field"]!.value == idFactura) {
                row.setChecked(true);
                updateClientRows(cliente.nombreFiscal!);

                beneficioMayor = 0;
                idFactura = 0;
                vuelta = 0;
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
      log('Error en AutorizacionAolicitudesPagoAnticipadoProvider - seleccionAutomatica() - $e');
      ejecBloq = false;
      return notifyListeners();
    }
    ejecBloq = false;
    return notifyListeners();
  }

  Future<void> updateClientRows(String nombrecliente) async {
    try {
      for (var cliente in clientes) {
        if (cliente.nombreFiscal == nombrecliente) {
          cliente.facturasSeleccionadas = 0;
          cliente.facturacion = 0;
          cliente.beneficio = 0;
          cliente.pagoAdelantado = 0;
          for (var row in cliente.rows!) {
            DateTime fnp = DateTime(row.cells["fecha_pago_field"]!.value.year, row.cells["fecha_pago_field"]!.value.month, row.cells["fecha_pago_field"]!.value.day);
            DateTime now = DateTime.now();
            DateTime fpa = DateTime(now.year, now.month, now.day);
            int dac = row.cells["dias_adicionales_field"]!.value;
            double tasaAnual = 10 / 100; // TODO: Obtener Tasa Anual del mantenimiento de Clientes : cliente.tasaAnual;

            double x = tasaAnual / 360;
            int y = fnp.difference(fpa).inDays + 1 + dac;
            double z = x * y;

            double porcComision = double.parse((z).toStringAsFixed(6));
            double cantComision = porcComision * row.cells["importe_field"]!.value;
            double pagoanticipado = row.cells["importe_field"]!.value - cantComision;

            row.cells["beneficio_porc_field"]!.value = porcComision;
            row.cells["beneficio_cant_field"]!.value = cantComision;
            row.cells["pago_anticipado_field"]!.value = pagoanticipado;

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
      log('Error en AutorizacionAolicitudesPagoAnticipadoProvider - updateClientRows() - $e');
    }

    return await calcClients();
  }

  Future<void> checkClient(String nombrecliente, bool check) async {
    try {
      for (var cliente in clientes) {
        if (cliente.nombreFiscal == nombrecliente) {
          cliente.facturasSeleccionadas = 0;
          cliente.facturacion = 0;
          cliente.beneficio = 0;
          cliente.pagoAdelantado = 0;
          if (check) {
            for (var row in cliente.rows!) {
              row.setChecked(true);
              cliente.facturacion = cliente.facturacion! + row.cells["importe_field"]!.value;
              cliente.beneficio = cliente.beneficio! + row.cells["beneficio_cant_field"]!.value;
              cliente.pagoAdelantado = cliente.pagoAdelantado! + (row.cells["importe_field"]!.value - row.cells["beneficio_cant_field"]!.value);
              cliente.facturasSeleccionadas = cliente.facturasSeleccionadas! + 1;
            }
          } else {
            for (var row in cliente.rows!) {
              row.setChecked(false);
            }
          }
        }
      }
    } catch (e) {
      log('Error en AutorizacionAolicitudesPagoAnticipadoProvider - updateClientRows() - $e');
    }

    return await calcClients();
  }

  Future<void> uncheckAll() async {
    try {
      for (var cliente in clientes) {
        for (var row in cliente.rows!) {
          row.setChecked(false);
        }
        await updateClientRows(cliente.nombreFiscal!);
      }
    } catch (e) {
      log('Error en AutorizacionAolicitudesPagoAnticipadoProvider - uncheckAll() - $e');
    }
    return await calcClients();
  }

  Future<void> calcClients() async {
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
      log('Error en AutorizacionAolicitudesPagoAnticipadoProvider - checkInList() - $e');
    }

    clientes.sort((a, b) => b.facturasSeleccionadas!.compareTo(a.facturasSeleccionadas!));
    return notifyListeners();
  }

  Future<bool> updateRecords() async {
    ejecBloq = true;
    notifyListeners();
    try {
      /* for (var cliente in clientes) {
        for (var row in cliente.rows!) {
          if (row.checked == true) {
            await supabase.from('bitacora_estatus_facturas').insert(
              {
                'factura_id': row.cells['id_factura_field']!.value,
                'prev_estatus_id': row.cells['estatus_id_field']!.value,
                'post_estatus_id': 2,
                'pantalla': 'Selección de Pagos Anticipados',
                'descripcion': 'Factura seleccionada para su ejecución en la pantalla de Selección de Pagos Anticipados',
                'rol_id': currentUser!.rol.rolId,
                'usuario_id': currentUser!.id,
              },
            );

            await supabase.rpc(
              'update_factura_estatus',
              params: {
                'factura_id': row.cells['id_factura_field']!.value,
                'estatus_id': 2,
              },
            );

            if (row.cells["dias_adicionales_field"]!.value != 0) {
              await supabase.from('facturas').update(
                {
                  'porc_dpp': row.cells["beneficio_porc_field"]!.value * 100,
                  'cant_dpp': row.cells["beneficio_cant_field"]!.value,
                  'pago_anticipado': row.cells["pago_anticipado_field"]!.value,
                  'dias_pago_adicionales': row.cells["dias_adicionales_field"]!.value,
                },
              ).eq('factura_id', row.cells["id_factura_field"]!.value);
            }
          }
        }
      } */
      await clearAll();
    } catch (e) {
      log('Error en UpdatePartidasSolicitadas() - $e');
      ejecBloq = false;
      notifyListeners();
      return false;
    }
    return true;
  }
}
