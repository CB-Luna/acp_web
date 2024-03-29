import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:acp_web/helpers/globals.dart';
import 'package:acp_web/models/models.dart';
import 'package:acp_web/functions/tokens.dart';
import 'package:acp_web/pages/pages.dart';
import 'package:acp_web/services/navigation_service.dart';

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
        if (currentUser!.esCliente) {
          return const SolicitudPagosPage();
        } else if (currentUser!.esAnalista || currentUser!.esTesorero) {
          return const PagosPage();
        } else if (currentUser!.esRegistroCentralizado) {
          return const UsuariosPage();
        }
        if (currentUser!.rol.permisos.seleccionPagosAnticipados == null) {
          return const PageNotFoundPage();
        }
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
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (BuildContext context, GoRouterState state) {
        if (currentUser == null) {
          return const PageNotFoundPage();
        }
        return const HomePage();
      },
    ),
    GoRoute(
      path: '/cambio-contrasena',
      name: 'cambio_contrasena',
      builder: (BuildContext context, GoRouterState state) {
        if (currentUser != null) return const CambioContrasenaPage();
        final String? tokenString = state.uri.queryParameters['token'];
        if (tokenString == null) return const LoginPage();
        final token = parseToken(tokenString);
        if (token == null) return const LoginPage();
        return CambioContrasenaPage(token: token);
      },
    ),
    GoRoute(
      path: '/clientes',
      name: 'clientes',
      builder: (BuildContext context, GoRouterState state) {
        if (currentUser!.rol.permisos.listaClientes == null) {
          return const PageNotFoundPage();
        }
        return const ClientesPage();
      },
      routes: [
        GoRoute(
          path: 'registro-cliente',
          name: 'registro_cliente',
          builder: (BuildContext context, GoRouterState state) {
            if (currentUser == null) return const PageNotFoundPage();
            if (currentUser!.rol.permisos.registroClientes == null) return const PageNotFoundPage();
            if (state.extra == null) return const ClientesPage();
            return const RegistroClientePage();
          },
        ),
        GoRoute(
          path: 'editar-cliente',
          name: 'editar_cliente',
          builder: (BuildContext context, GoRouterState state) {
            if (currentUser == null) return const PageNotFoundPage();
            if (currentUser!.rol.permisos.registroClientes == null) return const PageNotFoundPage();
            if (state.extra == null) return const ClientesPage();
            return const RegistroClientePage();
          },
        ),
      ],
    ),
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
        //Usuarios
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
            if (currentUser == null) return const PageNotFoundPage();
            if (currentUser!.rol.permisos.registroUsuario == null) return const SeleccionPagosAnticipadosPage();
            if (state.extra == null) return const UsuariosPage();
            return RegistroUsuariosPage(usuario: state.extra as Usuario);
          },
        ),
      ],
    ),

    //Propuesta de Pago
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
      path: '/autorizacion_solicitudes',
      name: 'Autorización de Solicitudes',
      builder: (BuildContext context, GoRouterState state) {
        /* if (currentUser!.rol.permisos.pagos == null) {
          return const PageNotFoundPage();
        } */
        return const AutorizacionSolicitudesPagoAnticipadoPage();
      },
    ),

    //Pagos
    GoRoute(
      path: '/pagos',
      name: 'Pagos',
      builder: (BuildContext context, GoRouterState state) {
        /* if (currentUser!.rol.permisos.pagos == null) {
          return const PageNotFoundPage();
        } */
        return const PagosPage();
      },
    ),

    //Cuentas por cobrar
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
    GoRoute(
      path: '/dashboards',
      name: 'Dashboards',
      builder: (BuildContext context, GoRouterState state) {
        /* if (currentUser!.rol.permisos.pagos == null) {
          return const PageNotFoundPage();
        } */
        return const DashboardsPage();
      },
    ),
    GoRoute(
      path: '/reporte_pricing',
      name: 'Reporte pricing',
      builder: (BuildContext context, GoRouterState state) {
        /* if (currentUser!.rol.permisos.pagos == null) {
          return const PageNotFoundPage();
        } */
        return const ReportePricingPage();
      },
    ),
    GoRoute(
      path: '/calculadora_pricing',
      name: 'Calculadora pricing',
      builder: (BuildContext context, GoRouterState state) {
        /* if (currentUser!.rol.permisos.pagos == null) {
          return const PageNotFoundPage();
        } */
        return const CalculadoraPricingPage();
      },
    ),
  ],
);
