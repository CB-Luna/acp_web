import 'dart:convert';
import 'dart:developer';
//import 'dart:typed_data';

import 'package:acp_web/functions/date_format.dart';
import 'package:acp_web/functions/money_format.dart';
import 'package:acp_web/models/models.dart';
import 'package:excel/excel.dart';
import 'package:http/http.dart' as http;

import 'package:acp_web/helpers/constants.dart';
import 'package:acp_web/helpers/globals.dart';
import 'package:acp_web/models/configuracion/calculadora_pricing_models.dart';
import 'package:acp_web/models/seleccion_pagos_anticipados/seleccion_pagos_anticipados_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:pluto_grid/pluto_grid.dart';

class SeleccionaPagosanticipadosProvider extends ChangeNotifier {
  PlutoGridStateManager? stateManager;

  List<SeleccionPagosAnticipados> clientes = [];
  List<SeleccionPagosAnticipados> respaldo = [];
  double montoFacturacion = 0;
  int cantidadFacturas = 0;
  int cantidadFacturasSeleccionadas = 0;
  double totalPagos = 0;

  double fondoDisponibleRestante = 0;
  double comisionTotal = 0;
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
    comisionTotal = 0;
    fondoDisponibleRestante = 0;

    controllerFondoDisp.text = '0.00';
    controllerFondoDispFake.text = '';

    controllerBusqueda.clear();

