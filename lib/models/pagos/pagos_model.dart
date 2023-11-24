import 'dart:convert';

import 'package:acp_web/models/global/factura_model.dart';
import 'package:pluto_grid/pluto_grid.dart';

class Pagos {
  int? year;
  int? month;
  List<Cliente>? clientes;
  bool isExpanded = false;

  Pagos({
    this.year,
    this.month,
    this.clientes,
  });

  factory Pagos.fromJson(String str) => Pagos.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Pagos.fromMap(Map<String, dynamic> json) => Pagos(
        year: json["year"],
        month: json["month"],
        clientes: json["clientes"] == null ? [] : List<Cliente>.from(json["clientes"]!.map((x) => Cliente.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "year": year,
        "month": month,
        "clientes": clientes == null ? [] : List<dynamic>.from(clientes!.map((x) => x.toMap())),
      };
}

class Cliente {
  String? logo;
  String? estatus;
  int? anexoId;
  double? anticipo;
  double? comision;
  List<Factura>? facturas;
  List<PlutoRow>? rows = [];
  String? sociedad;
  String? anexoDoc;
  int? clienteId;
  int? estatusId;
  DateTime? fechaPago;
  String? nombreFiscal;
  String? codigoAcreedor;
  DateTime? fechaPropuesta;
  int? cuentasAnticipadas;
  bool isExpanded = false;

  Cliente({
    this.logo,
    this.estatus,
    this.anexoId,
    this.anticipo,
    this.comision,
    this.facturas,
    this.sociedad,
    this.anexoDoc,
    this.clienteId,
    this.estatusId,
    this.fechaPago,
    this.nombreFiscal,
    this.codigoAcreedor,
    this.fechaPropuesta,
    this.cuentasAnticipadas,
  });

  factory Cliente.fromJson(String str) => Cliente.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Cliente.fromMap(Map<String, dynamic> json) => Cliente(
        logo: json["logo"],
        estatus: json["estatus"],
        anexoId: json["anexo_id"],
        anticipo: json["anticipo"]?.toDouble(),
        comision: json["comision"]?.toDouble(),
        facturas: json["facturas"] == null ? [] : List<Factura>.from(json["facturas"]!.map((x) => Factura.fromMap(x))),
        sociedad: json["sociedad"],
        anexoDoc: json["anexo_doc"],
        clienteId: json["cliente_id"],
        estatusId: json["estatus_id"],
        fechaPago: json["fecha_pago"] == null ? null : DateTime.parse(json["fecha_pago"]),
        nombreFiscal: json["nombre_fiscal"],
        codigoAcreedor: json["codigo_acreedor"],
        fechaPropuesta: json["fecha_propuesta"] == null ? null : DateTime.parse(json["fecha_propuesta"]),
        cuentasAnticipadas: json["cuentas_anticipadas"],
      );

  Map<String, dynamic> toMap() => {
        "logo": logo,
        "estatus": estatus,
        "anexo_id": anexoId,
        "anticipo": anticipo,
        "comision": comision,
        "facturas": facturas == null ? [] : List<dynamic>.from(facturas!.map((x) => x.toMap())),
        "sociedad": sociedad,
        "anexo_doc": anexoDoc,
        "cliente_id": clienteId,
        "estatus_id": estatusId,
        "fecha_pago": fechaPago?.toIso8601String(),
        "nombre_fiscal": nombreFiscal,
        "codigo_acreedor": codigoAcreedor,
        "fecha_propuesta": fechaPropuesta?.toIso8601String(),
        "cuentas_anticipadas": cuentasAnticipadas,
      };
}
