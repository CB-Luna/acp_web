import 'package:acp_web/helpers/globals.dart';
import 'package:acp_web/pages/pagos/widgets/tarjeta_mes.dart';
import 'package:acp_web/pages/widgets/custom_header_options.dart';
import 'package:acp_web/pages/widgets/custom_side_menu.dart';
import 'package:acp_web/pages/widgets/custom_side_notifications.dart';
import 'package:acp_web/pages/widgets/custom_top_menu.dart';
import 'package:acp_web/pages/widgets/footer.dart';
import 'package:acp_web/providers/providers.dart';
import 'package:acp_web/providers/visual_state/visual_state_provider.dart';
import 'package:acp_web/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:provider/provider.dart';

class PagosPage extends StatefulWidget {
  const PagosPage({super.key});

  @override
  State<PagosPage> createState() => _PagosPageState();
}

class _PagosPageState extends State<PagosPage> {
  bool filterSelected = false;

  bool listOpenned = false;

  late List<PlutoGridStateManager> listStateManager;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final PagosProvider provider = Provider.of<PagosProvider>(
        context,
        listen: false,
      );
      await provider.getRecords();
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width / 1440;
    double height = MediaQuery.of(context).size.height / 1024;

    final VisualStateProvider visualState = Provider.of<VisualStateProvider>(context);
    visualState.setTapedOption(3);

    //final bool permisoCaptura = currentUser!.rol.permisos.extraccionDeFacturas == 'C';
    String? monedaSeleccionada = currentUser!.monedaSeleccionada;

    final PagosProvider provider = Provider.of<PagosProvider>(context);

