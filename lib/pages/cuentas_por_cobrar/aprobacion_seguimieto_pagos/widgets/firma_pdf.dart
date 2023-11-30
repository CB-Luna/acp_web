// ignore_for_file: use_build_context_synchronously
import 'package:acp_web/models/cuentas_por_cobrar/aprobacion_seguimineto_pagos_view.dart';
import 'package:acp_web/providers/cuentas_por_cobrar/aprobacion_seguimiento_pagos_provider.dart';
import 'package:acp_web/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signature/signature.dart';

class FirmaPDF extends StatefulWidget {
  const FirmaPDF({super.key, required this.propuesta});
  final Propuesta propuesta;
  @override
  State<FirmaPDF> createState() => FirmaPDFState();
}

class FirmaPDFState extends State<FirmaPDF> {
  @override
  void initState() {
    super.initState();
    /* WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final AprobacionSeguimientoPagosProvider provider = Provider.of<AprobacionSeguimientoPagosProvider>(
        context,
        listen: false,
      );
      //await provider.crearPDF(widget.propuesta);
    }); */
  }

  @override
  Widget build(BuildContext context) {
    final AprobacionSeguimientoPagosProvider provider = Provider.of<AprobacionSeguimientoPagosProvider>(context);
    double width = MediaQuery.of(context).size.width / 1440;
    double height = MediaQuery.of(context).size.height / 1024;
    return AlertDialog(
      key: UniqueKey(),
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      content: Container(
        width: width * 350,
        height: height * 400,
        decoration: BoxDecoration(
          color: AppTheme.of(context).secondaryBackground,
          borderRadius: const BorderRadius.all(
            Radius.circular(21),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Ingresa Firma',
                style: AppTheme.of(context).title1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Tooltip(
                    message: 'Confirmar Firma',
                    child: IconButton(
                      iconSize: 50,
                      onPressed: () async {
                        if (provider.controller.isNotEmpty) {
                          await provider.exportSignature();
                          await provider.crearPDF(widget.propuesta);
                          Navigator.pop(context);
                        } else {
                          provider.controller.clear();
                          provider.firmaAnexo = false;
                          await provider.crearPDF(widget.propuesta);
                          Navigator.pop(context);
                        }
                      },
                      icon: const Icon(
                        Icons.check,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  Tooltip(
                    message: 'Limpiar Firma',
                    child: IconButton(
                        iconSize: 50,
                        onPressed: () {
                          provider.controller.clear();
                          provider.firmaAnexo = false;
                        },
                        icon: const Icon(
                          Icons.clear,
                          color: Colors.red,
                        )),
                  )
                ],
              ),
              /* provider.pdfController == null
                  ? const CircularProgressIndicator()
                  :  */Signature(
                      controller: provider.controller,
                      backgroundColor: AppTheme.of(context).primaryBackground,
                      height: 250,
                      width: 350,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
