import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:acp_web/helpers/supabase/queries.dart';
import 'package:acp_web/models/usuario.dart';
import 'package:acp_web/theme/theme.dart';

final GlobalKey<ScaffoldMessengerState> snackbarKey = GlobalKey<ScaffoldMessengerState>();

const storage = FlutterSecureStorage();

final supabase = Supabase.instance.client;

late final SharedPreferences prefs;

Usuario? currentUser;

Future<void> initGlobals() async {
  prefs = await SharedPreferences.getInstance();

  currentUser = await SupabaseQueries.getCurrentUserData();

  if (currentUser == null) return;
}

PlutoGridScrollbarConfig plutoGridScrollbarConfig(BuildContext context) {
  return PlutoGridScrollbarConfig(
    isAlwaysShown: true,
    scrollbarThickness: 5,
    hoverWidth: 20,
    scrollBarColor: AppTheme.of(context).primaryColor,
  );
}

PlutoGridStyleConfig plutoGridStyleConfig(BuildContext context) {
  return AppTheme.themeMode == ThemeMode.light
      ? PlutoGridStyleConfig(
          menuBackgroundColor: AppTheme.of(context).primaryBackground,
          iconColor: AppTheme.of(context).primaryColor,
          // borderColor: Colors.transparent,
          rowHeight: 60,
          rowColor: AppTheme.of(context).primaryBackground,
          columnTextStyle: AppTheme.of(context).tituloTablas,
          cellTextStyle: AppTheme.of(context).contenidoTablas,
          enableColumnBorderHorizontal: true,
          enableColumnBorderVertical: false,
          enableCellBorderVertical: false,
          enableCellBorderHorizontal: true,
          checkedColor: AppTheme.themeMode == ThemeMode.light ? const Color(0XFFC7EDDD) : const Color(0XFF4B4B4B),
          enableRowColorAnimation: true,
          // gridBackgroundColor: Colors.transparent,
          gridBorderColor: Colors.transparent,
          // gridBorderColor: const Color(0x661C1C1C),
          activatedColor: AppTheme.of(context).primaryBackground,
        )
      : PlutoGridStyleConfig.dark(
          rowHeight: 60,
          cellTextStyle: AppTheme.of(context).contenidoTablas,
          columnTextStyle: AppTheme.of(context).contenidoTablas,
          enableCellBorderVertical: false,
          borderColor: Colors.transparent,
          checkedColor: AppTheme.themeMode == ThemeMode.light ? const Color(0XFFC7EDDD) : const Color(0XFF4B4B4B),
          enableRowColorAnimation: true,
          iconColor: AppTheme.of(context).primaryColor,
          gridBackgroundColor: Colors.transparent,
          rowColor: AppTheme.of(context).primaryBackground,
          menuBackgroundColor: AppTheme.of(context).primaryBackground,
          activatedColor: AppTheme.of(context).primaryBackground,
        );
}
