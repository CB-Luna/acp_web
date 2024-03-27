import 'package:acp_web/providers/reportes/dashboards_provider.dart';
import 'package:acp_web/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContenedoresDashboards extends StatefulWidget {
  const ContenedoresDashboards({
    super.key,
    required this.moneda,
  });

  final String moneda;

  @override
  State<ContenedoresDashboards> createState() => _ContenedoresDashboardsState();
}

class _ContenedoresDashboardsState extends State<ContenedoresDashboards> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width / 1440;

    final DashboardsProvider provider = Provider.of<DashboardsProvider>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.of(context).tertiaryColor)),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              width: width * 440,
              height: 140,
              constraints: const BoxConstraints(minWidth: 400),
              decoration: BoxDecoration(
                color: const Color(0xFFE5ECF6),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Wrap(
                  runSpacing: 16,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Numero Anexos',
                          style: AppTheme.of(context).title3,
                        ),
                        Text(
                          provider.indicadoresAnexos.isEmpty ? '' : '${provider.genereados}',
                          style: AppTheme.of(context).title2,
                        ),
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(4),
                            child: Icon(
                              Icons.monetization_on_outlined,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Aceptados',
                              style: AppTheme.of(context).bodyText1,
                            ),
                            Text(
                              provider.indicadoresAnexos.isEmpty ? '' : '${provider.aceptados}',
                              style: AppTheme.of(context).title2,
                            ),
                          ],
                        ),
                        Container(color: AppTheme.of(context).secondaryText, width: 1, height: 55),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Cancelados',
                              style: AppTheme.of(context).bodyText1,
                            ),
                            Text(
                              provider.indicadoresAnexos.isEmpty ? '' : '${provider.cancelados}',
                              style: AppTheme.of(context).title2,
                            ),
                          ],
                        ),
                        Container(color: AppTheme.of(context).secondaryText, width: 1, height: 55),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Pagados',
                              style: AppTheme.of(context).bodyText1,
                            ),
                            Text(
                              provider.indicadoresAnexos.isEmpty ? '' : '${provider.pagados}',
                              style: AppTheme.of(context).title2,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.of(context).tertiaryColor)),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              width: width * 440,
              height: 140,
              constraints: const BoxConstraints(minWidth: 400),
              decoration: BoxDecoration(
                color: const Color(0xFFE3F5FF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Wrap(
                  runSpacing: 16,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Días Credito Promedio al que se esta pagando',
                          style: AppTheme.of(context).title3,
                        ),
                        Wrap(
                          spacing: 16,
                          children: [
                            Tooltip(
                              message: 'Autorizar Pago',
                              child: InkWell(
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
                                        Icons.play_arrow_outlined,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                  onTap: () {}
                                  /*  async {
                                  if (provider.ejecBloq) {
                                    const SnackBar(
                                      content: Text('Proceso ejecutandose.'),
                                    );
                                  } else {
                                    if (provider.fondoDisponibleRestante < 0) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('El fondo disponible restante no puede ser menor a 0.'),
                                        ),
                                      );
                                    } else if (provider.cantidadFacturasSeleccionadas == 0) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Debe de seleccionar por lo menos una cuenta para realizar este proceso.'),
                                        ),
                                      );
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return StatefulBuilder(
                                            builder: (context, setState) {
                                              return const PopUpEjecucion();
                                            },
                                          );
                                        },
                                      );
                                    }
                                  }
                                }, */
                                  ),
                            ),
                          ],
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          provider.indicadoresDias.isEmpty ? '' : ' ${provider.dias}',
                          style: AppTheme.of(context).title2.override(
                                fontFamily: AppTheme.of(context).title2Family,
                                useGoogleFonts: false,
                                color: provider.dias < 0 ? AppTheme.of(context).red : AppTheme.of(context).primaryText,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
