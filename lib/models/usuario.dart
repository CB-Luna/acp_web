import 'dart:convert';

import 'package:acp_web/models/pais.dart';
import 'package:acp_web/models/rol.dart';

class Usuario {
  Usuario({
    required this.id,
    required this.idSecuencial,
    required this.email,
    required this.nombre,
    required this.apellidos,
    this.imagen,
    required this.telefono,
    this.ext,
    required this.pais,
    required this.rol,
    this.idProveedorFk,
    this.responsableFk,
    required this.ausencia,
    required this.activado,
    this.cambioContrasena = true,
    this.fechaIngreso,
    this.monedaSeleccionada,
  });

  String id;
  int idSecuencial;
  String email;
  String nombre;
  String apellidos;
  String? imagen;
  String telefono;
  String? ext;
  int? idProveedorFk;
  String? responsableFk;
  Pais pais;
  Rol rol;
  bool ausencia;
  bool activado;
  bool cambioContrasena;
  DateTime? fechaIngreso;
  String? monedaSeleccionada;

  String get nombreCompleto => '$nombre $apellidos';

  bool get esProveedor => rol.nombreRol == 'Proveedor';

  bool get esAdmin => rol.nombreRol == 'Administrador ARUX';

  bool get esFinanzas => rol.nombreRol == 'Finanzas Local';

  bool get esOnboarding => rol.nombreRol == 'Onboarding';

  bool get esValidador => rol.nombreRol == 'Analista Contable (OLS)' || rol.nombreRol == 'Administrador Contable (OLS)';

  bool get esTesorero =>
      rol.nombreRol == 'Finanzas Local' ||
      rol.nombreRol == 'Especialista de Tesorería' ||
      rol.nombreRol == 'Gerente Financiero/Tesorería';

  bool get esRegistroCentralizado => rol.nombreRol == 'Analista Registros Centralizados';

  bool get esAdministradorGeneral => rol.nombreRol == 'Administrador General ARUX';

  factory Usuario.fromJson(String str) => Usuario.fromMap(json.decode(str));

  factory Usuario.fromMap(Map<String, dynamic> json) {
    Pais usuarioPais = Pais.fromJson(jsonEncode(json['pais']));

    Usuario usuario = Usuario(
      id: json["id"],
      idSecuencial: json["usuario_id_secuencial"],
      email: json["email"],
      nombre: json["nombre"],
      apellidos: json["apellidos"],
      imagen: json['imagen'],
      telefono: json["telefono"],
      ext: json['ext'],
      idProveedorFk: json["id_proveedor_fk"],
      responsableFk: json['responsable_fk'],
      pais: usuarioPais,
      rol: Rol.fromJson(jsonEncode(json['rol'])),
      ausencia: json['ausencia'],
      activado: json['activado'],
      cambioContrasena: json['cambio_contrasena'] ?? true,
      fechaIngreso: json['fecha_ingreso'] != null ? DateTime.parse(json["fecha_ingreso"]).toLocal() : null,
    );

    return usuario;
  }

  Usuario copyWith({
    String? id,
    int? idSecuencial,
    String? email,
    String? nombre,
    String? apellidos,
    String? imagen,
    String? telefono,
    String? ext,
    int? idProveedorFk,
    String? responsableFk,
    Pais? pais,
    Rol? rol,
    bool? ausencia,
    bool? activado,
    bool? cambioContrasena,
  }) {
    return Usuario(
      id: id ?? this.id,
      idSecuencial: idSecuencial ?? this.idSecuencial,
      email: email ?? this.email,
      nombre: nombre ?? this.nombre,
      apellidos: apellidos ?? this.apellidos,
      imagen: imagen ?? this.imagen,
      telefono: telefono ?? this.telefono,
      ext: ext ?? this.ext,
      idProveedorFk: idProveedorFk ?? this.idProveedorFk,
      responsableFk: responsableFk ?? this.responsableFk,
      pais: pais ?? this.pais,
      rol: rol ?? this.rol,
      ausencia: ausencia ?? this.ausencia,
      activado: activado ?? this.activado,
      cambioContrasena: cambioContrasena ?? this.cambioContrasena,
    );
  }
}
