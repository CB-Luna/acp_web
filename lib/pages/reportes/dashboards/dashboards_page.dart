import 'package:acp_web/helpers/globals.dart';
import 'package:acp_web/pages/reportes/dashboards/widgets/contenedores_dashboards.dart';
import 'package:acp_web/pages/reportes/dashboards/widgets/graficas_dashboards.dart';
import 'package:acp_web/pages/reportes/dashboards/widgets/marcadores.dart';
import 'package:acp_web/pages/reportes/dashboards/widgets/tabla_dashboards.dart';
import 'package:acp_web/pages/widgets/custom_header_options.dart';
import 'package:acp_web/pages/widgets/custom_side_menu.dart';
import 'package:acp_web/pages/widgets/custom_side_notifications.dart';
import 'package:acp_web/pages/widgets/custom_top_menu.dart';
import 'package:acp_web/pages/widgets/footer.dart';
import 'package:acp_web/providers/reportes/dashboards_provider.dart';
import 'package:acp_web/providers/visual_state/visual_state_provider.dart';
import 'package:acp_web/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:provider/provider.dart';

class DashboardsPage extends StatefulWidget {
  const DashboardsPage({super.key});

  @override
  State<DashboardsPage> createState() => _DashboardsPageState();
}

class _DashboardsPageState extends State<DashboardsPage> {
  bool filterSelected = false;
  bool gridSelected = false;
  bool listOpenned = true;

  late List<PlutoGridStateManager> listStateManager;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      /* final AprobacionSeguimientoPagosProvider provider = Provider.of<AprobacionSeguimientoPagosProvider>(
        context,
        listen: false,
      ); */
    });
  }

  @override
  Widget build(BuildContext context) {
    String? monedaSeleccionada = currentUser!.monedaSeleccionada;
    double width = MediaQuery.of(context).size.width / 1440;
    //double height = MediaQuery.of(context).size.height / 1024;

    final VisualStateProvider visualState = Provider.of<VisualStateProvider>(context);
    visualState.setTapedOption(6);
    final DashboardsProvider provider = Provider.of<DashboardsProvider>(context);
    return Scaffold(
      backgroundColor: AppTheme.of(context).primaryBackground,
      body: SizedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const CustomSideMenu(),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  //Top Menu
                  CustomTopMenu(
                    pantalla: 'Reportes',
                    controllerBusqueda: provider.controllerBusqueda,
                    onSearchChanged: (p0) async {
                      await provider.search();
                    },
                    onMonedaSeleccionada: () async {
                      //await provider.aprobacionSeguimientoPagos();
                    },
                  ),
                  //Contenido
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: SingleChildScrollView(
                        controller: ScrollController(),
                        scrollDirection: Axis.vertical,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CustomHeaderOptions(
                              encabezado: 'Dashboards',
                              filterSelected: filterSelected,
                              gridSelected: gridSelected,
                              onFilterSelected: () {
                                setState(() {
                                  filterSelected = !filterSelected;
                                });
                              },
                              onGridSelected: () {
                                setState(() {
                                  gridSelected = true;
                                });
                              },
                              onListSelected: () {
                                setState(() {
                                  gridSelected = false;
                                });
                              },
                            ),
                            //Marcadores
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: Container(
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.of(context).tertiaryColor)),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Marcadores(
                                        width: width,
                                        titulo: 'Tasa Minima',
                                        cantidad: '720',
                                        porcentaje: 15,
                                        icono: Icons.file_open,
                                        moneda: 'GTQ',
                                        color: AppTheme.of(context).blueBackground,
                                      ),
                                      Marcadores(
                                        width: width,
                                        titulo: 'Tasa Maxima',
                                        cantidad: '720',
                                        porcentaje: 15,
                                        icono: Icons.file_open,
                                        moneda: 'GTQ',
                                        color: AppTheme.of(context).purpleBackground,
                                      ),
                                      Marcadores(
                                        width: width,
                                        titulo: 'Moda',
                                        cantidad: '720',
                                        porcentaje: 15,
                                        icono: Icons.file_open,
                                        moneda: 'GTQ',
                                        color: AppTheme.of(context).blueBackground,
                                      ),
                                      Marcadores(
                                        width: width,
                                        titulo: 'Media',
                                        cantidad: '720',
                                        porcentaje: 15,
                                        icono: Icons.file_open,
                                        moneda: 'GTQ',
                                        color: AppTheme.of(context).purpleBackground,
                                      ),
                                      Marcadores(
                                        width: width,
                                        titulo: 'Tasa Promedio\nPonderada',
                                        cantidad: '720',
                                        porcentaje: 15,
                                        icono: Icons.file_open,
                                        moneda: 'GTQ',
                                        color: AppTheme.of(context).blueBackground,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            //Contenedores
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: ContenedoresDashboards(
                                moneda: monedaSeleccionada!,
                              ),
                            ),
                            //Graficas
                            const Padding(
                              padding: EdgeInsets.only(bottom: 16),
                              child: GraficasDashboards(),
                            ),
                            //Tabla
                            const Padding(
                              padding: EdgeInsets.only(bottom: 16),
                              child: TablaDashboards(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  //Footer
                  const Footer(),
                ],
              ),
            ),
            const CustomSideNotifications(),
          ],
        ),
      ),
    );
  }
}
