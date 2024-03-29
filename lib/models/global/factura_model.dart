import 'dart:convert';

class Factura {
  String? noDoc;
  String? moneda;
  double? importe;
  double? cantComision;
  double? porcComision;
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
  DateTime? fechaNormalPago;

  ///
  DateTime? fechaEjecucion;
  DateTime? fechaSolicitud;

  //
  double? upfn = 0;
  double? mpfn = 0;

  Factura({
    this.noDoc,
    this.moneda,
    this.importe,
    this.cantComision,
    this.porcComision,
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
    this.fechaNormalPago,

    ///
    this.fechaEjecucion,
    this.fechaSolicitud,
  });

  factory Factura.fromJson(String str) => Factura.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Factura.fromMap(Map<String, dynamic> json) => Factura(
        noDoc: json["no_doc"],
        moneda: json["moneda"],
        importe: json["importe"]?.toDouble(),
        cantComision: json["cant_comision"]?.toDouble(),
        porcComision: json["porc_comision"]?.toDouble(),
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
        fechaNormalPago: json["fecha_normal_pago"] == null ? null : DateTime.parse(json["fecha_normal_pago"]),

        ///
        fechaEjecucion: json["fecha_ejecucion"] == null ? null : DateTime.parse(json["fecha_ejecucion"]),
        fechaSolicitud: json["fecha_solicitud"] == null ? null : DateTime.parse(json["fecha_solicitud"]),
      );

  Map<String, dynamic> toMap() => {
        "no_doc": noDoc,
        "moneda": moneda,
        "importe": importe,
        "cant_comision": cantComision,
        "porc_comision": porcComision,
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
        "fecha_normal_pago": fechaNormalPago?.toIso8601String(),

        ///
        "fecha_ejecucion": fechaEjecucion?.toIso8601String(),
        "fecha_solicitud": fechaSolicitud?.toIso8601String(),
      };
}
