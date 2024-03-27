import 'dart:convert';
import 'dart:developer';
import 'package:acp_web/helpers/globals.dart';
import 'package:acp_web/models/dashboards/grafica_condicion_pago.dart';
import 'package:acp_web/models/dashboards/grafica_spend.dart';
import 'package:acp_web/models/dashboards/indicadores_anexos.dart';
import 'package:acp_web/models/dashboards/indicadores_dias.dart';
import 'package:acp_web/models/dashboards/indicadores_tasa_dashboards.dart';
import 'package:acp_web/models/dashboards/tabla_dashboard.dart';
import 'package:acp_web/pages/widgets/dateranges.dart';
import 'package:acp_web/theme/theme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:pluto_grid/pluto_grid.dart';

class DashboardsProvider extends ChangeNotifier {
  final controllerBusqueda = TextEditingController();
  double montoFacturacion = 0;
  int cantidadFacturas = 0;
  int cantidadFacturasSeleccionadas = 0;
  double numAnexos = 0;
  double totalPagos = 0;
  bool ejecBloq = false;
  List<PlutoRow> rows = [];
  DateTime now = DateTime.now();
  DateRange range = DateRange(DateTime.now().subtract(const Duration(days: 7)), DateTime.now());
  DateTimeRange dateRange = DateTimeRange(start: DateTime.now().subtract(const Duration(days: 7)), end: DateTime.now());

  //Indicadores Tasa
  List<IndicadoresTasaDashboards> indicadoresTaza = [];
  double tMaxima = 0, tMinima = 0, moda = 0, media = 0, tPromedio = 0;
  double pMaxima = 0, pMinima = 0, pModa = 0, pMedia = 0, pPromedio = 0;
  String rMaxima = '', rMinima = '', rModa = '', rMedia = '', rPromedio = '';
  double dMaxima = 0, dMinima = 0, dModa = 0, dMedia = 0, dPromedio = 0;
  //Indicadores Anexos
  List<IndicadoresAnexos> indicadoresAnexos = [];
  List<IndicadoresDias> indicadoresDias = [];
  double genereados = 0, aceptados = 0, cancelados = 0, pagados = 0, dias = 0;
  //Tabla
  List<TablaDashboard> listTabla = [];

  //Graficas
  List<GraficaSpend> listSpend = [];
  List<GraficaCondicionPago> listCondicion = [];
  List<String> weekList = ['0-30', '31-45', '46-89', '90', '>90'];
  double s30 = 0, s3145 = 0, s4689 = 0, s90 = 0, sm90 = 0;
  double c030 = 0, c3145 = 0, c4689 = 0, c90 = 0, cm90 = 0;
  int touchedIndex = -1;
  Color shipping = const Color(0XFF2EA437), testing = const Color(0xFF8B84DC), packaging = const Color(0XFF5446E6), delivering = const Color(0xFFA6CD28), provisioning = const Color(0xFF692EA4);

  Future<void> search() async {
    try {} catch (e) {
      log('Error en aprobacionSeguimientoPagos - search() - $e');
    }
    return;
  }

  Future<void> updateState() async {
    clearAll();
    await getIndicadoresTasa();
    await getIndicadoresAnexos();
    await getTabla();
    await getGrafica();
  }

  clearAll() {
    tMaxima = 0;
    tMinima = 0;
    moda = 0;
    media = 0;
    tPromedio = 0;
    genereados = 0;
    aceptados = 0;
    cancelados = 0;
    pagados = 0;
    dias = 0;
    s30 = 0;
    s3145 = 0;
    s4689 = 0;
    s90 = 0;
    sm90 = 0;
    c030 = 0;
    c3145 = 0;
    c4689 = 0;
    c90 = 0;
    cm90 = 0;
  }

