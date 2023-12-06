import 'dart:convert';

class SolicitudPagos {
    int? factuaId;
    String? noDoc;
    dynamic referencia;
    double? importe;
    double? comision;
    int? diasPago;
    double? pagoAnticipado;
    String? moneda;
    bool ischeck = false;

    SolicitudPagos({
        this.factuaId,
        this.noDoc,
        this.referencia,
        this.importe,
        this.comision,
        this.diasPago,
        this.pagoAnticipado,
        this.moneda,
    });

    factory SolicitudPagos.fromJson(String str) => SolicitudPagos.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory SolicitudPagos.fromMap(Map<String, dynamic> json) => SolicitudPagos(
        factuaId: json["factua_id"],
        noDoc: json["noDoc"],
        referencia: json["referencia"],
        importe: json["importe"]?.toDouble(),
        comision: json["comision"]?.toDouble(),
        diasPago: json["dias_pago"],
        pagoAnticipado: json["pago_anticipado"]?.toDouble(),
        moneda: json["moneda"],
    );

    Map<String, dynamic> toMap() => {
        "factua_id": factuaId,
        "noDoc": noDoc,
        "referencia": referencia,
        "importe": importe,
        "comision": comision,
        "dias_pago": diasPago,
        "pago_anticipado": pagoAnticipado,
        "moneda": moneda,
    };
}
