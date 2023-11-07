import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:acp_web/pages/registro_cliente/widgets/header.dart';
import 'package:acp_web/pages/registro_cliente/widgets/opciones_widget.dart';
import 'package:acp_web/pages/widgets/custom_side_menu.dart';
import 'package:acp_web/pages/widgets/custom_side_notifications.dart';
import 'package:acp_web/pages/widgets/custom_top_menu.dart';
import 'package:acp_web/providers/providers.dart';
import 'package:acp_web/models/models.dart';
import 'package:acp_web/theme/theme.dart';
import 'package:acp_web/pages/widgets/footer.dart';
import 'package:acp_web/pages/registro_cliente/widgets/datos_contacto_widget.dart';
import 'package:acp_web/pages/registro_cliente/widgets/datos_generales_widget.dart';

class RegistroClientePage extends StatefulWidget {
  const RegistroClientePage({super.key});

  @override
  State<RegistroClientePage> createState() => _RegistroClientePageState();
}

class _RegistroClientePageState extends State<RegistroClientePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final ClientesProvider provider = Provider.of<ClientesProvider>(context);

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppTheme.of(context).primaryBackground,
      body: const Row(
        children: [
          CustomSideMenu(),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //Top Menu
                CustomTopMenu(pantalla: 'Registro de Clientes'),
                //Contenido
                Expanded(
                  child: SingleChildScrollView(
                    clipBehavior: Clip.none,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          //Encabezado
                          RegistroClientesHeader(encabezado: 'Registro de Clientes'),
                          //Contenido
                          DatosGeneralesWidget(),
                          SizedBox(height: 16),
                          DatosContactoWidget(),
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: OpcionesWidget(),
                ),
                //Footer
                Footer(),
              ],
            ),
          ),
          CustomSideNotifications(),
        ],
      ),
    );
  }
}
