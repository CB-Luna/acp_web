import 'package:acp_web/widgets/custom_side_menu.dart';
import 'package:acp_web/theme/theme.dart';
import 'package:acp_web/widgets/custom_side_notifications.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SeleccionPagosAnticipadosPage extends StatefulWidget {
  const SeleccionPagosAnticipadosPage({super.key});

  @override
  State<SeleccionPagosAnticipadosPage> createState() => _SeleccionPagosAnticipadosPageState();
}

class _SeleccionPagosAnticipadosPageState extends State<SeleccionPagosAnticipadosPage> {
  @override
  Widget build(BuildContext context) {
    //final VisualStateProvider visualState = Provider.of<VisualStateProvider>(context);
    //visualState.setTapedOption(2);

    //final bool permisoCaptura = currentUser!.rol.permisos.extraccionDeFacturas == 'C';
    //String? monedaSeleccionada = currentUser!.monedaSeleccionada;

    //final SeleccionPagosAnticipadosPage provider = Provider.of<SeleccionPagosAnticipadosPage>(context);

    return Scaffold(
      backgroundColor: AppTheme.of(context).primaryBackground,
      body: const SizedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomSideMenu(),
            Column(),
            CustomSideNotifications(),
          ],
        ),
      ),
    );
  }
}
