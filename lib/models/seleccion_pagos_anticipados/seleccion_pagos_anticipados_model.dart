import 'dart:convert';

import 'package:acp_web/models/global/factura_model.dart';
import 'package:pluto_grid/pluto_grid.dart';

class SeleccionPagosAnticipados {
  int? clienteId;
  String? nombreFiscal;
  String? sociedad;
  String? codigoCliente;
  String? logo;
  //
  int? condPago;
  double? tasaAnual;
  double? tae = 0;
  double? facturacionMayorA;
  double? tasaPreferencial;
  //
  List<Factura>? facturas;
  //
  List<PlutoRow>? rows = [];
  int? facturasSeleccionadas = 0;
  double? facturacion = 0;
  double? facturacionTotal = 0;
  double? comision = 0;
  double? margenOperativo = 0;
  double? utilidadNeta = 0;
  double? pagoAdelantado = 0;
  //
  bool isExpanded = false;
  bool bloqueado = false;

  SeleccionPagosAnticipados({
    this.clienteId,
    this.nombreFiscal,
    this.sociedad,
    this.codigoCliente,
    this.logo,
    //
    this.condPago,
    this.tasaAnual,
    this.tae,
    this.facturacionMayorA,
    this.tasaPreferencial,
    //
    this.facturas,
  });

  factory SeleccionPagosAnticipados.fromJson(String str) => SeleccionPagosAnticipados.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SeleccionPagosAnticipados.fromMap(Map<String, dynamic> json) => SeleccionPagosAnticipados(
        clienteId: json["cliente_id"],
        nombreFiscal: json["nombre_fiscal"],
        sociedad: json["sociedad"],
        codigoCliente: json["codigo_cliente"],
        logo: json["logo"],
        //
        condPago: json["cond_pago"].toDouble(),
        tasaAnual: json["tasa_anual"]?.toDouble(),
        tae: json["tasa_anual"]?.toDouble(),
        facturacionMayorA: json["facturacion_mayor_a"]?.toDouble(),
        tasaPreferencial: json["tasa_preferencial"]?.toDouble(),
        //
        facturas: json["facturas"] == null ? [] : List<Factura>.from(json["facturas"]!.map((x) => Factura.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "cliente_id": clienteId,
        "nombre_fiscal": nombreFiscal,
        "sociedad": sociedad,
        "codigo_cliente": codigoCliente,
        "logo": logo,
        //
        "cond_pago": condPago,
        "tasa_anual": tae,
        "facturacion_mayor_a": facturacionMayorA,
        "tasa_preferencial": tasaPreferencial,
        //
        "facturas": facturas == null ? [] : List<dynamic>.from(facturas!.map((x) => x.toMap())),
      };
}
