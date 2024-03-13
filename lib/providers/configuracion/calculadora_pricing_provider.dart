import 'dart:convert';
import 'dart:developer';
import 'package:acp_web/functions/money_format.dart';
import 'package:acp_web/helpers/globals.dart';
import 'package:acp_web/models/configuracion/calculadora_pricing_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:pluto_grid/pluto_grid.dart';

class CalculadoraPricingProvider extends ChangeNotifier {
  final costoFinancieroController = MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',', rightSymbol: '%');
  final costoOperativoController = MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',');
  final tarifaGOController = MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',');
  final isrController = MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',', rightSymbol: '%');
  final capitalBController = MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',', rightSymbol: '%');
  final costoCapitalController = MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',', rightSymbol: '%');
  final incrementoController = MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',', rightSymbol: '%');
  final perdidaController = MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',', rightSymbol: '%');

  final controllerBusqueda = TextEditingController();
  List<CalculadoraPricing> calculadoraList = [], calculadora = [];
  List<String> sociedad = [];
  bool ejecBloq = false;
  PlutoGridStateManager? stateManager;
  List<PlutoRow> rows = [];

  Future<void> updateState() async {
    controllerBusqueda.clear();
    await getCalculadoraPricing();
    await tablaCalculadora();
  }

  Future<void> search() async {
    try {} catch (e) {
      log('Error en aprobacionSeguimientoPagos - search() - $e');
    }
    return;
  }

  Future<void> getCalculadoraPricing() async {
    try {
      var response = await supabase.rpc(
        'get_calculadora_pricing',
        params: {
          "busqueda": controllerBusqueda.text,
          "nom_sociedades": [currentUser!.sociedadSeleccionada!],
        },
      );
      calculadora = (response as List<dynamic>).map((usuario) => CalculadoraPricing.fromJson(jsonEncode(usuario))).toList();
      costoFinancieroController.text = moneyFormat(calculadora.first.costoFinanciero!);
      costoOperativoController.text = moneyFormat(calculadora.first.costoOperativo!);
      tarifaGOController.text = moneyFormat(calculadora.first.tarifaGo!);
      isrController.text = moneyFormat(calculadora.first.isr!);
      capitalBController.text = moneyFormat(calculadora.first.asignacionCapital!);
      costoCapitalController.text = moneyFormat(calculadora.first.costoCapital!);
      incrementoController.text = moneyFormat(calculadora.first.probabilidadIncremento!);
      perdidaController.text = moneyFormat(calculadora.first.perdidaIncumplimineto!);
      notifyListeners();
    } catch (e) {
      log('Error en getCalculadoraPricing- $e');
    }
  }

  Future<bool> crearCalculadoraPricing() async {
    ejecBloq = true;
    notifyListeners();
    try {
      // Consultar si existe un registro con la sociedad actual
      final res = await supabase.from('calculadora_pricing').select().eq('sociedad', currentUser!.sociedadSeleccionada!).single();

      // Si se encontró un registro, actualizarlo
      if (res != null) {
        await supabase.from('calculadora_pricing').update(
          {
            'costo_financiero': costoFinancieroController.numberValue,
            'costo_operativo': costoOperativoController.numberValue,
            'tarifa_GO': tarifaGOController.numberValue,
            'ISR': isrController.numberValue,
            'asignacion_capital': capitalBController.numberValue,
            'costo_capital': costoCapitalController.numberValue,
            'probabilidad_incremento': incrementoController.numberValue,
            'perdida_incumplimineto': perdidaController.numberValue,
          },
        ).eq('sociedad', currentUser!.sociedadSeleccionada!);
      } else {
        // Si no se encontró un registro, insertar uno nuevo
        await supabase.from('calculadora_pricing').insert(
          {
            'costo_financiero': costoFinancieroController.numberValue,
            'costo_operativo': costoOperativoController.numberValue,
            'tarifa_GO': tarifaGOController.numberValue,
            'ISR': isrController.numberValue,
            'asignacion_capital': capitalBController.numberValue,
            'costo_capital': costoCapitalController.numberValue,
            'probabilidad_incremento': incrementoController.numberValue,
            'perdida_incumplimineto': perdidaController.numberValue,
            'sociedad': currentUser!.sociedadSeleccionada!,
          },
        );
      }
    } catch (e) {
      log('Error en crearCalculadoraPricing- $e');
      ejecBloq = false;
      notifyListeners();
      return false; // Devolver false para indicar que no se pudo completar la operación
    }

    ejecBloq = false;
    await tablaCalculadora();
    notifyListeners();
    return true;
  }

  Future<bool> borrarCalculadoraPricing(int id) async {
    try {
      final res = await supabase.from('calculadora_pricing').delete().eq('id', id);
      return res;
    } catch (e) {
      log('Error en borrarUsuario() - $e');
      return false;
    }
  }

  Future<void> cargarDatosCalculadoraPricing(int id) async {
    try {
      var response = await supabase.from('calculadora_pricing').select().eq('id', id);
      calculadora = (response as List<dynamic>).map((usuario) => CalculadoraPricing.fromJson(jsonEncode(usuario))).toList();
      costoFinancieroController.text = moneyFormat(calculadora.first.costoFinanciero!);
      costoOperativoController.text = moneyFormat(calculadora.first.costoOperativo!);
      tarifaGOController.text = moneyFormat(calculadora.first.tarifaGo!);
      isrController.text = moneyFormat(calculadora.first.isr!);
      capitalBController.text = moneyFormat(calculadora.first.asignacionCapital!);
      costoCapitalController.text = moneyFormat(calculadora.first.costoCapital!);
      incrementoController.text = moneyFormat(calculadora.first.probabilidadIncremento!);
      perdidaController.text = moneyFormat(calculadora.first.perdidaIncumplimineto!);
      notifyListeners();
    } catch (e) {
      log('Error en getCalculadoraPricing- $e');
    }
  }

  Future<void> tablaCalculadora() async {
    if (stateManager != null) {
      stateManager!.setShowLoading(true);
    }
    try {
      var res = await supabase.rpc(
        'get_calculadora_pricing',
        params: {
          "busqueda": controllerBusqueda.text,
          "nom_sociedades": listaSociedades,
        },
      );
      calculadoraList = (res as List<dynamic>).map((usuario) => CalculadoraPricing.fromJson(jsonEncode(usuario))).toList();
      rows.clear();
      for (var registro in calculadoraList) {
        rows.add(
          PlutoRow(
            cells: {
              'id': PlutoCell(value: registro.id),
              'sociedad': PlutoCell(value: registro.sociedad),
              'costo_financiero': PlutoCell(value: registro.costoFinanciero),
              'costo_operativo': PlutoCell(value: registro.costoOperativo),
              'tarifa_go': PlutoCell(value: registro.tarifaGo),
              'isr': PlutoCell(value: registro.isr),
              'capital_bill': PlutoCell(value: registro.asignacionCapital),
              'costo_capital': PlutoCell(value: registro.costoCapital),
              'probabilidad_incremento': PlutoCell(value: registro.probabilidadIncremento),
              'perdida_incumplimiento': PlutoCell(value: registro.asignacionCapital),
              'acciones': PlutoCell(value: ''),
            },
          ),
        );
      }

      notifyListeners();
    } catch (e) {
      log('Error en tablaCalculadora - $e');
    }
  }
}
