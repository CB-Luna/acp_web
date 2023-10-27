import 'package:acp_web/helpers/globals.dart';
import 'package:acp_web/providers/providers.dart';
import 'package:acp_web/providers/visual_state/visual_state_provider.dart';
import 'package:acp_web/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_side_menu/flutter_side_menu.dart';
import 'package:provider/provider.dart';

class CustomTopMenu extends StatefulWidget {
  const CustomTopMenu({
    super.key,
    required this.sideMenuController,
    required this.sideNotificationsController,
    required this.pantalla,
  });

  final SideMenuController sideMenuController;
  final SideMenuController sideNotificationsController;
  final String pantalla;

  @override
  State<CustomTopMenu> createState() => _CustomTopMenuState();
}

class _CustomTopMenuState extends State<CustomTopMenu> {
  @override
  Widget build(BuildContext context) {
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
                            visualState.toogleSideMenu();
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
                          style: AppTheme.of(context).subtitle3,
                        ),
                        Text(
                          '/',
                          style: AppTheme.of(context).subtitle3,
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
                    //SearchBar
                    Container(
                      width: 160,
                      height: 30,
                      color: AppTheme.of(context).gris,
                    ),
                    Container(
                      width: 42,
                      height: 42,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                    ),
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
                            visualState.toogleNotificationMenu();
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
