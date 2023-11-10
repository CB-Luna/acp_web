import 'package:acp_web/providers/pagos/pagos_provider.dart';
import 'package:acp_web/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pdfx/pdfx.dart';
import 'package:provider/provider.dart';

import '../../../models/pagos/pagos_model.dart';

class PopUpValidacionAnexo extends StatefulWidget {
  const PopUpValidacionAnexo({super.key, required this.cliente});

  final Cliente cliente;

  @override
  State<PopUpValidacionAnexo> createState() => _PopUpValidacionAnexoState();
}

class _PopUpValidacionAnexoState extends State<PopUpValidacionAnexo> {
  @override
  Widget build(BuildContext context) {
    final PagosProvider provider = Provider.of<PagosProvider>(context);

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
                  const SizedBox(width: 40, height: 40),
                  const Spacer(),
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
                                  ) //Image.memory(provider.imageBytes!),
                                  );
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
                      onPressed: () async {
                        await provider.descargarAnexo(widget.cliente.anexoDoc!);
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
                      child: PdfView(
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
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
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
                        await provider.updateRecords(widget.cliente.facturas!);
                        context.pushReplacement('/pagos');
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
            ],
          )),
    );
  }
}