    return await getRecords();
  }

  Future<void> getRecords() async {
    ejecBloq = true;
    notifyListeners();
    if (stateManager != null) {
      stateManager!.setShowLoading(true);
    }

    cantidadFacturas = 0;
    fondoDisponibleRestante = controllerFondoDisp.numberValue;

    try {
      var responseCalc = await supabase.from("calculadora_pricing").select().order("id", ascending: false);
      List<CalculadoraPricing> calculadoras = (responseCalc as List<dynamic>).map((calculadora) => CalculadoraPricing.fromJson(jsonEncode(calculadora))).toList();

      var response = await supabase.rpc(
        "seleccion_pagos_anticipados",
        params: {
          "busqueda": controllerBusqueda.text,
          "nom_sociedades": currentUser!.sociedadSeleccionada!.clave == "Todas" ? listaSociedades!.map((sociedad) => sociedad.clave).toList() : [currentUser!.sociedadSeleccionada!.clave],
          "nom_monedas": currentUser!.monedaSeleccionada != null ? [currentUser!.monedaSeleccionada] : ["GTQ", "USD"], //TODO: Change
        },
      ).select();

      clientes = (response as List<dynamic>).map((cliente) => SeleccionPagosAnticipados.fromJson(jsonEncode(cliente))).toList();

      for (var cliente in clientes) {
        cliente.facturas!.sort((a, b) => b.cantComision!.compareTo(a.cantComision!));

        List<PlutoRow> rows = [];

        if (cliente.facturas != null && cliente.facturas!.isNotEmpty) {
          CalculadoraPricing calculadora = calculadoras.firstWhere((element) => element.sociedad == cliente.sociedad);
          for (var factura in cliente.facturas!) {
            var imq = factura.importe!;
            var ago = calculadora.tarifaGo!; //Asignación de Gasto Operativo
            var diasDif = factura.fechaNormalPago!.difference(DateTime(factura.fechaExtraccion!.year, factura.fechaExtraccion!.month, factura.fechaExtraccion!.day)).inDays;

            var iod = ((cliente.tae! / 360) * (diasDif)) * (imq); //Ingresos por operación de descuento
            var pa = imq - iod; //Pago Anticipado
            var cfi = ((calculadora.costoFinanciero! / 365) * (diasDif)) * (pa); //Costo Financiero
            var mfi = iod - cfi; //Margen Financiero
            var mop = mfi - ago; //Margen Operativo

            factura.upfn = ((mop - calculadora.isr!) / imq) * (360 / (diasDif));
            factura.mpfn = ((mfi - ago) / imq) * (360 / (diasDif));

            cliente.facturacionTotal = cliente.facturacionTotal! + factura.importe!;

            rows.add(
              PlutoRow(
                checked: factura.fechaSolicitud != null,
                cells: {
                  'id_factura_field': PlutoCell(value: factura.facturaId),
                  'id_cliente_field': PlutoCell(value: cliente.clienteId),
                  'cuenta_field': PlutoCell(value: factura.noDoc),
                  'moneda_field': PlutoCell(value: factura.moneda),
                  'importe_field': PlutoCell(value: factura.importe),
                  'comision_porc_field': PlutoCell(value: factura.porcComision),
                  'comision_cant_field': PlutoCell(value: factura.cantComision),
                  'pago_anticipado_field': PlutoCell(value: factura.pagoAnticipado),
                  'dias_pago_field': PlutoCell(value: factura.diasPago),
                  'dias_adicionales_field': PlutoCell(value: 0),
                  'fecha_extraccion_field': PlutoCell(value: factura.fechaExtraccion),
                  'fecha_normal_pago_field': PlutoCell(value: factura.fechaNormalPago),
                  'estatus_id_field': PlutoCell(value: factura.estatusId),
                  //
                  'upfn_field': PlutoCell(value: factura.upfn),
                  'mpfn_field': PlutoCell(value: factura.mpfn),
                },
              ),
            );

            if (factura.fechaSolicitud != null) {
              cliente.facturasSeleccionadas = cliente.facturasSeleccionadas! + 1;
            }
          }

          cliente.rows = rows;
          cantidadFacturas = cantidadFacturas + cliente.facturas!.length;
        }

        if (cliente.facturasSeleccionadas != 0) {
          updateClientRows(cliente);
        }
      }
    } catch (e) {
      log('Error en SeleccionaPagosanticipadosProvider - getRecords() - $e');
    }
    await calcClients();

    ejecBloq = false;
    return notifyListeners();
  }

  Future<void> search(String busqueda) async {
    try {
      if (respaldo.isEmpty) {
        respaldo = clientes;
      } else {
        //Almacenamiento de cambios que haya realizado el usuario al realizar una selección sobre una busqueda
        for (var cliente in clientes) {
          for (var clienteResp in respaldo) {
            if (clienteResp.clienteId == cliente.clienteId) {
              for (var row in cliente.rows!) {
                for (var rowResp in clienteResp.rows!) {
                  if (rowResp.cells["id_factura_field"]!.value == row.cells["id_factura_field"]!.value && rowResp.cells["id_cliente_field"]!.value == row.cells["id_cliente_field"]!.value) {
                    rowResp.setChecked(row.checked);
                  }
                }
              }
            }
          }
        }

        //Reinicio de indicadores
        fondoDisponibleRestante = controllerFondoDisp.numberValue;
        montoFacturacion = 0;
        cantidadFacturas = 0;
        cantidadFacturasSeleccionadas = 0;
        totalPagos = 0;
        comisionTotal = 0;
        clientes = [];

        //Obtención información de la busqueda realizada
        await getRecords();

        //De lo respaldado se sobreescribe sobre los datos obtenidos
        for (var cliente in clientes) {
          for (var clienteResp in respaldo) {
            if (clienteResp.clienteId == cliente.clienteId) {
              for (var row in cliente.rows!) {
                for (var rowResp in clienteResp.rows!) {
                  if (rowResp.cells["id_factura_field"]!.value == row.cells["id_factura_field"]!.value && rowResp.cells["id_cliente_field"]!.value == row.cells["id_cliente_field"]!.value) {
                    row.setChecked(rowResp.checked);
                  }
                }
              }
              //Se encontró relación con un cliente del respaldo con uno obtenido de la busqueda
              updateClientRows(cliente);
            }
          }
        }

        if (busqueda.isEmpty) {
          respaldo = [];
        }
      }

      //Calculo de indicadores superiores
      await calcClients();
    } catch (e) {
      log('Error en AutorizacionSolicitudesPagoAnticipadoProvider - search() - $e');
    }
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
          if (!cliente.bloqueado) {
            for (var row in cliente.rows!) {
              if (row.checked == false) {
                if (beneficioMayor < row.cells["comision_cant_field"]!.value && row.cells["pago_anticipado_field"]!.value < fondoDisponibleRestante) {
                  beneficioMayor = row.cells["comision_cant_field"]!.value;
                  idFactura = row.cells["id_factura_field"]!.value;
                }

                if (vuelta == 1 && row.cells["id_factura_field"]!.value == idFactura) {
                  row.setChecked(true);
                  updateClientRows(cliente);

                  beneficioMayor = 0;
                  idFactura = 0;
                  vuelta = 0;
                }
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
      return notifyListeners();
    }
    ejecBloq = false;
    return notifyListeners();
  }

  Future<void> blockClient(SeleccionPagosAnticipados cliente, bool lock) async {
    try {
      cliente.bloqueado = lock;
      notifyListeners();
    } catch (e) {
      log('Error en SeleccionaPagosanticipadosProvider - blockClient() - $e');
    }
  }

  Future<void> updateClientRows(SeleccionPagosAnticipados cliente) async {
    try {
      cliente.facturasSeleccionadas = 0;
      cliente.facturacion = 0;
      cliente.comision = 0;
      cliente.pagoAdelantado = 0;
      cliente.margenOperativo = 0;
      cliente.utilidadNeta = 0;

      double sumaUpfn = 0;
      double sumaMpfn = 0;
      //Realizamos los calculos necesarios para la obtención del dato "Facturación"
      for (var row in cliente.rows!) {
        DateTime fnp = DateTime(row.cells["fecha_normal_pago_field"]!.value.year, row.cells["fecha_normal_pago_field"]!.value.month, row.cells["fecha_normal_pago_field"]!.value.day);
        DateTime now = row.cells["fecha_extraccion_field"]!.value;
        DateTime fpa = DateTime(now.year, now.month, now.day);
        int dac = row.cells["dias_adicionales_field"]!.value;

        double x = (cliente.tae! / 100) / 360;
        int y = fnp.difference(fpa).inDays + 1 + dac;
        double z = x * y;

        double porcComision = double.parse((z).toStringAsFixed(6));
        double cantComision = porcComision * row.cells["importe_field"]!.value;
        double pagoanticipado = row.cells["importe_field"]!.value - cantComision;

        row.cells["comision_porc_field"]!.value = porcComision;
        row.cells["comision_cant_field"]!.value = cantComision;
        row.cells["pago_anticipado_field"]!.value = pagoanticipado;

        if (row.checked == true) {
          cliente.facturacion = cliente.facturacion! + row.cells["importe_field"]!.value;
        }
      }

      //Una vez obtenido el dato de "Facturación", obtenemos el dato "TAE" según las condiciones siguientes
      if ((cliente.facturacionMayorA != null && cliente.tasaPreferencial != null) && cliente.facturacion! > cliente.facturacionMayorA!) {
        cliente.tae = cliente.tasaPreferencial;
      } else if (cliente.facturacionTotal! >= 100000 && currentUser!.monedaSeleccionada == 'GTQ') {
        cliente.tae = 33;
      } else {
        cliente.tae = cliente.tasaAnual;
      }

      cliente.facturasSeleccionadas = 0;
      cliente.facturacion = 0;
      cliente.comision = 0;
      cliente.pagoAdelantado = 0;
      cliente.margenOperativo = 0;
      cliente.utilidadNeta = 0;

      sumaUpfn = 0;
      sumaMpfn = 0;

      //Obtenemos los datos colocados en la pantalla "Calculadora Pricing" para la obtención de datos como "Margen Operativo" y "Utilidad Neta"
      var responseCalc = await supabase.from("calculadora_pricing").select().order("id", ascending: false);
      List<CalculadoraPricing> calculadoras = (responseCalc as List<dynamic>).map((calculadora) => CalculadoraPricing.fromJson(jsonEncode(calculadora))).toList();
      CalculadoraPricing calculadora = calculadoras.firstWhere((element) => element.sociedad == cliente.sociedad);

      for (var factura in cliente.facturas!) {
        var imq = factura.importe!;
        var ago = calculadora.tarifaGo!; //Asignación de Gasto Operativo
        var diasDif = factura.fechaNormalPago!.difference(factura.fechaExtraccion!).inDays;

        var iod = ((cliente.tae! / 360) * (diasDif)) * (imq); //Ingresos por operación de descuento
        var pa = imq - iod; //Pago Anticipado
        var cfi = ((calculadora.costoFinanciero! / 365) * (diasDif)) * (pa); //Costo Financiero
        var mfi = iod - cfi; //Margen Financiero
        var mop = mfi - ago; //Margen Operativo

        factura.upfn = ((mop - calculadora.isr!) / imq) * (360 / (diasDif)); //Utilidad de la factura
        factura.mpfn = ((mfi - ago) / imq) * (360 / (diasDif)); //Margen de la factura

        //cliente.facturacionTotal = cliente.facturacionTotal! + factura.importe!;

        for (var row in cliente.rows!) {
          //Si la "Factura" de la iteración actual es igual al "Renglón" de la iteración actual
          if (row.cells["id_factura_field"]!.value == factura.facturaId) {
            row.cells["upfn_field"]!.value = factura.upfn;
            row.cells["mpfn_field"]!.value = factura.mpfn;

            //Si el "Renglón" de la iteración actual está marcado
            if (row.checked == true) {
              cliente.facturacion = cliente.facturacion! + row.cells["importe_field"]!.value;
              cliente.comision = cliente.comision! + row.cells["comision_cant_field"]!.value;
              cliente.pagoAdelantado = cliente.pagoAdelantado! + (row.cells["importe_field"]!.value - row.cells["comision_cant_field"]!.value);

              cliente.facturasSeleccionadas = cliente.facturasSeleccionadas! + 1;

              sumaUpfn = sumaUpfn + row.cells["upfn_field"]!.value;
              sumaMpfn = sumaMpfn + row.cells["mpfn_field"]!.value;
            }
          }
        }
      }

      if (cliente.facturasSeleccionadas != 0) {
        cliente.utilidadNeta = sumaUpfn / cliente.facturasSeleccionadas!;
        cliente.margenOperativo = sumaMpfn / cliente.facturasSeleccionadas!;
      }
    } catch (e) {
      log('Error en SeleccionaPagosanticipadosProvider - updateClientRows() - $e');
    }

    return await calcClients();
  }

  Future<void> checkClient(SeleccionPagosAnticipados cliente, bool check) async {
    try {
      if (check) {
        for (var row in cliente.rows!) {
          row.setChecked(true);
          //cliente.facturacion = cliente.facturacion! + row.cells["importe_field"]!.value;
          //cliente.comision = cliente.comision! + row.cells["comision_cant_field"]!.value;
          //cliente.pagoAdelantado = cliente.pagoAdelantado! + (row.cells["importe_field"]!.value - row.cells["comision_cant_field"]!.value);
          //cliente.facturasSeleccionadas = cliente.facturasSeleccionadas! + 1;
        }
      } else {
        for (var row in cliente.rows!) {
          row.setChecked(false);
        }
      }
      return await updateClientRows(cliente);
    } catch (e) {
      log('Error en SeleccionaPagosanticipadosProvider - checkClient() - $e');
    }

    return await calcClients();
  }

  Future<void> uncheckAll() async {
    try {
      for (var cliente in clientes) {
        for (var row in cliente.rows!) {
          row.setChecked(false);
        }
        await updateClientRows(cliente);
      }
    } catch (e) {
      log('Error en SeleccionaPagosanticipadosProvider - uncheckAll() - $e');
    }
    return await calcClients();
  }

  Future<void> calcClients() async {
    montoFacturacion = 0;
    cantidadFacturasSeleccionadas = 0;
    totalPagos = 0;
    fondoDisponibleRestante = 0;
    comisionTotal = 0;
    try {
      for (var cliente in clientes) {
        montoFacturacion = montoFacturacion + cliente.facturacion!;
        cantidadFacturasSeleccionadas = cantidadFacturasSeleccionadas + cliente.facturasSeleccionadas!;
        comisionTotal = comisionTotal + cliente.comision!;
        totalPagos = montoFacturacion - comisionTotal;

        fondoDisponibleRestante = controllerFondoDisp.numberValue - totalPagos;
      }
    } catch (e) {
      log('Error en SeleccionaPagosanticipadosProvider - calcClients() - $e');
    }

    clientes.sort((a, b) => b.comision!.compareTo(a.comision!));
    return notifyListeners();
  }

  Future<bool> updateRecords() async {
    ejecBloq = true;
    notifyListeners();
    try {
      for (var cliente in clientes) {
        for (var row in cliente.rows!) {
          if (row.checked == true) {
            await supabase.from('bitacora_estatus_facturas').insert(
              {
                'factura_id': row.cells['id_factura_field']!.value,
                'prev_estatus_id': row.cells['estatus_id_field']!.value,
                'post_estatus_id': 11,
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
                'estatus_id': 11,
              },
            );

            if (row.cells["dias_adicionales_field"]!.value != 0) {
              await supabase.from('facturas').update(
                {
                  'porc_comision': row.cells["comision_porc_field"]!.value * 100,
                  'cant_comision': row.cells["comision_cant_field"]!.value,
                  'pago_anticipado': row.cells["pago_anticipado_field"]!.value,
                  'dias_pago_adicionales': row.cells["dias_adicionales_field"]!.value,
                },
              ).eq('factura_id', row.cells["id_factura_field"]!.value);
            }
          }
        }
      }

      final response = await http.post(
        Uri.parse(apiGatewayUrl),
        body: json.encode(
          {
            "user": "Web",
            "action": "bonitaProcessInstantiation",
            "process": "ACP_Propuesta_Pago_Anticipado",
            "data": {},
          },
        ),
      );

      if (response.statusCode > 204) {
        return false;
      }

      await clearAll();
    } catch (e) {
      log('Error en SeleccionaPagosanticipadosProvider - Error en updateRecords() - $e');
      ejecBloq = false;
      notifyListeners();
      return false;
    }
    return true;
  }

  ////////////Excel////////////////
  Future<bool> seleccionPagosExcel(SeleccionPagosAnticipados facturas) async {
    try {
      //Crear excel
      Excel excel = Excel.createExcel();
      Sheet sheet = excel['Selección de pagos anticipados'];

      //Agregar primera lineas
      sheet.getColumnAutoFits;
      sheet.appendRow([
        'Selección de pagos anticipados',
        '',
        'Usuario',
        '${currentUser?.nombreCompleto}',
        '',
        'Fecha:',
        dateFormat(DateTime.now()),
        'Sociedad',
        '${facturas.nombreFiscal}-${facturas.sociedad}',
      ]);

      //Agregar linea vacia
      sheet.appendRow(['']);
      sheet.appendRow(['Cuenta', 'Importe', '% Comisión', 'Comisión', 'Pago Anticipado', 'Días para pago', 'DAC']);
      for (var factura in facturas.rows!) {
        sheet.appendRow([
          factura.cells['cuenta_field']!.value,
          '${currentUser!.monedaSeleccionada!} ${moneyFormat(factura.cells['importe_field']!.value)}',
          '${moneyFormat(factura.cells['comision_porc_field']!.value * 100)} %',
          '${currentUser!.monedaSeleccionada!} ${moneyFormat(factura.cells['comision_cant_field']!.value)}',
          '${currentUser!.monedaSeleccionada!} ${moneyFormat(factura.cells['pago_anticipado_field']!.value)}',
          factura.cells['dias_pago_field']!.value,
          factura.cells['dias_adicionales_field']!.value,
        ]);
      }

      //Borrar Sheet1 default
      excel.delete('Sheet1');

      //Descargar
      final List<int>? fileBytes = excel.save(fileName: "Selección_Pagos_Anticipados_${facturas.nombreFiscal}_${facturas.sociedad!}.xlsx");
      if (fileBytes == null) return false;

      return true;
    } catch (e) {
      log('error in excel-$e');
      return false;
    }
  }
}