  //Indicadores Tasa
  Future<void> getIndicadoresTasa() async {
    try {
      final res = await supabase
          .from('indicadores_tasas_dashboard')
          .select('*')
          .eq('cliente',
              'Ejem - ClearOne, Inc.') // 'soceidad', currentUser!.sociedadSeleccionada!.clave == "Todas" ? listaSociedades!.map((sociedad) => sociedad.clave).toList() : [currentUser!.sociedadSeleccionada!.clave],
          .gte('created_at', range.start)
          .lte('created_at', range.end);
      indicadoresTaza.clear();
      indicadoresTaza = (res as List<dynamic>).map((quote) => IndicadoresTasaDashboards.fromJson(jsonEncode(quote))).toList();
      for (var indicador in indicadoresTaza) {
        tMaxima = tMaxima + indicador.tasaMaxima!;
        tMinima = tMinima + indicador.tasaMinima!;
        moda = moda + indicador.moda!;
        media = media + indicador.media!;
        tPromedio = tPromedio + indicador.promedio!;
      }
      // Calculando la suma de los valores de los indicadores
      double sumaValoresIndicadores = tMaxima + tMinima + moda + media + tPromedio;

      // Verificando si todos los valores son cero
      if (sumaValoresIndicadores == 0) {
      // Si todos los valores son cero, establecer los porcentajes a cero
        rMaxima = '0.00';
        rMinima = '0.00';
        rModa = '0.00';
        rMedia = '0.00';
        rPromedio = '0.00';
      } else {
      // Calculando los porcentajes solo si la suma de los valores no es cero
        pMaxima = (tMaxima / sumaValoresIndicadores) * 100;
        pMinima = (tMinima / sumaValoresIndicadores) * 100;
        pModa = (moda / sumaValoresIndicadores) * 100;
        pMedia = (media / sumaValoresIndicadores) * 100;
        pPromedio = (tPromedio / sumaValoresIndicadores) * 100;

      // Redondeando los porcentajes a 2 decimales y convirtiéndolos a cadena
        rMaxima = pMaxima.toStringAsFixed(2);
        rMinima = pMinima.toStringAsFixed(2);
        rModa = pModa.toStringAsFixed(2);
        rMedia = pMedia.toStringAsFixed(2);
        rPromedio = pPromedio.toStringAsFixed(2);
      }
      // Convirtiendo las cadenas a valores double si es necesario
      dMaxima = double.parse(rMaxima);
      dMinima = double.parse(rMinima);
      dModa = double.parse(rModa);
      dMedia = double.parse(rMedia);
      dPromedio = double.parse(rPromedio);

      notifyListeners();
    } catch (e) {
      log('Error en  getIndicadoresTasa() - $e');
    }
  }

