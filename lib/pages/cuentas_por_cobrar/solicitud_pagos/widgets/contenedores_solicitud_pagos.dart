import 'package:acp_web/functions/date_format.dart';
import 'package:acp_web/functions/money_format.dart';
import 'package:acp_web/pages/cuentas_por_cobrar/solicitud_pagos/widgets/popup_solicitud_pagos.dart';
import 'package:acp_web/providers/cuentas_por_cobrar/solicitud_pagos_provider.dart';
import 'package:acp_web/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContenedoresSolicitudPagos extends StatefulWidget {
  const ContenedoresSolicitudPagos({super.key});

  @override
  State<ContenedoresSolicitudPagos> createState() => _ContenedoresSolicitudPagosState();
}

class _ContenedoresSolicitudPagosState extends State<ContenedoresSolicitudPagos> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width / 1440;
    double height = MediaQuery.of(context).size.height / 1024;
    final SolicitudPagosProvider provider = Provider.of<SolicitudPagosProvider>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: width * 432,
          height: 200,
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
                      'Ganancias',
                      style: AppTheme.of(context).subtitle1,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Facturación',
                          style: AppTheme.of(context).subtitle2,
                        ),
                        Text(
                          'GTQ ${moneyFormat(provider.montoFacturacion)}',
                          style: AppTheme.of(context).title3,
                        ),
                      ],
                    ),
                    Container(color: AppTheme.of(context).gray, width: 1, height: 55),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CxC',
                          style: AppTheme.of(context).subtitle2,
                        ),
                        Text(
                          '${provider.cantidadFacturasSeleccionadas} de ${provider.facturas.length}',
                          style: AppTheme.of(context).title3,
                        ),
                      ],
                    ),
                    Container(color: AppTheme.of(context).gray, width: 1, height: 55),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Comisión',
                          style: AppTheme.of(context).subtitle2,
                        ),
                        Text(
                          'GTQ ${moneyFormat(provider.totalPagos)}',
                          style: AppTheme.of(context).title3,
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Ganancias calculadas de los ultimos 30 dias',
                      style: AppTheme.of(context).subtitle1,
                    ),
                    Container(
                      height: 30,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        Container(
          width: width * 432,
          height: height * 180,
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
                      'Facturas Seleccionadas',
                      style: AppTheme.of(context).subtitle1,
                    ),
                    Tooltip(
                      message: 'Solicitar Pago Anticipado',
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
                        onTap: () async {
                          await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return  PopupSolicitudPagos(
                                moneda: provider.facturas.first.moneda,
                                cantidadFacturas: provider.cantidadFacturas,
                                cantidadFacturasSeleccionadas: provider.cantidadFacturasSeleccionadas,
                                comision: provider.totalPagos,
                                pagoanticipado: provider.pagoAnticipado,
                              );
                            },
                          );
                        },
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pago Anticipado',
                          style: AppTheme.of(context).subtitle2,
                        ),
                        Text(
                          'GTQ ${moneyFormat(provider.pagoAnticipado)}',
                          style: AppTheme.of(context).title3,
                        ),
                      ],
                    ),
                    Container(color: AppTheme.of(context).gray, width: 1, height: 55),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Fecha Pago Anticipado',
                          style: AppTheme.of(context).subtitle2,
                        ),
                        Text(
                          dateFormat(provider.fecha),
                          style: AppTheme.of(context).title3,
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
    );
  }
}
