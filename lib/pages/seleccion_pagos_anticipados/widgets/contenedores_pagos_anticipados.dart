import 'package:acp_web/functions/money_format.dart';
import 'package:acp_web/theme/theme.dart';
import 'package:flutter/material.dart';

class ContenedoresPagosAnticipados extends StatefulWidget {
  const ContenedoresPagosAnticipados({super.key});

  @override
  State<ContenedoresPagosAnticipados> createState() => _ContenedoresPagosAnticipadosState();
}

class _ContenedoresPagosAnticipadosState extends State<ContenedoresPagosAnticipados> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width / 1440;

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
                          'Monto de Facturación',
                          style: AppTheme.of(context).subtitle2,
                        ),
                        Text(
                          'GTQ ${moneyFormat(1213513.00)}',
                          style: AppTheme.of(context).title3,
                        ),
                      ],
                    ),
                    Container(color: AppTheme.of(context).gris, width: 1, height: 55),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CxP',
                          style: AppTheme.of(context).subtitle2,
                        ),
                        Text(
                          '47 de 95',
                          style: AppTheme.of(context).title3,
                        ),
                      ],
                    ),
                    Container(color: AppTheme.of(context).gris, width: 1, height: 55),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total de pagos',
                          style: AppTheme.of(context).subtitle2,
                        ),
                        Text(
                          'GTQ ${moneyFormat(1921.00)}',
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
          height: 200,
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
                    Wrap(
                      spacing: 16,
                      children: [
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
                              Icons.energy_savings_leaf_outlined,
                              size: 20,
                            ),
                          ),
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
                              Icons.play_arrow_outlined,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
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
                          'Fondo Disponible Restante',
                          style: AppTheme.of(context).subtitle2,
                        ),
                        Text(
                          'GTQ ${moneyFormat(10000.00)}',
                          style: AppTheme.of(context).title3,
                        ),
                      ],
                    ),
                    Container(color: AppTheme.of(context).gris, width: 1, height: 55),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Beneficio Total',
                          style: AppTheme.of(context).subtitle2,
                        ),
                        Text(
                          'GTQ ${moneyFormat(135000.00)}',
                          style: AppTheme.of(context).title3,
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Fondo disponible:',
                      style: AppTheme.of(context).subtitle1,
                    ),
                    Container(
                      width: 185,
                      height: 30,
                      decoration: BoxDecoration(
                        color: AppTheme.of(context).primaryBackground,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
