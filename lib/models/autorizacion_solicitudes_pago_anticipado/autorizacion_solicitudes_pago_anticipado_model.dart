import 'dart:convert';

import 'package:acp_web/models/global/factura_model.dart';
import 'package:pluto_grid/pluto_grid.dart';

class AutorizacionSolicitudesPagoanticipado {
  int? clienteId;
  String? nombreFiscal;
  String? sociedad;
  String? codigoCliente;
  //String? contacto;
  String? logoUrl;
  DateTime? fechaSolicitud;
  List<Factura>? facturas;
  List<PlutoRow>? rows = [];
  int? facturasSeleccionadas = 0;
  double? facturacion = 0;
  double? beneficio = 0;
  double? pagoAdelantado = 0;
  bool isExpanded = false;

  AutorizacionSolicitudesPagoanticipado({
    this.clienteId,
    this.nombreFiscal,
    this.sociedad,
    this.codigoCliente,
    //this.contacto,
    this.logoUrl,
    this.fechaSolicitud,
    this.facturas,
  });

  factory AutorizacionSolicitudesPagoanticipado.fromJson(String str) => AutorizacionSolicitudesPagoanticipado.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AutorizacionSolicitudesPagoanticipado.fromMap(Map<String, dynamic> json) => AutorizacionSolicitudesPagoanticipado(
        clienteId: json["cliente_id"],
        nombreFiscal: json["nombre_fiscal"],
        sociedad: json["sociedad"],
        codigoCliente: json["codigo_cliente"],
        //contacto: json["contacto"],
        logoUrl: json["logo_url"],
        fechaSolicitud: json["fecha_solicitud"] == null ? null : DateTime.parse(json["fecha_solicitud"]),
        facturas: json["facturas"] == null ? [] : List<Factura>.from(json["facturas"]!.map((x) => Factura.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "cliente_id": clienteId,
        "nombre_fiscal": nombreFiscal,
        "sociedad": sociedad,
        "codigo_cliente": codigoCliente,
        //"contacto": contacto,
        "logo_url": logoUrl,
        "fecha_solicitud": "${fechaSolicitud!.year.toString().padLeft(4, '0')}-${fechaSolicitud!.month.toString().padLeft(2, '0')}-${fechaSolicitud!.day.toString().padLeft(2, '0')}",
        "facturas": facturas == null ? [] : List<dynamic>.from(facturas!.map((x) => x.toMap())),
      };
}
