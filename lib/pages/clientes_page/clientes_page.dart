import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:provider/provider.dart';

import 'package:acp_web/pages/widgets/custom_side_menu.dart';
import 'package:acp_web/pages/widgets/custom_side_notifications.dart';
import 'package:acp_web/pages/widgets/custom_top_menu.dart';
import 'package:acp_web/providers/providers.dart';
import 'package:acp_web/pages/clientes_page/widgets/header.dart';
import 'package:acp_web/providers/visual_state/visual_state_provider.dart';
import 'package:acp_web/theme/theme.dart';
import 'package:acp_web/helpers/globals.dart';
import 'package:acp_web/models/models.dart';
import 'package:acp_web/pages/widgets/footer.dart';
import 'package:acp_web/pages/widgets/get_image_widget.dart';
import 'package:acp_web/services/api_error_handler.dart';

class ClientesPage extends StatefulWidget {
  const ClientesPage({super.key});

  @override
  State<ClientesPage> createState() => _ClientesPageState();
}

class _ClientesPageState extends State<ClientesPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final bool permisoCaptura = currentUser!.rol.permisos.listaUsuarios == 'C';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      ClientesProvider provider = Provider.of<ClientesProvider>(
        context,
        listen: false,
      );
      await provider.updateState();
    });
  }

  @override
  Widget build(BuildContext context) {
    final VisualStateProvider visualState = Provider.of<VisualStateProvider>(context);
    visualState.setTapedOption(5);

    final ClientesProvider provider = Provider.of<ClientesProvider>(context);

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
                const CustomTopMenu(pantalla: 'Clientes'),
                //Contenido
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        //Encabezado
                        const ClientesHeader(encabezado: 'Listado de Clientes'),

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
                                field: 'cliente_id',
                                width: 57,
                                enableContextMenu: false,
                                enableDropToResize: false,
                                titleTextAlign: PlutoColumnTextAlign.center,
                                textAlign: PlutoColumnTextAlign.center,
                                type: PlutoColumnType.number(),
                                enableEditingMode: false,
                              ),
                              PlutoColumn(
                                title: 'Cliente',
                                field: 'cliente',
                                width: 200,
                                enableContextMenu: false,
                                enableDropToResize: false,
                                titleTextAlign: PlutoColumnTextAlign.center,
                                type: PlutoColumnType.text(),
                                enableEditingMode: false,
                                renderer: (rendererContext) {
                                  final cliente = rendererContext.cell.value as Cliente;
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
                                          cliente.imagen,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          cliente.nombreFiscal,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppTheme.of(context).bodyText2,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                              PlutoColumn(
                                title: 'Fecha Registro',
                                field: 'fecha_registro',
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
                                width: 116,
                                enableContextMenu: false,
                                enableDropToResize: false,
                                titleTextAlign: PlutoColumnTextAlign.center,
                                textAlign: PlutoColumnTextAlign.center,
                                type: PlutoColumnType.text(),
                                enableEditingMode: false,
                              ),
                              PlutoColumn(
                                title: 'Moneda',
                                field: 'moneda',
                                width: 100,
                                enableContextMenu: false,
                                enableDropToResize: false,
                                titleTextAlign: PlutoColumnTextAlign.center,
                                textAlign: PlutoColumnTextAlign.center,
                                type: PlutoColumnType.text(),
                                enableEditingMode: false,
                              ),
                              PlutoColumn(
                                title: 'Tasa Anual',
                                field: 'tasa_anual',
                                width: 100,
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
                                  final Cliente cliente = rendererContext.cell.value;
                                  if (permisoCaptura) {
                                    return Row(
                                      children: [
                                        Switch(
                                          value: cliente.activo,
                                          activeColor: const Color(0xFF0090FF),
                                          onChanged: (value) async {
                                            cliente.activo = value;
                                            final res = await provider.updateActivado(
                                              cliente,
                                              cliente.activo,
                                              rendererContext.rowIdx,
                                            );
                                            if (!res) {
                                              await ApiErrorHandler.callToast(
                                                  'Error al ${value ? "" : "des"}activar cliente');
                                            }
                                          },
                                        ),
                                        IconButton(
                                          padding: EdgeInsets.zero,
                                          icon: const Icon(
                                            FontAwesomeIcons.penToSquare,
                                            size: 24,
                                            color: Color(0xFF0090FF),
                                          ),
                                          splashRadius: 0.01,
                                          onPressed: () async {
                                            // await provider.initEditarUsuario(usuario!);
                                            // if (!mounted) return;
                                            provider.cliente = cliente;
                                            await context.pushNamed(
                                              'editar_cliente',
                                              extra: cliente,
                                            );
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
