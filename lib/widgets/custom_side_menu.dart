import 'package:acp_web/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_side_menu/flutter_side_menu.dart';

class CustomSideMenu extends StatefulWidget {
  const CustomSideMenu({super.key});

  @override
  State<CustomSideMenu> createState() => _CustomSideMenuState();
}

class _CustomSideMenuState extends State<CustomSideMenu> {
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
        Container(
          decoration: BoxDecoration(gradient: AppTheme.of(context).blueGradient),
          child: SideMenu(
            controller: _controller,
            backgroundColor: Colors.transparent,
            mode: SideMenuMode.auto,
            maxWidth: 210,
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
                          'Mario Alonso',
                          style: TextStyle(
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
                    isSelected: _currentIndex == 0,
                    onTap: () => setState(() => _currentIndex = 0),
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
                        (!sideMenuItemDataTileGroupsOpened['Propuesta de Pago']! && (_currentIndex == 1.1 || _currentIndex == 1.2)) || ((_currentIndex == 1.1 || _currentIndex == 1.2) && !data.isOpen),
                    onTap: () => setState(() {
                      sideMenuItemDataTileGroupsOpened.update('Propuesta de Pago', (value) => !value);
                    }),
                  ),
                  if (sideMenuItemDataTileGroupsOpened['Propuesta de Pago']! && data.isOpen)
                    SideMenuItemDataTile(
                      title: 'Selección de pagos anticipados',
                      titleStyle: const TextStyle(color: Colors.black, overflow: TextOverflow.fade),
                      selectedTitleStyle: const TextStyle(fontWeight: FontWeight.bold),
                      hoverColor: hoverColor,
                      highlightSelectedColor: highlightSelectedColor,
                      borderRadius: borderRadius,
                      margin: paddingHItemsGroup,
                      isSelected: _currentIndex == 1.1,
                      onTap: () => setState(() => _currentIndex = 1.1),
                    ),
                  if (sideMenuItemDataTileGroupsOpened['Propuesta de Pago']! && data.isOpen)
                    SideMenuItemDataTile(
                      //title: 'Autorización de solicitudes de pago anticipado',
                      title: 'Autorización de solicitudes',
                      titleStyle: const TextStyle(color: Colors.black, overflow: TextOverflow.ellipsis),
                      selectedTitleStyle: const TextStyle(fontWeight: FontWeight.bold),
                      hoverColor: hoverColor,
                      highlightSelectedColor: highlightSelectedColor,
                      borderRadius: borderRadius,
                      margin: paddingHItemsGroup,
                      isSelected: _currentIndex == 1.2,
                      onTap: () => setState(() => _currentIndex = 1.2),
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
                    isSelected: _currentIndex == 3,
                    onTap: () => setState(() => _currentIndex = 3),
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
                    isSelected: _currentIndex == 4,
                    onTap: () => setState(() => _currentIndex = 4),
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
                    isSelected: _currentIndex == 5,
                    onTap: () => setState(() => _currentIndex = 5),
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
                    isSelected: _currentIndex == 6,
                    onTap: () => setState(() => _currentIndex = 6),
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
                    isSelected: _currentIndex == 7,
                    onTap: () => setState(() => _currentIndex = 7),
                  ),
                ],
                footer: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Container(
                    width: 180,
                    height: 60,
                    color: Colors.red,
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
