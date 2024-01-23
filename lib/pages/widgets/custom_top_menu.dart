import 'package:acp_web/pages/widgets/custom_hover_icon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:acp_web/helpers/globals.dart';
import 'package:acp_web/providers/providers.dart';
import 'package:acp_web/theme/theme.dart';

class CustomTopMenu extends StatefulWidget {
  const CustomTopMenu({
    super.key,
    required this.pantalla,
    this.controllerBusqueda,
    this.onSearchChanged,
    this.onMonedaSeleccionada,
  });

  final String pantalla;
  final TextEditingController? controllerBusqueda;
  final Function(String)? onSearchChanged;
  final Function()? onMonedaSeleccionada;

  @override
  State<CustomTopMenu> createState() => _CustomTopMenuState();
}

class _CustomTopMenuState extends State<CustomTopMenu> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width / 1440;

    final VisualStateProvider visualState = Provider.of<VisualStateProvider>(context);
    final UserState userState = Provider.of<UserState>(context);
    return SizedBox(
      height: 85,
      child: Column(
        children: [
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  spacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Wrap(
                      spacing: 8,
                      children: [
                        CustomHoverIcon(
                          size: 24,
                          icon: Icons.format_indent_decrease_outlined,
                          onTap: () {
                            visualState.toggleSideMenu();
                          },
                        ),
                        CustomHoverIcon(
                          size: 24,
                          icon: Icons.star_border_outlined,
                          onTap: () {},
                        ),
                      ],
                    ),
                    Wrap(
                      spacing: 8,
                      children: [
                        Text(
                          currentUser!.rol.nombre,
                          style: AppTheme.of(context).bodyText1.override(
                                fontFamily: AppTheme.of(context).bodyText1Family,
                                useGoogleFonts: false,
                                color: AppTheme.of(context).secondaryText,
                              ),
                        ),
                        Text(
                          '/',
                          style: AppTheme.of(context).bodyText1.override(
                                fontFamily: AppTheme.of(context).bodyText1Family,
                                useGoogleFonts: false,
                                color: AppTheme.of(context).secondaryText,
                              ),
                        ),
                        Text(widget.pantalla, style: AppTheme.of(context).bodyText1),
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  spacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Wrap(
                      spacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Tooltip(
                          message: 'Selecciona el tipo de moneda',
                          child: Text(
                            'Moneda',
                            style: AppTheme.of(context).title3.override(
                                  fontFamily: AppTheme.of(context).title3Family,
                                  useGoogleFonts: false,
                                  color: AppTheme.of(context).primaryColor,
                                ),
                          ),
                        ),
                        InkWell(
                          child: Text(
                            'USD',
                            style: AppTheme.of(context).title3.override(
                                  fontFamily: AppTheme.of(context).title3Family,
                                  useGoogleFonts: false,
                                  color: currentUser!.monedaSeleccionada == 'USD'
                                      ? AppTheme.of(context).primaryColor
                                      : AppTheme.of(context).secondaryBackground,
                                ),
                          ),
                          onTap: () async {
                            currentUser!.monedaSeleccionada = 'USD';
                            if (widget.onMonedaSeleccionada != null) {
                              await widget.onMonedaSeleccionada!();
                            }
                          },
                        ),
                        InkWell(
                          child: Text(
                            'GTQ',
                            style: AppTheme.of(context).title3.override(
                                  fontFamily: AppTheme.of(context).title3Family,
                                  useGoogleFonts: false,
                                  color: currentUser!.monedaSeleccionada == 'GTQ'
                                      ? AppTheme.of(context).primaryColor
                                      : AppTheme.of(context).secondaryBackground,
                                ),
                          ),
                          onTap: () async {
                            currentUser!.monedaSeleccionada = 'GTQ';
                            if (widget.onMonedaSeleccionada != null) {
                              await widget.onMonedaSeleccionada!();
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    //SearchBar
                    Container(
                      width: width * 160,
                      height: 30,
                      decoration: BoxDecoration(
                        color: AppTheme.of(context).gray,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: TextField(
                          controller: widget.controllerBusqueda,
                          onChanged: widget.onSearchChanged,
                          decoration: InputDecoration(
                            hintText: 'Busqueda',
                            hintStyle: AppTheme.of(context).bodyText1.override(
                                  fontFamily: AppTheme.of(context).bodyText1Family,
                                  useGoogleFonts: false,
                                  color: AppTheme.of(context).secondaryText,
                                ),
                            border: InputBorder.none,
                            prefixText: '',
                            prefixStyle: AppTheme.of(context).subtitle1,
                            icon: const Icon(Icons.search),
                            focusColor: AppTheme.of(context).primaryColor,
                          ),
                          cursorColor: AppTheme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        CustomHoverIcon(
                          size: 24,
                          icon: Icons.wb_sunny_outlined,
                          onTap: () {},
                        ),
                        CustomHoverIcon(
                          size: 24,
                          icon: Icons.history_outlined,
                          onTap: () {},
                        ),
                        CustomHoverIcon(
                          size: 24,
                          icon: Icons.notifications_outlined,
                          onTap: () {},
                        ),
                        CustomHoverIcon(
                          size: 24,
                          icon: Icons.exit_to_app_outlined,
                          onTap: () async {
                            await userState.logout();
                          },
                        ),
                        CustomHoverIcon(
                          size: 24,
                          icon: Icons.format_indent_increase_outlined,
                          onTap: () {
                            visualState.toggleNotificationMenu();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 1),
        ],
      ),
    );
  }
}