  //Indicadores anexos
  Future<void> getIndicadoresAnexos() async {
    try {
      //anexos
      final res = await supabase
          .from('indicadores_anexos_dashboard')
          .select('*')
          .eq('cliente',
              'Ejem - ClearOne, Inc.') // 'soceidad', currentUser!.sociedadSeleccionada!.clave == "Todas" ? listaSociedades!.map((sociedad) => sociedad.clave).toList() : [currentUser!.sociedadSeleccionada!.clave],
          .gte('created_at', range.start)
          .lte('created_at', range.end);
      indicadoresAnexos.clear();
      indicadoresAnexos = (res as List<dynamic>).map((quote) => IndicadoresAnexos.fromJson(jsonEncode(quote))).toList();
      for (var indicador in indicadoresAnexos) {
        genereados = genereados + indicador.generados!;
        aceptados = aceptados + indicador.aceptados!;
        cancelados = cancelados + indicador.cancelados!;
        pagados = pagados + indicador.pagados!;
      }
      //dias promedio
      final res2 = await supabase
          .from('indicadores_dias_credito_dashboard')
          .select('*')
          .eq('cliente',
              'Ejem - ClearOne, Inc.') // 'soceidad', currentUser!.sociedadSeleccionada!.clave == "Todas" ? listaSociedades!.map((sociedad) => sociedad.clave).toList() : [currentUser!.sociedadSeleccionada!.clave],
          .gte('created_at', range.start)
          .lte('created_at', range.end);
      indicadoresDias.clear();
      indicadoresDias = (res2 as List<dynamic>).map((quote) => IndicadoresDias.fromJson(jsonEncode(quote))).toList();
      for (var indicador in indicadoresDias) {
        dias = dias + indicador.diasPromedio!;
      }
      notifyListeners();
    } catch (e) {
      log('Error en  getIndicadoresAnexos() - $e');
    }
  }

//Tabla
  Future<void> getTabla() async {
    try {
      final res = await supabase
          .from('parreto_clientes_comision')
          .select('*')
          .eq('cliente',
              'Ejem - ClearOne, Inc.') // 'soceidad', currentUser!.sociedadSeleccionada!.clave == "Todas" ? listaSociedades!.map((sociedad) => sociedad.clave).toList() : [currentUser!.sociedadSeleccionada!.clave],
          .gte('created_at', range.start)
          .lte('created_at', range.end);
      listTabla.clear();
      listTabla = (res as List<dynamic>).map((quote) => TablaDashboard.fromJson(jsonEncode(quote))).toList();
      for (var registro in listTabla) {
        rows.add(
          PlutoRow(
            cells: {
              'cliente_field': PlutoCell(value: registro.cliente),
              'tasa_field': PlutoCell(value: registro.tasaCliente),
              'importe_field': PlutoCell(value: registro.importe),
              'created_at': PlutoCell(value: registro.createdAt),
              'sociedad_field': PlutoCell(value: registro.sociedad)
            },
          ),
        );
      }
      notifyListeners();
    } catch (e) {
      log('Error en  getIndicadoresTasa() - $e');
    }
  }

//Puntos Grafica
  Future<void> getGrafica() async {
    try {
      final res = await supabase
          .from('grafica_clientes_x_condicion_pago')
          .select('*')
          .eq('cliente',
              'Ejem - ClearOne, Inc.') // 'soceidad', currentUser!.sociedadSeleccionada!.clave == "Todas" ? listaSociedades!.map((sociedad) => sociedad.clave).toList() : [currentUser!.sociedadSeleccionada!.clave],
          .gte('created_at', range.start)
          .lte('created_at', range.end);
      listSpend = (res as List<dynamic>).map((quote) => GraficaSpend.fromJson(jsonEncode(quote))).toList();
      for (var lista in listSpend) {
        s30 = s30 + (lista.clientesDiasJson!.dias030!);
        s3145 = s3145 + (lista.clientesDiasJson!.dias3145!);
        s4689 = s4689 + (lista.clientesDiasJson!.dias4689!);
        s90 = s90 + (lista.clientesDiasJson!.dias90!);
        sm90 = sm90 + (lista.clientesDiasJson!.diasM90!);
      }

      final res2 = await supabase
          .from('grafica_total_facturado_x_condicion_pago')
          .select('*')
          .eq('cliente',
              'Ejem - ClearOne, Inc.') // 'soceidad', currentUser!.sociedadSeleccionada!.clave == "Todas" ? listaSociedades!.map((sociedad) => sociedad.clave).toList() : [currentUser!.sociedadSeleccionada!.clave],
          .gte('created_at', range.start)
          .lte('created_at', range.end);
      listCondicion = (res2 as List<dynamic>).map((quote) => GraficaCondicionPago.fromJson(jsonEncode(quote))).toList();
      for (var lista in listCondicion) {
        c030 = c030 + (lista.totalFacturadoDiasJson!.dias030!);
        c3145 = c3145 + (lista.totalFacturadoDiasJson!.dias3145!);
        c4689 = c4689 + (lista.totalFacturadoDiasJson!.dias4689!);
        c90 = c90 + (lista.totalFacturadoDiasJson!.dias90!);
        cm90 = cm90 + (lista.totalFacturadoDiasJson!.totalFacturadoDiasJsonDias90!);
      }

      notifyListeners();
    } catch (e) {
      log('Error en  getIndicadoresTasa() - $e');
    }
  }

  BarChartGroupData barra(int x, double fondosNu, Color color) {
    return BarChartGroupData(
      x: x,
      groupVertically: true,
      barsSpace: 20,
      barRods: [
        BarChartRodData(fromY: 0, toY: fondosNu, color: color, width: 50, borderRadius: BorderRadius.zero),
      ],
    );
  }

