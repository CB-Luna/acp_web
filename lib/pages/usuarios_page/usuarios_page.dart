import 'package:acp_web/helpers/globals.dart';
// import 'package:acp_web/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_side_menu/flutter_side_menu.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:provider/provider.dart';

import 'package:acp_web/pages/widgets/custom_side_menu.dart';
import 'package:acp_web/pages/widgets/custom_side_notifications.dart';
import 'package:acp_web/pages/widgets/custom_top_menu.dart';
import 'package:acp_web/pages/usuarios_page/widgets/header.dart';
import 'package:acp_web/providers/providers.dart';
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

  final bool permisoCaptura = currentUser!.rol.permisos.listaUsuarios == 'C';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      UsuariosProvider provider = Provider.of<UsuariosProvider>(
        context,
        listen: false,
      );
      await provider.updateState();
    });
  }

  @override
  Widget build(BuildContext context) {
    final VisualStateProvider visualState = Provider.of<VisualStateProvider>(context);
    visualState.setTapedOption(4);

    final UsuariosProvider provider = Provider.of<UsuariosProvider>(context);

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
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        //Encabezado
                        const UsuariosHeader(encabezado: 'Listado de Usuarios'),

                        //Tabla
                        Flexible(
                          child: PlutoGrid(
                            key: UniqueKey(),
                            configuration: PlutoGridConfiguration(
                              localeText: const PlutoGridLocaleText.spanish(),
                              scrollbar: plutoGridScrollbarConfig(context),
                              style: plutoGridStyleConfig(context),
                              columnFilter: PlutoGridColumnFilterConfig(
                                filters: const [
                                  ...FilterHelper.defaultFilters,
                                ],
                                resolveDefaultColumnFilter: (column, resolver) {
                                  return resolver<PlutoFilterTypeContains>() as PlutoFilterType;
                                },
                              ),
                            ),
                            columns: [
                              PlutoColumn(
                                title: 'ID',
                                field: 'usuario_id_secuencial',
                                width: 57,
                                enableContextMenu: false,
                                enableDropToResize: false,
                                titleTextAlign: PlutoColumnTextAlign.center,
                                textAlign: PlutoColumnTextAlign.center,
                                type: PlutoColumnType.number(),
                                enableEditingMode: false,
                              ),
                              PlutoColumn(
                                title: 'Nombre',
                                field: 'nombre',
                                width: 100,
                                enableContextMenu: false,
                                enableDropToResize: false,
                                titleTextAlign: PlutoColumnTextAlign.center,
                                textAlign: PlutoColumnTextAlign.center,
                                type: PlutoColumnType.text(),
                                enableEditingMode: false,
                              ),
                              PlutoColumn(
                                title: 'Apellido',
                                field: 'apellido',
                                width: 85,
                                enableContextMenu: false,
                                enableDropToResize: false,
                                titleTextAlign: PlutoColumnTextAlign.center,
                                textAlign: PlutoColumnTextAlign.center,
                                type: PlutoColumnType.text(),
                                enableEditingMode: false,
                              ),
                              PlutoColumn(
                                title: 'Telefono',
                                field: 'telefono',
                                width: 116,
                                enableContextMenu: false,
                                enableDropToResize: false,
                                titleTextAlign: PlutoColumnTextAlign.center,
                                textAlign: PlutoColumnTextAlign.center,
                                type: PlutoColumnType.text(),
                                enableEditingMode: false,
                              ),
                              PlutoColumn(
                                title: 'Rol',
                                field: 'rol',
                                width: 100,
                                enableContextMenu: false,
                                enableDropToResize: false,
                                titleTextAlign: PlutoColumnTextAlign.center,
                                textAlign: PlutoColumnTextAlign.center,
                                type: PlutoColumnType.text(),
                                enableEditingMode: false,
                              ),
                              PlutoColumn(
                                title: 'Compañía',
                                field: 'compania',
                                width: 100,
                                enableContextMenu: false,
                                enableDropToResize: false,
                                titleTextAlign: PlutoColumnTextAlign.center,
                                textAlign: PlutoColumnTextAlign.center,
                                type: PlutoColumnType.text(),
                                enableEditingMode: false,
                              ),
                              PlutoColumn(
                                title: 'Contacto',
                                field: 'email',
                                width: 162,
                                enableContextMenu: false,
                                enableDropToResize: false,
                                titleTextAlign: PlutoColumnTextAlign.center,
                                textAlign: PlutoColumnTextAlign.center,
                                type: PlutoColumnType.text(),
                                enableEditingMode: false,
                              ),
                              PlutoColumn(
                                title: 'Sociedad',
                                field: 'sociedad',
                                width: 90,
                                enableContextMenu: false,
                                enableDropToResize: false,
                                titleTextAlign: PlutoColumnTextAlign.center,
                                textAlign: PlutoColumnTextAlign.center,
                                type: PlutoColumnType.text(),
                                enableEditingMode: false,
                              ),
                              PlutoColumn(
                                title: 'País',
                                field: 'pais',
                                width: 90,
                                enableContextMenu: false,
                                enableDropToResize: false,
                                titleTextAlign: PlutoColumnTextAlign.center,
                                textAlign: PlutoColumnTextAlign.center,
                                type: PlutoColumnType.text(),
                                enableEditingMode: false,
                              ),
                              PlutoColumn(
                                title: 'Estado',
                                field: 'activo',
                                width: 111,
                                enableContextMenu: false,
                                enableDropToResize: false,
                                titleTextAlign: PlutoColumnTextAlign.center,
                                textAlign: PlutoColumnTextAlign.center,
                                type: PlutoColumnType.text(),
                                enableEditingMode: false,
                                renderer: (rendererContext) {
                                  return Container(
                                    height: 32,
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: const Color(0xFF94D0FF),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      rendererContext.cell.value,
                                      style: AppTheme.of(context).contenidoTablas,
                                    ),
                                  );
                                },
                              ),
                              PlutoColumn(
                                title: 'Acciones',
                                field: 'acciones',
                                width: 88,
                                enableContextMenu: false,
                                enableDropToResize: false,
                                titleTextAlign: PlutoColumnTextAlign.center,
                                textAlign: PlutoColumnTextAlign.center,
                                type: PlutoColumnType.text(),
                                enableEditingMode: false,
                                renderer: (rendererContext) {
                                  // final String id = rendererContext.cell.value;
                                  // Usuario? usuario;
                                  // try {
                                  //   usuario = provider.usuarios.firstWhere((element) => element.id == id);
                                  // } catch (e) {
                                  //   usuario = null;
                                  // }
                                  if (permisoCaptura) {
                                    return Row(
                                      children: [
                                        // if (usuario!.activo)
                                        //   AnimatedHoverButton(
                                        //     icon: Icons.edit,
                                        //     tooltip: 'Editar Usuario',
                                        //     primaryColor: AppTheme.of(context).primaryColor,
                                        //     secondaryColor: AppTheme.of(context).primaryBackground,
                                        //     onTap: () async {
                                        //       await provider.initEditarUsuario(
                                        //         usuario!,
                                        //       );
                                        //       if (!mounted) return;
                                        //       context.pushNamed(
                                        //         'editar_usuario',
                                        //         extra: usuario,
                                        //       );
                                        //     },
                                        //   ),
                                        // if (usuario.activado) const SizedBox(width: 10),
                                        // AnimatedHoverButton(
                                        //   icon: usuario.activado ? Icons.block : Icons.lock_open,
                                        //   tooltip: usuario.activado ? 'Desactivar' : 'Activar',
                                        //   primaryColor: AppTheme.of(context).primaryColor,
                                        //   secondaryColor: AppTheme.of(context).primaryBackground,
                                        //   onTap: () async {
                                        //     final res = await provider.updateActivado(
                                        //       usuario!,
                                        //       !usuario.activado,
                                        //     );
                                        //     if (res != null) {
                                        //       await ApiErrorHandler.callToast(res);
                                        //     }
                                        //   },
                                        // ),
                                      ],
                                    );
                                  }
                                  return const SizedBox.shrink();
                                },
                              ),
                            ],
                            rows: provider.rows,
                            createFooter: (stateManager) {
                              stateManager.setPageSize(
                                20,
                                notify: false,
                              );
                              return PlutoPagination(stateManager);
                            },
                            onLoaded: (event) {
                              provider.stateManager = event.stateManager;
                            },
                            onRowChecked: (event) {},
                          ),
                        ),
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
                              'Support',
                              style: AppTheme.of(context).subtitle3,
                            ),
                            Text(
                              'Contact Us',
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
