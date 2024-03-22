import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:provider/provider.dart';

import 'package:acp_web/pages/widgets/custom_side_menu.dart';
import 'package:acp_web/pages/widgets/custom_side_notifications.dart';
import 'package:acp_web/pages/widgets/custom_top_menu.dart';
import 'package:acp_web/pages/usuarios_page/widgets/header.dart';
import 'package:acp_web/providers/providers.dart';
import 'package:acp_web/theme/theme.dart';
import 'package:acp_web/helpers/globals.dart';
import 'package:acp_web/models/models.dart';
import 'package:acp_web/pages/usuarios_page/widgets/confirmacion_popup.dart';
import 'package:acp_web/pages/widgets/footer.dart';
import 'package:acp_web/pages/widgets/get_image_widget.dart';
import 'package:acp_web/services/api_error_handler.dart';

class UsuariosPage extends StatefulWidget {
  const UsuariosPage({super.key});

  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

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
                  pantalla: 'Usuarios',
                  controllerBusqueda: provider.busquedaController,
                  onSearchChanged: (busqueda) async {
                    await provider.getUsuarios();
                  },
                ),
                //Contenido
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
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
                                title: 'Usuario',
                                field: 'usuario',
                                width: 200,
                                enableContextMenu: false,
                                enableDropToResize: false,
                                titleTextAlign: PlutoColumnTextAlign.center,
                                type: PlutoColumnType.text(),
                                enableEditingMode: false,
                                renderer: (rendererContext) {
                                  final infoUsuario = rendererContext.cell.value as Map<String, String?>;
                                  return Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 24,
                                        height: 24,
                                        clipBehavior: Clip.antiAlias,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                        ),
                                        child: getUserImage(
                                          height: 24,
                                          infoUsuario['imagen'],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          infoUsuario['nombre'] ?? '',
                                          overflow: TextOverflow.ellipsis,
                                          style: AppTheme.of(context).bodyText2,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                              PlutoColumn(
                                title: 'Correo electrónico',
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
                                width: 150,
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
                                      color: rendererContext.cell.value == 'Activo'
                                          ? const Color(0xFF94D0FF)
                                          : Colors.grey[300],
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      rendererContext.cell.value,
                                      style: AppTheme.of(context).bodyText2,
                                    ),
                                  );
                                },
                              ),
                              PlutoColumn(
                                title: 'Acciones',
                                field: 'acciones',
                                width: 160,
                                enableContextMenu: false,
                                enableDropToResize: false,
                                titleTextAlign: PlutoColumnTextAlign.center,
                                textAlign: PlutoColumnTextAlign.center,
                                type: PlutoColumnType.text(),
                                enableEditingMode: false,
                                renderer: (rendererContext) {
                                  final String id = rendererContext.cell.value;
                                  Usuario? usuario;
                                  try {
                                    usuario = provider.usuarios.firstWhere((element) => element.id == id);
                                  } catch (e) {
                                    usuario = null;
                                    return const SizedBox.shrink();
                                  }
                                  if (permisoCaptura) {
                                    return Row(
                                      children: [
                                        Switch(
                                          value: usuario.activo,
                                          activeColor: const Color(0xFF0090FF),
                                          onChanged: (value) async {
                                            usuario!.activo = value;
                                            final res = await provider.updateActivado(
                                              usuario,
                                              usuario.activo,
                                              rendererContext.rowIdx,
                                            );
                                            if (!res) {
                                              await ApiErrorHandler.callToast(
                                                  'Error al ${value ? "" : "des"}activar usuario');
                                            }
                                          },
                                        ),
                                        IconButton(
                                          padding: EdgeInsets.zero,
                                          icon: Transform.translate(
                                            offset: const Offset(0, -2.5),
                                            child: const Icon(
                                              FontAwesomeIcons.penToSquare,
                                              size: 24,
                                              color: Color(0xFF0090FF),
                                            ),
                                          ),
                                          splashRadius: 0.01,
                                          onPressed: () async {
                                            provider.initEditarUsuario(usuario!);
                                            if (!mounted) return;
                                            await context.pushNamed(
                                              'editar_usuario',
                                              extra: usuario,
                                            );
                                          },
                                        ),
                                        IconButton(
                                          padding: EdgeInsets.zero,
                                          icon: const Icon(
                                            Icons.delete_outline_outlined,
                                            size: 24,
                                            color: Color(0xFF0090FF),
                                          ),
                                          splashRadius: 0.01,
                                          onPressed: () async {
                                            final popupResult = await showDialog(
                                              context: context,
                                              builder: (context) {
                                                return const ConfirmacionPopup();
                                              },
                                            );
                                            if (popupResult == null || popupResult is! bool) return;
                                            if (popupResult == false) return;
                                            final res = await provider.borrarUsuario(usuario!.id);
                                            if (!res) {
                                              ApiErrorHandler.callToast('Error al borrar usuario');
                                              return;
                                            }
                                          },
                                        ),
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
