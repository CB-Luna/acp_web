import 'dart:convert';

import 'package:acp_web/models/global/factura_model.dart';
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
  final String sociedad;
  final List<Factura> registrosPorDia;
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
    required this.sociedad,
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
        sociedad: json["sociedad"],
        registrosPorDia: List<Factura>.from(json["registros_por_dia"].map((x) => Factura.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "dia": dia,
        "mes": mes,
        "year": year,
        "estatus": estatus,
        "moneda": moneda,
        "sociedad": sociedad,
        "registros_por_dia": List<dynamic>.from(registrosPorDia.map((x) => x.toMap())),
      };
}
