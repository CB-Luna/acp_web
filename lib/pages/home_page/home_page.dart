import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:acp_web/helpers/globals.dart';
import 'package:acp_web/pages/widgets/custom_side_menu.dart';
import 'package:acp_web/pages/widgets/custom_side_notifications.dart';
import 'package:acp_web/pages/widgets/custom_top_menu.dart';
import 'package:acp_web/providers/providers.dart';
import 'package:acp_web/theme/theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _ClientesPageState();
}

class _ClientesPageState extends State<HomePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final bool permisoCaptura = currentUser!.rol.permisos.listaUsuarios == 'C';

  @override
  Widget build(BuildContext context) {
    final VisualStateProvider visualState = Provider.of<VisualStateProvider>(context);
    visualState.setTapedOption(0);

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppTheme.of(context).primaryBackground,
      body: const Row(
        children: [
          CustomSideMenu(),
          Expanded(
            child: Column(
              children: [
                //Top Menu
                CustomTopMenu(pantalla: 'Home'),
                //Contenido
                Expanded(
                  child: Image(
                    image: AssetImage('assets/images/home_image.png'),
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.high,
                  ),
                ),
              ],
            ),
          ),
          CustomSideNotifications(),
        ],
      ),
    );
  }
}
