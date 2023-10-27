import 'dart:convert';

import 'package:acp_web/models/configuration.dart';

class TemaDescargado {
  TemaDescargado({
    required this.id,
    required this.usuarioFk,
    required this.nombre,
    required this.tema,
  });

  int id;
  String usuarioFk;
  String nombre;
  Configuration tema;

  factory TemaDescargado.fromJson(String str) => TemaDescargado.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TemaDescargado.fromMap(Map<String, dynamic> json) => TemaDescargado(id: json['id'], usuarioFk: json['usuario_fk'], nombre: json['nombre'], tema: Configuration.fromMap(json['tema']));

  Map<String, dynamic> toMap() => {
        "id": id,
        "usuario_fk": usuarioFk,
        'nombre': nombre,
        'tema': tema.toMap(),
      };
}
