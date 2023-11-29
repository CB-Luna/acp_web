import 'package:acp_web/pages/widgets/toasts/success_toast.dart';
import 'package:acp_web/services/api_error_handler.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:acp_web/providers/providers.dart';

class OpcionesWidget extends StatefulWidget {
  const OpcionesWidget({
    super.key,
    required this.formKey,
  });

  final GlobalKey<FormState> formKey;

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
              if (!widget.formKey.currentState!.validate()) {
                return;
              }
              if (provider.cliente == null) return;

              // await provider.validarImagen(widget.cliente?.imagen);

              bool res = await provider.guardarCliente();

              if (!res) {
                await ApiErrorHandler.callToast('Error al guardar cliente');
                return;
              }

              if (!mounted) return;
              fToast.showToast(
                child: const SuccessToast(
                  message: 'Cliente guardado',
                ),
                gravity: ToastGravity.BOTTOM,
                toastDuration: const Duration(seconds: 2),
              );

              context.pushReplacement('/clientes');
              return;
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
