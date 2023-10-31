import 'package:acp_web/functions/money_format.dart';
import 'package:acp_web/pages/seleccion_pagos_anticipados/widgets/popup_selecci%C3%B3n_facturas.dart';
import 'package:acp_web/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:pluto_grid/pluto_grid.dart';

class CustomCard extends StatefulWidget {
  const CustomCard({
    super.key,
    required this.nombreCliente,
    required this.moneda,
    required this.facturacion,
    required this.beneficio,
    required this.pagoAdelantado,
    required this.cantidadFacturas,
    required this.cantidadFacturasSeleccionadas,
    required this.rows,
  });

  final String nombreCliente;
  final String moneda;
  final double facturacion;
  final double beneficio;
  final double pagoAdelantado;
  final int cantidadFacturas;
  final int cantidadFacturasSeleccionadas;
  final List<PlutoRow> rows;

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  @override
  Widget build(BuildContext context) {
    double porcentajeSeleccionadas = widget.cantidadFacturasSeleccionadas * 100 / widget.cantidadFacturas;

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
                        widget.nombreCliente,
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
                            '${widget.moneda} ${moneyFormat(widget.facturacion)}',
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
                            '${widget.moneda} ${moneyFormat(widget.beneficio)}',
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
                  '${widget.moneda} ${moneyFormat(widget.pagoAdelantado)}',
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
                            return StatefulBuilder(builder: (context, setState) {
                              return PopUpSeleccionfacturas(
                                moneda: 'GTQ',
                                nombreCliente: widget.nombreCliente,
                                facturacion: widget.facturacion,
                                beneficio: widget.beneficio,
                                pagoAdelantado: widget.pagoAdelantado,
                                cantidadFacturas: widget.cantidadFacturas,
                                cantidadFacturasSeleccionadas: widget.cantidadFacturasSeleccionadas,
                                rows: widget.rows,
                              );
                            });
                          });
                    },
                  ),
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
                              widget.cantidadFacturasSeleccionadas.toString(),
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
                              widget.cantidadFacturas.toString(),
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
