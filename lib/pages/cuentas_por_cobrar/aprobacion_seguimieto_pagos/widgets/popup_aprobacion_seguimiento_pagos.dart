import 'package:acp_web/providers/cuentas_por_cobrar/aprobacion_seguimiento_pagos_provider.dart';
import 'package:acp_web/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:provider/provider.dart';

class PopupAprobacionSeguimientoPagos extends StatefulWidget {
  const PopupAprobacionSeguimientoPagos({super.key, required this.estatus});
  final int estatus;

  @override
  State<PopupAprobacionSeguimientoPagos> createState() => PopupAprobacionSeguimientoPagosState();
}

class PopupAprobacionSeguimientoPagosState extends State<PopupAprobacionSeguimientoPagos> {
  @override
  Widget build(BuildContext context) {
    final AprobacionSeguimientoPagosProvider provider = Provider.of<AprobacionSeguimientoPagosProvider>(context);
    //double width = MediaQuery.of(context).size.width / 1440;
    //double height = MediaQuery.of(context).size.height / 1024;
    return AlertDialog(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      content: Container(
        width: 750,
        height: 750,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(21),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                if (widget.estatus == 2)
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: IconButton(
                      icon: Icon(Icons.upload_file, color: AppTheme.of(context).primaryColor),
                      tooltip: 'Cargar Anexo',
                      color: AppTheme.of(context).primaryColor,
                      onPressed: () {
                        if (provider.pdfController != null && provider.docProveedor != null && provider.popupVisorPdfVisible == false) {
                          provider.verPdf(true);
                          setState(() {
                            //Metodo de probado
                          });
                        } else {
                          provider.pickProveedorDoc();
                          provider.verPdf(true);
                        }
                      },
                    ),
                  ),
                if (widget.estatus == 3)
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: IconButton(
                      icon: Icon(Icons.history_edu, color: AppTheme.of(context).primaryColor),
                      tooltip: 'Firmar Anexo',
                      color: AppTheme.of(context).primaryColor,
                      onPressed: () {
                        /* if (provider.imageBytes != null && provider.docProveedor != null && provider.popupVisorPdfVisible == false) {
                          provider.verPdf(true);
                          setState(() {});
                        } else {
                          provider.pickDoc();
                          provider.verPdf(true);
                        } */
                      },
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: IconButton(
                      icon: Icon(Icons.fullscreen, color: AppTheme.of(context).primaryColor),
                      tooltip: 'Pantalla Completa',
                      color: AppTheme.of(context).primaryColor,
                      onPressed: () async {
                        await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                content: SizedBox(
                                  width: 1000,
                                  height: 1000,
                                  child: PdfView(
                                    backgroundDecoration: const BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(21),
                                      ),
                                    ),
                                    controller: provider.pdfController!,
                                  ),
                                ) //Image.memory(provider.imageBytes!),
                                );
                          },
                        );
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: IconButton(
                    icon: Icon(Icons.file_download_outlined, color: AppTheme.of(context).primaryColor),
                    tooltip: 'Descargar Anexo',
                    color: AppTheme.of(context).primaryColor,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: IconButton(
                    icon: Icon(Icons.print, color: AppTheme.of(context).primaryColor),
                    tooltip: 'Imprimir',
                    color: AppTheme.of(context).primaryColor,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: IconButton(
                    icon: Icon(Icons.close, color: AppTheme.of(context).primaryColor),
                    tooltip: 'Salir',
                    color: AppTheme.of(context).primaryColor,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(10),
              child: (provider.pdfController != null && provider.docProveedor != null)
                  ? SizedBox(
                    width: 500,
                    height: 400,
                    child: PdfView(
                        backgroundDecoration: const BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.all(
                            Radius.circular(21),
                          ),
                        ),
                        controller: provider.pdfController!,
                      ),
                  )
                  : Container(),
            ))
          ],
        ),
      ),
    );
  }
}
