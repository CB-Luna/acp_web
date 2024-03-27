import 'dart:convert';

class IndicadoresTasaDashboards {
    int? id;
    DateTime? createdAt;
    double? tasaMinima;
    double? tasaMaxima;
    double? moda;
    double? media;
    double? promedio;
    String? idAnalisis;
    String? cliente;

    IndicadoresTasaDashboards({
        this.id,
        this.createdAt,
        this.tasaMinima,
        this.tasaMaxima,
        this.moda,
        this.media,
        this.promedio,
        this.idAnalisis,
        this.cliente,
    });

    factory IndicadoresTasaDashboards.fromJson(String str) => IndicadoresTasaDashboards.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory IndicadoresTasaDashboards.fromMap(Map<String, dynamic> json) => IndicadoresTasaDashboards(
        id: json["id"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        tasaMinima: json["tasa_minima"],
        tasaMaxima: json["tasa_maxima"],
        moda: json["moda"],
        media: json["media"],
        promedio: json["promedio"],
        idAnalisis: json["id_analisis"],
        cliente: json["cliente"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "created_at": createdAt?.toIso8601String(),
        "tasa_minima": tasaMinima,
        "tasa_maxima": tasaMaxima,
        "moda": moda,
        "media": media,
        "promedio": promedio,
        "id_analisis": idAnalisis,
        "cliente": cliente,
    };
}
