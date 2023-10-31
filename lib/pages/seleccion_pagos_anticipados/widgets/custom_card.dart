import 'package:acp_web/functions/money_format.dart';
import 'package:acp_web/models/seleccion_pagos_anticipados/seleccion_pagos_anticipados_model.dart';
import 'package:acp_web/pages/seleccion_pagos_anticipados/widgets/popup_selecci%C3%B3n_facturas.dart';
import 'package:acp_web/providers/seleccion_pagos_anticipados/seleccion_pagos_anticipados_provider.dart';
import 'package:acp_web/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:provider/provider.dart';

class CustomCard extends StatefulWidget {
  const CustomCard({
    super.key,
    required this.moneda,
    required this.cliente,
  });

  final SeleccionPagosAnticipados cliente;
  final String moneda;

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  @override
  Widget build(BuildContext context) {
    double porcentajeSeleccionadas = widget.cliente.facturasSeleccionadas! * 100 / widget.cliente.facturas!.length;

    final SeleccionaPagosanticipadosProvider provider = Provider.of<SeleccionaPagosanticipadosProvider>(context);

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
                Container(
                  width: 42,
                  height: 42,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.cliente.nombreFiscal!,
                        overflow: TextOverflow.fade,
                        style: AppTheme.of(context).subtitle1,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Facturación',
                            overflow: TextOverflow.fade,
                            style: AppTheme.of(context).subtitle3,
                          ),
                          Text(
                            '${widget.moneda} ${moneyFormat(widget.cliente.facturacion!)}',
                            overflow: TextOverflow.fade,
                            style: AppTheme.of(context).subtitle1.override(
                                  fontFamily: 'Gotham',
                                  useGoogleFonts: false,
                                  color: AppTheme.of(context).gris,
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
                            style: AppTheme.of(context).subtitle3,
                          ),
                          Text(
                            '${widget.moneda} ${moneyFormat(widget.cliente.beneficio!)}',
                            overflow: TextOverflow.fade,
                            style: AppTheme.of(context).subtitle1.override(
                                  fontFamily: 'Gotham',
                                  useGoogleFonts: false,
                                  color: AppTheme.of(context).gris,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(),
            Wrap(
              spacing: 16,
              children: [
                Text(
                  'Pago Adelantado',
                  style: AppTheme.of(context).subtitle3,
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
              backgroundColor: AppTheme.of(context).gris,
              progressColor: porcentajeSeleccionadas == 0
                  ? Colors.red
                  : porcentajeSeleccionadas != 100
                      ? Colors.amber
                      : Colors.green,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Tooltip(
                      message: 'Marcar',
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
                            provider.checkClient(widget.cliente.nombreFiscal!, false);
                          } else {
                            provider.checkClient(widget.cliente.nombreFiscal!, true);
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
                                    moneda: 'GTQ',
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
                      style: AppTheme.of(context).subtitle3,
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
                                  ? Colors.red
                                  : porcentajeSeleccionadas != 100
                                      ? Colors.amber
                                      : Colors.green,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              widget.cliente.facturasSeleccionadas!.toString(),
                              style: AppTheme.of(context).subtitle1.override(
                                    fontFamily: 'Gotham',
                                    useGoogleFonts: false,
                                    color: porcentajeSeleccionadas == 0
                                        ? Colors.red
                                        : porcentajeSeleccionadas != 100
                                            ? Colors.amber
                                            : Colors.green,
                                  ),
                            ),
                            Text(
                              '/',
                              style: AppTheme.of(context).subtitle3,
                            ),
                            Text(
                              widget.cliente.facturas!.length.toString(),
                              style: AppTheme.of(context).subtitle3,
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
