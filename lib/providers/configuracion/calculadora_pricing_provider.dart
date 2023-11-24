import 'dart:convert';
import 'dart:developer';
import 'package:acp_web/helpers/globals.dart';
import 'package:acp_web/models/configuracion/calculadora_pricing_models.dart';
import 'package:flutter/material.dart';

class CalculadoraPricingProvider extends ChangeNotifier {
  TextEditingController costoFinancieroController = TextEditingController();
  TextEditingController costoOperativoController = TextEditingController();
  TextEditingController tarifaGOController = TextEditingController();
  TextEditingController isrController = TextEditingController();
  TextEditingController capitalBController = TextEditingController();
  TextEditingController costoCapitalController = TextEditingController();
  TextEditingController incrementoController = TextEditingController();
  TextEditingController perdidaController = TextEditingController();
  TextEditingController codigoClienteController = TextEditingController();
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
      costoFinancieroController.text = calculadora.costoFinanciero.toString();
      costoOperativoController.text = calculadora.costoOperativo.toString();
      tarifaGOController.text = calculadora.tarifaGo.toString();
      isrController.text = calculadora.isr.toString();
      capitalBController.text = calculadora.asignacionCapital.toString();
      costoCapitalController.text = calculadora.costoCapital.toString();
      incrementoController.text = calculadora.probabilidadIncremento.toString();
      perdidaController.text = calculadora.perdidaIncumplimineto.toString();
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
          'costo_financiero': costoFinancieroController.text,
          'costo_operativo': costoOperativoController.text,
          'tarifa_GO': tarifaGOController.text,
          'ISR': isrController.text,
          'asignacion_capital': capitalBController.text,
          'costo_capital': costoCapitalController.text,
          'probabilidad_incremento': incrementoController.text,
          'perdida_incumplimineto': perdidaController.text,
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
