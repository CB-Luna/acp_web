import 'dart:convert';

class ClienteSap {
  ClienteSap({
    required this.clienteSapId,
    required this.codigoCliente,
    required this.nombreFiscal,
    required this.identificadorFiscal,
    required this.sociedad,
    required this.direccion,
    required this.fechaExtraccion,
    required this.condicionPago,
    required this.numeroCuenta,
    this.bancoIndustrial,
    this.tipoCuenta,
    this.moneda,
    required this.tasaAnual,
  });

  int clienteSapId;
  String codigoCliente;
  String nombreFiscal;
  String identificadorFiscal;
  String sociedad;
  String direccion;
  DateTime fechaExtraccion;
  int condicionPago;
  String numeroCuenta;
  String? bancoIndustrial;
  String? tipoCuenta;
  String? moneda;
  num tasaAnual;

  factory ClienteSap.fromJson(String str) => ClienteSap.fromMap(json.decode(str));

  factory ClienteSap.fromMap(Map<String, dynamic> json) {
    return ClienteSap(
      clienteSapId: json["cliente_sap_id"],
      codigoCliente: json["codigo_cliente"],
      nombreFiscal: json['nombre_fiscal'],
      identificadorFiscal: json['identificador_fiscal'],
      direccion: json['direccion'],
      fechaExtraccion: DateTime.parse(json['fecha_extraccion']),
      condicionPago: json['condicion_pago'],
      numeroCuenta: json['numero_cuenta'],
      bancoIndustrial: json['banco_industrial'],
      tipoCuenta: json['tipo_cuenta'],
      moneda: json['moneda'],
      tasaAnual: json['tasa_anual'],
      sociedad: json['sociedad'],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ClienteSap && other.clienteSapId == clienteSapId && other.codigoCliente == codigoCliente;
  }

  @override
  int get hashCode => Object.hash(clienteSapId, codigoCliente);
}
