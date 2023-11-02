import 'dart:convert';

class AprobacionSeguimientoPagos {
  final int factuaId;
  final String noDoc;
  final double importe;
  final double comision;
  final double pagoAnticipado;
  final int diasPago;
  final DateTime fechaSeleccion;

  AprobacionSeguimientoPagos({
    required this.factuaId,
    required this.noDoc,
    required this.importe,
    required this.comision,
    required this.pagoAnticipado,
    required this.diasPago,
    required this.fechaSeleccion,
  });

  factory AprobacionSeguimientoPagos.fromJson(String str) => AprobacionSeguimientoPagos.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AprobacionSeguimientoPagos.fromMap(Map<String, dynamic> json) => AprobacionSeguimientoPagos(
        factuaId: json["factua_id"],
        noDoc: json["noDoc"],
        importe: json["importe"].toDouble(),
        comision: json["comision"].toDouble(),
        pagoAnticipado: json["pago_anticipado"].toDouble(),
        diasPago: json["dias_pago"],
        fechaSeleccion: DateTime.parse(json["fecha_seleccion"]),
      );

  Map<String, dynamic> toMap() => {
        "factua_id": factuaId,
        "noDoc": noDoc,
        "importe": importe,
        "comision": comision,
        "pago_anticipado": pagoAnticipado,
        "dias_pago": diasPago,
        "fecha_seleccion": "${fechaSeleccion.year.toString().padLeft(4, '0')}-${fechaSeleccion.month.toString().padLeft(2, '0')}-${fechaSeleccion.day.toString().padLeft(2, '0')}",
      };
}
