import 'package:acp_web/helpers/globals.dart';
import 'package:acp_web/main.dart';
import 'package:acp_web/models/configuration.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const kThemeModeKey = '__theme_mode__';

void setDarkModeSetting(BuildContext context, ThemeMode themeMode) => MyApp.of(context).setThemeMode(themeMode);

abstract class AppTheme {
  static ThemeMode get themeMode {
    final darkMode = prefs.getBool(kThemeModeKey);
    return darkMode == null
        ? ThemeMode.light
        : darkMode
            ? ThemeMode.dark
            : ThemeMode.light;
  }

  static LightModeTheme lightTheme = LightModeTheme();
  static DarkModeTheme darkTheme = DarkModeTheme();

  static void initConfiguration(Configuration? conf) {
    lightTheme = LightModeTheme(mode: conf?.light);
    darkTheme = DarkModeTheme(mode: conf?.dark);
  }

  static void saveThemeMode(ThemeMode mode) => mode == ThemeMode.system ? prefs.remove(kThemeModeKey) : prefs.setBool(kThemeModeKey, mode == ThemeMode.dark);

  static AppTheme of(BuildContext context) => Theme.of(context).brightness == Brightness.dark ? darkTheme : lightTheme;

  abstract Color primaryColor;
  abstract Color secondaryColor;
  abstract Color tertiaryColor;
  abstract Color alternate;
  abstract Color primaryBackground;
  abstract Color secondaryBackground;
  abstract Color tertiaryBackground;
  abstract Color purpleBackground;
  abstract Color blueBackground;
  abstract Color primaryText;
  abstract Color secondaryText;
  abstract Color tertiaryText;
  abstract Color gray;
  abstract Color green;
  abstract Color green2;
  abstract Color yellow;
  abstract Color red;
  abstract Color purple;
  Gradient blueGradient = const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment(4, 0.8),
    colors: <Color>[
      Color(0xFF0090FF),
      Color(0xFF0363C8),
      Color(0xFF063E9B),
      Color(0xFF0A0859),
    ],
  );

  String get title1Family => typography.title1Family;
  TextStyle get title1 => typography.title1;
  String get title2Family => typography.title2Family;
  TextStyle get title2 => typography.title2;
  String get title3Family => typography.title3Family;
  TextStyle get title3 => typography.title3;
  String get subtitle1Family => typography.subtitle1Family;
  TextStyle get subtitle1 => typography.subtitle1;
  String get subtitle2Family => typography.subtitle2Family;
  TextStyle get subtitle2 => typography.subtitle2;
  String get bodyText1Family => typography.bodyText1Family;
  TextStyle get bodyText1 => typography.bodyText1;
  String get bodyText2Family => typography.bodyText2Family;
  TextStyle get bodyText2 => typography.bodyText2;

  Typography get typography => ThemeTypography(this);
}

class LightModeTheme extends AppTheme {
  @override
  Color primaryColor = const Color(0XFF0A0859);
  @override
  Color secondaryColor = const Color(0XFF0090FF);
  @override
  Color tertiaryColor = const Color(0XFF0070C0);
  @override
  Color alternate = const Color(0XFFB3DEFF);
  @override
  Color primaryBackground = const Color(0xFFFFFFFF);
  @override
  Color secondaryBackground = const Color(0XFFD7E9FB);
  @override
  Color tertiaryBackground = const Color(0XFFF7F9FB);
  @override
  Color purpleBackground = const Color(0XFFE5ECF6);
  @override
  Color blueBackground = const Color(0XFFE3F5FF);
  @override
  Color primaryText = const Color(0xFF060606);
  @override
  Color secondaryText = const Color(0XFF828282);
  @override
  Color tertiaryText = const Color(0XFFFDFDFD);
  @override
  Color gray = const Color(0XFFE5E5E5);
  @override
  Color green = const Color(0XFF00C950);
  @override
  Color green2 = const Color(0XFFBAEDBD);
  @override
  Color yellow = const Color(0XFFFFC000);
  @override
  Color red = const Color(0XFFFF0000);
  @override
  Color purple = const Color(0XFF773AA5);

  LightModeTheme({Mode? mode}) {
    if (mode != null) {
      primaryColor = Color(mode.primaryColor);
      secondaryColor = Color(mode.secondaryColor);
      tertiaryColor = Color(mode.tertiaryColor);
      primaryText = Color(mode.primaryText);
      primaryBackground = Color(mode.primaryBackground);
    }
  }
}

