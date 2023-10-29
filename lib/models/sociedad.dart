import 'dart:convert';

class Sociedad {
  Sociedad({
    required this.sociedadId,
    required this.nombre,
    required this.paisFk,
  });

  int sociedadId;
  String nombre;
  int paisFk;

  factory Sociedad.fromJson(String str) => Sociedad.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Sociedad.fromMap(Map<String, dynamic> json) {
    return Sociedad(
      sociedadId: json["sociedad_id"],
      nombre: json["nombre"],
      paisFk: json["pais_fk"],
    );
  }

  Map<String, dynamic> toMap() => {
        "sociedad_id": sociedadId,
        "nombre": nombre,
        "pais_fk": paisFk,
      };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Sociedad && other.sociedadId == sociedadId && other.nombre == nombre && other.paisFk == paisFk;
  }

  @override
  int get hashCode => Object.hash(sociedadId, nombre, paisFk);
}
