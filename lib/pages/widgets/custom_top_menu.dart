import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:acp_web/helpers/globals.dart';
import 'package:acp_web/providers/providers.dart';
import 'package:acp_web/providers/visual_state/visual_state_provider.dart';
import 'package:acp_web/theme/theme.dart';

class CustomTopMenu extends StatefulWidget {
  const CustomTopMenu({
    super.key,
    required this.pantalla,
    this.controllerBusqueda,
    this.onSearchChanged,
  });

  final String pantalla;
  final TextEditingController? controllerBusqueda;
  final Function(String)? onSearchChanged;

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
                        IconButton(
                          icon: const Icon(
                            Icons.format_indent_decrease_outlined,
                            size: 24,
                          ),
                          splashRadius: 0.01,
                          onPressed: () {
                            visualState.toggleSideMenu();
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.star_border_outlined,
                            size: 24,
                          ),
                          splashRadius: 0.01,
                          onPressed: () {},
                        ),
                      ],
                    ),
                    Wrap(
                      spacing: 8,
                      children: [
                        Text(
                          currentUser!.rol.nombre,
                          style: AppTheme.of(context).bodyText2,
                        ),
                        Text(
                          '/',
                          style: AppTheme.of(context).bodyText2,
                        ),
                        Text(
                          widget.pantalla,
                          style: AppTheme.of(context).subtitle2,
                        ),
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
                        Text(
                          'Moneda',
                          style: AppTheme.of(context).subtitle1.override(
                                fontFamily: AppTheme.of(context).bodyText2Family,
                                useGoogleFonts: false,
                                color: AppTheme.of(context).primaryColor,
                              ),
                        ),
                        InkWell(
                          child: Text(
                            'USD',
                            style: AppTheme.of(context).subtitle1.override(
                                  fontFamily: AppTheme.of(context).bodyText2Family,
                                  useGoogleFonts: false,
                                  color: AppTheme.of(context).secondaryColor,
                                ),
                          ),
                          onTap: () {},
                        ),
                        InkWell(
                          child: Text(
                            'GTQ',
                            style: AppTheme.of(context).subtitle1.override(
                                  fontFamily: AppTheme.of(context).bodyText2Family,
                                  useGoogleFonts: false,
                                  color: AppTheme.of(context).primaryColor,
                                ),
                          ),
                          onTap: () {},
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    //SearchBar
                    Container(
                      width: width * 160,
                      height: 30,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F4F4),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: TextField(
                          controller: widget.controllerBusqueda,
                          onChanged: widget.onSearchChanged,
                          decoration: InputDecoration(
                            hintText: 'Busqueda',
                            hintStyle: AppTheme.of(context).bodyText2,
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
                        IconButton(
                          icon: const Icon(
                            Icons.wb_sunny_outlined,
                            size: 24,
                          ),
                          splashRadius: 0.01,
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.history_outlined,
                            size: 24,
                          ),
                          splashRadius: 0.01,
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.notifications_outlined,
                            size: 24,
                          ),
                          splashRadius: 0.01,
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.exit_to_app_outlined,
                            size: 24,
                          ),
                          splashRadius: 0.01,
                          onPressed: () async {
                            await userState.logout();
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.format_indent_increase_outlined,
                            size: 24,
                          ),
                          splashRadius: 0.01,
                          onPressed: () {
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
          const Divider()
        ],
      ),
    );
  }
}
