import 'dart:convert';

class SolicitudPagos {
    final int factuaId;
    final double importe;
    final double comision;
    final int diasPago;
    final double pagoAnticipado;

    SolicitudPagos({
        required this.factuaId,
        required this.importe,
        required this.comision,
        required this.diasPago,
        required this.pagoAnticipado,
    });

    factory SolicitudPagos.fromJson(String str) => SolicitudPagos.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory SolicitudPagos.fromMap(Map<String, dynamic> json) => SolicitudPagos(
        factuaId: json["factua_id"],
        importe: json["importe"].toDouble(),
        comision: json["comision"].toDouble(),
        diasPago: json["dias_pago"],
        pagoAnticipado: json["pago_anticipado"].toDouble(),
    );

    Map<String, dynamic> toMap() => {
        "factua_id": factuaId,
        "importe": importe,
        "comision": comision,
        "dias_pago": diasPago,
        "pago_anticipado": pagoAnticipado,
    };
}