    return Scaffold(
      backgroundColor: AppTheme.of(context).primaryBackground,
      body: Stack(
        children: [
          SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CustomSideMenu(),
                Expanded(
                  child: Column(
                    children: [
                      //Top Menu
                      CustomTopMenu(
                        pantalla: 'Pagos',
                        controllerBusqueda: provider.controllerBusqueda,
                        onSearchChanged: (p0) async {
                          await provider.getRecords();
                        },
                        onMonedaSeleccionada: () async {
                          await provider.getRecords();
                        },
                      ),
                      //Contenido
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              //Encabezado
                              CustomHeaderOptions(
                                encabezado: 'Pagos',
                                filterSelected: filterSelected,
                                gridSelected: provider.gridSelected,
                                onFilterSelected: () {
                                  setState(() async {
                                    filterSelected = !filterSelected;
                                  });
                                },
                                onGridSelected: () {
                                  setState(() {
                                    provider.gridSelected = true;
                                  });
                                },
                                onListSelected: () {
                                  setState(() {
                                    provider.gridSelected = false;
                                  });
                                },
                              ),
                              //Lista
                              Padding(
                                padding: const EdgeInsets.only(top: 16),
                                child: Column(
                                  children: [
                                    //Encabezado
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 16.0),
                                      child: Container(
                                        width: double.infinity,
                                        //height: height * 79,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(6),
                                          color: AppTheme.of(context).primaryColor,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 5),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              //ID
                                              SizedBox(
                                                width: width * 50,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.badge_outlined,
                                                      size: 25,
                                                      color: AppTheme.of(context).primaryBackground,
                                                    ),
                                                    Text(
                                                      'ID',
                                                      style: AppTheme.of(context).title3.override(
                                                            fontFamily: AppTheme.of(context).title3Family,
                                                            useGoogleFonts: false,
                                                            color: AppTheme.of(context).primaryBackground,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              //Cliente
                                              SizedBox(
                                                width: width * 111,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.person,
                                                      size: 25,
                                                      color: AppTheme.of(context).primaryBackground,
                                                    ),
                                                    Text(
                                                      'Cliente',
                                                      style: AppTheme.of(context).title3.override(
                                                            fontFamily: AppTheme.of(context).title3Family,
                                                            useGoogleFonts: false,
                                                            color: AppTheme.of(context).primaryBackground,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              //Cuentas Anticipadas
                                              SizedBox(
                                                width: width * 61,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.task,
                                                      size: 25,
                                                      color: AppTheme.of(context).primaryBackground,
                                                    ),
                                                    Text(
                                                      'Cuentas Anticipadas',
                                                      textAlign: TextAlign.center,
                                                      style: AppTheme.of(context).title3.override(
                                                            fontFamily: AppTheme.of(context).title3Family,
                                                            useGoogleFonts: false,
                                                            color: AppTheme.of(context).primaryBackground,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              //Fecha Propuesta
                                              SizedBox(
                                                width: width * 70,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.event_outlined,
                                                      size: 25,
                                                      color: AppTheme.of(context).primaryBackground,
                                                    ),
                                                    Text(
                                                      'Fecha Propuesta',
                                                      textAlign: TextAlign.center,
                                                      style: AppTheme.of(context).title3.override(
                                                            fontFamily: AppTheme.of(context).title3Family,
                                                            useGoogleFonts: false,
                                                            color: AppTheme.of(context).primaryBackground,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              //Anticipo
                                              SizedBox(
                                                width: width * 130,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.payments_outlined,
                                                      size: 25,
                                                      color: AppTheme.of(context).primaryBackground,
                                                    ),
                                                    Text(
                                                      'Anticipo',
                                                      style: AppTheme.of(context).title3.override(
                                                            fontFamily: AppTheme.of(context).title3Family,
                                                            useGoogleFonts: false,
                                                            color: AppTheme.of(context).primaryBackground,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              //Comision
                                              SizedBox(
                                                width: width * 108,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.savings_outlined,
                                                      size: 25,
                                                      color: AppTheme.of(context).primaryBackground,
                                                    ),
                                                    Text(
                                                      'Comision',
                                                      style: AppTheme.of(context).title3.override(
                                                            fontFamily: AppTheme.of(context).title3Family,
                                                            useGoogleFonts: false,
                                                            color: AppTheme.of(context).primaryBackground,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              //Fecha Pago
                                              SizedBox(
                                                width: width * 90,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.calendar_month_outlined,
                                                      size: 25,
                                                      color: AppTheme.of(context).primaryBackground,
                                                    ),
                                                    Text(
                                                      'Fecha Pago',
                                                      textAlign: TextAlign.center,
                                                      style: AppTheme.of(context).title3.override(
                                                            fontFamily: AppTheme.of(context).title3Family,
                                                            useGoogleFonts: false,
                                                            color: AppTheme.of(context).primaryBackground,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              //Estatus
                                              SizedBox(
                                                width: width * 122,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.star_outline_sharp,
                                                      size: 25,
                                                      color: AppTheme.of(context).primaryBackground,
                                                    ),
                                                    Text(
                                                      'Estatus',
                                                      style: AppTheme.of(context).title3.override(
                                                            fontFamily: AppTheme.of(context).title3Family,
                                                            useGoogleFonts: false,
                                                            color: AppTheme.of(context).primaryBackground,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: width * 79,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.border_color_outlined,
                                                      size: 25,
                                                      color: AppTheme.of(context).primaryBackground,
                                                    ),
                                                    Text(
                                                      'Acciones',
                                                      style: AppTheme.of(context).title3.override(
                                                            fontFamily: AppTheme.of(context).title3Family,
                                                            useGoogleFonts: false,
                                                            color: AppTheme.of(context).primaryBackground,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    //Contenido
                                    SizedBox(
                                      //color: Colors.red,
                                      width: double.infinity,
                                      height: height * 680,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: provider.pagos.length,
                                        scrollDirection: Axis.vertical,
                                        itemBuilder: (BuildContext ctx, index) {
                                          return TarjetaMes(
                                            pagos: provider.pagos[index],
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              )
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
        ],
      ),
    );
  }
}


/* Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          'Mes Año',
                                                          style: AppTheme.of(context).title2,
                                                        ),
                                                        const SizedBox(height: 8),
                                                        ExpansionPanelList(
                                                          expandedHeaderPadding: EdgeInsets.zero,
                                                          elevation: 0,
                                                          children: [],
                                                        ),
                                                      ],
                                                    ), */