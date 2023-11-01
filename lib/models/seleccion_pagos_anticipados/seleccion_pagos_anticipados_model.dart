import 'dart:convert';

import 'package:pluto_grid/pluto_grid.dart';

class SeleccionPagosAnticipados {
  int? clienteId;
  String? nombreFiscal;
  String? sociedad;
  String? codigoAcreedor;
  String? contacto;
  String? logoUrl;
  List<Factura>? facturas;
  List<PlutoRow>? rows = [];
  int? facturasSeleccionadas = 0;
  double? facturacion = 0;
  double? beneficio = 0;
  double? pagoAdelantado = 0;

  SeleccionPagosAnticipados({
    this.clienteId,
    this.nombreFiscal,
    this.sociedad,
    this.codigoAcreedor,
    this.contacto,
    this.logoUrl,
    this.facturas,
  });

  factory SeleccionPagosAnticipados.fromJson(String str) => SeleccionPagosAnticipados.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SeleccionPagosAnticipados.fromMap(Map<String, dynamic> json) => SeleccionPagosAnticipados(
        clienteId: json["cliente_id"],
        nombreFiscal: json["nombre_fiscal"],
        sociedad: json["sociedad"],
        codigoAcreedor: json["codigo_acreedor"],
        contacto: json["contacto"],
        logoUrl: json["logo_url"],
        facturas: json["facturas"] == null ? [] : List<Factura>.from(json["facturas"]!.map((x) => Factura.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "cliente_id": clienteId,
        "nombre_fiscal": nombreFiscal,
        "sociedad": sociedad,
        "codigo_acreedor": codigoAcreedor,
        "contacto": contacto,
        "logo_url": logoUrl,
        "facturas": facturas == null ? [] : List<dynamic>.from(facturas!.map((x) => x.toMap())),
      };
}

class Factura {
  String? noDoc;
  String? moneda;
  double? importe;
  double? cantDpp;
  double? porcDpp;
  String? sociedad;
  int? diasPago;
  DateTime? fechaDoc;
  int? clienteId;
  int? estatusId;
  int? facturaId;
  DateTime? fechaPago;
  int? tipoCambio;
  DateTime? fechaContable;
  DateTime? fechaRegistro;
  double? pagoAnticipado;
  DateTime? fechaExtraccion;
  DateTime? fechaActualizacion;

  Factura({
    this.noDoc,
    this.moneda,
    this.importe,
    this.cantDpp,
    this.porcDpp,
    this.sociedad,
    this.diasPago,
    this.fechaDoc,
    this.clienteId,
    this.estatusId,
    this.facturaId,
    this.fechaPago,
    this.tipoCambio,
    this.fechaContable,
    this.fechaRegistro,
    this.pagoAnticipado,
    this.fechaExtraccion,
    this.fechaActualizacion,
  });

  factory Factura.fromJson(String str) => Factura.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Factura.fromMap(Map<String, dynamic> json) => Factura(
        noDoc: json["noDoc"],
        moneda: json["moneda"],
        importe: json["importe"]?.toDouble(),
        cantDpp: json["cant_dpp"]?.toDouble(),
        porcDpp: json["porc_dpp"]?.toDouble(),
        sociedad: json["sociedad"],
        diasPago: json["dias_pago"],
        fechaDoc: json["fecha_doc"] == null ? null : DateTime.parse(json["fecha_doc"]),
        clienteId: json["cliente_id"],
        estatusId: json["estatus_id"],
        facturaId: json["factura_id"],
        fechaPago: json["fecha_pago"] == null ? null : DateTime.parse(json["fecha_pago"]),
        tipoCambio: json["tipo_cambio"],
        fechaContable: json["fecha_contable"] == null ? null : DateTime.parse(json["fecha_contable"]),
        fechaRegistro: json["fecha_registro"] == null ? null : DateTime.parse(json["fecha_registro"]),
        pagoAnticipado: json["pago_anticipado"]?.toDouble(),
        fechaExtraccion: json["fecha_extraccion"] == null ? null : DateTime.parse(json["fecha_extraccion"]),
        fechaActualizacion: json["fecha_actualizacion"] == null ? null : DateTime.parse(json["fecha_actualizacion"]),
      );

  Map<String, dynamic> toMap() => {
        "noDoc": noDoc,
        "moneda": moneda,
        "importe": importe,
        "cant_dpp": cantDpp,
        "porc_dpp": porcDpp,
        "sociedad": sociedad,
        "dias_pago": diasPago,
        "fecha_doc": fechaDoc?.toIso8601String(),
        "cliente_id": clienteId,
        "estatus_id": estatusId,
        "factura_id": facturaId,
        "fecha_pago": fechaPago?.toIso8601String(),
        "tipo_cambio": tipoCambio,
        "fecha_contable": fechaContable?.toIso8601String(),
        "fecha_registro": fechaRegistro?.toIso8601String(),
        "pago_anticipado": pagoAnticipado,
        "fecha_extraccion": fechaExtraccion?.toIso8601String(),
        "fecha_actualizacion": fechaActualizacion?.toIso8601String(),
      };
}
