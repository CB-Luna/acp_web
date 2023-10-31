import 'package:acp_web/functions/money_format.dart';
import 'package:acp_web/theme/theme.dart';
import 'package:flutter/material.dart';

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
                        /* Container(
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
                        ), */
                        //popup
                        IconButton(
                          onPressed: () async {
                            await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  content: Container(
                                    width: width * 600,
                                    height: height * 520,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFD7E9FB),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(35),
                                      ),
                                      border: Border.all(
                                        color: const Color(0xFFD1D1D1),
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        //titulo
                                        Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: Text(
                                            'Por favor revisa la selección de facturas antes de continuar',
                                            textAlign: TextAlign.center,
                                            style: AppTheme.of(context).subtitle1.override(
                                                  fontFamily: 'Gotham',
                                                  useGoogleFonts: false,
                                                  fontSize: 30,
                                                  color: AppTheme.of(context).tertiaryColor,
                                                ),
                                          ),
                                        ),
                                        //Informacion
                                        Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.only(bottom: 20),
                                                      child: Text(
                                                        'Total de Facturas:',
                                                        style: AppTheme.of(context).subtitle1.override(
                                                              fontFamily: 'Gotham',
                                                              useGoogleFonts: false,
                                                              fontSize: 20,
                                                              color: AppTheme.of(context).tertiaryColor,
                                                            ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(bottom: 20),
                                                      child: Text(
                                                        'Moneda:',
                                                        style: AppTheme.of(context).subtitle1.override(
                                                              fontFamily: 'Gotham',
                                                              useGoogleFonts: false,
                                                              fontSize: 20,
                                                              color: AppTheme.of(context).tertiaryColor,
                                                            ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(bottom: 20),
                                                      child: Text(
                                                        'Comisión:',
                                                        style: AppTheme.of(context).subtitle1.override(
                                                              fontFamily: 'Gotham',
                                                              useGoogleFonts: false,
                                                              fontSize: 20,
                                                              color: AppTheme.of(context).tertiaryColor,
                                                            ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(bottom: 20),
                                                      child: Text(
                                                        'Pago Anticipado:',
                                                        style: AppTheme.of(context).subtitle1.override(
                                                              fontFamily: 'Gotham',
                                                              useGoogleFonts: false,
                                                              fontSize: 20,
                                                              color: AppTheme.of(context).tertiaryColor,
                                                            ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const Spacer(),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.only(bottom: 20),
                                                      child: Text(
                                                        '5',
                                                        style: AppTheme.of(context).subtitle1.override(
                                                              fontFamily: 'Gotham',
                                                              useGoogleFonts: false,
                                                              fontSize: 20,
                                                              color: AppTheme.of(context).tertiaryColor,
                                                            ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(bottom: 20),
                                                      child: Text(
                                                        'GTQ',
                                                        style: AppTheme.of(context).subtitle1.override(
                                                              fontFamily: 'Gotham',
                                                              useGoogleFonts: false,
                                                              fontSize: 20,
                                                              color: AppTheme.of(context).tertiaryColor,
                                                            ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(bottom: 20),
                                                      child: Text(
                                                        'GTQ ${moneyFormat(1520)}',
                                                        style: AppTheme.of(context).subtitle1.override(
                                                              fontFamily: 'Gotham',
                                                              useGoogleFonts: false,
                                                              fontSize: 20,
                                                              color: AppTheme.of(context).tertiaryColor,
                                                            ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(bottom: 20),
                                                      child: Text(
                                                        'GTQ ${moneyFormat(1520)}',
                                                        style: AppTheme.of(context).subtitle1.override(
                                                              fontFamily: 'Gotham',
                                                              useGoogleFonts: false,
                                                              fontSize: 20,
                                                              color: AppTheme.of(context).tertiaryColor,
                                                            ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        //Botones
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {},
                                              style: ElevatedButton.styleFrom(
                                                elevation: 8,
                                                shadowColor: AppTheme.of(context).primaryBackground.withOpacity(0.8),
                                                backgroundColor: AppTheme.of(context).tertiaryColor,
                                              ),
                                              child: SizedBox(
                                                width: width * 250,
                                                height: height * 60,
                                                child: Center(
                                                  child: Text(
                                                    'Cancelar',
                                                    style: AppTheme.of(context).bodyText1.override(
                                                          fontFamily: 'Gotham',
                                                          useGoogleFonts: false,
                                                          fontSize: 20,
                                                          color: AppTheme.of(context).primaryBackground,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {},
                                              style: ElevatedButton.styleFrom(
                                                elevation: 8,
                                                shadowColor: AppTheme.of(context).primaryBackground.withOpacity(0.8),
                                                backgroundColor: AppTheme.of(context).primaryColor,
                                              ),
                                              child: SizedBox(
                                                width: width * 250,
                                                height: height * 60,
                                                child: Center(
                                                  child: Text(
                                                    'Aceptar',
                                                    style: AppTheme.of(context).bodyText1.override(
                                                          fontFamily: 'Gotham',
                                                          useGoogleFonts: false,
                                                          fontSize: 20,
                                                          color: AppTheme.of(context).primaryBackground,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          icon: const Icon(Icons.note_alt),
                          color: AppTheme.of(context).primaryColor,
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
