import 'dart:convert';

class Compania {
  Compania({
    required this.companiaId,
    required this.nombre,
  });

  int companiaId;
  String nombre;

  factory Compania.fromJson(String str) => Compania.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Compania.fromMap(Map<String, dynamic> json) {
    return Compania(
      companiaId: json["compania_id"],
      nombre: json["nombre"],
    );
  }

  Map<String, dynamic> toMap() => {
        "compania_id": companiaId,
        "nombre": nombre,
      };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Compania && other.nombre == nombre && other.companiaId == companiaId;
  }

  @override
  int get hashCode => Object.hash(nombre, companiaId);
}
