import 'package:acp_web/functions/month_name.dart';
import 'package:acp_web/models/pagos/pagos_model.dart';
import 'package:acp_web/pages/pagos/widgets/tarjeta_cliente.dart';
import 'package:acp_web/theme/theme.dart';
import 'package:flutter/material.dart';

class TarjetaMes extends StatefulWidget {
  const TarjetaMes({super.key, required this.pagos});

  final Pagos pagos;

  @override
  State<TarjetaMes> createState() => _TarjetaMesState();
}

class _TarjetaMesState extends State<TarjetaMes> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height / 1024;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        //constraints: BoxConstraints(maxHeight: height * 265),
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
                  backgroundColor: Colors.transparent,
                  canTapOnHeader: true,
                  isExpanded: widget.pagos.isExpanded,
                  headerBuilder: (context, isExpanded) {
                    return Row(
                      children: [
                        Text(
                          '${monthName(widget.pagos.month!)} ${widget.pagos.year} - ${widget.pagos.sociedad}',
                          style: AppTheme.of(context).title2,
                        ),
                      ],
                    );
                  },
                  body: Container(
                    constraints: BoxConstraints(maxHeight: height * 500),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.pagos.clientes!.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return TarjetaCliente(
                          cliente: widget.pagos.clientes![index],
                        );
                      },
                    ),
                  ),
                )
              ],
              expansionCallback: (panelIndex, isExpanded) {
                setState(() {
                  widget.pagos.isExpanded = !widget.pagos.isExpanded;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
