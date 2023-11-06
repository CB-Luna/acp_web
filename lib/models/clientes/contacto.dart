import 'dart:convert';

class Contacto {
  Contacto({
    required this.contactoId,
    required this.nombre,
    required this.correo,
    required this.puesto,
    required this.telefono,
    required this.clienteFk,
  });

  int contactoId;
  String nombre;
  String correo;
  String puesto;
  String telefono;
  int clienteFk;

  factory Contacto.fromJson(String str) => Contacto.fromMap(json.decode(str));

  factory Contacto.fromMap(Map<String, dynamic> json) {
    return Contacto(
      contactoId: json["contacto_id"],
      nombre: json["nombre"],
      correo: json['correo'],
      puesto: json['puesto'],
      telefono: json['telefono'],
      clienteFk: json['cliente_fk'],
    );
  }
}
