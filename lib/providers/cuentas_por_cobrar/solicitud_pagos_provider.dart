import 'dart:convert';
import 'dart:developer';

import 'package:acp_web/functions/date_format.dart';
import 'package:acp_web/functions/money_format.dart';
import 'package:acp_web/helpers/constants.dart';
import 'package:acp_web/helpers/globals.dart';
import 'package:acp_web/models/cuentas_por_cobrar/solicitud_pagos.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:http/http.dart' as http;

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
          'nom_sociedades': currentUser!.sociedadSeleccionada!.clave == "Todas" ? listaSociedades!.map((sociedad) => sociedad.clave).toList() : [currentUser!.sociedadSeleccionada!.clave],
          'nom_monedas': currentUser!.monedaSeleccionada != null ? [currentUser!.monedaSeleccionada] : ["GTQ", "USD"],
          'clienteid': currentUser!.cliente!.clienteId
        },
      ).select();
      facturas = (response as List<dynamic>).map((cliente) => SolicitudPagos.fromJson(jsonEncode(cliente))).toList();
      for (var factura in facturas) {
        factura.comision;
        cantidadFacturas = cantidadFacturas + facturas.length;
      }
      notifyListeners();
    } catch (e) {
      log('Error en solicitudPagos - $e');
    }
  }

  //Actualizar facturas seleccionadas
  Future<bool> actualizarFacturasSeleccionadas() async {
    if (stateManager != null) {
      stateManager!.setShowLoading(true);
    }
    try {
      final correos = await supabase.rpc('correos_gerentes', params: {});
      for (var correo in correos) {
        final response = await http.post(
          Uri.parse(apiGatewayUrl),
          body: json.encode(
            {
              "user": "Web",
              "action": "bonitaBpmCaseVariables",
              "process": "ACP_Solicitud_de_pago_anticipado",
              'data': {
                'variables': [
                  {
                    'name': 'cliente',
                    'value': currentUser!.nombreCompleto,
                  },
                  {
                    'name': 'numero',
                    'value': cantidadFacturasSeleccionadas.toString(),
                  },
                  {
                    'name': 'importe',
                    'value': moneyFormat(montoFacturacion),
                  },
                  {
                    'name': 'cliente_correo',
                    'value': correo,
                  },
                ]
              },
            },
          ),
        );
        if (response.statusCode > 204) {
          return false;
        }
        log((response.body));
      }

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

    await getRecords();
    await solicitudPagos();
    notifyListeners();
    return true;
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

  ///////////////////Excel/////////////////////////
  Future<bool> solicitudExcel() async {
    try {
      //Crear excel

      Excel excel = Excel.createExcel();
      Sheet sheet = excel['Solicitud Pagos'];

      //Agregar primera lineas
      sheet.getColumnAutoFits;
      sheet.appendRow([
        'Solicitud Pagos',
        '',
        'Usuario',
        '${currentUser?.nombreCompleto}',
        '',
        'Fecha:',
        dateFormat(DateTime.now()),
        'Sociedad',
        '${currentUser!.sociedadSeleccionada!.nombre}-${currentUser!.sociedadSeleccionada!.clave}',
      ]);

      //Agregar linea vacia
      sheet.appendRow(['']);
      sheet.appendRow(['Factura','Sociedad' ,'Importe', 'Comisión', 'Días para pago', 'Pago Anticipado']);
      for (var factura in facturas) {
        sheet.appendRow([
          factura.noDoc,
          factura.sociedad,
          '${currentUser!.monedaSeleccionada!} ${moneyFormat(factura.importe!)}',
          '${currentUser!.monedaSeleccionada!} ${moneyFormat(factura.comision!)}',
          factura.diasPago,
          '${currentUser!.monedaSeleccionada!} ${moneyFormat(factura.pagoAnticipado!)}'
        ]);

        //cantidadFacturas = cantidadFacturas + cliente.facturas!.length;
      }

      //Borrar Sheet1 default
      excel.delete('Sheet1');

      //Descargar
      final List<int>? fileBytes = excel.save(fileName: "Solicitud_Pagos_${currentUser!.sociedadSeleccionada!.nombre}_${currentUser!.sociedadSeleccionada!.clave}.xlsx");
      if (fileBytes == null) return false;

      return true;
    } catch (e) {
      log('error in excel-$e');
      return false;
    }
  }
}
