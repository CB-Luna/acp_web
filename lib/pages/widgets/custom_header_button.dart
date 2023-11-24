import 'package:acp_web/theme/theme.dart';
import 'package:flutter/material.dart';

class CustomHeaderButton extends StatefulWidget {
  const CustomHeaderButton({super.key, required this.encabezado, required this.texto, required this.icon, required this.onPressed});

  final String encabezado;
  final String texto;
  final IconData icon;
  final Function()? onPressed;

  @override
  State<CustomHeaderButton> createState() => HeaderOptionsState();
}

class HeaderOptionsState extends State<CustomHeaderButton> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.encabezado,
          style: AppTheme.of(context).title3,
        ),
        ElevatedButton(
          onPressed: widget.onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.of(context).primaryColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            padding: const EdgeInsets.all(18),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                color: Colors.white,
              ),
              const SizedBox(width: 5),
              Text(widget.texto,
                  style: AppTheme.of(context).title2.override(
                        fontFamily: AppTheme.of(context).bodyText2Family,
                        useGoogleFonts: false,
                        color: AppTheme.of(context).primaryBackground,
                      )),
            ],
          ),
        ),
      ],
    );
  }
}
