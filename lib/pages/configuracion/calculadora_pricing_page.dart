import 'package:acp_web/functions/money_format.dart';
import 'package:acp_web/helpers/globals.dart';
import 'package:acp_web/pages/usuarios_page/widgets/confirmacion_popup.dart';
import 'package:acp_web/pages/widgets/custom_header_button.dart';
import 'package:acp_web/pages/widgets/custom_input_field.dart';
import 'package:acp_web/pages/widgets/custom_side_menu.dart';
import 'package:acp_web/pages/widgets/custom_side_notifications.dart';
import 'package:acp_web/pages/widgets/custom_top_menu.dart';
import 'package:acp_web/pages/widgets/footer.dart';
import 'package:acp_web/pages/widgets/imput_container.dart';
import 'package:acp_web/providers/configuracion/calculadora_pricing_provider.dart';
import 'package:acp_web/providers/visual_state/visual_state_provider.dart';
import 'package:acp_web/services/api_error_handler.dart';
import 'package:acp_web/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:provider/provider.dart';

class CalculadoraPricingPage extends StatefulWidget {
  const CalculadoraPricingPage({super.key});

  @override
  State<CalculadoraPricingPage> createState() => _CalculadoraPricingPageState();
}

class _CalculadoraPricingPageState extends State<CalculadoraPricingPage> {
  bool filterSelected = false;
  bool gridSelected = false;
  bool listOpenned = true;

