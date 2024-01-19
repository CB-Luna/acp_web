import 'dart:convert';

import 'package:acp_web/models/global/factura_model.dart';
import 'package:pluto_grid/pluto_grid.dart';

class AutorizacionSolicitudesPagoanticipado {
  int? clienteId;
  String? nombreFiscal;
  String? sociedad;
  String? codigoCliente;
  String? logo;
  //
  DateTime? fechaSolicitud;
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
  double? comision = 0;
  double? margenOperativo = 0;
  double? utilidadNeta = 0;
  double? pagoAdelantado = 0;
  //
  bool isExpanded = false;
  bool bloqueado = false;

  AutorizacionSolicitudesPagoanticipado({
    this.clienteId,
    this.nombreFiscal,
    this.sociedad,
    this.codigoCliente,
    this.logo,
    //
    this.fechaSolicitud,
    //
    this.condPago,
    this.tasaAnual,
    this.tae,
    this.facturacionMayorA,
    this.tasaPreferencial,
    //
    this.facturas,
  });

  factory AutorizacionSolicitudesPagoanticipado.fromJson(String str) => AutorizacionSolicitudesPagoanticipado.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AutorizacionSolicitudesPagoanticipado.fromMap(Map<String, dynamic> json) => AutorizacionSolicitudesPagoanticipado(
        clienteId: json["cliente_id"],
        nombreFiscal: json["nombre_fiscal"],
        sociedad: json["sociedad"],
        codigoCliente: json["codigo_cliente"],
        logo: json["logo"],
        //
        fechaSolicitud: json["fecha_solicitud"] == null ? null : DateTime.parse(json["fecha_solicitud"]),
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
        "fecha_solicitud": "${fechaSolicitud!.year.toString().padLeft(4, '0')}-${fechaSolicitud!.month.toString().padLeft(2, '0')}-${fechaSolicitud!.day.toString().padLeft(2, '0')}",
        //
        "cond_pago": condPago,
        "tasa_anual": tae,
        "facturacion_mayor_a": facturacionMayorA,
        "tasa_preferencial": tasaPreferencial,
        //
        "facturas": facturas == null ? [] : List<dynamic>.from(facturas!.map((x) => x.toMap())),
      };
}
