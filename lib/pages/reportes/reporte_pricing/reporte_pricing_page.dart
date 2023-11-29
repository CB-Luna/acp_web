import 'package:acp_web/functions/money_format.dart';
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
                            padding: const EdgeInsets.only(bottom: 10),
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
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              //Reporte
                              Container(
                                width: width * 250,
                                height: height * 780,
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: AppTheme.of(context).secondaryBackground,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Form(
                                  key: formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 16),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Text('Reporte', style: AppTheme.of(context).title3),
                                            //Calcular
                                            ElevatedButton(
                                              onPressed: () async {
                                                final isValid = formKey.currentState!.validate();
                                                if (isValid) {
                                                  formKey.currentState!.save();
                                                  await provider.reportePricing();
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: AppTheme.of(context).primaryColor,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(24),
                                                ),
                                                padding: const EdgeInsets.all(18),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Icon(
                                                    Icons.edit_document,
                                                    color: Colors.white,
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Text('Generar',
                                                      style: AppTheme.of(context).title2.override(
                                                            fontFamily: AppTheme.of(context).bodyText2Family,
                                                            useGoogleFonts: false,
                                                            color: AppTheme.of(context).primaryBackground,
                                                          )),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      //TAE
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 16),
                                        child: InputContainer(
                                          title: 'TAE',
                                          child: CustomInputField(
                                            height: height * 20,
                                            label: 'Captura',
                                            controller: provider.taeController,
                                            keyboardType: TextInputType.number,
                                            formatters: [
                                              FilteringTextInputFormatter.allow(
                                                RegExp(r'[0-9.]'),
                                              )
                                            ],
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return 'TAE es requerido';
                                              } else if (value.length < 4 || value.length > 7) {
                                                return 'Por favor, ingresa entre 0.00% y 100.00%';
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
                                            height: height * 20,
                                            label: 'Captura',
                                            controller: provider.fechaOperacionController,
                                            keyboardType: TextInputType.datetime,
                                            formatters: [
                                              FilteringTextInputFormatter.allow(RegExp(r"^[0-9/]+")),
                                            ],
                                            validator: (value) {
                                              const pattern = r"^\d{2}/\d{2}/\d{4}$";
                                              final regexp = RegExp(pattern);
                                              if (value == null || value.isEmpty) {
                                                return 'Fecha Operación es requerido';
                                              } else if (!regexp.hasMatch(value)) {
                                                return 'Por favor, ingrese la fecha con\n el formato dd/mm/aaaa';
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
                                            height: height * 20,
                                            label: 'Captura',
                                            controller: provider.fechaPagoController,
                                            keyboardType: TextInputType.name,
                                            formatters: [
                                              FilteringTextInputFormatter.allow(RegExp(r"^[0-9/]+")),
                                            ],
                                            validator: (value) {
                                              const pattern = r"^\d{2}/\d{2}/\d{4}$";
                                              final regexp = RegExp(pattern);
                                              if (value == null || value.isEmpty) {
                                                return 'Fecha Pago es requerido';
                                              } else if (!regexp.hasMatch(value)) {
                                                return 'Por favor, ingrese la fecha con\n el formato dd/mm/aaaa';
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
                                            height: height * 20,
                                            readOnly: true,
                                            label: '',
                                            controller: provider.diasControll,
                                            keyboardType: TextInputType.number,
                                            formatters: [
                                              FilteringTextInputFormatter.allow(
                                                RegExp(r'[0-9]'),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      //Monto Q
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 16),
                                        child: InputContainer(
                                          title: 'Monto Q',
                                          child: CustomInputField(
                                            height: height * 20,
                                            label: 'Captura',
                                            controller: provider.montoQController,
                                            keyboardType: TextInputType.number,
                                            formatters: [
                                              FilteringTextInputFormatter.allow(
                                                RegExp(r'[0-9]'),
                                              )
                                            ],
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return 'El Monto Q es requerido';
                                              } else if (value.length < 4 || value.length > 14) {
                                                return 'Por favor, ingresa entre\n 0.00 y 999,999,999.99';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                      //Número Operaciónes
                                      InputContainer(
                                        title: 'Número Operaciónes',
                                        child: CustomInputField(
                                          height: height * 20,
                                          label: 'Captura',
                                          controller: provider.nOperacionesController,
                                          keyboardType: TextInputType.number,
                                          formatters: [
                                            FilteringTextInputFormatter.allow(
                                              RegExp(r'[0-9]'),
                                            )
                                          ],
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'El Número de Operaciónes\n es requerido';
                                            } else if (value.length > 4) {
                                              return 'Por favor, ingresa entre\n 0 y 9999';
                                            }

                                            return null;
                                          },
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
                                  height: height * 780,
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
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              'Resumen',
                                              style: AppTheme.of(context).title3,
                                            ),
                                            const Spacer(),
                                            Tooltip(
                                              message: 'Descargar Excel',
                                              child: InkWell(
                                                onTap: () async {
                                                  await provider.reportePricingExcel();
                                                },
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
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: AppTheme.of(context).primaryBackground,
                                            borderRadius: BorderRadius.circular(16),
                                          ),
                                          child: SingleChildScrollView(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                RenglonReporte(
                                                    titulo: 'Tamaño Comercial/Desembolso Real',
                                                    message: '"Monto Q" - "Ingresos por operación de descuento"',
                                                    valor: provider.tComercial,
                                                    style: AppTheme.of(context).subtitle1),
                                                RenglonReporte(
                                                    titulo: 'Ingresos por Operación de descuento',
                                                    message: '(("TAE"/360)*("Días"))*("Monto Q")',
                                                    valor: provider.iODescuento,
                                                    style: AppTheme.of(context).bodyText2),
                                                RenglonReporte(
                                                    titulo: 'Costo Finaniero',
                                                    message: '(("Costo Financiero"/365)*("Días"))*(("Tamaño Comercial) / ("DESEMBOLSO REAL"))',
                                                    valor: provider.cFinanciero,
                                                    style: AppTheme.of(context).bodyText2),
                                                RenglonReporte(
                                                    titulo: 'Margen Financiero',
                                                    message: '("Ingresos por operación de descuento" - "Costo Financiero")',
                                                    valor: provider.mFinanciero,
                                                    porcentaje1: '${moneyFormat(provider.pMFinanciero)} %',
                                                    style: AppTheme.of(context).subtitle1),
                                                RenglonReporte(
                                                    titulo: 'Asignación de gasto operativo',
                                                    message: '(Tarifa GO/Operación"*"Número Operaciones")',
                                                    valor: provider.aGastoOperativo,
                                                    style: AppTheme.of(context).bodyText2),
                                                RenglonReporte(
                                                    titulo: 'Margen Operativo',
                                                    message: '("Margen Financiero"-"Asignación de gasto operativo")',
                                                    valor: provider.mOperativo,
                                                    porcentaje1: '${moneyFormat(provider.p1MOperativo)} %',
                                                    porcentaje2: '${moneyFormat(provider.p2MOperativo)} %',
                                                    style: AppTheme.of(context).subtitle1),
                                                RenglonReporte(titulo: 'ISR', valor: provider.isr, style: AppTheme.of(context).bodyText2),
                                                RenglonReporte(
                                                    titulo: 'Utilidad Neta',
                                                    message: '("Margen Operativo"-"ISR")',
                                                    valor: provider.uNeta,
                                                    porcentaje1: '${moneyFormat(provider.p1UNeta)} %',
                                                    porcentaje2: '${moneyFormat(provider.p2UNeta)} %',
                                                    style: AppTheme.of(context).subtitle1),
                                                RenglonReporte(
                                                    titulo: 'Asignación de capital',
                                                    message: '(("Tamaño Comercial" / "DESEMBOLSO REAL") * ("Asignación capital BIII))',
                                                    valor: provider.aCapital,
                                                    style: AppTheme.of(context).bodyText2),
                                                RenglonReporte(
                                                    titulo: 'Costo Capital',
                                                    message: '(("Costo Capital/"365)*("Dias")*("Asignación de capital"))',
                                                    valor: provider.cCapital,
                                                    style: AppTheme.of(context).bodyText2),
                                                Divider(color: AppTheme.of(context).primaryColor),
                                                RenglonReporte(
                                                    titulo: 'EVA- Operación',
                                                    message: '("Utilidad Neta" - "Costo capital")',
                                                    valor: provider.eva,
                                                    porcentaje1: '${moneyFormat(provider.pEva)} %',
                                                    style: AppTheme.of(context).subtitle1),
                                                Divider(color: AppTheme.of(context).primaryColor),
                                                RenglonReporte(
                                                    titulo: 'ROE- Operación', message: '(("Utilidad Neta"/"Asignación de capital")*(360/"Dias"))', valor: provider.roe, style: AppTheme.of(context).subtitle1),
                                              ],
                                            ),
                                          ),
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
