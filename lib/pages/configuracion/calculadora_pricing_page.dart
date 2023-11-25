import 'package:acp_web/pages/widgets/custom_header_button.dart';
import 'package:acp_web/pages/widgets/custom_input_field.dart';
import 'package:acp_web/pages/widgets/custom_side_menu.dart';
import 'package:acp_web/pages/widgets/custom_side_notifications.dart';
import 'package:acp_web/pages/widgets/custom_top_menu.dart';
import 'package:acp_web/pages/widgets/footer.dart';
import 'package:acp_web/pages/widgets/imput_container.dart';
import 'package:acp_web/providers/configuracion/calculadora_pricing_provider.dart';
import 'package:acp_web/providers/visual_state/visual_state_provider.dart';
import 'package:acp_web/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      await provider.getCalculadoraPricing();
    });
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    // String? monedaSeleccionada = currentUser!.monedaSeleccionada;
    double width = MediaQuery.of(context).size.width / 1440;
    //double height = MediaQuery.of(context).size.height / 1024;

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
                                      if (await provider.calculadoraPricing()) {
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
                          Form(
                            key: formKey,
                            child: Container(
                              width: width * 700,
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          //Costo Financiero
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 16),
                                            child: InputContainer(
                                              title: 'Costo Financiero',
                                              child: CustomInputField(
                                                label: '0.00%',
                                                controller: provider.costoFinancieroController,
                                                keyboardType: TextInputType.number,
                                                formatters: [
                                                  FilteringTextInputFormatter.allow(
                                                    RegExp(r'[0-9.%]'),
                                                  )
                                                ],
                                                validator: (value) {
                                                  if (value == null || value.isEmpty) {
                                                    return 'El Costo Financiero es requerido';
                                                  }
                                                  if (value.length < 5 || value.length > 6) {
                                                    return 'Por favor, ingresa entre 5 y 6 valores.';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                          ),
                                          //Costo Operativo
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 16),
                                            child: InputContainer(
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
                                                  if (value.isEmpty || value.length > 5) {
                                                    return 'Por favor, ingresa entre 1 y 6 valores.';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                          ),
                                          //Tarifa GO/Operación
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 16),
                                            child: InputContainer(
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
                                                  }
                                                  // Verificar la longitud de la cadena
                                                  if (value.length < 4 || value.length > 10) {
                                                    return 'Por favor, ingresa entre 1 y 6 valores.';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                          ),
                                          //ISR
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 16),
                                            child: InputContainer(
                                              title: 'ISR',
                                              child: CustomInputField(
                                                label: '0.00%',
                                                controller: provider.isrController,
                                                keyboardType: TextInputType.number,
                                                formatters: [
                                                  FilteringTextInputFormatter.allow(
                                                    RegExp(r'[0-9.%]'),
                                                  )
                                                ],
                                                validator: (value) {
                                                  if (value == null || value.isEmpty) {
                                                    return 'El ISR es requerido';
                                                  }
                                                  if (value.length < 5 || value.length > 6) {
                                                    return 'Por favor, ingresa entre 5 y 6 valores.';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      Column(
                                        children: [
                                          //Asignación Capital BILL
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 16),
                                            child: InputContainer(
                                              title: 'Asignación Capital BILL',
                                              child: CustomInputField(
                                                label: '0.00%',
                                                controller: provider.capitalBController,
                                                keyboardType: TextInputType.number,
                                                formatters: [
                                                  FilteringTextInputFormatter.allow(
                                                    RegExp(r'[0-9.%]'),
                                                  )
                                                ],
                                                validator: (value) {
                                                  if (value == null || value.isEmpty) {
                                                    return 'Asignación Capital BILL es requerido';
                                                  }
                                                  if (value.length < 5 || value.length > 6) {
                                                    return 'Por favor, ingresa entre 5 y 6 valores.';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                          ),
                                          //Costo Capital
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 16),
                                            child: InputContainer(
                                              title: 'Costo Capital',
                                              child: CustomInputField(
                                                label: '0.00%',
                                                controller: provider.costoCapitalController,
                                                keyboardType: TextInputType.number,
                                                formatters: [
                                                  FilteringTextInputFormatter.allow(
                                                    RegExp(r'[0-9.%]'),
                                                  )
                                                ],
                                                validator: (value) {
                                                  if (value == null || value.isEmpty) {
                                                    return 'El Costo Capital es requerido';
                                                  }
                                                  if (value.length < 5 || value.length > 6) {
                                                    return 'Por favor, ingresa entre 5 y 6 valores.';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                          ),
                                          //Probabilidad Incremento BBB
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 16),
                                            child: InputContainer(
                                              title: 'Probabilidad Incremento BBB',
                                              child: CustomInputField(
                                                label: '0.00%',
                                                controller: provider.incrementoController,
                                                keyboardType: TextInputType.number,
                                                formatters: [
                                                  FilteringTextInputFormatter.allow(
                                                    RegExp(r'[0-9.%]'),
                                                  )
                                                ],
                                                validator: (value) {
                                                  if (value == null || value.isEmpty) {
                                                    return 'Probabilidad Incremento BBB es requerido';
                                                  }
                                                  if (value.length < 5 || value.length > 6) {
                                                    return 'Por favor, ingresa entre 5 y 6 valores.';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                          ),
                                          //% Pérdida Incumplimineto
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 16),
                                            child: InputContainer(
                                              title: '% Pérdida Incumplimineto',
                                              child: CustomInputField(
                                                label: '0.00%',
                                                controller: provider.perdidaController,
                                                keyboardType: TextInputType.number,
                                                formatters: [
                                                  FilteringTextInputFormatter.allow(
                                                    RegExp(r'[0-9.%]'),
                                                  )
                                                ],
                                                validator: (value) {
                                                  if (value == null || value.isEmpty) {
                                                    return '% Pérdida Incumplimineto es requerido';
                                                  }
                                                  if (value.length < 5 || value.length > 6) {
                                                    return 'Por favor, ingresa entre 5 y 6 valores.';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
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
