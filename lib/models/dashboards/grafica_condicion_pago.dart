import 'dart:convert';

class GraficaCondicionPago {
    int? id;
    DateTime? createdAt;
    TotalFacturadoDiasJson? totalFacturadoDiasJson;
    String? idAnalisis;
    String? cliente;
    dynamic sociedad;

    GraficaCondicionPago({
        this.id,
        this.createdAt,
        this.totalFacturadoDiasJson,
        this.idAnalisis,
        this.cliente,
        this.sociedad,
    });

    factory GraficaCondicionPago.fromJson(String str) => GraficaCondicionPago.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory GraficaCondicionPago.fromMap(Map<String, dynamic> json) => GraficaCondicionPago(
        id: json["id"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        totalFacturadoDiasJson: json["total_facturado_dias_json"] == null ? null : TotalFacturadoDiasJson.fromMap(json["total_facturado_dias_json"]),
        idAnalisis: json["id_analisis"],
        cliente: json["cliente"],
        sociedad: json["sociedad"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "created_at": createdAt?.toIso8601String(),
        "total_facturado_dias_json": totalFacturadoDiasJson?.toMap(),
        "id_analisis": idAnalisis,
        "cliente": cliente,
        "sociedad": sociedad,
    };
}

class TotalFacturadoDiasJson {
    double? dias90;
    double? totalFacturadoDiasJsonDias90;
    double? dias030;
    double? dias3145;
    double? dias4689;

    TotalFacturadoDiasJson({
        this.dias90,
        this.totalFacturadoDiasJsonDias90,
        this.dias030,
        this.dias3145,
        this.dias4689,
    });

    factory TotalFacturadoDiasJson.fromJson(String str) => TotalFacturadoDiasJson.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory TotalFacturadoDiasJson.fromMap(Map<String, dynamic> json) => TotalFacturadoDiasJson(
        dias90: json["dias 90"],
        totalFacturadoDiasJsonDias90: json["dias >90"],
        dias030: json["dias 0-30"],
        dias3145: json["dias 31-45"],
        dias4689: json["dias 46-89"],
    );

    Map<String, dynamic> toMap() => {
        "dias 90": dias90,
        "dias >90": totalFacturadoDiasJsonDias90,
        "dias 0-30": dias030,
        "dias 31-45": dias3145,
        "dias 46-89": dias4689,
    };
}
