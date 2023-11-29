import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:acp_web/providers/providers.dart';
import 'package:acp_web/helpers/constants.dart';
import 'package:acp_web/helpers/globals.dart';
import 'package:acp_web/router/router.dart';
import 'package:acp_web/theme/theme.dart';
import 'package:acp_web/helpers/scroll_behavior.dart';
import 'package:acp_web/internationalization/internationalization.dart';
import 'package:acp_web/providers/configuracion/calculadora_pricing_provider.dart';
import 'package:acp_web/providers/reportes/dashboards_provider.dart';
import 'package:acp_web/providers/reportes/reporte_pricing_provider.dart';
import 'package:acp_web/services/navigation_service.dart';
import 'package:acp_web/pages/widgets/inactivity_popup.dart';

import 'providers/cuentas_por_cobrar/aprobacion_seguimiento_pagos_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setPathUrlStrategy();

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: anonKey,
  );

  await initGlobals();

  GoRouter.optionURLReflectsImperativeAPIs = true;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserState(),
        ),
        ChangeNotifierProvider(
          create: (_) => ClientesProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => UsuariosProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => VisualStateProvider(context),
        ),
        ChangeNotifierProvider(
          create: (context) => AprobacionSeguimientoPagosProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => SolicitudPagosProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => SeleccionaPagosanticipadosProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AutorizacionSolicitudesPagoAnticipadoProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => PagosProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => DashboardsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ReportePricingProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CalculadoraPricingProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) => context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('es');
  ThemeMode _themeMode = AppTheme.themeMode;

  void setLocale(Locale value) => setState(() => _locale = value);
  void setThemeMode(ThemeMode mode) => setState(() {
        _themeMode = mode;
        AppTheme.saveThemeMode(mode);
      });

  late RestartableTimer timer;

  @override
  void initState() {
    timer = RestartableTimer(
      const Duration(minutes: 3),
      () {
        if (currentUser != null && ModalRoute.of(context)?.isCurrent != true) {
          showDialog(
            context: NavigationService.navigatorKey.currentState!.context,
            builder: (context) {
              return const InactivityPopup();
            },
          );
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Portal(
      child: Listener(
        onPointerDown: (event) => timer.reset(),
        onPointerMove: (event) => timer.reset(),
        child: MaterialApp.router(
          title: 'ACP',
          debugShowCheckedModeBanner: false,
          locale: _locale,
          localizationsDelegates: const [
            AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en', 'US')],
          theme: ThemeData(
            brightness: Brightness.light,
            dividerColor: Colors.grey,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            dividerColor: Colors.grey,
          ),
          themeMode: _themeMode,
          routerConfig: router,
          scrollBehavior: MyCustomScrollBehavior(),
        ),
      ),
    );
  }
}
