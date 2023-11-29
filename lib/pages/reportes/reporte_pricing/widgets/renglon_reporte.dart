import 'package:acp_web/functions/money_format.dart';
import 'package:acp_web/theme/theme.dart';
import 'package:flutter/material.dart';

class RenglonReporte extends StatefulWidget {
  const RenglonReporte({
    super.key,
    required this.titulo,
    required this.valor,
    this.porcentaje1 = '      ',
    this.porcentaje2 = '      ',
    required this.style,
    this.message='',
  });
  final String titulo;
  final double valor;
  final String? porcentaje1;
  final String? porcentaje2;
  final TextStyle style;
  final String? message;

  @override
  State<RenglonReporte> createState() => _RenglonReporteState();
}

class _RenglonReporteState extends State<RenglonReporte> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width / 1440;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: width * 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Tooltip(
                  message: widget.message,
                  child: Text(
                    widget.titulo,
                    style: widget.style == AppTheme.of(context).bodyText2
                        ? AppTheme.of(context).bodyText2.override(
                              fontFamily: AppTheme.of(context).bodyText2Family,
                              useGoogleFonts: false,
                              color: AppTheme.of(context).secondaryText,
                            )
                        : widget.style,
                  ),
                ),
              ],
            ),
          ),
          /* SizedBox(
            width: width * 20,
            child: Text(
              'Q', //'${provider.montoQController.numberValue}',
              style: widget.style == AppTheme.of(context).bodyText2
                  ? AppTheme.of(context).bodyText2.override(
                        fontFamily: AppTheme.of(context).bodyText2Family,
                        useGoogleFonts: false,
                        color: AppTheme.of(context).secondaryText,
                      )
                  : widget.style,
              textAlign: TextAlign.center,
            ),
          ), */
          SizedBox(
            width: width * 100,
            child: Text(
              moneyFormat(widget.valor),
              style: widget.style == AppTheme.of(context).bodyText2
                  ? AppTheme.of(context).bodyText2.override(
                        fontFamily: AppTheme.of(context).bodyText2Family,
                        useGoogleFonts: false,
                        color: AppTheme.of(context).secondaryText,
                      )
                  : widget.style,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: width * 50,
            child: Text(
              widget.porcentaje1!,
              style: widget.style == AppTheme.of(context).bodyText2
                  ? AppTheme.of(context).bodyText2.override(
                        fontFamily: AppTheme.of(context).bodyText2Family,
                        useGoogleFonts: false,
                        color: AppTheme.of(context).secondaryText,
                      )
                  : widget.style,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: width * 50,
            child: Text(
              widget.porcentaje2!,
              style: widget.style == AppTheme.of(context).bodyText2
                  ? AppTheme.of(context).bodyText2.override(
                        fontFamily: AppTheme.of(context).bodyText2Family,
                        useGoogleFonts: false,
                        color: AppTheme.of(context).secondaryText,
                      )
                  : widget.style,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
