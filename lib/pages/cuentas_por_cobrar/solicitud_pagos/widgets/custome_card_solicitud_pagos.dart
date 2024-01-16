import 'package:acp_web/functions/money_format.dart';
import 'package:acp_web/models/cuentas_por_cobrar/solicitud_pagos.dart';
import 'package:acp_web/providers/cuentas_por_cobrar/solicitud_pagos_provider.dart';
import 'package:acp_web/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:provider/provider.dart';

class CustomeCardSolicitudPagos extends StatefulWidget {
  const CustomeCardSolicitudPagos({super.key, required this.propuesta});

  final SolicitudPagos propuesta;

  @override
  State<CustomeCardSolicitudPagos> createState() => _CustomeCardSolicitudPagosState();
}

class _CustomeCardSolicitudPagosState extends State<CustomeCardSolicitudPagos> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<PlutoGridStateManager> listStateManager;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool opened = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width / 1440;
    double height = MediaQuery.of(context).size.height / 1024;
    final SolicitudPagosProvider provider = Provider.of<SolicitudPagosProvider>(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        width: double.infinity,
        height: height * 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(6),
            topRight: const Radius.circular(6),
            bottomRight: opened ? Radius.zero : const Radius.circular(6),
            bottomLeft: opened ? Radius.zero : const Radius.circular(6),
          ),
          border: Border.all(color: const Color(0xFFD1D1D1)),
          color: opened == true
              ? AppTheme.of(context).secondaryColor
              : AppTheme.themeMode == ThemeMode.light
                  ? const Color(0xFFF7F9FB)
                  : Colors.grey,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //checkbox
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
                        widget.propuesta.ischeck == true ? Icons.check_box : Icons.check_box_outline_blank,
                        size: 20,
                      ),
                    ),
                  ),
                  onTap: () async {
                    //Ya están marcadas todas
                    if (widget.propuesta.ischeck == false) {
                      setState(() {
                        widget.propuesta.ischeck = true;
                      });
                    } else {
                      setState(() {
                        widget.propuesta.ischeck = false;
                      });
                    }
                    provider.facturasSeleccionadas();
                  },
                ),
              ),
              //Factura
              SizedBox(
                width: MediaQuery.of(context).size.width / 1440 * 160,
                child: Text(
                  widget.propuesta.no_doc.toString(),
                  style: AppTheme.of(context).subtitle1.override(
                        fontFamily: AppTheme.of(context).subtitle1Family,
                        useGoogleFonts: false,
                      ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.fade,
                ),
              ),
              //importe
              SizedBox(
                width: width * 160,
                child: Text(
                  '${widget.propuesta.moneda} ${moneyFormat(widget.propuesta.importe!)}',
                  textAlign: TextAlign.center,
                  style: AppTheme.of(context).subtitle1.override(
                        fontFamily: AppTheme.of(context).subtitle1Family,
                        useGoogleFonts: false,
                        color: AppTheme.of(context).tertiaryColor,
                      ),
                ),
              ),
              //comision
              SizedBox(
                width: width * 160,
                child: Text(
                  '${widget.propuesta.moneda} ${moneyFormat(widget.propuesta.comision!)}',
                  textAlign: TextAlign.center,
                  style: AppTheme.of(context).subtitle1.override(
                        fontFamily: AppTheme.of(context).subtitle1Family,
                        useGoogleFonts: false,
                        color: AppTheme.of(context).green,
                      ),
                ),
              ),
              //diaspago
              SizedBox(
                width: MediaQuery.of(context).size.width / 1440 * 160,
                child: Text(
                  widget.propuesta.diasPago.toString(),
                  style: AppTheme.of(context).subtitle1,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.fade,
                ),
              ),
              //Pago adelantado
              SizedBox(
                width: width * 160,
                child: Text(
                  '${widget.propuesta.moneda} ${moneyFormat(widget.propuesta.pagoAnticipado!)}',
                  style: AppTheme.of(context).subtitle1.override(
                        fontFamily: AppTheme.of(context).subtitle1Family,
                        useGoogleFonts: false,
                        color: AppTheme.of(context).primaryColor,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
