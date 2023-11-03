import 'package:acp_web/pages/seleccion_pagos_anticipados/widgets/contenedores_pagos_anticipados.dart';
import 'package:acp_web/pages/seleccion_pagos_anticipados/widgets/custom_card.dart';
import 'package:acp_web/pages/seleccion_pagos_anticipados/widgets/custom_list.dart';
import 'package:acp_web/pages/widgets/custom_header_options.dart';
import 'package:acp_web/pages/widgets/custom_side_menu.dart';
import 'package:acp_web/pages/widgets/custom_side_notifications.dart';
import 'package:acp_web/pages/widgets/custom_top_menu.dart';
import 'package:acp_web/pages/widgets/footer.dart';
import 'package:acp_web/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:provider/provider.dart';

import 'package:acp_web/providers/providers.dart';
import 'package:acp_web/providers/visual_state/visual_state_provider.dart';

class SeleccionPagosAnticipadosPage extends StatefulWidget {
  const SeleccionPagosAnticipadosPage({super.key});

  @override
  State<SeleccionPagosAnticipadosPage> createState() => _SeleccionPagosAnticipadosPageState();
}

class _SeleccionPagosAnticipadosPageState extends State<SeleccionPagosAnticipadosPage> {
  bool filterSelected = false;

  bool listOpenned = false;

  late List<PlutoGridStateManager> listStateManager;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final SeleccionaPagosanticipadosProvider provider = Provider.of<SeleccionaPagosanticipadosProvider>(
        context,
        listen: false,
      );
      await provider.getRecords();
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height / 1024;

    final VisualStateProvider visualState = Provider.of<VisualStateProvider>(context);
    visualState.setTapedOption(1);

    //final bool permisoCaptura = currentUser!.rol.permisos.extraccionDeFacturas == 'C';
    //String? monedaSeleccionada = currentUser!.monedaSeleccionada;

    final SeleccionaPagosanticipadosProvider provider = Provider.of<SeleccionaPagosanticipadosProvider>(context);

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
                        pantalla: 'Propuesta de Pago',
                        controllerBusqueda: provider.controllerBusqueda,
                        onSearchChanged: (p0) async {
                          await provider.search();
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
                                encabezado: 'Selección de Pagos Anticipados',
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
                              //Contenedores
                              const ContenedoresPagosAnticipados(),
                              //Lista - Grid
                              Padding(
                                padding: const EdgeInsets.only(top: 16),
                                child: SizedBox(
                                  height: height * 1024 - 415,
                                  child: provider.gridSelected
                                      ? GridView.builder(
                                          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                            maxCrossAxisExtent: 400,
                                            //childAspectRatio: 3,
                                            crossAxisSpacing: 35,
                                            mainAxisSpacing: 35,
                                            mainAxisExtent: 230,
                                          ),
                                          shrinkWrap: true,
                                          itemCount: provider.clientes.length,
                                          itemBuilder: (BuildContext ctx, index) {
                                            return CustomCard(
                                              moneda: 'GTQ',
                                              cliente: provider.clientes[index],
                                            );
                                          },
                                        )
                                      : Column(
                                          children: [
                                            //Encabezado
                                            Padding(
                                              padding: const EdgeInsets.only(bottom: 16.0),
                                              child: Container(
                                                width: double.infinity,
                                                height: height * 79,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(6),
                                                  color: AppTheme.of(context).primaryColor,
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
                                                              Icons.person,
                                                              size: 20,
                                                              color: AppTheme.of(context).primaryBackground,
                                                            ),
                                                            Text(
                                                              'Cliente',
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
                                                              Icons.content_paste,
                                                              size: 20,
                                                              color: AppTheme.of(context).primaryBackground,
                                                            ),
                                                            Text(
                                                              'Num. Facturas',
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
                                                              color: AppTheme.of(context).primaryBackground,
                                                            ),
                                                            Text(
                                                              'Facturación',
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
                                                              Icons.payments_outlined,
                                                              color: AppTheme.of(context).primaryBackground,
                                                            ),
                                                            Text(
                                                              'Beneficio',
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
                                                              'Pago Adelantado',
                                                              style: AppTheme.of(context).subtitle1.override(
                                                                    fontFamily: AppTheme.of(context).subtitle1Family,
                                                                    useGoogleFonts: false,
                                                                    color: AppTheme.of(context).primaryBackground,
                                                                  ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(width: 65),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            //Contenido
                                            Expanded(
                                              child: SizedBox(
                                                height: height * 505,
                                                child: ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount: provider.clientes.length,
                                                  scrollDirection: Axis.vertical,
                                                  itemBuilder: (BuildContext ctx, index) {
                                                    return CustomListCard(
                                                      moneda: 'GTQ',
                                                      cliente: provider.clientes[index],
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
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
          if (provider.ejecBloq)
            Container(
              width: double.infinity,
              height: double.infinity,
              color: const Color(0x32000000),
              child: Center(
                child: SizedBox(
                  height: 100,
                  width: 100,
                  child: CircularProgressIndicator(
                    color: AppTheme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
