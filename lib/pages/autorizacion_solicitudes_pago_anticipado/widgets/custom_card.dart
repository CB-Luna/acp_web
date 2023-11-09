import 'package:acp_web/functions/money_format.dart';
import 'package:acp_web/models/autorizacion_solicitudes_pago_anticipado/autorizacion_solicitudes_pago_anticipado_model.dart';
import 'package:acp_web/pages/autorizacion_solicitudes_pago_anticipado/widgets/popup_seleccion_facturas.dart';
import 'package:acp_web/pages/widgets/custom_image_container.dart';
import 'package:acp_web/providers/providers.dart';
import 'package:acp_web/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

class CustomCard extends StatefulWidget {
  const CustomCard({
    super.key,
    required this.moneda,
    required this.cliente,
  });

  final AutorizacionSolicitudesPagoanticipado cliente;
  final String moneda;

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  @override
  Widget build(BuildContext context) {
    double porcentajeSeleccionadas = widget.cliente.facturasSeleccionadas! * 100 / widget.cliente.facturas!.length;

    final AutorizacionAolicitudesPagoAnticipadoProvider provider = Provider.of<AutorizacionAolicitudesPagoAnticipadoProvider>(context);

    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FB),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFFD1D1D1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                ImageContainer(imageUrl: widget.cliente.logoUrl, size: 42),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.cliente.nombreFiscal!,
                        overflow: TextOverflow.fade,
                        style: AppTheme.of(context).title3,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Facturación',
                            overflow: TextOverflow.fade,
                            style: AppTheme.of(context).bodyText1.override(
                                  fontFamily: AppTheme.of(context).bodyText1Family,
                                  useGoogleFonts: false,
                                  color: AppTheme.of(context).secondaryText,
                                ),
                          ),
                          Text(
                            '${widget.moneda} ${moneyFormat(widget.cliente.facturacion!)}',
                            overflow: TextOverflow.fade,
                            style: AppTheme.of(context).subtitle1.override(
                                  fontFamily: AppTheme.of(context).subtitle1Family,
                                  useGoogleFonts: false,
                                  color: AppTheme.of(context).secondaryText,
                                ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Beneficio',
                            overflow: TextOverflow.fade,
                            style: AppTheme.of(context).bodyText1.override(
                                  fontFamily: AppTheme.of(context).bodyText1Family,
                                  useGoogleFonts: false,
                                  color: AppTheme.of(context).secondaryText,
                                ),
                          ),
                          Text(
                            '${widget.moneda} ${moneyFormat(widget.cliente.beneficio!)}',
                            overflow: TextOverflow.fade,
                            style: AppTheme.of(context).subtitle1.override(
                                  fontFamily: AppTheme.of(context).subtitle1Family,
                                  useGoogleFonts: false,
                                  color: AppTheme.of(context).secondaryText,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Divider(
              color: AppTheme.of(context).secondaryText,
            ),
            Wrap(
              spacing: 16,
              children: [
                Text(
                  'Pago Adelantado',
                  style: AppTheme.of(context).bodyText1.override(
                        fontFamily: AppTheme.of(context).bodyText1Family,
                        useGoogleFonts: false,
                        color: AppTheme.of(context).secondaryText,
                      ),
                ),
                Text(
                  '${widget.moneda} ${moneyFormat(widget.cliente.pagoAdelantado!)}',
                  style: AppTheme.of(context).subtitle1,
                ),
              ],
            ),
            LinearPercentIndicator(
              lineHeight: 4,
              percent: porcentajeSeleccionadas / 100,
              backgroundColor: AppTheme.of(context).secondaryText,
              progressColor: porcentajeSeleccionadas == 0
                  ? AppTheme.of(context).red
                  : porcentajeSeleccionadas != 100
                      ? AppTheme.of(context).yellow
                      : AppTheme.of(context).green,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Tooltip(
                      message: 'Seleccionar',
                      child: InkWell(
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Icon(
                              widget.cliente.facturasSeleccionadas! == widget.cliente.rows!.length ? Icons.check_box : Icons.check_box_outline_blank,
                              size: 20,
                            ),
                          ),
                        ),
                        onTap: () async {
                          //Ya están marcadas todas
                          if (widget.cliente.facturasSeleccionadas! == widget.cliente.rows!.length) {
                            provider.checkClient(widget.cliente, false);
                          } else {
                            provider.checkClient(widget.cliente, true);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Tooltip(
                      message: widget.cliente.bloqueado ? 'Desbloquear' : 'Bloquear',
                      child: InkWell(
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Icon(
                              widget.cliente.bloqueado ? Icons.lock_outline : Icons.lock_open_outlined,
                              size: 20,
                            ),
                          ),
                        ),
                        onTap: () async {
                          if (widget.cliente.bloqueado) {
                            await provider.blockClient(widget.cliente, false);
                          } else {
                            await provider.blockClient(widget.cliente, true);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Tooltip(
                      message: 'Editar',
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
                              Icons.file_copy_outlined,
                              size: 20,
                            ),
                          ),
                        ),
                        onTap: () async {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return StatefulBuilder(
                                builder: (context, setState) {
                                  return PopUpSeleccionfacturas(
                                    moneda: widget.moneda,
                                    cliente: widget.cliente,
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Seleccionadas',
                      style: AppTheme.of(context).bodyText1.override(
                            fontFamily: AppTheme.of(context).bodyText1Family,
                            useGoogleFonts: false,
                            color: AppTheme.of(context).secondaryText,
                          ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: porcentajeSeleccionadas == 0
                                  ? AppTheme.of(context).red
                                  : porcentajeSeleccionadas != 100
                                      ? AppTheme.of(context).yellow
                                      : AppTheme.of(context).green,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              widget.cliente.facturasSeleccionadas!.toString(),
                              style: AppTheme.of(context).subtitle1.override(
                                    fontFamily: AppTheme.of(context).subtitle1Family,
                                    useGoogleFonts: false,
                                    color: porcentajeSeleccionadas == 0
                                        ? AppTheme.of(context).red
                                        : porcentajeSeleccionadas != 100
                                            ? AppTheme.of(context).yellow
                                            : AppTheme.of(context).green,
                                  ),
                            ),
                            Text(
                              '/',
                              style: AppTheme.of(context).bodyText2,
                            ),
                            Text(
                              widget.cliente.facturas!.length.toString(),
                              style: AppTheme.of(context).bodyText2,
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
