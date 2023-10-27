import 'package:acp_web/pages/usuarios_page/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_side_menu/flutter_side_menu.dart';
import 'package:provider/provider.dart';

import 'package:acp_web/pages/widgets/custom_header_options.dart';
import 'package:acp_web/pages/widgets/custom_side_menu.dart';
import 'package:acp_web/pages/widgets/custom_side_notifications.dart';
import 'package:acp_web/pages/widgets/custom_top_menu.dart';
import 'package:acp_web/providers/visual_state/visual_state_provider.dart';
import 'package:acp_web/theme/theme.dart';

class UsuariosPage extends StatefulWidget {
  const UsuariosPage({super.key});

  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  SideMenuController sideMenuController = SideMenuController();
  SideMenuController sideNotificationsController = SideMenuController();

  @override
  Widget build(BuildContext context) {
    final VisualStateProvider visualState = Provider.of<VisualStateProvider>(context);
    visualState.setTapedOption(4);

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppTheme.of(context).primaryBackground,
      body: Row(
        children: [
          const CustomSideMenu(),
          Expanded(
            child: Column(
              children: [
                //Top Menu
                CustomTopMenu(
                  sideMenuController: sideMenuController,
                  sideNotificationsController: sideNotificationsController,
                  pantalla: 'Usuarios',
                ),
                //Contenido
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        //Encabezado
                        UsuariosHeader(encabezado: 'Listado de Usuarios'),
                      ],
                    ),
                  ),
                ),
                //Footer
                Container(
                  color: AppTheme.of(context).primaryBackground,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '© 2023 ACP ALTERNATICAS DE CAPITAL',
                          style: AppTheme.of(context).subtitle3,
                        ),
                        Wrap(
                          spacing: 16,
                          children: [
                            Text(
                              'About',
                              style: AppTheme.of(context).subtitle3,
                            ),
                            Text(
                              'support',
                              style: AppTheme.of(context).subtitle3,
                            ),
                            Text(
                              'contact Us',
                              style: AppTheme.of(context).subtitle3,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          const CustomSideNotifications(),
        ],
      ),
    );
  }
}
