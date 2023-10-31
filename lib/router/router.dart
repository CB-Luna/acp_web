import 'package:acp_web/helpers/globals.dart';
import 'package:acp_web/pages/pages.dart';
import 'package:acp_web/pages/registro_usuario_page/registro_usuario_page.dart';
import 'package:acp_web/services/navigation_service.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// The route configuration.
final GoRouter router = GoRouter(
  debugLogDiagnostics: true,
  navigatorKey: NavigationService.navigatorKey,
  initialLocation: '/',
  redirect: (BuildContext context, GoRouterState state) {
    final bool loggedIn = currentUser != null;
    final bool isLoggingIn = state.matchedLocation.contains('/login');

    if (state.matchedLocation.contains('AD')) return null;

    if (state.matchedLocation.contains('/cambio-contrasena')) return null;

    // If user is not logged in and not in the login page
    if (!loggedIn && !isLoggingIn) return '/login';

    //if user is logged in and in the login page
    if (loggedIn && isLoggingIn) return '/';

    return null;
  },
  errorBuilder: (context, state) => const PageNotFoundPage(),
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      name: 'root',
      builder: (BuildContext context, GoRouterState state) {
        return const SeleccionPagosAnticipadosPage();
      },
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (BuildContext context, GoRouterState state) {
        // final String? token = state.queryParams['token'];
        // if (token != null) {
        //   final tokenMap = parseToken(token);
        //   return LoginPage(token: tokenMap);
        // }
        return const LoginPage();
      },
    ),
    // GoRoute(
    //   path: '/AD',
    //   name: 'auth',
    //   builder: (BuildContext context, GoRouterState state) {
    //     final params = state.queryParametersAll;
    //     return Scaffold(
    //       body: Center(
    //         child: Text('Params: $params'),
    //       ),
    //     );
    //   },
    // ),

    // GoRoute(
    //   path: '/cambio-contrasena',
    //   name: 'cambio_contrasena',
    //   builder: (BuildContext context, GoRouterState state) {
    //     if (currentUser != null) return const CambioContrasenaPage();
    //     final String? token = state.queryParams['token'];
    //     if (token == null) return const LoginPage();
    //     final tokenMap = parseToken(token);
    //     if (tokenMap == null) return const LoginPage();
    //     return CambioContrasenaPage(token: tokenMap);
    //   },
    // ),
    GoRoute(
      path: '/usuarios',
      name: 'usuarios',
      builder: (BuildContext context, GoRouterState state) {
        if (currentUser!.rol.permisos.listaUsuarios == null) {
          return const PageNotFoundPage();
        }
        return const UsuariosPage();
      },
      routes: [
        GoRoute(
          path: 'registro-usuario',
          name: 'registro_usuario',
          builder: (BuildContext context, GoRouterState state) {
            if (currentUser!.rol.permisos.registroUsuario == null) {
              return const PageNotFoundPage();
            }
            return const RegistroUsuariosPage();
          },
        ),
        GoRoute(
          path: 'editar-usuario',
          name: 'editar_usuario',
          builder: (BuildContext context, GoRouterState state) {
            if (currentUser!.rol.permisos.registroUsuario == null) {
              return const PageNotFoundPage();
            }
            if (state.extra == null) return const UsuariosPage();
            return const PageNotFoundPage();
            // return EditarUsuarioPage(usuario: state.extra as Usuario);
          },
        ),
      ],
    ),

    GoRoute(
      path: '/seleccion_pagos_anticipados',
      name: 'Selección Pagos Anticipados',
      builder: (BuildContext context, GoRouterState state) {
        /* if (currentUser!.rol.permisos.pagos == null) {
          return const PageNotFoundPage();
        } */
        return const SeleccionPagosAnticipadosPage();
      },
    ),

    GoRoute(
      path: '/aprobacion_seguimiento_pagos',
      name: 'Aprobación y Seguimiento de Pagos',
      builder: (BuildContext context, GoRouterState state) {
        /* if (currentUser!.rol.permisos.pagos == null) {
          return const PageNotFoundPage();
        } */
        return const AprobacionSeguimientoPagosPage();
      },
    ),
    GoRoute(
      path: '/solicitud_pagos',
      name: 'Solicitud de Pagos',
      builder: (BuildContext context, GoRouterState state) {
        /* if (currentUser!.rol.permisos.pagos == null) {
          return const PageNotFoundPage();
        } */
        return const SolicitudPagosPage();
      },
    ),

    // GoRoute(
    //   path: '/pagos',
    //   name: 'pagos',
    //   builder: (BuildContext context, GoRouterState state) {
    //     if (currentUser!.rol.permisos.pagos == null) {
    //       return const PageNotFoundPage();
    //     }
    //     return const Pagos();
    //   },
    // ),
    // GoRoute(
    //   path: '/solicitudes-dpp',
    //   name: 'solicitudes_dpp',
    //   builder: (BuildContext context, GoRouterState state) {
    //     if (currentUser!.rol.permisos.solicitudDppProveedor == null) {
    //       const PageNotFoundPage();
    //     }
    //     return const SolicitudesDpp();
    //   },
    // ),
    // GoRoute(
    //   path: '/solicitud-dpp',
    //   name: 'solicitud_dpp',
    //   builder: (BuildContext context, GoRouterState state) {
    //     if (currentUser!.rol.permisos.solicitudDppCBC == null) {
    //       const PageNotFoundPage();
    //     }
    //     return const SolicitudDPP();
    //   },
    // ),
    // GoRoute(
    //   path: '/tablero',
    //   name: 'tablero',
    //   builder: (BuildContext context, GoRouterState state) {
    //     if (currentUser!.rol.permisos.reportes == null) {
    //       return const PageNotFoundPage();
    //     }
    //     return const Tablero();
    //   },
    // ),
    // GoRoute(
    //   path: '/dashboard-inicio',
    //   name: 'dashboard_inicio',
    //   builder: (BuildContext context, GoRouterState state) {
    //     if (currentUser!.rol.permisos.reportes == null) {
    //       return const PageNotFoundPage();
    //     }
    //     return const DashboardInicio();
    //   },
    // ),
    // GoRoute(
    //   path: '/reporte-seguimiento-tablero',
    //   name: 'reporte_seguimiento_tablero',
    //   builder: (BuildContext context, GoRouterState state) {
    //     if (currentUser!.rol.permisos.reportes == null) {
    //       return const PageNotFoundPage();
    //     }
    //     return const ReporteSeguimientoFacturasTablero();
    //   },
    // ),
    // GoRoute(
    //   path: '/monitoreo',
    //   name: 'monitoreo',
    //   builder: (BuildContext context, GoRouterState state) {
    //     if (currentUser!.rol.permisos.reportes == null) {
    //       return const PageNotFoundPage();
    //     }
    //     return const Monitoreo();
    //   },
    // ),
    // GoRoute(
    //   path: '/monitoreo-usuarios',
    //   name: 'monitoreo_usuarios',
    //   builder: (BuildContext context, GoRouterState state) {
    //     if (currentUser!.rol.permisos.reportes == null) {
    //       return const PageNotFoundPage();
    //     }
    //     return const MonitoreoUsuariosPage();
    //   },
    // ),
    // GoRoute(
    //   path: '/consulta',
    //   name: 'consulta',
    //   builder: (BuildContext context, GoRouterState state) {
    //     if (currentUser!.esOnboarding ||
    //         currentUser!.esAdmin ||
    //         currentUser!.esFinanzas) {
    //       return const OnboardingCosulta();
    //     }
    //     return const PageNotFoundPage();
    //   },
    // ),
    // GoRoute(
    //   path: '/configuracion',
    //   name: 'configuracion',
    //   builder: (BuildContext context, GoRouterState state) {
    //     return const ConfiguracionPage();
    //   },
    // ),
  ],
);
