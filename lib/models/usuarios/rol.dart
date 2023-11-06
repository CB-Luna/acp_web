import 'dart:convert';

class Rol {
  Rol({
    required this.nombre,
    required this.rolId,
    required this.permisos,
  });

  String nombre;
  int rolId;
  Permisos permisos;

  factory Rol.fromJson(String str) => Rol.fromMap(json.decode(str));

  factory Rol.fromMap(Map<String, dynamic> json) => Rol(
        nombre: json["nombre"],
        rolId: json["rol_id"],
        permisos: Permisos.fromMap(json["permisos"]),
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Rol && other.nombre == nombre && other.rolId == rolId;
  }

  @override
  int get hashCode => Object.hash(nombre, rolId, permisos);
}

class Permisos {
  Permisos({
    required this.home,
    required this.seleccionPagosAnticipados,
    required this.autorizacionSolicitudesPagoAnticipado,
    required this.pagos,
    required this.registroUsuario,
    required this.listaUsuarios,
    required this.registroClientes,
    required this.listaClientes,
    required this.dashboards,
    required this.solicitudPago,
    required this.aprobacionPago,
  });

  String? home;
  String? seleccionPagosAnticipados;
  String? autorizacionSolicitudesPagoAnticipado;
  String? pagos;
  String? registroUsuario;
  String? listaUsuarios;
  String? registroClientes;
  String? listaClientes;
  String? dashboards;
  String? solicitudPago;
  String? aprobacionPago;

  factory Permisos.fromJson(String str) => Permisos.fromMap(json.decode(str));

  factory Permisos.fromMap(Map<String, dynamic> json) => Permisos(
        home: json['Home'],
        seleccionPagosAnticipados: json['Selección de pagos anticipados'],
        autorizacionSolicitudesPagoAnticipado: json['Autorización de solicitudes de pago anticipado'],
        pagos: json['Pagos'],
        registroUsuario: json['Registro de Usuario'],
        listaUsuarios: json['Lista de Usuarios'],
        registroClientes: json['Registro de Clientes'],
        listaClientes: json['Lista de Clientes'],
        dashboards: json['Dashboards'],
        solicitudPago: json['Solicitud de Pago'],
        aprobacionPago: json['Aprobación de Pago'],
      );
}
