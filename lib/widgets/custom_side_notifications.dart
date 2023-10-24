import 'package:acp_web/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_side_menu/flutter_side_menu.dart';
import 'package:timelines/timelines.dart';

class CustomSideNotifications extends StatefulWidget {
  const CustomSideNotifications({super.key});

  @override
  State<CustomSideNotifications> createState() => _CustomSideNotificationsState();
}

class _CustomSideNotificationsState extends State<CustomSideNotifications> {
  final _controller = SideMenuController();
  double _currentIndex = 0;

  EdgeInsetsDirectional paddingHItems = const EdgeInsetsDirectional.only(start: 15, end: 15);
  EdgeInsetsDirectional paddingHItemsGroup = const EdgeInsetsDirectional.only(start: 30, end: 15);

  TextStyle dataTileTextStyle = const TextStyle(
    fontSize: 13,
    color: Colors.black,
    fontWeight: FontWeight.w200,
  );
  TextStyle dataTileSelectedTextStyle = const TextStyle(
    fontSize: 13,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  Color hoverColor = const Color(0x50C6C6C6);
  Color highlightSelectedColor = const Color(0x50C6C6C6);

  BorderRadius borderRadius = BorderRadius.circular(8);

  double iconSize = 20;

  Map<String, bool> sideMenuItemDataTileGroupsOpened = {
    'Propuesta de Pago': false,
  };

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 15),
        Container(
          decoration: BoxDecoration(gradient: AppTheme.of(context).blueGradient),
          child: SideMenu(
            controller: _controller,
            position: SideMenuPosition.right,
            backgroundColor: Colors.transparent,
            mode: SideMenuMode.auto,
            maxWidth: 250,
            minWidth: 100,
            builder: (data) {
              return SideMenuData(
                header: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                  child: SizedBox(
                    height: 300,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: data.isOpen ? MainAxisAlignment.start : MainAxisAlignment.center,
                          children: [
                            Text(
                              'Notificaciones',
                              style: TextStyle(
                                fontSize: data.isOpen ? 14 : 10,
                                color: AppTheme.of(context).primaryBackground,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return data.isOpen
                                ? SizedBox(
                                    height: 50,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 25,
                                          height: 25,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            color: Colors.green[100],
                                          ),
                                          child: Icon(
                                            Icons.alarm_outlined,
                                            color: Colors.green[500],
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'En espera de validación',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: AppTheme.of(context).primaryBackground,
                                                overflow: TextOverflow.fade,
                                              ),
                                            ),
                                            Text(
                                              'Justo ahora',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: AppTheme.of(context).primaryBackground,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                : SizedBox(
                                    width: 180,
                                    height: 50,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 25,
                                          height: 25,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            color: Colors.green[100],
                                          ),
                                          child: Icon(
                                            Icons.alarm_outlined,
                                            color: Colors.green[500],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                items: [],
                footer: data.isOpen
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Actividades',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.of(context).primaryBackground,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: 5,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    Row(
                                      children: [
                                        const DotIndicator(size: 24),
                                        const SizedBox(width: 10),
                                        SizedBox(
                                          width: 180,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Tienes un error que necestia atención inmediata',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: AppTheme.of(context).primaryBackground,
                                                  overflow: TextOverflow.fade,
                                                ),
                                              ),
                                              Text(
                                                'Justo ahora',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: AppTheme.of(context).primaryBackground,
                                                  fontWeight: FontWeight.w300,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    if (index != 4)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 2.5),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            const SizedBox(width: 11.5),
                                            SizedBox(
                                              height: 20.0,
                                              child: SolidLineConnector(
                                                color: AppTheme.of(context).primaryBackground,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: data.isOpen ? MainAxisAlignment.start : MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Actividades',
                                  style: TextStyle(
                                    fontSize: data.isOpen ? 14 : 10,
                                    color: AppTheme.of(context).primaryBackground,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: 5,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        DotIndicator(size: 24),
                                      ],
                                    ),
                                    if (index != 4)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 5),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: 20.0,
                                              child: SolidLineConnector(
                                                color: AppTheme.of(context).primaryBackground,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
              );
            },
          ),
        ),
      ],
    );
  }
}
