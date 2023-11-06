import 'dart:convert';

import 'package:acp_web/models/models.dart';

class Usuario {
  Usuario({
    required this.id,
    required this.idSecuencial,
    required this.nombre,
    required this.apellidoPaterno,
    this.apellidoMaterno,
    required this.telefono,
    required this.rol,
    required this.compania,
    required this.email,
    this.cliente,
    this.imagen,
    required this.activo,
    required this.cambioContrasena,
    this.fechaIngreso,
  });

  String id;
  int idSecuencial;
  String nombre;
  String apellidoPaterno;
  String? apellidoMaterno;
  String telefono;
  Rol rol;
  String compania;
  String email;
  ClienteUsuario? cliente;
  String? imagen;
  bool activo;
  bool cambioContrasena;
  DateTime? fechaIngreso;

  String get nombreCompleto => '$nombre $apellidoPaterno ${apellidoMaterno ?? ''}';

  String get estatus => activo ? 'Activo' : 'Inactivo';

  factory Usuario.fromJson(String str) => Usuario.fromMap(json.decode(str));

  factory Usuario.fromMap(Map<String, dynamic> json) {
    Usuario usuario = Usuario(
      id: json["id"],
      idSecuencial: json["usuario_id_secuencial"],
      nombre: json["nombre"],
      apellidoPaterno: json["apellido_paterno"],
      apellidoMaterno: json["apellido_materno"],
      telefono: json['telefono'],
      rol: Rol.fromJson(jsonEncode(json['rol'])),
      compania: json['compania'],
      email: json["email"],
      cliente: json['cliente_fk'] != null ? ClienteUsuario.fromMap(json['cliente']) : null,
      imagen: json['imagen'],
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
    String? apellidoPaterno,
    String? apellidoMaterno,
    String? telefono,
    Rol? rol,
    String? compania,
    String? email,
    ClienteUsuario? cliente,
    String? imagen,
    bool? activo,
    bool? cambioContrasena,
    DateTime? fechaIngreso,
  }) {
    return Usuario(
      id: id ?? this.id,
      idSecuencial: idSecuencial ?? this.idSecuencial,
      nombre: nombre ?? this.nombre,
      apellidoPaterno: apellidoPaterno ?? this.apellidoPaterno,
      apellidoMaterno: apellidoMaterno ?? this.apellidoMaterno,
      telefono: telefono ?? this.telefono,
      rol: rol ?? this.rol,
      compania: compania ?? this.compania,
      email: email ?? this.email,
      cliente: cliente ?? this.cliente,
      imagen: imagen ?? this.imagen,
      activo: activo ?? this.activo,
      cambioContrasena: cambioContrasena ?? this.cambioContrasena,
      fechaIngreso: fechaIngreso ?? this.fechaIngreso,
    );
  }
}

class ClienteUsuario {
  ClienteUsuario({
    required this.clienteId,
    required this.codigoCliente,
    required this.sociedad,
  });

  int clienteId;
  String codigoCliente;
  String sociedad;

  factory ClienteUsuario.fromJson(String str) => ClienteUsuario.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ClienteUsuario.fromMap(Map<String, dynamic> json) {
    return ClienteUsuario(
      clienteId: json["cliente_id"],
      codigoCliente: json["codigo_cliente"],
      sociedad: json['sociedad'],
    );
  }

  Map<String, dynamic> toMap() => {
        "cliente_id": clienteId,
        "codigo_acreedor": codigoCliente,
        'sociedad': sociedad,
      };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ClienteUsuario && other.clienteId == clienteId && other.codigoCliente == codigoCliente;
  }

  @override
  int get hashCode => Object.hash(clienteId, codigoCliente);
}
