import 'dart:convert';

class TablaDashboard {
    int? id;
    DateTime? createdAt;
    String? cliente;
    double? importe;
    double? tasaCliente;
    String? idAnalisis;
    dynamic sociedad;

    TablaDashboard({
        this.id,
        this.createdAt,
        this.cliente,
        this.importe,
        this.tasaCliente,
        this.idAnalisis,
        this.sociedad,
    });

    factory TablaDashboard.fromJson(String str) => TablaDashboard.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory TablaDashboard.fromMap(Map<String, dynamic> json) => TablaDashboard(
        id: json["id"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        cliente: json["cliente"],
        importe: json["importe"]?.toDouble(),
        tasaCliente: json["tasa_cliente"]?.toDouble(),
        idAnalisis: json["id_analisis"],
        sociedad: json["sociedad"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "created_at": createdAt?.toIso8601String(),
        "cliente": cliente,
        "importe": importe,
        "tasa_cliente": tasaCliente,
        "id_analisis": idAnalisis,
        "sociedad": sociedad,
    };
}
