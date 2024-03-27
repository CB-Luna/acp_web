import 'dart:convert';

class IndicadoresAnexos {
    int? id;
    DateTime? createdAt;
    int? generados;
    int? aceptados;
    int? pagados;
    int? cancelados;
    String? idAnalisis;
    String? cliente;
    dynamic sociedad;

    IndicadoresAnexos({
        this.id,
        this.createdAt,
        this.generados,
        this.aceptados,
        this.pagados,
        this.cancelados,
        this.idAnalisis,
        this.cliente,
        this.sociedad,
    });

    factory IndicadoresAnexos.fromJson(String str) => IndicadoresAnexos.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory IndicadoresAnexos.fromMap(Map<String, dynamic> json) => IndicadoresAnexos(
        id: json["id"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        generados: json["generados"],
        aceptados: json["aceptados"],
        pagados: json["pagados"],
        cancelados: json["cancelados"],
        idAnalisis: json["id_analisis"],
        cliente: json["cliente"],
        sociedad: json["sociedad"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "created_at": createdAt?.toIso8601String(),
        "generados": generados,
        "aceptados": aceptados,
        "pagados": pagados,
        "cancelados": cancelados,
        "id_analisis": idAnalisis,
        "cliente": cliente,
        "sociedad": sociedad,
    };
}
