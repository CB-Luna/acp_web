import 'dart:convert';

import 'package:acp_web/models/global/factura_model.dart';

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
  String? estatus;
  double? anticipo;
  double? comision;
  //String? contacto;
  List<Factura>? facturas;
  dynamic logoUrl;
  String? sociedad;
  int? clienteId;
  int? estatusId;
  DateTime? fechaPago;
  String? nombreFiscal;
  String? codigoCliente;
  DateTime? fechaPropuesta;
  int? cuentasAnticipadas;

  Cliente({
    this.estatus,
    this.anticipo,
    this.comision,
    //this.contacto,
    this.facturas,
    this.logoUrl,
    this.sociedad,
    this.clienteId,
    this.estatusId,
    this.fechaPago,
    this.nombreFiscal,
    this.codigoCliente,
    this.fechaPropuesta,
    this.cuentasAnticipadas,
  });

  factory Cliente.fromJson(String str) => Cliente.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Cliente.fromMap(Map<String, dynamic> json) => Cliente(
        estatus: json["estatus"],
        anticipo: json["anticipo"]?.toDouble(),
        comision: json["comision"]?.toDouble(),
        //contacto: json["contacto"],
        facturas: json["facturas"] == null ? [] : List<Factura>.from(json["facturas"]!.map((x) => Factura.fromMap(x))),
        logoUrl: json["logo_url"],
        sociedad: json["sociedad"],
        clienteId: json["cliente_id"],
        estatusId: json["estatus_id"],
        fechaPago: json["fecha_pago"] == null ? null : DateTime.parse(json["fecha_pago"]),
        nombreFiscal: json["nombre_fiscal"],
        codigoCliente: json["codigo_cliente"],
        fechaPropuesta: json["fecha_propuesta"] == null ? null : DateTime.parse(json["fecha_propuesta"]),
        cuentasAnticipadas: json["cuentas_anticipadas"],
      );

  Map<String, dynamic> toMap() => {
        "estatus": estatus,
        "anticipo": anticipo,
        "comision": comision,
        //"contacto": contacto,
        "facturas": facturas == null ? [] : List<dynamic>.from(facturas!.map((x) => x.toMap())),
        "logo_url": logoUrl,
        "sociedad": sociedad,
        "cliente_id": clienteId,
        "estatus_id": estatusId,
        "fecha_pago": fechaPago?.toIso8601String(),
        "nombre_fiscal": nombreFiscal,
        "codigo_cliente": codigoCliente,
        "fecha_propuesta": "${fechaPropuesta!.year.toString().padLeft(4, '0')}-${fechaPropuesta!.month.toString().padLeft(2, '0')}-${fechaPropuesta!.day.toString().padLeft(2, '0')}",
        "cuentas_anticipadas": cuentasAnticipadas,
      };
}
