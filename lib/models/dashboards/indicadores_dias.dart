import 'dart:convert';

class IndicadoresDias {
    int? id;
    DateTime? createdAt;
    int? diasPromedio;
    String? idAnalisis;
    String? cliente;
    dynamic sociedad;

    IndicadoresDias({
        this.id,
        this.createdAt,
        this.diasPromedio,
        this.idAnalisis,
        this.cliente,
        this.sociedad,
    });

    factory IndicadoresDias.fromJson(String str) => IndicadoresDias.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory IndicadoresDias.fromMap(Map<String, dynamic> json) => IndicadoresDias(
        id: json["id"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        diasPromedio: json["dias_promedio"],
        idAnalisis: json["id_analisis"],
        cliente: json["cliente"],
        sociedad: json["sociedad"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "created_at": createdAt?.toIso8601String(),
        "dias_promedio": diasPromedio,
        "id_analisis": idAnalisis,
        "cliente": cliente,
        "sociedad": sociedad,
    };
}