  late List<PlutoGridStateManager> listStateManager;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final CalculadoraPricingProvider provider = Provider.of<CalculadoraPricingProvider>(
        context,
        listen: false,
      );
      await provider.updateState();
    });
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    // String? monedaSeleccionada = currentUser!.monedaSeleccionada;
    //double width = MediaQuery.of(context).size.width / 1440;
    double height = MediaQuery.of(context).size.height / 1024;

    final VisualStateProvider visualState = Provider.of<VisualStateProvider>(context);
    visualState.setTapedOption(11);
    final CalculadoraPricingProvider provider = Provider.of<CalculadoraPricingProvider>(context);
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
                    pantalla: 'Configuración',
                    controllerBusqueda: provider.controllerBusqueda,
                    onSearchChanged: (p0) async {
                      await provider.tablaCalculadora();
                    },
                    onSociedadSeleccionada: () async {
                      await provider.getCalculadoraPricing();
                    },
                    onMonedaSeleccionada: () async {
                      //await provider.aprobacionSeguimientoPagos();
                    },
                  ),
                  //Contenido
                  Expanded(
                    child: SingleChildScrollView(
                      clipBehavior: Clip.none,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //Encabezado
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: provider.ejecBloq
                                  ? GestureDetector(
                                      onTap: () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Proceso ejecutandose'),
                                          ),
                                        );
                                      },
                                      child: CircularProgressIndicator(
                                        color: AppTheme.of(context).primaryColor,
                                      ),
                                    )
                                  : CustomHeaderButton(
                                      encabezado: 'Calculdora Pricing',
                                      texto: 'Guardar',
                                      icon: Icons.save,
                                      onPressed: () async {
                                        if (provider.ejecBloq) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('Proceso ejecutandose.'),
                                            ),
                                          );
                                        }
                                        if (await provider.crearCalculadoraPricing()) {
                                          if (!mounted) return;
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('Proceso realizado con exito'),
                                            ),
                                          );
                                          setState(() {
                                            provider.ejecBloq = false;
                                          });
                                        } else {
                                          if (!mounted) return;
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('Proceso fallido'),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                            ),
                            //Contenido
                            Container(
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
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text('Reporte', style: AppTheme.of(context).title3),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        //Costo Financiero
                                        InputContainer(
                                          title: 'Costo Financiero',
                                          child: CustomInputField(
                                            label: '0.00%',
                                            controller: provider.costoFinancieroController,
                                            keyboardType: TextInputType.number,
                                            formatters: [
                                              FilteringTextInputFormatter.allow(
                                                RegExp(r'[0-9.]'),
                                              )
                                            ],
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return 'Costo Financiero es requerido';
                                              } else if (value.length < 4 || value.length > 7) {
                                                return 'Por favor, ingresa entre 0.00% y 100.00%';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 16,
                                        ),
                                        //Asignación Capital BILL
                                        InputContainer(
                                          title: 'Asignación Capital BILL',
                                          child: CustomInputField(
                                            label: '0.00%',
                                            controller: provider.capitalBController,
                                            keyboardType: TextInputType.number,
                                            formatters: [
                                              FilteringTextInputFormatter.allow(
                                                RegExp(r'[0-9.]'),
                                              )
                                            ],
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return 'Asignación Capital BILL es requerido';
                                              } else if (value.length < 4 || value.length > 7) {
                                                return 'Por favor, ingresa entre 0.00% y 100.00%';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        //Costo Operativo
                                        InputContainer(
                                          title: 'Costo Operativo',
                                          child: CustomInputField(
                                            label: '0.00',
                                            controller: provider.costoOperativoController,
                                            keyboardType: TextInputType.number,
                                            formatters: [
                                              FilteringTextInputFormatter.allow(
                                                RegExp(r'[0-9.]'),
                                              )
                                            ],
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return 'El Costo Operativo es requerido';
                                              }
                                              // Verificar la longitud de la cadena
                                              if (value.isEmpty || value.length > 7) {
                                                return 'Por favor, ingresa entre\n 0.00 y 999,999,999.99';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 16,
                                        ),
                                        //Costo Capital
                                        InputContainer(
                                          title: 'Costo Capital',
                                          child: CustomInputField(
                                            label: '0.00%',
                                            controller: provider.costoCapitalController,
                                            keyboardType: TextInputType.number,
                                            formatters: [
                                              FilteringTextInputFormatter.allow(
                                                RegExp(r'[0-9.]'),
                                              )
                                            ],
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return 'Costo Capital es requerido';
                                              } else if (value.length < 4 || value.length > 7) {
                                                return 'Por favor, ingresa entre 0.00% y 100.00%';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        //Tarifa GO/Operación
                                        InputContainer(
                                          title: 'Tarifa GO/Operación',
                                          child: CustomInputField(
                                            label: '0.00',
                                            controller: provider.tarifaGOController,
                                            keyboardType: TextInputType.number,
                                            formatters: [
                                              FilteringTextInputFormatter.allow(
                                                RegExp(r'[0-9.]'),
                                              )
                                            ],
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return 'Tarifa GO/Operación es requerido';
                                              } else if (value.length < 4 || value.length > 14) {
                                                return 'Por favor, ingresa entre\n 0.00 y 999,999,999.99';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 16,
                                        ),
                                        //Probabilidad Incremento BBB
                                        InputContainer(
                                          title: 'Probabilidad Incremento BBB',
                                          child: CustomInputField(
                                            label: '0.00%',
                                            controller: provider.incrementoController,
                                            keyboardType: TextInputType.number,
                                            formatters: [
                                              FilteringTextInputFormatter.allow(
                                                RegExp(r'[0-9.]'),
                                              )
                                            ],
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return 'Probabilidad Incremento BBB es requerido';
                                              } else if (value.length < 4 || value.length > 7) {
                                                return 'Por favor, ingresa entre 0.00% y 100.00%';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        //ISR
                                        InputContainer(
                                          title: 'ISR',
                                          child: CustomInputField(
                                            label: '0.00%',
                                            controller: provider.isrController,
                                            keyboardType: TextInputType.number,
                                            formatters: [
                                              FilteringTextInputFormatter.allow(
                                                RegExp(r'[0-9.]'),
                                              )
                                            ],
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return 'El ISR es requerido';
                                              } else if (value.length < 4 || value.length > 7) {
                                                return 'Por favor, ingresa entre 0.00% y 100.00%';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 16,
                                        ),
                                        //% Pérdida Incumplimineto
                                        InputContainer(
                                          title: '% Pérdida Incumplimineto',
                                          child: CustomInputField(
                                            label: '0.00%',
                                            controller: provider.perdidaController,
                                            keyboardType: TextInputType.number,
                                            formatters: [
                                              FilteringTextInputFormatter.allow(
                                                RegExp(r'[0-9.]'),
                                              )
                                            ],
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return 'El % Pérdida Incumplimineto es requerido';
                                              } else if (value.length < 4 || value.length > 7) {
                                                return 'Por favor, ingresa entre 0.00% y 100.00%';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            //Tabla
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: SizedBox(
                                height: height * 317,
                                child: PlutoGrid(
                                  key: UniqueKey(),
                                  configuration: PlutoGridConfiguration(
                                    localeText: const PlutoGridLocaleText.spanish(),
                                    scrollbar: plutoGridScrollbarConfig(context),
                                    style: plutoGridStyleConfig(context),
                                    columnFilter: PlutoGridColumnFilterConfig(
                                      filters: const [
                                        ...FilterHelper.defaultFilters,
                                      ],
                                      resolveDefaultColumnFilter: (column, resolver) {
                                        return resolver<PlutoFilterTypeContains>() as PlutoFilterType;
                                      },
                                    ),
                                  ),
                                  columns: [
                                    PlutoColumn(
                                      title: 'ID',
                                      field: 'id',
                                      width: 57,
                                      enableContextMenu: false,
                                      enableDropToResize: false,
                                      titleTextAlign: PlutoColumnTextAlign.center,
                                      textAlign: PlutoColumnTextAlign.center,
                                      type: PlutoColumnType.number(),
                                      enableEditingMode: false,
                                    ),
                                    PlutoColumn(
                                      title: 'Sociedad',
                                      field: 'sociedad',
                                      width: 150,
                                      enableContextMenu: false,
                                      enableDropToResize: false,
                                      titleTextAlign: PlutoColumnTextAlign.center,
                                      textAlign: PlutoColumnTextAlign.center,
                                      type: PlutoColumnType.text(),
                                      enableEditingMode: false,
                                    ),
                                    PlutoColumn(
                                      title: 'Costo Financiero',
                                      field: 'costo_financiero',
                                      width: 130,
                                      enableContextMenu: false,
                                      enableDropToResize: false,
                                      titleTextAlign: PlutoColumnTextAlign.center,
                                      textAlign: PlutoColumnTextAlign.center,
                                      type: PlutoColumnType.text(),
                                      enableEditingMode: false,
                                      renderer: (rendererContext) {
                                        return Text(
                                          '${moneyFormat(rendererContext.cell.value)}%',
                                          textAlign: TextAlign.center,
                                          style: AppTheme.of(context).bodyText2,
                                        );
                                      },
                                    ),
                                    PlutoColumn(
                                      title: 'Costo Operativo',
                                      field: 'costo_operativo',
                                      width: 150,
                                      enableContextMenu: false,
                                      enableDropToResize: false,
                                      titleTextAlign: PlutoColumnTextAlign.center,
                                      textAlign: PlutoColumnTextAlign.center,
                                      type: PlutoColumnType.text(),
                                      enableEditingMode: false,
                                    ),
                                    PlutoColumn(
                                      title: 'Tarifa GO',
                                      field: 'tarifa_go',
                                      width: 150,
                                      enableContextMenu: false,
                                      enableDropToResize: false,
                                      titleTextAlign: PlutoColumnTextAlign.center,
                                      textAlign: PlutoColumnTextAlign.center,
                                      type: PlutoColumnType.text(),
                                      enableEditingMode: false,
                                    ),
                                    PlutoColumn(
                                      title: 'ISR',
                                      field: 'isr',
                                      width: 130,
                                      enableContextMenu: false,
                                      enableDropToResize: false,
                                      titleTextAlign: PlutoColumnTextAlign.center,
                                      textAlign: PlutoColumnTextAlign.center,
                                      type: PlutoColumnType.text(),
                                      enableEditingMode: false,
                                      renderer: (rendererContext) {
                                        return Text(
                                          '${moneyFormat(rendererContext.cell.value)}%',
                                          textAlign: TextAlign.center,
                                          style: AppTheme.of(context).bodyText2,
                                        );
                                      },
                                    ),
                                    PlutoColumn(
                                      title: 'Asiganacion Capital BILL',
                                      field: 'capital_bill',
                                      width: 130,
                                      enableContextMenu: false,
                                      enableDropToResize: false,
                                      titleTextAlign: PlutoColumnTextAlign.center,
                                      textAlign: PlutoColumnTextAlign.center,
                                      type: PlutoColumnType.text(),
                                      enableEditingMode: false,
                                      renderer: (rendererContext) {
                                        return Text(
                                          '${moneyFormat(rendererContext.cell.value)}%',
                                          textAlign: TextAlign.center,
                                          style: AppTheme.of(context).bodyText2,
                                        );
                                      },
                                    ),
                                    PlutoColumn(
                                      title: 'Costo Capital',
                                      field: 'costo_capital',
                                      width: 130,
                                      enableContextMenu: false,
                                      enableDropToResize: false,
                                      titleTextAlign: PlutoColumnTextAlign.center,
                                      textAlign: PlutoColumnTextAlign.center,
                                      type: PlutoColumnType.text(),
                                      enableEditingMode: false,
                                      renderer: (rendererContext) {
                                        return Text(
                                          '${moneyFormat(rendererContext.cell.value)}%',
                                          textAlign: TextAlign.center,
                                          style: AppTheme.of(context).bodyText2,
                                        );
                                      },
                                    ),
                                    PlutoColumn(
                                      title: 'Probabiliad Incremento BBB',
                                      field: 'probabilidad_incremento',
                                      width: 130,
                                      enableContextMenu: false,
                                      enableDropToResize: false,
                                      titleTextAlign: PlutoColumnTextAlign.center,
                                      textAlign: PlutoColumnTextAlign.center,
                                      type: PlutoColumnType.text(),
                                      enableEditingMode: false,
                                      renderer: (rendererContext) {
                                        return Text(
                                          '${moneyFormat(rendererContext.cell.value)}%',
                                          textAlign: TextAlign.center,
                                          style: AppTheme.of(context).bodyText2,
                                        );
                                      },
                                    ),
                                    PlutoColumn(
                                      title: 'Pérdida Incumplimiento',
                                      field: 'perdida_incumplimiento',
                                      width: 130,
                                      enableContextMenu: false,
                                      enableDropToResize: false,
                                      titleTextAlign: PlutoColumnTextAlign.center,
                                      textAlign: PlutoColumnTextAlign.center,
                                      type: PlutoColumnType.text(),
                                      enableEditingMode: false,
                                      renderer: (rendererContext) {
                                        return Text(
                                          '${moneyFormat(rendererContext.cell.value)}%',
                                          textAlign: TextAlign.center,
                                          style: AppTheme.of(context).bodyText2,
                                        );
                                      },
                                    ),

                                    /* PlutoColumn(
                                      title: 'Estado',
                                      field: 'activo',
                                      width: 111,
                                      enableContextMenu: false,
                                      enableDropToResize: false,
                                      titleTextAlign: PlutoColumnTextAlign.center,
                                      textAlign: PlutoColumnTextAlign.center,
                                      type: PlutoColumnType.text(),
                                      enableEditingMode: false,
                                      renderer: (rendererContext) {
                                        return Container(
                                          height: 32,
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(16),
                                            color: rendererContext.cell.value == 'Activo' ? const Color(0xFF94D0FF) : Colors.grey[300],
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            rendererContext.cell.value,
                                            style: AppTheme.of(context).bodyText2,
                                          ),
                                        );
                                      },
                                    ),
                                     */
                                    PlutoColumn(
                                      title: 'Acciones',
                                      field: 'acciones',
                                      width: 160,
                                      enableContextMenu: false,
                                      enableDropToResize: false,
                                      titleTextAlign: PlutoColumnTextAlign.center,
                                      textAlign: PlutoColumnTextAlign.center,
                                      type: PlutoColumnType.text(),
                                      enableEditingMode: false,
                                      renderer: (rendererContext) {
                                        return Row(
                                          children: [
                                            Tooltip(
                                              message: 'Cargar valores',
                                              child: IconButton(
                                                padding: EdgeInsets.zero,
                                                icon: Transform.translate(
                                                  offset: const Offset(0, -2.5),
                                                  child: const Icon(
                                                    FontAwesomeIcons.penToSquare,
                                                    size: 24,
                                                    color: Color(0xFF0090FF),
                                                  ),
                                                ),
                                                splashRadius: 0.01,
                                                onPressed: () async {
                                                  await provider.cargarDatosCalculadoraPricing(rendererContext.row.cells["id"]!.value);
                                                },
                                              ),
                                            ),
                                            Tooltip(
                                              message: 'Eliminar Registro',
                                              child: IconButton(
                                                padding: EdgeInsets.zero,
                                                icon: const Icon(
                                                  Icons.delete_outline_outlined,
                                                  size: 24,
                                                  color: Color(0xFF0090FF),
                                                ),
                                                splashRadius: 0.01,
                                                onPressed: () async {
                                                  final popupResult = await showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return const ConfirmacionPopup();
                                                    },
                                                  );
                                                  if (popupResult == null || popupResult is! bool) return;
                                                  if (popupResult == false) return;
                                                  final res = await provider.borrarCalculadoraPricing(rendererContext.row.cells["id"]!.value);
                                                  if (!res) {
                                                    ApiErrorHandler.callToast('Error al borrar usuario');
                                                    return;
                                                  }
                                                },
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ],
                                  rows: provider.rows,
                                  createFooter: (stateManager) {
                                    stateManager.setPageSize(
                                      20,
                                      notify: false,
                                    );
                                    return PlutoPagination(stateManager);
                                  },
                                  onLoaded: (event) {
                                    provider.stateManager = event.stateManager;
                                  },
                                  onRowChecked: (event) {},
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
