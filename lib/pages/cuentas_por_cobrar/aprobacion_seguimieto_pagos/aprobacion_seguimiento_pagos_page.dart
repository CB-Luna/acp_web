import 'package:acp_web/pages/cuentas_por_cobrar/aprobacion_seguimieto_pagos/widgets/contedor_mes.dart';
import 'package:acp_web/pages/widgets/custom_header_options.dart';
import 'package:acp_web/pages/widgets/custom_side_menu.dart';
import 'package:acp_web/pages/widgets/custom_side_notifications.dart';
import 'package:acp_web/pages/widgets/custom_top_menu.dart';
import 'package:acp_web/pages/widgets/footer.dart';
import 'package:acp_web/providers/cuentas_por_cobrar/aprobacion_seguimiento_pagos_provider.dart';
//import 'package:acp_web/providers/cuentas_por_cobrar/cuentas_por_cobrar_provider.dart';
import 'package:acp_web/providers/visual_state/visual_state_provider.dart';
import 'package:acp_web/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:provider/provider.dart';

class AprobacionSeguimientoPagosPage extends StatefulWidget {
  const AprobacionSeguimientoPagosPage({super.key});

  @override
  State<AprobacionSeguimientoPagosPage> createState() => _AprobacionSeguimientoPagosPageState();
}

class _AprobacionSeguimientoPagosPageState extends State<AprobacionSeguimientoPagosPage> {
  bool filterSelected = false;
  bool gridSelected = false;

  bool listOpenned = true;

  late List<PlutoGridStateManager> listStateManager;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final AprobacionSeguimientoPagosProvider provider = Provider.of<AprobacionSeguimientoPagosProvider>(
        context,
        listen: false,
      );
      await provider.aprobacionSeguimientoPagos();
    });
  }

  @override
  Widget build(BuildContext context) {
    //double width = MediaQuery.of(context).size.width / 1440;
    double height = MediaQuery.of(context).size.height / 1024;

    final VisualStateProvider visualState = Provider.of<VisualStateProvider>(context);
    visualState.setTapedOption(9);

    //final bool permisoCaptura = currentUser!.rol.permisos.extraccionDeFacturas == 'C';
    //String? monedaSeleccionada = currentUser!.monedaSeleccionada;

    final AprobacionSeguimientoPagosProvider provider = Provider.of<AprobacionSeguimientoPagosProvider>(context);

    List<Map<String, dynamic>> listadoEjemplo1 = [
      {
        "fechaEjecucion": "Sep 24",
        "Descripcion": 'Propuesta de pago anticipado',
        "anticipo": 581.44,
        "comision": 895904.57,
        "Estatus": 'Aprobado',
      },
      {
        "fechaEjecucion": "Sep 23",
        "Descripcion": 'Propuesta de pago anticipado',
        "anticipo": 581.44,
        "comision": 895904.57,
        "Estatus": 'Anexo Pendiente',
      },
      {
        "fechaEjecucion": "Sep 22",
        "Descripcion": 'Propuesta de pago anticipado',
        "anticipo": 581.44,
        "comision": 895904.57,
        "Estatus": 'Pagada',
      },
      {
        "fechaEjecucion": "Sep 21",
        "Descripcion": 'Propuesta de pago anticipado',
        "anticipo": 581.44,
        "comision": 895904.57,
        "Estatus": 'Cancelada',
      },
    ];

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
                  const CustomTopMenu(pantalla: 'Cuentas por Cobrar'),
                  //Contenido
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CustomHeaderOptions(
                            encabezado: 'Aprobación y Seguimiento de Pagos',
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
                          //Titulos
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Container(
                              width: double.infinity,
                              height: height * 79,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: const Color(0xFF0A0859),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 24),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.calendar_month,
                                            size: 20,
                                            color: AppTheme.of(context).primaryBackground,
                                          ),
                                          Text(
                                            'Fecha Ejecución',
                                            style: AppTheme.of(context).subtitle1.override(
                                                  fontFamily: 'Gotham',
                                                  useGoogleFonts: false,
                                                  color: AppTheme.of(context).primaryBackground,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.assignment,
                                            size: 20,
                                            color: AppTheme.of(context).primaryBackground,
                                          ),
                                          Text(
                                            'Descripción',
                                            style: AppTheme.of(context).subtitle1.override(
                                                  fontFamily: 'Gotham',
                                                  useGoogleFonts: false,
                                                  color: AppTheme.of(context).primaryBackground,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.business_center,
                                            color: AppTheme.of(context).primaryBackground,
                                          ),
                                          Text(
                                            'Anticipo',
                                            style: AppTheme.of(context).subtitle1.override(
                                                  fontFamily: 'Gotham',
                                                  useGoogleFonts: false,
                                                  color: AppTheme.of(context).primaryBackground,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.credit_card,
                                            color: AppTheme.of(context).primaryBackground,
                                          ),
                                          Text(
                                            'Comisión',
                                            style: AppTheme.of(context).subtitle1.override(
                                                  fontFamily: 'Gotham',
                                                  useGoogleFonts: false,
                                                  color: AppTheme.of(context).primaryBackground,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.local_offer,
                                            color: AppTheme.of(context).primaryBackground,
                                          ),
                                          Text(
                                            'Estatus',
                                            style: AppTheme.of(context).subtitle1.override(
                                                  fontFamily: 'Gotham',
                                                  useGoogleFonts: false,
                                                  color: AppTheme.of(context).primaryBackground,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.menu,
                                            color: AppTheme.of(context).primaryBackground,
                                          ),
                                          Text(
                                            'Acciones',
                                            style: AppTheme.of(context).subtitle1.override(
                                                  fontFamily: 'Gotham',
                                                  useGoogleFonts: false,
                                                  color: AppTheme.of(context).primaryBackground,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    //const SizedBox(width: 65),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          //Lista
                          SizedBox(
                            height: height * 1024 - 300,
                            child: provider.clientes.isEmpty
                                ? const CircularProgressIndicator()
                                : ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: 2,
                                    scrollDirection: Axis.vertical,
                                    itemBuilder: (BuildContext ctx, index) {
                                      return ContenedorMes(
                                          list: listadoEjemplo1, mes: provider.clientes[index].fechaSeleccion.month.toString(), year: provider.clientes[index].fechaSeleccion.year.toString());
                                    },
                                  ),
                          ),
                        ],
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
