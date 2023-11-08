import 'dart:convert';

import 'package:acp_web/models/global/factura_model.dart';
import 'package:pluto_grid/pluto_grid.dart';

class SeleccionPagosAnticipados {
  int? clienteId;
  String? nombreFiscal;
  String? sociedad;
  String? codigoCliente;
  //String? contacto;
  String? logoUrl;
  List<Factura>? facturas;
  List<PlutoRow>? rows = [];
  int? facturasSeleccionadas = 0;
  double? facturacion = 0;
  double? beneficio = 0;
  double? pagoAdelantado = 0;
  bool isExpanded = false;

  SeleccionPagosAnticipados({
    this.clienteId,
    this.nombreFiscal,
    this.sociedad,
    this.codigoCliente,
    //this.contacto,
    this.logoUrl,
    this.facturas,
  });

  factory SeleccionPagosAnticipados.fromJson(String str) => SeleccionPagosAnticipados.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SeleccionPagosAnticipados.fromMap(Map<String, dynamic> json) => SeleccionPagosAnticipados(
        clienteId: json["cliente_id"],
        nombreFiscal: json["nombre_fiscal"],
        sociedad: json["sociedad"],
        codigoCliente: json["codigo_cliente"],
        //contacto: json["contacto"],
        logoUrl: json["logo_url"],
        facturas: json["facturas"] == null ? [] : List<Factura>.from(json["facturas"]!.map((x) => Factura.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "cliente_id": clienteId,
        "nombre_fiscal": nombreFiscal,
        "sociedad": sociedad,
        "codigo_cliente": codigoCliente,
        //"contacto": contacto,
        "logo_url": logoUrl,
        "facturas": facturas == null ? [] : List<dynamic>.from(facturas!.map((x) => x.toMap())),
      };
}
