import 'package:acp_web/theme/theme.dart';
import 'package:flutter/material.dart';

class PopupAprobacionSeguimientoPagos extends StatefulWidget {
  const PopupAprobacionSeguimientoPagos({super.key, required this.estatus});
  final int estatus;

  @override
  State<PopupAprobacionSeguimientoPagos> createState() => PopupAprobacionSeguimientoPagosState();
}

class PopupAprobacionSeguimientoPagosState extends State<PopupAprobacionSeguimientoPagos> {
  @override
  Widget build(BuildContext context) {
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
                        Navigator.pop(context);
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
                        Navigator.pop(context);
                      },
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: IconButton(
                    icon: Icon(Icons.fullscreen, color: AppTheme.of(context).primaryColor),
                    tooltip: 'Pantalla Completa',
                    color: AppTheme.of(context).primaryColor,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
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
              child: Container(
                color: Colors.blue,
              ),
            ))
          ],
        ),
      ),
    );
  }
}
