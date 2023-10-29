import 'dart:convert';

import 'package:acp_web/models/models.dart';

class Usuario {
  Usuario({
    required this.id,
    required this.idSecuencial,
    required this.nombre,
    required this.apellidos,
    required this.telefono,
    required this.rol,
    required this.compania,
    required this.email,
    required this.sociedad,
    required this.pais,
    required this.activo,
    required this.cambioContrasena,
    this.fechaIngreso,
  });

  String id;
  int idSecuencial;
  String nombre;
  String apellidos;
  String telefono;
  Rol rol;
  Compania compania;
  String email;
  Sociedad sociedad;
  Pais pais;
  bool activo;
  bool cambioContrasena;
  DateTime? fechaIngreso;

  String get nombreCompleto => '$nombre $apellidos';

  String get estatus => activo ? 'Activo' : 'Desactivado';

  factory Usuario.fromJson(String str) => Usuario.fromMap(json.decode(str));

  factory Usuario.fromMap(Map<String, dynamic> json) {
    Usuario usuario = Usuario(
      id: json["id"],
      idSecuencial: json["usuario_id_secuencial"],
      nombre: json["nombre"],
      apellidos: json["apellidos"],
      telefono: json['telefono'],
      rol: Rol.fromJson(jsonEncode(json['rol'])),
      compania: Compania.fromMap(json['compania']),
      email: json["email"],
      sociedad: Sociedad.fromMap(json['sociedad']),
      pais: Pais.fromMap(json['pais']),
      activo: json['activo'],
      cambioContrasena: json['cambio_contrasena'] ?? true,
      fechaIngreso: json['fecha_ingreso'] != null ? DateTime.parse(json["fecha_ingreso"]).toLocal() : null,
    );

    return usuario;
  }

  Usuario copyWith({
    String? id,
    int? idSecuencial,
    String? nombre,
    String? apellidos,
    String? telefono,
    Rol? rol,
    Compania? compania,
    String? email,
    Sociedad? sociedad,
    Pais? pais,
    bool? activo,
    bool? cambioContrasena,
    DateTime? fechaIngreso,
  }) {
    return Usuario(
      id: id ?? this.id,
      idSecuencial: idSecuencial ?? this.idSecuencial,
      nombre: nombre ?? this.nombre,
      apellidos: apellidos ?? this.apellidos,
      telefono: telefono ?? this.telefono,
      rol: rol ?? this.rol,
      compania: compania ?? this.compania,
      email: email ?? this.email,
      sociedad: sociedad ?? this.sociedad,
      pais: pais ?? this.pais,
      activo: activo ?? this.activo,
      cambioContrasena: cambioContrasena ?? this.cambioContrasena,
      fechaIngreso: fechaIngreso ?? this.fechaIngreso,
    );
  }
}
