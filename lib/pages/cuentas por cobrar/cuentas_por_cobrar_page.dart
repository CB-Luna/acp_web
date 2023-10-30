import 'package:acp_web/pages/cuentas%20por%20cobrar/customcard.dart';
import 'package:acp_web/pages/seleccion_pagos_anticipados/widgets/contenedores_pagos_anticipados.dart';
import 'package:acp_web/pages/seleccion_pagos_anticipados/widgets/custom_card.dart';
import 'package:acp_web/pages/seleccion_pagos_anticipados/widgets/custom_list.dart';
import 'package:acp_web/pages/widgets/custom_header_options.dart';
import 'package:acp_web/pages/widgets/custom_scrollbar.dart';
import 'package:acp_web/pages/widgets/custom_side_menu.dart';
import 'package:acp_web/pages/widgets/custom_side_notifications.dart';
import 'package:acp_web/pages/widgets/custom_top_menu.dart';
import 'package:acp_web/pages/widgets/footer.dart';
//import 'package:acp_web/providers/cuentas_por_cobrar/cuentas_por_cobrar_provider.dart';
import 'package:acp_web/providers/visual_state/visual_state_provider.dart';
import 'package:acp_web/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_side_menu/flutter_side_menu.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:provider/provider.dart';

class CuentasPorCobrarPage extends StatefulWidget {
  const CuentasPorCobrarPage({super.key});

  @override
  State<CuentasPorCobrarPage> createState() => _CuentasPorCobrarPageState();
}

class _CuentasPorCobrarPageState extends State<CuentasPorCobrarPage> {
  bool filterSelected = false;
  bool gridSelected = false;

  bool listOpenned = true;

  late List<PlutoGridStateManager> listStateManager;

  @override
  Widget build(BuildContext context) {
    //double width = MediaQuery.of(context).size.width / 1440;
    double height = MediaQuery.of(context).size.height / 1024;

    final VisualStateProvider visualState = Provider.of<VisualStateProvider>(context);
    visualState.setTapedOption(8);

    //final bool permisoCaptura = currentUser!.rol.permisos.extraccionDeFacturas == 'C';
    //String? monedaSeleccionada = currentUser!.monedaSeleccionada;

    //final CuentasPorCobrarProvider provider = Provider.of<CuentasPorCobrarProvider>(context);

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
    List<Map<String, dynamic>> listadoEjemplo2 = [
      {
        "fechaEjecucion": "Ago 24",
        "Descripcion": 'Propuesta de pago anticipado',
        "anticipo": 581.44,
        "comision": 895904.57,
        "Estatus": 'Aprobado',
      },
      {
        "fechaEjecucion": "Ago 23",
        "Descripcion": 'Propuesta de pago anticipado',
        "anticipo": 581.44,
        "comision": 895904.57,
        "Estatus": 'Anexo Pendiente',
      },
      {
        "fechaEjecucion": "Ago 22",
        "Descripcion": 'Propuesta de pago anticipado',
        "anticipo": 581.44,
        "comision": 895904.57,
        "Estatus": 'Pagada',
      },
      {
        "fechaEjecucion": "Ago 21",
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
                  Expanded(
                    child: SizedBox(
                      child: CustomScrollBar(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(.10),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(30),
                                    )),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'Septiembre 2023',
                                          style: AppTheme.of(context).subtitle1.override(
                                                fontFamily: 'Gotham',
                                                fontSize: 18,
                                                useGoogleFonts: false,
                                              ),
                                          overflow: TextOverflow.fade,
                                        ),
                                      ),
                                      ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: listadoEjemplo1.length,
                                        scrollDirection: Axis.vertical,
                                        itemBuilder: (BuildContext ctx, index) {
                                          return CustomeListCard(
                                            moneda: 'GTQ',
                                            fechaEjecucion: listadoEjemplo1[index]['fechaEjecucion'],
                                            descripcion: listadoEjemplo1[index]['Descripcion'],
                                            anticipo: listadoEjemplo1[index]['anticipo'],
                                            comision: listadoEjemplo1[index]['comision'],
                                            estatus: listadoEjemplo1[index]['Estatus'],
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(.1),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(30),
                                    )),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'Agosto 2023',
                                          style: AppTheme.of(context).subtitle1.override(
                                                fontFamily: 'Gotham',
                                                fontSize: 18,
                                                useGoogleFonts: false,
                                              ),
                                          overflow: TextOverflow.fade,
                                        ),
                                      ),
                                      ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: listadoEjemplo2.length,
                                        scrollDirection: Axis.vertical,
                                        itemBuilder: (BuildContext ctx, index) {
                                          return CustomeListCard(
                                            moneda: 'GTQ',
                                            fechaEjecucion: listadoEjemplo2[index]['fechaEjecucion'],
                                            descripcion: listadoEjemplo2[index]['Descripcion'],
                                            anticipo: listadoEjemplo2[index]['anticipo'],
                                            comision: listadoEjemplo2[index]['comision'],
                                            estatus: listadoEjemplo2[index]['Estatus'],
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
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
