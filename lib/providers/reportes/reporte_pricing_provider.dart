import 'dart:convert';
import 'dart:developer';
import 'package:acp_web/functions/date_format.dart';
import 'package:acp_web/functions/money_format.dart';
import 'package:acp_web/helpers/globals.dart';
import 'package:acp_web/models/configuracion/calculadora_pricing_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:excel/excel.dart';

class ReportePricingProvider extends ChangeNotifier {
  late CalculadoraPricing calculadora;
  final taeController = MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',');
  final diasController = MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',');
  final montoQController = MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',');
  final numOperacionesController = MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',');
  TextEditingController fechaOperacionController = TextEditingController();
  TextEditingController fechaPagoController = TextEditingController();

  final controllerBusqueda = TextEditingController();

  double tComercial = 0;
  double iODescuento = 0;
  double cFinanciero = 0;
  double mFinanciero = 0, pMFinanciero = 0;
  double aGastoOperativo = 0;
  double mOperativo = 0, p1MOperativo = 0, p2MOperativo = 0;
  double isr = 0;
  double uNeta = 0, p1UNeta = 0, p2UNeta = 0;
  double aCapital = 0;
  double cCapital = 0;
  double eva = 0, pEva = 0;
  double roe = 0;

  bool ejecBloq = false;

  Future<void> search() async {
    try {} catch (e) {
      log('Error en aprobacionSeguimientoPagos - search() - $e');
    }
    return;
  }

  Future<void> reportePricing() async {
    try {
      var response = await supabase.from('calculadora_pricing').select().order('id', ascending: false).limit(1);
      calculadora = CalculadoraPricing.fromJson(jsonEncode(response[0]));
      iODescuento = (((taeController.numberValue / 360) * diasController.numberValue) * montoQController.numberValue); //27.77
      tComercial = (montoQController.numberValue - iODescuento); //72.22
      cFinanciero = (((calculadora.costoFinanciero! / 365) * diasController.numberValue) * tComercial); //0.812475
      mFinanciero = (iODescuento - cFinanciero);
      pMFinanciero = (mFinanciero / iODescuento);
      aGastoOperativo = (calculadora.tarifaGo! * numOperacionesController.numberValue);
      mOperativo = (mFinanciero - aGastoOperativo);
      p1MOperativo = (mOperativo / iODescuento);
      p2MOperativo = ((mOperativo / montoQController.numberValue) * (360 / diasController.numberValue));
      isr = calculadora.isr!;
      uNeta = (mOperativo - isr);
      p1UNeta = (uNeta / iODescuento);
      p2UNeta = ((uNeta / montoQController.numberValue) * (360 / diasController.numberValue));
      aCapital = (tComercial * calculadora.asignacionCapital!);
      cCapital = ((calculadora.costoCapital! / 365) * (diasController.numberValue) * (aCapital));
      eva = (uNeta - cCapital);
      pEva = (eva / iODescuento);
      roe = ((uNeta / aCapital) * (360 / diasController.numberValue));
      notifyListeners();
    } catch (e) {
      log('Error en aprobacionSeguimientoPagos - search() - $e');
    }
  }

  Future<bool> reportePricingExcel() async {
    //Crear excel

    Excel excel = Excel.createExcel();
    Sheet? sheet = excel.sheets[excel.getDefaultSheet()];

    if (sheet == null) return false;

    //Agregar primera linea
    sheet.appendRow([
      'Título',
      'Reporte Pricing',
      '',
      'Usuario',
      '${currentUser?.nombreCompleto}',
      '',
      'Fecha Creacion Resumen',
      dateFormat(DateTime.now()),
      'Fecha Pago',
      fechaPagoController.text,
      'Fecha Operación',
      fechaOperacionController.text,
    ]);

    //Agregar linea vacia
    sheet.appendRow(['']);
    sheet.appendRow(['Descripción', 'Importe', 'Porcentaje 1', 'Porcentaje 2']);
    sheet.appendRow(['Tamaño Comercial/Desembolso Real', moneyFormat(tComercial), '', '']);
    sheet.appendRow(['Ingresos por Operación de descuento', moneyFormat(iODescuento), '', '']);
    sheet.appendRow(['Costo Finaniero', moneyFormat(cFinanciero), '', '']);
    sheet.appendRow(['Margen Financiero', moneyFormat(mFinanciero), '${moneyFormat(pMFinanciero)} %', '']);
    sheet.appendRow(['']);
    sheet.appendRow(['Asignación de gasto operativo', moneyFormat(aGastoOperativo), '', '']);
    sheet.appendRow(['Margen Operativo', moneyFormat(mOperativo), '${moneyFormat(p1MOperativo)} %', '${moneyFormat(p2MOperativo)} %']);
    sheet.appendRow(['']);
    sheet.appendRow(['Utilidad Neta', moneyFormat(uNeta), '${moneyFormat(p1UNeta)} %', '${moneyFormat(p2UNeta)} %']);
    sheet.appendRow(['']);
    sheet.appendRow(['Asignación de capital', moneyFormat(aCapital), '', '']);
    sheet.appendRow(['Costo Capital', moneyFormat(cCapital), '', '']);
    sheet.appendRow(['']);
    sheet.appendRow(['EVA- Operación', moneyFormat(eva), '${moneyFormat(pEva)} %', '']);
    sheet.appendRow(['ROE- Operación', moneyFormat(roe), '', '']);

    //Descargar
    final List<int>? fileBytes = excel.save(fileName: "Reporte_Pricing.xlsx");
    if (fileBytes == null) return false;

    return true;
  }
}
