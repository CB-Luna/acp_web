//import 'package:acp_web/providers/dashboards/dashboards_provider.dart';
//import 'package:acp_web/theme/theme.dart';
import 'package:acp_web/providers/reportes/dashboards_provider.dart';
import 'package:acp_web/theme/theme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:provider/provider.dart';

class GraficasDashboards extends StatefulWidget {
  const GraficasDashboards({
    super.key,
  });
  @override
  State<GraficasDashboards> createState() => _GraficasDashboardsState();
}

class _GraficasDashboardsState extends State<GraficasDashboards> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width / 1440;
    double height = MediaQuery.of(context).size.height / 1024;

    final DashboardsProvider provider = Provider.of<DashboardsProvider>(context);

    Widget leftTitleWidgets(double value, TitleMeta meta) {
      if (value == meta.max) {
        return Container();
      }
      return SideTitleWidget(
        axisSide: meta.axisSide,
        child: Text('$value',
            style: TextStyle(
              fontSize: 15,
              fontFamily: 'UniNeue',
              fontWeight: FontWeight.normal,
              color: AppTheme.of(context).primaryText,
            )),
      );
    }

    Widget bottomTitles(double value, TitleMeta meta) {
      final isTouched = value == provider.touchedIndex;
      final style = TextStyle(
        fontFamily: 'UniNeue',
        fontWeight: isTouched ? FontWeight.bold : FontWeight.normal,
        color: isTouched ? AppTheme.of(context).primaryColor : AppTheme.of(context).primaryText,
        fontSize: 15,
      );
      return SideTitleWidget(
        axisSide: meta.axisSide,
        //angle: 11,
        //angle: provider.dateList[0].length > 5 ? 7 : 0,
        //space: 40,
        child: Text(
            /* provider.range.start == findFirstDateOfTheYear(DateTime.now()) || provider.range.start == findFirstDateOfTheYear(DateTime(DateTime.now().year - 1, 1))
                ? provider.weekList[value.toInt()]
                : */
            provider.weekList[value.toInt()],
            textAlign: TextAlign.center,
            style: style),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          width: width * 450,
          height: height * 280,
          constraints: const BoxConstraints(minWidth: 400),
          decoration: BoxDecoration(
            color: AppTheme.of(context).tertiaryBackground,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  'Spend Proveedores por Condición de Pago',
                  style: AppTheme.of(context).title2,
                ),
                Text(
                  'total de Spend.Facturado',
                  style: AppTheme.of(context).bodyText1,
                ),
                //Cambiar por Grafica
                SizedBox(
                    width: width * 412,
                    height: height * 200,
                    child: provider.listSpend.isEmpty
                        ? const CircularProgressIndicator()
                        : BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              barTouchData: BarTouchData(
                                enabled: true,
                                touchTooltipData: BarTouchTooltipData(
                                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                      return BarTooltipItem(
                                          group.x == 0
                                              ? '0-30: ${provider.s30}'
                                              : group.x == 1
                                                  ? '31-45: ${provider.s3145}'
                                                  : group.x == 2
                                                      ? '46-89: ${provider.s4689}'
                                                      : group.x == 3
                                                          ? '90: ${provider.s90}'
                                                          : '>90: ${provider.sm90}',
                                          TextStyle(
                                            color: group.x == 0
                                                ? provider.shipping
                                                : group.x == 1
                                                    ? provider.testing
                                                    : group.x == 2
                                                        ? provider.packaging
                                                        : group.x == 3
                                                            ? provider.delivering
                                                            : provider.provisioning,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ));
                                    },
                                    tooltipBgColor: const Color.fromARGB(255, 204, 204, 204)),
                                touchCallback: (FlTouchEvent event, barTouchResponse) {
                                  setState(() {
                                    if (!event.isInterestedForInteractions || barTouchResponse == null || barTouchResponse.spot == null) {
                                      provider.touchedIndex = -1;
                                      return;
                                    }
                                    provider.touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
                                  });
                                },
                              ),
                              titlesData: FlTitlesData(
                                show: true,
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    //reservedSize: 55,
                                    getTitlesWidget: bottomTitles,
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 80,
                                    getTitlesWidget: leftTitleWidgets,
                                  ),
                                ),
                                topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                              ),
                              gridData: FlGridData(
                                show: true,
                                checkToShowHorizontalLine: (value) => value % 10 == 0,
                                getDrawingHorizontalLine: (value) => const FlLine(
                                  color: Color(0xffe7e8ec),
                                  strokeWidth: 1,
                                ),
                                drawVerticalLine: false,
                              ),
                              borderData: FlBorderData(
                                show: true,
                              ),
                              groupsSpace: 50,
                              barGroups: [
                                provider.barra(0, provider.s30, provider.shipping),
                                provider.barra(1, provider.s3145, provider.testing),
                                provider.barra(2, provider.s4689, provider.packaging),
                                provider.barra(3, provider.s90, provider.delivering),
                                provider.barra(4, provider.sm90, provider.provisioning),
                              ],
                            ),
                          ))
              ],
            ),
          ),
        ),
        Container(
          width: width * 450,
          height: height * 280,
          constraints: const BoxConstraints(minWidth: 400),
          decoration: BoxDecoration(
            color: AppTheme.of(context).tertiaryBackground,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  'No. Proveedores por Condicion de Pago',
                  style: AppTheme.of(context).title2,
                ),
                Text(
                  'Total: # de clientes que se descuentan en cada condicion de pago',
                  style: AppTheme.of(context).bodyText1,
                ),
                //Cambiar por Grafica
                SizedBox(
                    width: width * 412,
                    height: height * 200,
                    child: provider.listSpend.isEmpty
                        ? const CircularProgressIndicator()
                        : BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              barTouchData: BarTouchData(
                                enabled: true,
                                touchTooltipData: BarTouchTooltipData(
                                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                      return BarTooltipItem(
                                          group.x == 0
                                              ? '0-30: ${provider.c030}'
                                              : group.x == 1
                                                  ? '31-45: ${provider.c3145}'
                                                  : group.x == 2
                                                      ? '46-89: ${provider.c4689}'
                                                      : group.x == 3
                                                          ? '90: ${provider.c90}'
                                                          : '>90: ${provider.cm90}',
                                          TextStyle(
                                            color: group.x == 0
                                                ? provider.shipping
                                                : group.x == 1
                                                    ? provider.testing
                                                    : group.x == 2
                                                        ? provider.packaging
                                                        : group.x == 3
                                                            ? provider.delivering
                                                            : provider.provisioning,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ));
                                    },
                                    tooltipBgColor: const Color.fromARGB(255, 204, 204, 204)),
                                touchCallback: (FlTouchEvent event, barTouchResponse) {
                                  setState(() {
                                    if (!event.isInterestedForInteractions || barTouchResponse == null || barTouchResponse.spot == null) {
                                      provider.touchedIndex = -1;
                                      return;
                                    }
                                    provider.touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
                                  });
                                },
                              ),
                              titlesData: FlTitlesData(
                                show: true,
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    //reservedSize: 55,
                                    getTitlesWidget: bottomTitles,
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 80,
                                    getTitlesWidget: leftTitleWidgets,
                                  ),
                                ),
                                topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                              ),
                              gridData: FlGridData(
                                show: true,
                                checkToShowHorizontalLine: (value) => value % 10 == 0,
                                getDrawingHorizontalLine: (value) => const FlLine(
                                  color: Color(0xffe7e8ec),
                                  strokeWidth: 1,
                                ),
                                drawVerticalLine: false,
                              ),
                              borderData: FlBorderData(
                                show: true,
                              ),
                              groupsSpace: 50,
                              barGroups: [
                                provider.barra(0, provider.c030, provider.shipping),
                                provider.barra(1, provider.c3145, provider.testing),
                                provider.barra(2, provider.c4689, provider.packaging),
                                provider.barra(3, provider.c90, provider.delivering),
                                provider.barra(4, provider.cm90, provider.provisioning),
                              ],
                            ),
                          ))
              ],
            ),
          ),
        ),
      ],
    );
  }
}
