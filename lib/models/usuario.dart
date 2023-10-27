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
    required this.pais,
    required this.rol,
    this.cambioContrasena = true,
    this.fechaIngreso,
  });

  String id;
  int idSecuencial;
  String email;
  String nombre;
  String apellidos;
  Pais pais;
  Rol rol;
  bool cambioContrasena;
  DateTime? fechaIngreso;

  String get nombreCompleto => '$nombre $apellidos';

  factory Usuario.fromJson(String str) => Usuario.fromMap(json.decode(str));

  factory Usuario.fromMap(Map<String, dynamic> json) {
    Pais usuarioPais = Pais.fromJson(jsonEncode(json['pais']));

    Usuario usuario = Usuario(
      id: json["id"],
      idSecuencial: json["usuario_id_secuencial"],
      email: json["email"],
      nombre: json["nombre"],
      apellidos: json["apellidos"],
      pais: usuarioPais,
      rol: Rol.fromJson(jsonEncode(json['rol'])),
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
      pais: pais ?? this.pais,
      rol: rol ?? this.rol,
      cambioContrasena: cambioContrasena ?? this.cambioContrasena,
    );
  }
}
