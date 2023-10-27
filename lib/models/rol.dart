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

  String toJson() => json.encode(toMap());

  factory Rol.fromMap(Map<String, dynamic> json) => Rol(
        nombre: json["nombre"],
        rolId: json["rol_id"],
        permisos: Permisos.fromMap(json["permisos"]),
      );

  Map<String, dynamic> toMap() => {
        "nombre": nombre,
        "rol_id": rolId,
        "permisos": permisos.toMap(),
      };

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
    required this.homeProveedor,
    required this.extraccionDeFacturas,
    required this.seguimientoDeFacturas,
    required this.pagos,
    required this.seguimientoProveedor,
    required this.seguimientoNC,
    required this.solicitudDppCBC,
    required this.solicitudDppProveedor,
    required this.cargaNc,
    required this.validacionNC,
    required this.notificaciones,
    required this.administracionDeProveedores,
    required this.administracionDeUsuarios,
    required this.reportes,
    required this.perfilDeUsuario,
  });

  String? home;
  String? homeProveedor;
  String? extraccionDeFacturas;
  String? seguimientoDeFacturas;
  String? pagos;
  String? seguimientoProveedor;
  String? seguimientoNC;
  String? solicitudDppCBC;
  String? solicitudDppProveedor;
  String? cargaNc;
  String? validacionNC;
  String? notificaciones;
  String? administracionDeProveedores;
  String? administracionDeUsuarios;
  String? reportes;
  String? perfilDeUsuario;

  factory Permisos.fromJson(String str) => Permisos.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Permisos.fromMap(Map<String, dynamic> json) => Permisos(
        home: json['Home'],
        homeProveedor: json['HomeProveedor'],
        extraccionDeFacturas: json["Extraccion de Facturas"],
        seguimientoDeFacturas: json["Seguimiento de Facturas"],
        pagos: json["Pagos"],
        seguimientoProveedor: json["Seguimiento Proveedor"],
        seguimientoNC: json["Seguimiento NC"],
        solicitudDppCBC: json['SolicitudDPPCBC'],
        solicitudDppProveedor: json['SolicitudDPPProveedor'],
        cargaNc: json['CargaNC'],
        validacionNC: json["Validacion NC"],
        notificaciones: json["Notificaciones"],
        administracionDeProveedores: json["Administracion de Proveedores"],
        administracionDeUsuarios: json["Administracion de Usuarios"],
        reportes: json["Reportes"],
        perfilDeUsuario: json["Perfil de Usuario"],
      );

  Map<String, dynamic> toMap() => {
        "Home": home,
        "Extraccion de Facturas": extraccionDeFacturas,
        "Seguimiento de Facturas": seguimientoDeFacturas,
        "Pagos": pagos,
        "Seguimiento Proveedor": seguimientoProveedor,
        "Seguimiento NC": seguimientoNC,
        "Validacion NC": validacionNC,
        "Notificaciones": notificaciones,
        "Administracion de Proveedores": administracionDeProveedores,
        "Administracion de Usuarios": administracionDeUsuarios,
        "Reportes": reportes,
        "Perfil de Usuario": perfilDeUsuario,
      };
}
