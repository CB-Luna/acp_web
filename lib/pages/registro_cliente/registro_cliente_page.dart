import 'package:flutter/material.dart';

import 'package:acp_web/pages/registro_cliente/widgets/header.dart';
import 'package:acp_web/pages/registro_cliente/widgets/opciones_widget.dart';
import 'package:acp_web/pages/widgets/custom_side_menu.dart';
import 'package:acp_web/pages/widgets/custom_side_notifications.dart';
import 'package:acp_web/pages/widgets/custom_top_menu.dart';
import 'package:acp_web/theme/theme.dart';
import 'package:acp_web/pages/widgets/footer.dart';
import 'package:acp_web/pages/registro_cliente/widgets/tasa_anual_widget.dart';
import 'package:acp_web/pages/registro_cliente/widgets/datos_contacto_widget.dart';
import 'package:acp_web/pages/registro_cliente/widgets/datos_generales_widget.dart';

class RegistroClientePage extends StatefulWidget {
  const RegistroClientePage({super.key});

  @override
  State<RegistroClientePage> createState() => _RegistroClientePageState();
}

class _RegistroClientePageState extends State<RegistroClientePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppTheme.of(context).primaryBackground,
      body: Row(
        children: [
          const CustomSideMenu(),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //Top Menu
                const CustomTopMenu(pantalla: 'Registro de Clientes'),
                //Contenido
                Expanded(
                  child: SingleChildScrollView(
                    clipBehavior: Clip.none,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Form(
                        key: formKey,
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //Encabezado
                            RegistroClientesHeader(encabezado: 'Registro de Clientes'),
                            //Contenido
                            DatosGeneralesWidget(),
                            SizedBox(height: 16),
                            DatosContactoWidget(),
                            SizedBox(height: 16),
                            TasaAnualWidget(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: OpcionesWidget(formKey: formKey),
                ),
                //Footer
                const Footer(),
              ],
            ),
          ),
          const CustomSideNotifications(),
        ],
      ),
    );
  }
}
