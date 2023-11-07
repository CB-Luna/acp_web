import 'package:acp_web/models/models.dart';
import 'package:acp_web/pages/widgets/toasts/success_toast.dart';
import 'package:acp_web/services/api_error_handler.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:acp_web/providers/providers.dart';

class OpcionesWidget extends StatefulWidget {
  const OpcionesWidget({super.key});

  @override
  State<OpcionesWidget> createState() => _OpcionesWidgetState();
}

class _OpcionesWidgetState extends State<OpcionesWidget> {
  FToast fToast = FToast();

  @override
  Widget build(BuildContext context) {
    fToast.init(context);
    final ClientesProvider provider = Provider.of<ClientesProvider>(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0x1A1C1C1C),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: () {
              if (context.canPop()) context.pop();
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              shadowColor: Colors.transparent,
              backgroundColor: const Color(0x0D1C1C1C),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
            ),
            child: Text(
              'Cancelar',
              style: GoogleFonts.inter(
                color: const Color(0xFF1C1C1C),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () async {
              // await provider.validarImagen(widget.usuario?.imagen);

              // if (widget.usuario != null) {
              //   //Editar usuario
              //   bool res = await provider.editarPerfilDeUsuario(widget.usuario!.id);

              //   if (!res) {
              //     await ApiErrorHandler.callToast('Error al editar perfil de usuario');
              //     return;
              //   }

              //   if (!mounted) return;
              //   fToast.showToast(
              //     child: const SuccessToast(
              //       message: 'Usuario editado',
              //     ),
              //     gravity: ToastGravity.BOTTOM,
              //     toastDuration: const Duration(seconds: 2),
              //   );

              //   context.pushReplacement('/usuarios');
              //   return;
              // }

              if (!mounted) return;
              fToast.showToast(
                child: const SuccessToast(
                  message: 'Cliente editado',
                ),
                gravity: ToastGravity.BOTTOM,
                toastDuration: const Duration(seconds: 2),
              );

              context.pushReplacement('/clientes');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF21418B),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
            ),
            child: Text(
              'Guardar Cambios',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
