import 'package:acp_web/pages/cuentas_por_cobrar/solicitud_pagos/widgets/contenedores_solicitud_pagos.dart';
import 'package:acp_web/pages/cuentas_por_cobrar/solicitud_pagos/widgets/custome_card_solicitud_pagos.dart';
import 'package:acp_web/pages/widgets/custom_header_options.dart';
import 'package:acp_web/pages/widgets/custom_scrollbar.dart';
import 'package:acp_web/pages/widgets/custom_side_menu.dart';
import 'package:acp_web/pages/widgets/custom_side_notifications.dart';
import 'package:acp_web/pages/widgets/custom_top_menu.dart';
import 'package:acp_web/pages/widgets/footer.dart';
import 'package:acp_web/providers/cuentas_por_cobrar/solicitud_pagos_provider.dart';
import 'package:acp_web/providers/visual_state/visual_state_provider.dart';
import 'package:acp_web/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:provider/provider.dart';

class SolicitudPagosPage extends StatefulWidget {
  const SolicitudPagosPage({super.key});

  @override
  State<SolicitudPagosPage> createState() => _SolicitudPagosPageState();
}

class _SolicitudPagosPageState extends State<SolicitudPagosPage> {
  bool filterSelected = false;
  bool gridSelected = false;

  bool listOpenned = true;

  late List<PlutoGridStateManager> listStateManager;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final SolicitudPagosProvider provider = Provider.of<SolicitudPagosProvider>(
        context,
        listen: false,
      );
      await provider.solicitudPagos();
    });
  }

  @override
  Widget build(BuildContext context) {
    //double width = MediaQuery.of(context).size.width / 1440;
    double height = MediaQuery.of(context).size.height / 1024;

    final VisualStateProvider visualState = Provider.of<VisualStateProvider>(context);
    final SolicitudPagosProvider provider = Provider.of<SolicitudPagosProvider>(context);
    visualState.setTapedOption(8);

    //final bool permisoCaptura = currentUser!.rol.permisos.extraccionDeFacturas == 'C';
    //String? monedaSeleccionada = currentUser!.monedaSeleccionada;

    //final CuentasPorCobrarProvider provider = Provider.of<CuentasPorCobrarProvider>(context);
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
                    pantalla: 'Cuentas por Cobrar',
                    controllerBusqueda: provider.controllerBusqueda,
                    onSociedadSeleccionada: () async {
                      await provider.solicitudPagos();
                    },
                    onMonedaSeleccionada: () async {
                      await provider.solicitudPagos();
                    },
                    onSearchChanged: (p0) async {
                      await provider.search();
                    },
                  ),

                  //Contenido
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          CustomHeaderOptions(
                            encabezado: 'Solicitud de Pagos',
                            filterSelected: filterSelected,
                            gridSelected: gridSelected,
                            onFilterSelected: () {
                              setState(() {
                                filterSelected = !filterSelected;
                              });
                            },
                            ondownloadExcel: () async {
                              await provider.solicitudExcel();
                            },
                            onGridSelected: null,
                            onListSelected: null,
                          ),
                          const ContenedoresSolicitudPagos(),
                          //Titulos
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Container(
                              //width: double.infinity,
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
                                            Icons.assignment,
                                            size: 20,
                                            color: AppTheme.of(context).primaryBackground,
                                          ),
                                          Text(
                                            'Factura',
                                            style: AppTheme.of(context).subtitle1.override(
                                                  fontFamily: AppTheme.of(context).subtitle1Family,
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
                                            Icons.person,
                                            size: 20,
                                            color: AppTheme.of(context).primaryBackground,
                                          ),
                                          Text(
                                            'Sociedad',
                                            style: AppTheme.of(context).subtitle1.override(
                                                  fontFamily: AppTheme.of(context).subtitle1Family,
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
                                            Icons.receipt_long,
                                            size: 20,
                                            color: AppTheme.of(context).primaryBackground,
                                          ),
                                          Text(
                                            'Importe',
                                            style: AppTheme.of(context).subtitle1.override(
                                                  fontFamily: AppTheme.of(context).subtitle1Family,
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
                                                  fontFamily: AppTheme.of(context).subtitle1Family,
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
                                            Icons.calendar_month,
                                            color: AppTheme.of(context).primaryBackground,
                                          ),
                                          Text(
                                            'Días para Pago',
                                            style: AppTheme.of(context).subtitle1.override(
                                                  fontFamily: AppTheme.of(context).subtitle1Family,
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
                                            Icons.shopping_bag,
                                            color: AppTheme.of(context).primaryBackground,
                                          ),
                                          Text(
                                            'Pago Anticipado',
                                            style: AppTheme.of(context).subtitle1.override(
                                                  fontFamily: AppTheme.of(context).subtitle1Family,
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
                                    provider.facturas.isEmpty
                                        ? const CircularProgressIndicator()
                                        : Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: provider.facturas.length,
                                              scrollDirection: Axis.vertical,
                                              itemBuilder: (BuildContext ctx, index) {
                                                return CustomeCardSolicitudPagos(
                                                  propuesta: provider.facturas[index],
                                                );
                                              },
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
                  ),
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
