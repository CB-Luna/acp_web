import 'package:acp_web/pages/reportes/reporte_pricing/widgets/renglon_reporte.dart';
import 'package:acp_web/pages/widgets/custom_input_field.dart';
import 'package:acp_web/pages/widgets/custom_side_menu.dart';
import 'package:acp_web/pages/widgets/custom_side_notifications.dart';
import 'package:acp_web/pages/widgets/custom_top_menu.dart';
import 'package:acp_web/pages/widgets/footer.dart';
import 'package:acp_web/pages/widgets/imput_container.dart';
import 'package:acp_web/providers/reportes/reporte_pricing_provider.dart';
import 'package:acp_web/providers/visual_state/visual_state_provider.dart';
import 'package:acp_web/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:provider/provider.dart';

class ReportePricingPage extends StatefulWidget {
  const ReportePricingPage({super.key});

  @override
  State<ReportePricingPage> createState() => _ReportePricingPageState();
}

class _ReportePricingPageState extends State<ReportePricingPage> {
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
    final formKey = GlobalKey<FormState>();
    // String? monedaSeleccionada = currentUser!.monedaSeleccionada;
    double width = MediaQuery.of(context).size.width / 1440;
    double height = MediaQuery.of(context).size.height / 1024;

    final VisualStateProvider visualState = Provider.of<VisualStateProvider>(context);
    visualState.setTapedOption(10);
    final ReportePricingProvider provider = Provider.of<ReportePricingProvider>(context);
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Row(
                              children: [
                                Text(
                                  'Reporte Pricing',
                                  style: AppTheme.of(context).title3,
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              //Reporte
                              Form(
                                key: formKey,
                                child: Container(
                                  width: width * 305,
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    color: AppTheme.of(context).secondaryBackground,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 16),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text('Reporte', style: AppTheme.of(context).title3),
                                        ),
                                      ),
                                      //TAE
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 16),
                                        child: InputContainer(
                                          title: 'TAE',
                                          child: CustomInputField(
                                            label: 'Captura',
                                            controller: provider.nombreController,
                                            keyboardType: TextInputType.name,
                                            formatters: [
                                              FilteringTextInputFormatter.allow(
                                                RegExp(r"^[a-zA-ZÀ-ÿ´ ]+"),
                                              )
                                            ],
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return 'El nombre es requerido';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                      //Fecha Operación
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 16),
                                        child: InputContainer(
                                          title: 'Fecha Operación',
                                          child: CustomInputField(
                                            label: 'Captura',
                                            controller: provider.apellidoPaternoController,
                                            keyboardType: TextInputType.name,
                                            formatters: [
                                              FilteringTextInputFormatter.allow(
                                                RegExp(r"^[a-zA-ZÀ-ÿ´ ]+"),
                                              )
                                            ],
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return 'El apellido es requerido';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                      //Fecha Pago
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 16),
                                        child: InputContainer(
                                          title: 'Fecha Pago',
                                          child: CustomInputField(
                                            label: 'Captura',
                                            controller: provider.apellidoMaternoController,
                                            keyboardType: TextInputType.name,
                                            formatters: [
                                              FilteringTextInputFormatter.allow(
                                                RegExp(r"^[a-zA-ZÀ-ÿ´ ]+"),
                                              )
                                            ],
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return 'El apellido es requerido';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                      //Días
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 16),
                                        child: InputContainer(
                                          title: 'Días',
                                          child: CustomInputField(
                                            label: 'Captura',
                                            controller: provider.telefonoController,
                                            keyboardType: TextInputType.phone,
                                            formatters: [
                                              FilteringTextInputFormatter.allow(
                                                RegExp(r'[0-9]'),
                                              )
                                            ],
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return 'El teléfono es obligatorio';
                                              }
                                              if (value.length != 10) {
                                                return 'El teléfono debe tener 10 dígitos';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                      //Monto Q
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 16),
                                        child: InputContainer(
                                          title: 'Monto Q',
                                          child: CustomInputField(
                                            label: 'Captura',
                                            controller: provider.apellidoMaternoController,
                                            keyboardType: TextInputType.number,
                                            formatters: [
                                              FilteringTextInputFormatter.allow(
                                                RegExp(r'[0-9]'),
                                              )
                                            ],
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return 'El Monto Q es requerido';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                      //Número Operaciónes
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 16),
                                        child: InputContainer(
                                          title: 'Número Operaciónes',
                                          child: CustomInputField(
                                            label: 'Captura',
                                            controller: provider.apellidoMaternoController,
                                            keyboardType: TextInputType.number,
                                            formatters: [
                                              FilteringTextInputFormatter.allow(
                                                RegExp(r'[0-9]'),
                                              )
                                            ],
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return 'El Número de Operaciónes es requerido';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: width * 20,
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    color: AppTheme.of(context).secondaryBackground,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 16),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Text(
                                              'Resumen',
                                              style: AppTheme.of(context).title3,
                                            ),
                                            Tooltip(
                                              message: 'Guardar',
                                              child: InkWell(
                                                onTap: () {},
                                                child: Container(
                                                  width: 30,
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                    color: Colors.black12,
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  child: const Padding(
                                                    padding: EdgeInsets.all(4),
                                                    child: Icon(
                                                      Icons.file_download_outlined,
                                                      size: 20,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: height * 692,
                                        decoration: BoxDecoration(
                                          color: AppTheme.of(context).primaryBackground,
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            const Spacer(),
                                            RenglonReporte(titulo: 'Tamaño Comercial/Desembolso Real', valor: 0, style: AppTheme.of(context).subtitle1),
                                            const Spacer(),
                                            RenglonReporte(titulo: 'Ingresos por Operación de descuento', valor: 0, style: AppTheme.of(context).bodyText2),
                                            RenglonReporte(titulo: 'Costo Finaniero', valor: 0, style: AppTheme.of(context).bodyText2),
                                            RenglonReporte(titulo: 'Margen Financiero', valor: 0, porcentaje1: '0.00 %', style: AppTheme.of(context).subtitle1),
                                            const Spacer(),
                                            RenglonReporte(titulo: 'Asignación de gasto operativo', valor: 0, style: AppTheme.of(context).bodyText2),
                                            RenglonReporte(titulo: 'Margen Operativo', valor: 0, porcentaje1: '0.00 %', porcentaje2: '0.00 %', style: AppTheme.of(context).subtitle1),
                                            const Spacer(),
                                            RenglonReporte(titulo: 'ISR', valor: 0, style: AppTheme.of(context).bodyText2),
                                            RenglonReporte(titulo: 'Utilidad Neta', valor: 0, porcentaje1: '0.00 %', porcentaje2: '0.00 %', style: AppTheme.of(context).subtitle1),
                                            const Spacer(),
                                            RenglonReporte(titulo: 'Asignación de capital', valor: 0, style: AppTheme.of(context).bodyText2),
                                            RenglonReporte(titulo: 'Costo Capital', valor: 0, style: AppTheme.of(context).bodyText2),
                                            Divider(color: AppTheme.of(context).primaryColor),
                                            RenglonReporte(titulo: 'EVA- Operación', valor: 0, porcentaje1: '0.00 %', porcentaje2: '0.00 %', style: AppTheme.of(context).subtitle1),
                                            Divider(color: AppTheme.of(context).primaryColor),
                                            RenglonReporte(titulo: 'ROE- Operación', valor: 0, style: AppTheme.of(context).subtitle1),
                                            const Spacer(),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
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
