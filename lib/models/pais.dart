import 'dart:convert';

class Pais {
  Pais({
    required this.nombre,
    required this.paisId,
    required this.clave,
  });

  String nombre;
  int paisId;
  String clave;

  factory Pais.fromJson(String str) => Pais.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Pais.fromMap(Map<String, dynamic> json) {
    final List<String> tempMonedas = [];
    if (json['monedas'] != null) {
      for (var moneda in json['monedas']) {
        tempMonedas.add(moneda.toString());
      }
    }

    return Pais(
      nombre: json["nombre"],
      paisId: json["pais_id"],
      clave: json["clave"],
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
