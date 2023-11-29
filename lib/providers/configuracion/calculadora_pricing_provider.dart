import 'dart:convert';
import 'dart:developer';
import 'package:acp_web/functions/money_format.dart';
import 'package:acp_web/helpers/globals.dart';
import 'package:acp_web/models/configuracion/calculadora_pricing_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

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
  late CalculadoraPricing calculadora;
  bool ejecBloq = false;

  Future<void> search() async {
    try {} catch (e) {
      log('Error en aprobacionSeguimientoPagos - search() - $e');
    }
    return;
  }

  Future<void> getCalculadoraPricing() async {
    try {
      var response = await supabase.from('calculadora_pricing').select().order('id', ascending: false).limit(1);
      calculadora = CalculadoraPricing.fromJson(jsonEncode(response[0]));
      costoFinancieroController.text = moneyFormat(calculadora.costoFinanciero!);
      costoOperativoController.text = moneyFormat(calculadora.costoOperativo!);
      tarifaGOController.text = moneyFormat(calculadora.tarifaGo!);
      isrController.text = moneyFormat(calculadora.isr!);
      capitalBController.text = moneyFormat(calculadora.asignacionCapital!);
      costoCapitalController.text = moneyFormat(calculadora.costoCapital!);
      incrementoController.text = moneyFormat(calculadora.probabilidadIncremento!);
      perdidaController.text = moneyFormat(calculadora.perdidaIncumplimineto!);
      notifyListeners();
    } catch (e) {
      log('Error en getCalculadoraPricing- $e');
    }
  }

  Future<bool> calculadoraPricing() async {
    ejecBloq = true;
    notifyListeners();
    try {
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
        },
      );
    } catch (e) {
      log('Error en calculadoraPricing- $e');
      ejecBloq = false;
      notifyListeners();
    }
    notifyListeners();
    return true;
  }
}
