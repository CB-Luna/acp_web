import 'package:acp_web/pages/cuentas_por_cobrar/aprobacion_seguimieto_pagos/widgets/custome_card_aprobacion_pagos.dart';
import 'package:acp_web/theme/theme.dart';
import 'package:flutter/material.dart';

class ContenedorMes extends StatefulWidget {
  const ContenedorMes({
    super.key,
    required this.list,
    required this.mes,
    required this.year,
  });
  final String mes, year;

  final List<Map<String, dynamic>> list;

  @override
  State<ContenedorMes> createState() => _ContenedorMesState();
}

bool opened = false;

class _ContenedorMesState extends State<ContenedorMes> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ExpansionPanelList(
        expandedHeaderPadding: EdgeInsets.zero,
        elevation: 0,
        children: [
          ExpansionPanel(
            canTapOnHeader: true,
            backgroundColor: Colors.black.withOpacity(.1),
            headerBuilder: (context, expanded) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${widget.mes} ${widget.year}',
                  style: AppTheme.of(context).subtitle1,
                  overflow: TextOverflow.fade,
                ),
              );
            },
            body: Container(
              height: 300,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.zero,
                  topRight: Radius.circular(6),
                  bottomRight: Radius.circular(6),
                  bottomLeft: Radius.circular(6),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.list.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext ctx, index) {
                        return CustomeCardAprobacionPagos(
                          moneda: 'GTQ',
                          fechaEjecucion: widget.list[index]['fechaEjecucion'],
                          descripcion: widget.list[index]['Descripcion'],
                          anticipo: widget.list[index]['anticipo'],
                          comision: widget.list[index]['comision'],
                          estatus: widget.list[index]['Estatus'],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            isExpanded: opened,
          ),
        ],
        expansionCallback: (panelIndex, isExpanded) {
          setState(() {
            opened = !isExpanded;
          });
        },
      ),
    );
  }
}