class DarkModeTheme extends AppTheme {
  @override
  Color primaryColor = const Color(0XFF0A0859);
  @override
  Color secondaryColor = const Color(0XFF0090FF);
  @override
  Color tertiaryColor = const Color(0XFF0070C0);
  @override
  Color alternate = const Color(0XFFB3DEFF);
  @override
  Color primaryBackground = const Color(0xFFFFFFFF);
  @override
  Color secondaryBackground = const Color(0XFFD7E9FB);
  @override
  Color tertiaryBackground = const Color(0XFFF7F9FB);
  @override
  Color purpleBackground = const Color(0XFFE5ECF6);
  @override
  Color blueBackground = const Color(0XFFE3F5FF);
  @override
  Color primaryText = const Color(0xFF060606);
  @override
  Color secondaryText = const Color(0XFF828282);
  @override
  Color tertiaryText = const Color(0XFFFDFDFD);
  @override
  Color gray = const Color(0XFFE5E5E5);
  @override
  Color green = const Color(0XFF00C950);
  @override
  Color green2 = const Color(0XFFBAEDBD);
  @override
  Color yellow = const Color(0XFFFFC000);
  @override
  Color red = const Color(0XFFFF0000);
  @override
  Color purple = const Color(0XFF773AA5);

  DarkModeTheme({Mode? mode}) {
    if (mode != null) {
      primaryColor = Color(mode.primaryColor);
      secondaryColor = Color(mode.secondaryColor);
      tertiaryColor = Color(mode.tertiaryColor);
      primaryText = Color(mode.primaryText);
      primaryBackground = Color(mode.primaryBackground);
    }
  }
}

extension TextStyleHelper on TextStyle {
  TextStyle override({
    required String fontFamily,
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? letterSpacing,
    bool useGoogleFonts = true,
    TextDecoration? decoration,
    double? lineHeight,
  }) =>
      useGoogleFonts
          ? GoogleFonts.getFont(
              fontFamily,
              color: color ?? this.color,
              fontSize: fontSize ?? this.fontSize,
              fontWeight: fontWeight ?? this.fontWeight,
              fontStyle: fontStyle ?? this.fontStyle,
              letterSpacing: letterSpacing ?? this.letterSpacing,
              decoration: decoration,
              height: lineHeight,
            )
          : copyWith(
              fontFamily: fontFamily,
              color: color,
              fontSize: fontSize,
              fontWeight: fontWeight,
              letterSpacing: letterSpacing,
              fontStyle: fontStyle,
              decoration: decoration,
              height: lineHeight,
            );
}

abstract class Typography {
  String get title1Family;
  TextStyle get title1;
  String get title2Family;
  TextStyle get title2;
  String get title3Family;
  TextStyle get title3;
  String get subtitle1Family;
  TextStyle get subtitle1;
  String get subtitle2Family;
  TextStyle get subtitle2;
  String get bodyText1Family;
  TextStyle get bodyText1;
  String get bodyText2Family;
  TextStyle get bodyText2;
}

class ThemeTypography extends Typography {
  ThemeTypography(this.theme);

  final AppTheme theme;

  @override
  String get title1Family => 'Gotham';
  @override
  TextStyle get title1 => TextStyle(
        fontSize: 30,
        fontFamily: 'Gotham-Bold',
        color: theme.primaryText,
      );
  @override
  String get title2Family => 'Gotham';
  @override
  TextStyle get title2 => TextStyle(
        fontSize: 18,
        fontFamily: 'Gotham-Bold',
        color: theme.primaryText,
      );
  @override
  String get title3Family => 'Gotham';
  @override
  TextStyle get title3 => TextStyle(
        fontSize: 14,
        fontFamily: 'Gotham-Bold',
        color: theme.primaryText,
      );

  @override
  String get subtitle1Family => 'Gotham';
  @override
  TextStyle get subtitle1 => TextStyle(
        fontSize: 12,
        fontFamily: 'Gotham-Bold',
        color: theme.primaryText,
      );
  @override
  String get subtitle2Family => 'Gotham';
  @override
  TextStyle get subtitle2 => TextStyle(
        fontSize: 20,
        fontFamily: 'Gotham-Book',
        color: theme.primaryText,
      );

  @override
  String get bodyText1Family => 'Gotham';
  @override
  TextStyle get bodyText1 => TextStyle(
        fontSize: 14,
        fontFamily: 'Gotham-Book',
        color: theme.primaryText,
      );
  @override
  String get bodyText2Family => 'Gotham';
  @override
  TextStyle get bodyText2 => TextStyle(
        fontSize: 12,
        fontFamily: 'Gotham-Book',
        color: theme.primaryText,
      );
}
