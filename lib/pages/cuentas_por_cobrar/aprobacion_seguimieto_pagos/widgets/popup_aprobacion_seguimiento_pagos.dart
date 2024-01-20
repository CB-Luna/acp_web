// ignore_for_file: use_build_context_synchronously

import 'package:acp_web/functions/date_format.dart';
import 'package:acp_web/helpers/globals.dart';
import 'package:acp_web/models/cuentas_por_cobrar/aprobacion_seguimineto_pagos_view.dart';
import 'package:acp_web/pages/cuentas_por_cobrar/aprobacion_seguimieto_pagos/widgets/firma_pdf.dart';
import 'package:acp_web/providers/cuentas_por_cobrar/aprobacion_seguimiento_pagos_provider.dart';
import 'package:acp_web/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pdfx/pdfx.dart';
import 'package:provider/provider.dart';

class PopupAprobacionSeguimientoPagos extends StatefulWidget {
  const PopupAprobacionSeguimientoPagos({super.key, required this.propuesta});
  final Propuesta propuesta;

  @override
  State<PopupAprobacionSeguimientoPagos> createState() => PopupAprobacionSeguimientoPagosState();
}

class PopupAprobacionSeguimientoPagosState extends State<PopupAprobacionSeguimientoPagos> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final AprobacionSeguimientoPagosProvider provider = Provider.of<AprobacionSeguimientoPagosProvider>(
        context,
        listen: false,
      );
      await provider.crearPDF(widget.propuesta);
      //provider.pdfController = PdfController(document: PdfDocument.openAsset('assets/docs/Anexo .pdf'));
      provider.anexo = false;
      provider.firmaAnexo = false;
      //provider.controller.clear();
    });
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
        width: 750,
        height: 750,
        decoration: BoxDecoration(
          color: AppTheme.of(context).secondaryBackground,
          borderRadius: const BorderRadius.all(
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
                if (widget.propuesta.estatus == 2 && provider.anexo == true)
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: IconButton(
                      icon: Icon(Icons.upload_file, color: AppTheme.of(context).primaryColor),
                      tooltip: 'Cargar Anexo Firmado',
                      color: AppTheme.of(context).primaryColor,
                      onPressed: () async {
                        await provider.pickProveedorDoc();
                        /* setState(() {}); */
                      },
                    ),
                  ),
                if (widget.propuesta.estatus == 2)
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: IconButton(
                        icon: Icon(Icons.history_edu, color: AppTheme.of(context).primaryColor),
                        tooltip: 'Firmar Anexo',
                        color: AppTheme.of(context).primaryColor,
                        onPressed: () async {
                          await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return FirmaPDF(
                                propuesta: widget.propuesta,
                              );
                            },
                          );
                        }),
                  ),
                //Pantalla Completa
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
                                  width: width * 1000,
                                  height: height * 1000,
                                  child: PdfView(
                                    backgroundDecoration: const BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(21),
                                      ),
                                    ),
                                    controller: provider.pdfController!,
                                  ),
                                ));
                          },
                        );
                      }),
                ),
                //Descargar Anexo
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: IconButton(
                    icon: Icon(Icons.file_download_outlined, color: AppTheme.of(context).primaryColor),
                    tooltip: 'Descargar Anexo',
                    color: AppTheme.of(context).primaryColor,
                    onPressed: () {
                      provider.descargarArchivo(provider.documento, '${dateFormat(provider.fecha)}_Anexo_${currentUser!.nombreCompleto}.pdf');
                      provider.anexo = true;
                      setState(() {});
                    },
                  ),
                ),
                //Imprimir
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
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: MediaQuery.of(context).size.height * 0.6,
                    decoration: BoxDecoration(
                      color: const Color(0xff262626),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.of(context).primaryColor,
                        width: 1.5,
                      ),
                    ),
                    child: provider.pdfController == null
                        ? const CircularProgressIndicator()
                        : PdfView(
                            pageSnapping: false,
                            scrollDirection: Axis.vertical,
                            physics: const BouncingScrollPhysics(),
                            renderer: (PdfPage page) {
                              if (page.width >= page.height) {
                                return page.render(
                                  width: page.width * 7,
                                  height: page.height * 4,
                                  format: PdfPageImageFormat.jpeg,
                                  backgroundColor: '#15FF0D',
                                );
                              } else if (page.width == page.height) {
                                return page.render(
                                  width: page.width * 4,
                                  height: page.height * 4,
                                  format: PdfPageImageFormat.jpeg,
                                  backgroundColor: '#15FF0D',
                                );
                              } else {
                                return page.render(
                                  width: page.width * 4,
                                  height: page.height * 7,
                                  format: PdfPageImageFormat.jpeg,
                                  backgroundColor: '#15FF0D',
                                );
                              }
                            },
                            controller: provider.pdfController!,
                            onDocumentLoaded: (document) {},
                            onPageChanged: (page) {},
                            onDocumentError: (error) {},
                          )),
              ),
            ),
            provider.firmaAnexo == true
                ? Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            //Navigator.pop(context);
                            context.pushReplacement('/aprobacion_seguimiento_pagos');
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 8,
                            shadowColor: AppTheme.of(context).primaryBackground.withOpacity(0.8),
                            backgroundColor: AppTheme.of(context).tertiaryColor,
                          ),
                          child: SizedBox(
                            width: width * 180,
                            height: height * 60,
                            child: Center(
                              child: Text(
                                'Cancelar',
                                style: AppTheme.of(context).bodyText1.override(
                                      fontFamily: AppTheme.of(context).bodyText2Family,
                                      useGoogleFonts: false,
                                      color: AppTheme.of(context).primaryBackground,
                                    ),
                              ),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            //Cambiar Status de facturas
                            if (provider.ejecBloq) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Proceso ejecutandose.'),
                                ),
                              );
                            } else {
                              if (provider.pdfController == null || provider.documento.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Por Favor Cargue Anexo Firmado'),
                                  ),
                                );
                              } else {
                                if (await provider.actualizarFacturasSeleccionadas(widget.propuesta)) {
                                  if (!mounted) return;
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Proceso realizado con exito'),
                                    ),
                                  );
                                  setState(() {
                                    provider.ejecBloq = false;
                                  });
                                } else {
                                  if (!mounted) return;
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Proceso fallido'),
                                    ),
                                  );
                                }
                                context.pushReplacement('/aprobacion_seguimiento_pagos');
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 8,
                            shadowColor: AppTheme.of(context).primaryBackground.withOpacity(0.8),
                            backgroundColor: AppTheme.of(context).primaryColor,
                          ),
                          child: SizedBox(
                            width: width * 180,
                            height: height * 60,
                            child: Center(
                              child: Text(
                                'Aceptar',
                                style: AppTheme.of(context).bodyText1.override(
                                      fontFamily: AppTheme.of(context).bodyText2Family,
                                      useGoogleFonts: false,
                                      color: AppTheme.of(context).primaryBackground,
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
