import 'dart:convert';

import 'package:acp_web/models/global/factura_model.dart';
import 'package:pluto_grid/pluto_grid.dart';

class SeleccionPagosAnticipados {
  int? clienteId;
  String? nombreFiscal;
  String? sociedad;
  String? codigoCliente;
  //String? contacto;
  String? logo;
  List<Factura>? facturas;
  List<PlutoRow>? rows = [];
  int? facturasSeleccionadas = 0;
  double? facturacion = 0;
  double? facturaionTotal = 0;
  double? tae = 0;
  double? comision = 0;
  double? margenOperativo = 0;
  double? utilidadNeta = 0;
  double? pagoAdelantado = 0;
  bool isExpanded = false;
  bool bloqueado = false;

  SeleccionPagosAnticipados({
    this.clienteId,
    this.nombreFiscal,
    this.sociedad,
    this.codigoCliente,
    //this.contacto,
    this.logo,
    this.facturas,
    this.tae,
  });

  factory SeleccionPagosAnticipados.fromJson(String str) => SeleccionPagosAnticipados.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SeleccionPagosAnticipados.fromMap(Map<String, dynamic> json) => SeleccionPagosAnticipados(
        clienteId: json["cliente_id"],
        nombreFiscal: json["nombre_fiscal"],
        sociedad: json["sociedad"],
        codigoCliente: json["codigo_cliente"],
        //contacto: json["contacto"],
        logo: json["logo"],
        facturas: json["facturas"] == null ? [] : List<Factura>.from(json["facturas"]!.map((x) => Factura.fromMap(x))),
        tae: json["tasa_anual"]?.toDouble(),
      );

  Map<String, dynamic> toMap() => {
        "cliente_id": clienteId,
        "nombre_fiscal": nombreFiscal,
        "sociedad": sociedad,
        "codigo_cliente": codigoCliente,
        //"contacto": contacto,
        "logo": logo,
        "facturas": facturas == null ? [] : List<dynamic>.from(facturas!.map((x) => x.toMap())),
        "tasa_anual": tae,
      };
}
