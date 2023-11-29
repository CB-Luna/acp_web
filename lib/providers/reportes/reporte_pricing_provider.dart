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
  final taeController = MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',', rightSymbol: '%');
  final montoQController = MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',');
  TextEditingController fechaOperacionController = TextEditingController();
  TextEditingController fechaPagoController = TextEditingController();
  TextEditingController diasControll = TextEditingController();
  TextEditingController nOperacionesController = TextEditingController();

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
  String fehcaPago = '', fechaOperacionE = '';

  bool ejecBloq = false;

  Future<void> search() async {
    try {} catch (e) {
      log('Error en aprobacionSeguimientoPagos - search() - $e');
    }
    return;
  }

  Future<void> reportePricing() async {
    try {
      DateTime parseDate(String dateStr) {
        // Parsear la cadena en un objeto DateTime con el formato dd/MM/yyyy
        List<String> parts = dateStr.split('/');
        int day = int.parse(parts[0]);
        int month = int.parse(parts[1]);
        int year = int.parse(parts[2]);
        return DateTime(year, month, day);
      }

      // Obtener las fechas ingresadas
      String fechaOperacion = fechaOperacionController.text;
      String fechaPago = fechaPagoController.text;

      // Validar que ambas fechas estén ingresadas y tengan el formato correcto
      const pattern = r"^\d{2}/\d{2}/\d{4}$";
      final regexp = RegExp(pattern);

      if (fechaOperacion.isNotEmpty && fechaPago.isNotEmpty && regexp.hasMatch(fechaOperacion) && regexp.hasMatch(fechaPago)) {
        // Convertir las fechas a objetos DateTime
        DateTime fechaOperacionDate = parseDate(fechaOperacion);
        DateTime fechaPagoDate = parseDate(fechaPago);

        // Calcular la diferencia de días
        int diferenciaDias = fechaPagoDate.difference(fechaOperacionDate).inDays;

        // Mostrar la diferencia de días en el tercer campo
        diasControll.text = diferenciaDias.toString();
      }

      // Llamado de los datos de la calculadora pricing
      var response = await supabase.from('calculadora_pricing').select().order('id', ascending: false).limit(1);
      calculadora = CalculadoraPricing.fromJson(jsonEncode(response[0]));

      //Operaciones fomrulario
      iODescuento = ((((taeController.numberValue/100) / 360) * double.parse(diasControll.text)) * montoQController.numberValue);
      tComercial = (montoQController.numberValue - iODescuento);
      cFinanciero = ((((calculadora.costoFinanciero!/100) / 365) * double.parse(diasControll.text)) * tComercial);
      mFinanciero = (iODescuento - cFinanciero);
      pMFinanciero = (mFinanciero / iODescuento);
      aGastoOperativo = (calculadora.tarifaGo! * double.parse(nOperacionesController.text));
      mOperativo = (mFinanciero - aGastoOperativo);
      p1MOperativo = (mOperativo / iODescuento);
      p2MOperativo = ((mOperativo / montoQController.numberValue) * (360 / double.parse(diasControll.text)));
      isr = (calculadora.isr!/100);
      uNeta = (mOperativo - isr);
      p1UNeta = (uNeta / iODescuento);
      p2UNeta = ((uNeta / montoQController.numberValue) * (360 / double.parse(diasControll.text)));
      aCapital = (tComercial * (calculadora.asignacionCapital!/100));
      cCapital = (((calculadora.costoCapital!/100) / 365) * (double.parse(diasControll.text)) * (aCapital));
      eva = (uNeta - cCapital);
      pEva = (eva / iODescuento);
      roe = ((uNeta / aCapital) * (360 / double.parse(diasControll.text)));

      //Registro Fechas para Excel
      fechaOperacionE = fechaOperacionController.text;
      fehcaPago = fechaPagoController.text;

      notifyListeners();
    } catch (e) {
      log('Error en reportePricing - $e');
    }
  }

  Future<bool> reportePricingExcel() async {
    //Crear excel

    Excel excel = Excel.createExcel();
    Sheet sheet = excel['Reporte_Pricing'];

    //Agregar primera linea
    sheet.setColumnWidth(0, 30);
    /*  sheet.setColumnWidth(5, 30);
    sheet.setColumnWidth(7, 30);
    sheet.setColumnWidth(9, 30); */
    /* sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: 0)).value = 'Fecha Creacion Resumen';
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: 0)).value = 'Fecha Pago';
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 9, rowIndex: 0)).value = 'Fecha Operación'; */
    sheet.appendRow([
      'Reporte Pricing',
      '',
      'Usuario',
      '${currentUser?.nombreCompleto}',
      '',
      'Fecha Creacion Resumen',
      dateFormat(DateTime.now()),
      'Fecha Operación',
      fechaOperacionE,
      'Fecha Pago',
      fehcaPago,
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

    //Borrar Sheet1 default
    excel.delete('Sheet1');

    //Descargar
    final List<int>? fileBytes = excel.save(fileName: "Reporte_Pricing.xlsx");
    if (fileBytes == null) return false;

    return true;
  }
}
