import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:acp_web/helpers/supabase/queries.dart';
import 'package:acp_web/theme/theme.dart';
import 'package:acp_web/models/models.dart';

final GlobalKey<ScaffoldMessengerState> snackbarKey = GlobalKey<ScaffoldMessengerState>();

const storage = FlutterSecureStorage();

final supabase = Supabase.instance.client;

late final SharedPreferences prefs;

Usuario? currentUser;

List<String>? listaSociedades;

Future<void> initGlobals() async {
  prefs = await SharedPreferences.getInstance();

  currentUser = await SupabaseQueries.getCurrentUserData();

  await SupabaseQueries.getSociedades();

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
          menuBackgroundColor: AppTheme.of(context).secondaryColor,
          gridPopupBorderRadius: BorderRadius.circular(16),
          //
          enableColumnBorderVertical: false,
          columnTextStyle: AppTheme.of(context).bodyText2,
          iconColor: AppTheme.of(context).tertiaryColor,
          borderColor: Colors.transparent,
          //
          rowHeight: 60,
          rowColor: Colors.transparent,
          cellTextStyle: AppTheme.of(context).bodyText2,
          enableColumnBorderHorizontal: true,
          enableCellBorderVertical: false,
          enableCellBorderHorizontal: false,
          checkedColor: AppTheme.themeMode == ThemeMode.light ? AppTheme.of(context).secondaryColor : const Color(0XFF4B4B4B),
          enableRowColorAnimation: true,
          gridBackgroundColor: Colors.transparent,
          gridBorderColor: const Color(0x661C1C1C),
          gridBorderRadius: BorderRadius.circular(16),
          activatedColor: AppTheme.of(context).primaryBackground,
          activatedBorderColor: AppTheme.of(context).tertiaryColor,
        )
      : PlutoGridStyleConfig.dark(
          menuBackgroundColor: AppTheme.of(context).secondaryColor,
          gridPopupBorderRadius: BorderRadius.circular(16),
          //
          enableColumnBorderVertical: false,
          columnTextStyle: AppTheme.of(context).bodyText2,
          iconColor: AppTheme.of(context).tertiaryColor,
          borderColor: Colors.transparent,
          //
          rowHeight: 60,
          rowColor: Colors.transparent,
          cellTextStyle: AppTheme.of(context).bodyText2,
          enableColumnBorderHorizontal: true,
          enableCellBorderVertical: false,
          enableCellBorderHorizontal: false,
          checkedColor: AppTheme.themeMode == ThemeMode.light ? AppTheme.of(context).secondaryColor : const Color(0XFF4B4B4B),
          enableRowColorAnimation: true,
          gridBackgroundColor: Colors.transparent,
          gridBorderColor: Colors.transparent,
          gridBorderRadius: BorderRadius.circular(16),
          //
          activatedColor: AppTheme.of(context).primaryBackground,
          activatedBorderColor: AppTheme.of(context).tertiaryColor,
        );
}

PlutoGridStyleConfig plutoGridPopUpStyleConfig(BuildContext context) {
  return AppTheme.themeMode == ThemeMode.light
      ? PlutoGridStyleConfig(
          menuBackgroundColor: AppTheme.of(context).secondaryBackground,
          gridPopupBorderRadius: BorderRadius.circular(16),
          //
          enableColumnBorderVertical: false,
          columnTextStyle: AppTheme.of(context).bodyText2,
          iconColor: AppTheme.of(context).tertiaryColor,
          borderColor: Colors.transparent,
          //
          rowHeight: 60,
          rowColor: Colors.transparent,
          cellTextStyle: AppTheme.of(context).bodyText2,
          enableColumnBorderHorizontal: false,
          enableCellBorderVertical: false,
          enableCellBorderHorizontal: false,
          checkedColor: Colors.transparent,
          enableRowColorAnimation: false,
          gridBackgroundColor: Colors.transparent,
          gridBorderColor: AppTheme.of(context).secondaryText,
          gridBorderRadius: BorderRadius.circular(16),
          //
          activatedColor: AppTheme.of(context).primaryBackground,
          activatedBorderColor: AppTheme.of(context).tertiaryColor,
        )
      : PlutoGridStyleConfig.dark(
          menuBackgroundColor: AppTheme.of(context).secondaryBackground,
          gridPopupBorderRadius: BorderRadius.circular(16),
          //
          enableColumnBorderVertical: false,
          columnTextStyle: AppTheme.of(context).bodyText2,
          iconColor: AppTheme.of(context).tertiaryColor,
          borderColor: Colors.transparent,
          //
          rowHeight: 60,
          rowColor: Colors.transparent,
          cellTextStyle: AppTheme.of(context).bodyText2,
          enableColumnBorderHorizontal: false,
          enableCellBorderVertical: false,
          enableCellBorderHorizontal: false,
          checkedColor: Colors.transparent,
          enableRowColorAnimation: false,
          gridBackgroundColor: Colors.transparent,
          gridBorderColor: AppTheme.of(context).secondaryText,
          gridBorderRadius: BorderRadius.circular(16),
          //
          activatedColor: AppTheme.of(context).primaryBackground,
          activatedBorderColor: AppTheme.of(context).tertiaryColor,
        );
}
