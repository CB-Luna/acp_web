import 'dart:convert';

import 'package:pluto_grid/pluto_grid.dart';

class AprobacionSegumientoPagosFuncion {
  final int year;
  final int month;
  final List<Propuesta> propuestas;
  bool isExpanded = false;
  bool checked = false;

  AprobacionSegumientoPagosFuncion({
    required this.year,
    required this.month,
    required this.propuestas,
  });

  factory AprobacionSegumientoPagosFuncion.fromJson(String str) => AprobacionSegumientoPagosFuncion.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AprobacionSegumientoPagosFuncion.fromMap(Map<String, dynamic> json) => AprobacionSegumientoPagosFuncion(
        year: json["year"],
        month: json["month"],
        propuestas: List<Propuesta>.from(json["propuestas"].map((x) => Propuesta.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "year": year,
        "month": month,
        "propuestas": List<dynamic>.from(propuestas.map((x) => x.toMap())),
      };
}

class Propuesta {
  final int dia;
  final int mes;
  final int year;
  final String moneda;
  final int estatus;
  final List<RegistrosPorDia> registrosPorDia;
  List<PlutoRow>? rows = [];
  bool isExpanded = false;
  double? sumAnticipo = 0;
  double? sumComision = 0;

  Propuesta({
    required this.dia,
    required this.mes,
    required this.year,
    required this.moneda,
    required this.estatus,
    required this.registrosPorDia,
  });

  factory Propuesta.fromJson(String str) => Propuesta.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Propuesta.fromMap(Map<String, dynamic> json) => Propuesta(
        dia: json["dia"],
        mes: json["mes"],
        year: json["year"],
        estatus: json["estatus"],
        moneda: json["moneda"],
        registrosPorDia: List<RegistrosPorDia>.from(json["registros_por_dia"].map((x) => RegistrosPorDia.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "dia": dia,
        "mes": mes,
        "year": year,
        "estatus": estatus,
        "moneda": moneda,
        "registros_por_dia": List<dynamic>.from(registrosPorDia.map((x) => x.toMap())),
      };
}

class RegistrosPorDia {
  final String noDoc;
  final String moneda;
  final String cliente;
  final int estatus;
  final double importe;
  final String sociedad;
  final double beneficio;
  final int diasPago;
  final int clienteId;
  final int facturaId;
  final double pagoAnticipado;
  final DateTime fechaSeleccionPagoAnticipado;

  RegistrosPorDia({
    required this.noDoc,
    required this.moneda,
    required this.cliente,
    required this.estatus,
    required this.importe,
    required this.sociedad,
    required this.beneficio,
    required this.diasPago,
    required this.clienteId,
    required this.facturaId,
    required this.pagoAnticipado,
    required this.fechaSeleccionPagoAnticipado,
  });

  factory RegistrosPorDia.fromJson(String str) => RegistrosPorDia.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RegistrosPorDia.fromMap(Map<String, dynamic> json) => RegistrosPorDia(
        noDoc: json["noDoc"],
        moneda: json["moneda"],
        cliente: json["cliente"],
        estatus: json["estatus"],
        importe: json["importe"].toDouble(),
        sociedad: json["sociedad"],
        beneficio: json["beneficio"].toDouble(),
        diasPago: json["dias_pago"],
        clienteId: json["cliente_id"],
        facturaId: json["factura_id"],
        pagoAnticipado: json["pago_anticipado"].toDouble(),
        fechaSeleccionPagoAnticipado: DateTime.parse(json["fecha_seleccion_pago_anticipado"]),
      );

  Map<String, dynamic> toMap() => {
        "noDoc": noDoc,
        "moneda": moneda,
        "cliente": cliente,
        "estatus": estatus,
        "importe": importe,
        "sociedad": sociedad,
        "beneficio": beneficio,
        "dias_pago": diasPago,
        "cliente_id": clienteId,
        "factura_id": facturaId,
        "pago_anticipado": pagoAnticipado,
        "fecha_seleccion_pago_anticipado": fechaSeleccionPagoAnticipado.toIso8601String(),
      };
}
