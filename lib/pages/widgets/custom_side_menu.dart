import 'package:acp_web/helpers/globals.dart';
import 'package:acp_web/providers/visual_state/visual_state_provider.dart';
import 'package:acp_web/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_side_menu/flutter_side_menu.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CustomSideMenu extends StatefulWidget {
  const CustomSideMenu({
    super.key,
  });

  @override
  State<CustomSideMenu> createState() => _CustomSideMenuState();
}

class _CustomSideMenuState extends State<CustomSideMenu> {
  EdgeInsetsDirectional paddingHItems = const EdgeInsetsDirectional.only(start: 15, end: 15);
  EdgeInsetsDirectional paddingHItemsGroup = const EdgeInsetsDirectional.only(start: 30, end: 15);

  TextStyle dataTileTextStyle = const TextStyle(
    fontSize: 13,
    color: Colors.white,
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

  @override
  Widget build(BuildContext context) {
    final VisualStateProvider visualState = Provider.of<VisualStateProvider>(context);

    return Row(
      children: [
        Container(
          decoration: const BoxDecoration(//gradient: AppTheme.of(context).blueGradient),
          color: Color.fromRGBO(10, 8, 89, 1)),
          child: SideMenu(
            controller: visualState.sideMenuController,
            hasResizer: false,
            hasResizerToggle: false,
            backgroundColor: Colors.transparent,
            mode: SideMenuMode.auto,
            maxWidth: 250,
            minWidth: 100,
            builder: (data) {
              return SideMenuData(
                header: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: data.isOpen ? MainAxisAlignment.start : MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        color: Colors.red,
                      ),
                      if (data.isOpen) const SizedBox(width: 5),
                      if (data.isOpen)
                        Text(
                          currentUser!.nombreCompleto,
                          style: TextStyle(
                            overflow: TextOverflow.fade,
                            fontSize: 14,
                            color: AppTheme.of(context).primaryBackground,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ),
                items: [
                  SideMenuItemDataTitle(
                    title: 'Tesorero',
                    textAlign: data.isOpen ? TextAlign.start : TextAlign.center,
                    titleStyle: TextStyle(
                      fontSize: data.isOpen ? 14 : 10,
                      color: AppTheme.of(context).primaryBackground,
                      fontWeight: FontWeight.w300,
                    ),
                    padding: paddingHItems,
                  ),
                  SideMenuItemDataTile(
                    title: 'Home',
                    titleStyle: dataTileTextStyle,
                    selectedTitleStyle: const TextStyle(fontWeight: FontWeight.bold),
                    icon: Icon(
                      Icons.home_outlined,
                      size: iconSize,
                    ),
                    hoverColor: hoverColor,
                    highlightSelectedColor: highlightSelectedColor,
                    borderRadius: borderRadius,
                    margin: paddingHItems,
                    isSelected: visualState.isTaped[0],
                    onTap: () {
                      setState(() {
                        visualState.setTapedOption(0);
                      });
                      context.pushReplacement('/home');
                    },
                  ),
                  SideMenuItemDataTile(
                    title: 'Cuentas Por Cobrar',
                    titleStyle: dataTileTextStyle,
                    selectedTitleStyle: const TextStyle(fontWeight: FontWeight.bold),
                    icon: Icon(
                      Icons.credit_card,
                      size: iconSize,
                    ),
                    hoverColor: hoverColor,
                    highlightSelectedColor: highlightSelectedColor,
                    borderRadius: borderRadius,
                    margin: paddingHItems,
                    isSelected: visualState.isTaped[8],
                    onTap: () {
                      setState(() {
                        visualState.setTapedOption(8);
                      });
                      context.pushReplacement('/cuentas_por_cobrar');
                    },
                  ),
                  SideMenuItemDataTile(
                    title: 'Propuesta de pago',
                    titleStyle: dataTileTextStyle,
                    selectedTitleStyle: const TextStyle(fontWeight: FontWeight.bold),
                    icon: Icon(
                      Icons.file_copy_outlined,
                      size: iconSize,
                    ),
                    hoverColor: Colors.transparent,
                    highlightSelectedColor: highlightSelectedColor,
                    margin: paddingHItems,
                    isSelected:
                        (!visualState.isGroupTaped['Propuesta de Pago']! && (visualState.isTaped[1] || visualState.isTaped[2])) || ((visualState.isTaped[1] || visualState.isTaped[2]) && !data.isOpen),
                    onTap: () => setState(() {
                      visualState.isGroupTaped.update('Propuesta de Pago', (value) => !value);
                    }),
                  ),
                  if (visualState.isGroupTaped['Propuesta de Pago']! && data.isOpen)
                    SideMenuItemDataTile(
                      title: 'Selección de pagos anticipados',
                      titleStyle: const TextStyle(color: Colors.white, overflow: TextOverflow.fade),
                      selectedTitleStyle: const TextStyle(fontWeight: FontWeight.bold),
                      hoverColor: hoverColor,
                      highlightSelectedColor: highlightSelectedColor,
                      borderRadius: borderRadius,
                      margin: paddingHItemsGroup,
                      isSelected: visualState.isTaped[1],
                      onTap: () {
                        setState(() {
                          visualState.setTapedOption(1);
                        });
                        context.pushReplacement('/seleccion_pagos_anticipados');
                      },
                    ),
                  if (visualState.isGroupTaped['Propuesta de Pago']! && data.isOpen)
                    SideMenuItemDataTile(
                      //title: 'Autorización de solicitudes de pago anticipado',
                      title: 'Autorización de solicitudes',
                      titleStyle: const TextStyle(color: Colors.white, overflow: TextOverflow.ellipsis),
                      selectedTitleStyle: const TextStyle(fontWeight: FontWeight.bold),
                      hoverColor: hoverColor,
                      highlightSelectedColor: highlightSelectedColor,
                      borderRadius: borderRadius,
                      margin: paddingHItemsGroup,
                      isSelected: visualState.isTaped[2],
                      onTap: () {
                        setState(() {
                          visualState.setTapedOption(1);
                        });
                        context.pushReplacement('/autorizacion_solicitudes');
                      },
                    ),
                  SideMenuItemDataTile(
                    title: 'Pagos',
                    titleStyle: dataTileTextStyle,
                    selectedTitleStyle: const TextStyle(fontWeight: FontWeight.bold),
                    icon: Icon(
                      Icons.attach_money_rounded,
                      size: iconSize,
                    ),
                    hoverColor: hoverColor,
                    highlightSelectedColor: highlightSelectedColor,
                    borderRadius: borderRadius,
                    margin: paddingHItems,
                    isSelected: visualState.isTaped[3],
                    onTap: () => setState(() => visualState.setTapedOption(3)),
                  ),
                  SideMenuItemDataTile(
                    title: 'Usuarios',
                    titleStyle: dataTileTextStyle,
                    selectedTitleStyle: const TextStyle(fontWeight: FontWeight.bold),
                    icon: Icon(
                      Icons.person_outline,
                      size: iconSize,
                    ),
                    hoverColor: hoverColor,
                    highlightSelectedColor: highlightSelectedColor,
                    borderRadius: borderRadius,
                    margin: paddingHItems,
                    isSelected: visualState.isTaped[4],
                    onTap: () {
                      setState(() {
                        visualState.setTapedOption(4);
                      });
                      context.pushReplacement('/usuarios');
                    },
                  ),
                  SideMenuItemDataTile(
                    title: 'Clientes',
                    titleStyle: dataTileTextStyle,
                    selectedTitleStyle: const TextStyle(fontWeight: FontWeight.bold),
                    icon: Icon(
                      Icons.group_outlined,
                      size: iconSize,
                    ),
                    hoverColor: hoverColor,
                    highlightSelectedColor: highlightSelectedColor,
                    borderRadius: borderRadius,
                    margin: paddingHItems,
                    isSelected: visualState.isTaped[5],
                    onTap: () => setState(() => visualState.setTapedOption(5)),
                  ),
                  SideMenuItemDataTile(
                    title: 'Dashboard',
                    titleStyle: dataTileTextStyle,
                    selectedTitleStyle: const TextStyle(fontWeight: FontWeight.bold),
                    icon: Icon(
                      Icons.pie_chart_outline,
                      size: iconSize,
                    ),
                    hoverColor: hoverColor,
                    highlightSelectedColor: highlightSelectedColor,
                    borderRadius: borderRadius,
                    margin: paddingHItems,
                    isSelected: visualState.isTaped[6],
                    onTap: () => setState(() => visualState.setTapedOption(6)),
                  ),
                  SideMenuItemDataTile(
                    title: 'Ajustes',
                    titleStyle: dataTileTextStyle,
                    selectedTitleStyle: const TextStyle(fontWeight: FontWeight.bold),
                    icon: Icon(
                      Icons.settings_outlined,
                      size: iconSize,
                    ),
                    hoverColor: hoverColor,
                    highlightSelectedColor: highlightSelectedColor,
                    borderRadius: borderRadius,
                    margin: paddingHItems,
                    isSelected: visualState.isTaped[7],
                    onTap: () => setState(() => visualState.setTapedOption(7)),
                  ),
                ],
                footer: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Image.asset(
                    'assets/images/Logo.png',
                    width: 180,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(
          width: 15,
        )
      ],
    );
  }
}
