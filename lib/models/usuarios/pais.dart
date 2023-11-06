import 'dart:convert';

import 'package:acp_web/models/usuarios/sociedad.dart';

class Pais {
  Pais({
    required this.nombre,
    required this.paisId,
    required this.clave,
    required this.sociedades,
  });

  String nombre;
  int paisId;
  String clave;
  List<Sociedad> sociedades;

  factory Pais.fromJson(String str) => Pais.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Pais.fromMap(Map<String, dynamic> json) {
    final List<String> tempMonedas = [];
    if (json['monedas'] != null) {
      for (var moneda in json['monedas']) {
        tempMonedas.add(moneda.toString());
      }
    }

    final List<Sociedad> tempSociedades = [];
    if (json['sociedades'] != null) {
      for (var sociedad in json['sociedades']) {
        tempSociedades.add(Sociedad.fromMap(sociedad));
      }
    }

    return Pais(
      nombre: json["nombre"],
      paisId: json["pais_id"],
      clave: json["clave"],
      sociedades: tempSociedades,
    );
  }

  Map<String, dynamic> toMap() => {
        "nombre": nombre,
        "pais_id": paisId,
        "clave": clave,
      };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Pais && other.nombre == nombre && other.paisId == paisId && other.clave == clave;
  }

  @override
  int get hashCode => Object.hash(nombre, paisId, clave);
}
