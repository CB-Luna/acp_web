import 'dart:convert';

class GraficaSpend {
    int? id;
    DateTime? createdAt;
    ClientesDiasJson? clientesDiasJson;
    String? idAnalisis;
    int? noClientes;
    String? cliente;
    dynamic sociedad;

    GraficaSpend({
        this.id,
        this.createdAt,
        this.clientesDiasJson,
        this.idAnalisis,
        this.noClientes,
        this.cliente,
        this.sociedad,
    });

    factory GraficaSpend.fromJson(String str) => GraficaSpend.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory GraficaSpend.fromMap(Map<String, dynamic> json) => GraficaSpend(
        id: json["id"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        clientesDiasJson: json["clientes_dias_json"] == null ? null : ClientesDiasJson.fromMap(json["clientes_dias_json"]),
        idAnalisis: json["id_analisis"],
        noClientes: json["no_clientes"],
        cliente: json["cliente"],
        sociedad: json["sociedad"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "created_at": createdAt?.toIso8601String(),
        "clientes_dias_json": clientesDiasJson?.toMap(),
        "id_analisis": idAnalisis,
        "no_clientes": noClientes,
        "cliente": cliente,
        "sociedad": sociedad,
    };
}

class ClientesDiasJson {
    double? dias90;
    double? diasM90;
    double? dias030;
    double? dias3145;
    double? dias4689;

    ClientesDiasJson({
        this.dias90,
        this.diasM90,
        this.dias030,
        this.dias3145,
        this.dias4689,
    });

    factory ClientesDiasJson.fromJson(String str) => ClientesDiasJson.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ClientesDiasJson.fromMap(Map<String, dynamic> json) => ClientesDiasJson(
        dias90: json["dias 90"],
        diasM90: json["dias >90"],
        dias030: json["dias 0-30"],
        dias3145: json["dias 31-45"],
        dias4689: json["dias 46-89"],
    );

    Map<String, dynamic> toMap() => {
        "dias 90": dias90,
        "dias >90": diasM90,
        "dias 0-30": dias030,
        "dias 31-45": dias3145,
        "dias 46-89": dias4689,
    };
}
