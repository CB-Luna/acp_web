import 'package:acp_web/functions/day_month_format.dart';
import 'package:acp_web/functions/money_format.dart';
import 'package:acp_web/functions/month_name.dart';
import 'package:acp_web/models/pagos/pagos_model.dart';
import 'package:acp_web/pages/pagos/widgets/pop_up_validacion_anexo.dart';
import 'package:acp_web/pages/widgets/custom_hover_icon.dart';
import 'package:acp_web/pages/widgets/custom_image_container.dart';
import 'package:acp_web/providers/providers.dart';
import 'package:acp_web/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TarjetaMes extends StatefulWidget {
  const TarjetaMes({super.key, required this.pagos});

  final Pagos pagos;

  @override
  State<TarjetaMes> createState() => _TarjetaMesState();
}

class _TarjetaMesState extends State<TarjetaMes> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width / 1440;
    double height = MediaQuery.of(context).size.height / 1024;
    final PagosProvider provider = Provider.of<PagosProvider>(context);

    String monedaSeleccionada = 'GTQ';

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
                          '${monthName(widget.pagos.month!)} ${widget.pagos.year}',
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
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Container(
                            height: 75,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: AppTheme.of(context).primaryBackground,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 6,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: width * 55,
                                    child: Text(
                                      widget.pagos.clientes![index].anexoId != null ? widget.pagos.clientes![index].anexoId!.toString() : 'Pendiente',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * 111,
                                    child: Row(
                                      children: [
                                        ClientImageContainer(imageName: widget.pagos.clientes?[index].logo, size: 20),
                                        const SizedBox(width: 5),
                                        SizedBox(
                                          width: width * 90,
                                          //height: 50,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                widget.pagos.clientes![index].nombreFiscal!,
                                                style: AppTheme.of(context).subtitle1,
                                                overflow: TextOverflow.fade,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * 61,
                                    child: Text(
                                      widget.pagos.clientes![index].cuentasAnticipadas.toString(),
                                      style: AppTheme.of(context).subtitle1,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * 70,
                                    child: Text(
                                      dayMothFormat(widget.pagos.clientes![index].fechaPropuesta!),
                                      style: AppTheme.of(context).subtitle1,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * 130,
                                    child: Text(
                                      '$monedaSeleccionada ${moneyFormat(widget.pagos.clientes![index].anticipo!)}',
                                      style: AppTheme.of(context).subtitle1.override(
                                            fontFamily: AppTheme.of(context).subtitle1Family,
                                            useGoogleFonts: false,
                                            color: AppTheme.of(context).secondaryColor,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * 108,
                                    child: Text(
                                      '$monedaSeleccionada ${moneyFormat(widget.pagos.clientes![index].comision!)}',
                                      style: AppTheme.of(context).subtitle1.override(
                                            fontFamily: AppTheme.of(context).subtitle1Family,
                                            useGoogleFonts: false,
                                            color: AppTheme.of(context).purple,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * 90,
                                    child: Text(
                                      widget.pagos.clientes![index].fechaPago != null ? dayMothFormat(widget.pagos.clientes![index].fechaPago!) : 'Pendiente',
                                      style: AppTheme.of(context).subtitle1,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Container(
                                    width: width * 122,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: AppTheme.of(context).yellow,
                                    ),
                                    child: Center(
                                      child: Text(
                                        widget.pagos.clientes![index].estatus!,
                                        style: AppTheme.of(context).subtitle1.override(
                                              fontFamily: AppTheme.of(context).subtitle1Family,
                                              useGoogleFonts: false,
                                              color: AppTheme.of(context).tertiaryText,
                                            ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * 79,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        if (widget.pagos.clientes?[index].anexoDoc != null && widget.pagos.clientes?[index].estatusId == 8)
                                          Tooltip(
                                            message: 'Validar',
                                            child: CustomHoverIcon(
                                              icon: Icons.edit_square,
                                              size: 20,
                                              onTap: () async {
                                                await provider.pickAnexoDoc(widget.pagos.clientes![index].anexoDoc!);

                                                // ignore: use_build_context_synchronously
                                                await showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return PopUpValidacionAnexo(
                                                      cliente: widget.pagos.clientes![index],
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                        if (widget.pagos.clientes?[index].anexoDoc != null && widget.pagos.clientes?[index].estatusId == 8)
                                          Tooltip(
                                            message: 'Ver',
                                            child: CustomHoverIcon(
                                              icon: Icons.remove_red_eye_outlined,
                                              size: 20,
                                              onTap: () {},
                                            ),
                                          ),
                                        if (widget.pagos.clientes?[index].anexoDoc != null)
                                          Tooltip(
                                            message: 'Descargar',
                                            child: CustomHoverIcon(
                                              icon: Icons.file_download_outlined,
                                              size: 20,
                                              onTap: () async {
                                                await provider.descargarAnexo(widget.pagos.clientes![index].anexoDoc!);
                                              },
                                            ),
                                          ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
              ],
              expansionCallback: (panelIndex, isExpanded) {
                setState(() {
                  widget.pagos.isExpanded = !isExpanded;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