  BarChartGroupData getData(int x, double y1, y2, y3, y4, y5) {
    return BarChartGroupData(
      x: x,
      barsSpace: 0,
      barRods: [
        BarChartRodData(
            width: 20,
            toY: y1,
            color: shipping,
            rodStackItems: [
              BarChartRodStackItem(0, y1, shipping),
            ],
            borderRadius: const BorderRadius.all(Radius.zero)),
        BarChartRodData(
            width: 20,
            toY: y2,
            color: testing,
            rodStackItems: [
              BarChartRodStackItem(0, y2, testing),
            ],
            borderRadius: const BorderRadius.all(Radius.zero)),
        BarChartRodData(
          width: 20,
          toY: y3,
          color: packaging,
          rodStackItems: [
            BarChartRodStackItem(0, y3, packaging),
          ],
          borderRadius: const BorderRadius.all(Radius.zero),
        ),
        BarChartRodData(
            width: 20,
            toY: y4,
            color: delivering,
            rodStackItems: [
              BarChartRodStackItem(0, y4, delivering),
            ],
            borderRadius: const BorderRadius.all(Radius.zero)),
        BarChartRodData(
          width: 20,
          toY: y5,
          color: provisioning,
          rodStackItems: [
            BarChartRodStackItem(0, y5, provisioning),
          ],
          borderRadius: const BorderRadius.all(Radius.zero),
        )
      ],
    );
  }

  Widget datePickerBuilder(BuildContext context, dynamic Function(DateRange?) onDateRangeChanged, [bool doubleMonth = true]) => DateRangePickerWidget(
        doubleMonth: doubleMonth,
        quickDateRanges: [
          QuickDateRange(
            label: 'Today',
            dateRange: DateRange(
              DateTime.now(),
              DateTime.now(),
            ),
          ),
          QuickDateRange(
            label: 'This Week',
            dateRange: DateRange(
              findFirstDateOfTheWeek(DateTime.now()),
              findLastDateOfTheWeek(DateTime.now()),
            ),
          ),
          QuickDateRange(
            label: 'Previous Week',
            dateRange: DateRange(
              findFirstDateOfPreviousWeek(DateTime.now()),
              findLastDateOfPreviousWeek(DateTime.now()),
            ),
          ),
          QuickDateRange(
            label: 'This Month',
            dateRange: DateRange(
              DateTime(DateTime.now().year, DateTime.now().month, 1),
              findLastDateOfTheMonth(
                DateTime(DateTime.now().year, DateTime.now().month, 1),
              ),
            ),
          ),
          QuickDateRange(
            label: 'Previous Month',
            dateRange: DateRange(
              DateTime(DateTime.now().year, DateTime.now().month - 1, 1),
              findLastDateOfTheMonth(
                DateTime(DateTime.now().year, DateTime.now().month - 1, 1),
              ),
            ),
          ),
          QuickDateRange(
            label: 'This Quarter',
            dateRange: DateRange(
              findFirstDateOfTheQuarter(DateTime.now()),
              findLastDateOfTheQuarter(DateTime.now()),
            ),
          ),
          QuickDateRange(
            label: 'Previous Quarter',
            dateRange: DateRange(
              findFirstDateOfThePreviusQuarter(DateTime.now()),
              findLastDateOfThePreviusQuarter(DateTime.now()),
            ),
          ),
          QuickDateRange(
            label: 'This Year',
            dateRange: DateRange(
              findFirstDateOfTheYear(DateTime.now()),
              findLastDateOfTheYear(DateTime.now()),
            ),
          ),
          QuickDateRange(
            label: 'Previous Year',
            dateRange: DateRange(
              findFirstDateOfTheYear(
                DateTime(DateTime.now().year - 1, 1),
              ),
              findLastDateOfTheYear(
                DateTime(DateTime.now().year - 1, 1),
              ),
            ),
          ),
        ],
        initialDateRange: range,
        initialDisplayedDate: range.start,
        onDateRangeChanged: (DateRange? value) async {
          range = value!;
          await updateState();
          notifyListeners();
        },
        theme: CalendarTheme(
            selectedColor: AppTheme.of(context).primaryColor,
            dayNameTextStyle: TextStyle(color: AppTheme.of(context).primaryText, fontSize: 10), //texto dias
            inRangeColor: AppTheme.of(context).primaryColor.withOpacity(.2), //color rango seleccionado
            inRangeTextStyle: TextStyle(color: AppTheme.of(context).primaryColor),
            selectedTextStyle: TextStyle(color: AppTheme.of(context).primaryBackground),
            todayTextStyle: const TextStyle(fontWeight: FontWeight.bold),
            defaultTextStyle: TextStyle(color: AppTheme.of(context).primaryText, fontSize: 12),
            radius: 10,
            tileSize: 40,
            disabledTextStyle: const TextStyle(color: Colors.grey),
            selectedQuickDateRangeColor: AppTheme.of(context).primaryColor),
      );
}
