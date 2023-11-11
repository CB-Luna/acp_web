import 'package:acp_web/functions/month_name.dart';
import 'package:acp_web/models/cuentas_por_cobrar/aprobacion_seguimineto_pagos_view.dart';
import 'package:acp_web/pages/cuentas_por_cobrar/aprobacion_seguimieto_pagos/widgets/cuadro_blanco.dart';
import 'package:acp_web/theme/theme.dart';
import 'package:flutter/material.dart';

class CuadroGris extends StatefulWidget {
  const CuadroGris({
    super.key,
    required this.clase,
  });
  final AprobacionSegumientoPagosFuncion clase;

  @override
  State<CuadroGris> createState() => _CuadroGrisState();
}

bool opened = false;

class _CuadroGrisState extends State<CuadroGris> {
  @override
  Widget build(BuildContext context) {
    //final AprobacionSeguimientoPagosProvider provider = Provider.of<AprobacionSeguimientoPagosProvider>(context);
    //double width = MediaQuery.of(context).size.width / 1440;
    double height = MediaQuery.of(context).size.height / 1024;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppTheme.of(context).gray,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SizedBox(
            child: ExpansionPanelList(
              expandedHeaderPadding: EdgeInsets.zero,
              elevation: 0,
              children: [
                ExpansionPanel(
                  canTapOnHeader: true,
                  backgroundColor: Colors.transparent,
                  isExpanded: widget.clase.isExpanded,
                  headerBuilder: (context, expanded) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${monthName(widget.clase.month)} ${widget.clase.year}',
                        style: AppTheme.of(context).title2,
                      ),
                    );
                  },
                  body: Container(
                    //height: 300,
                    constraints: BoxConstraints(maxHeight: height * 500),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        //horizontal: 24,
                        vertical: 6,
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: widget.clase.propuestas.length,
                        controller: ScrollController(),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext ctx, index) {
                          return CuadroBlanco(
                            propuesta: widget.clase.propuestas[index],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
              expansionCallback: (panelIndex, isExpanded) {
                setState(() {
                  widget.clase.isExpanded = !widget.clase.isExpanded;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
