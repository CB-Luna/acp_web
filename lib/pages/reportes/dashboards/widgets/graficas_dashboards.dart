//import 'package:acp_web/providers/dashboards/dashboards_provider.dart';
//import 'package:acp_web/theme/theme.dart';
import 'package:acp_web/theme/theme.dart';
import 'package:flutter/material.dart';
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

    //final DashboardsProvider provider = Provider.of<DashboardsProvider>(context);

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
                  child: Image.asset(
                    'assets/images/grafica 1.PNG',
                    fit: BoxFit.cover,
                  ),
                )
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
                  child: Image.asset(
                    'assets/images/grafica 2.PNG',
                    fit: BoxFit.cover,
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
