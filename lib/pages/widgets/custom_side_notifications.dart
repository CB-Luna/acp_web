import 'package:acp_web/providers/visual_state/visual_state_provider.dart';
import 'package:acp_web/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_side_menu/flutter_side_menu.dart';
import 'package:provider/provider.dart';
import 'package:timelines/timelines.dart';

class CustomSideNotifications extends StatefulWidget {
  const CustomSideNotifications({
    super.key,
  });

  @override
  State<CustomSideNotifications> createState() => _CustomSideNotificationsState();
}

class _CustomSideNotificationsState extends State<CustomSideNotifications> {
  @override
  Widget build(BuildContext context) {
    final VisualStateProvider visualState = Provider.of<VisualStateProvider>(context);
    return Row(
      children: [
        const SizedBox(width: 15),
        Container(
          decoration: const BoxDecoration(
              //gradient: AppTheme.of(context).blueGradient),
              color: Color(0xFF0A0859)),
          child: SideMenu(
            controller: visualState.sideNotificationsController,
            hasResizer: false,
            hasResizerToggle: false,
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
                              style: AppTheme.of(context).title3.override(
                                    fontFamily: AppTheme.of(context).title3Family,
                                    fontSize: data.isOpen ? 14 : 10,
                                    color: AppTheme.of(context).primaryBackground,
                                  ),
                              overflow: TextOverflow.fade,
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
                                              style: AppTheme.of(context).title3.override(
                                                    fontFamily: AppTheme.of(context).title3Family,
                                                    color: AppTheme.of(context).primaryBackground,
                                                  ),
                                              overflow: TextOverflow.fade,
                                            ),
                                            Text(
                                              'Justo ahora',
                                              style: AppTheme.of(context).bodyText2.override(
                                                    fontFamily: AppTheme.of(context).bodyText2Family,
                                                    color: AppTheme.of(context).primaryBackground,
                                                  ),
                                              overflow: TextOverflow.fade,
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
                                  style: AppTheme.of(context).title3.override(
                                        fontFamily: AppTheme.of(context).title3Family,
                                        fontSize: 14,
                                        color: AppTheme.of(context).primaryBackground,
                                      ),
                                  overflow: TextOverflow.fade,
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
                                        const DotIndicator(
                                          size: 24,
                                          color: Colors.red,
                                        ),
                                        const SizedBox(width: 10),
                                        SizedBox(
                                          width: 180,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Tienes un error que necestia atención inmediata',
                                                style: AppTheme.of(context).title3.override(
                                                      fontFamily: AppTheme.of(context).title3Family,
                                                      color: AppTheme.of(context).primaryBackground,
                                                    ),
                                                overflow: TextOverflow.fade,
                                              ),
                                              Text(
                                                'Justo ahora',
                                                style: AppTheme.of(context).bodyText2.override(
                                                      fontFamily: AppTheme.of(context).bodyText2Family,
                                                      color: AppTheme.of(context).primaryBackground,
                                                    ),
                                                overflow: TextOverflow.fade,
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
                                    fontSize: 10,
                                    color: AppTheme.of(context).primaryBackground,
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
                                        DotIndicator(
                                          size: 24,
                                          color: Colors.red,
                                        ),
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
