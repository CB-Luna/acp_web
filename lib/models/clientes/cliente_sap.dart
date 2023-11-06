import 'dart:convert';

class ClienteSap {
  ClienteSap({
    required this.clienteId,
    required this.codigoCliente,
    required this.nombreFiscal,
    required this.identificadorFiscal,
    required this.sociedad,
    required this.direccion,
    this.imagen,
    required this.fechaRegistro,
    required this.condicionPago,
    required this.numeroCuenta,
    this.bancoIndustrial,
    this.tipoCuenta,
    this.moneda,
    required this.tasaAnual,
    this.formula,
    this.acuerdoComercial,
    required this.activo,
  });

  int clienteId;
  String codigoCliente;
  String nombreFiscal;
  String identificadorFiscal;
  String sociedad;
  String direccion;
  String? imagen;
  DateTime fechaRegistro;
  int condicionPago;
  String numeroCuenta;
  String? bancoIndustrial;
  String? tipoCuenta;
  String? moneda;
  num tasaAnual;
  String? formula;
  String? acuerdoComercial;
  bool activo;

  String get estatus => activo ? 'Activo' : 'Inactivo';

  factory ClienteSap.fromJson(String str) => ClienteSap.fromMap(json.decode(str));

  factory ClienteSap.fromMap(Map<String, dynamic> json) {
    return ClienteSap(
        clienteId: json["cliente_id"],
        codigoCliente: json["codigo_cliente"],
        nombreFiscal: json['nombre_fiscal'],
        identificadorFiscal: json['identificador_fiscal'],
        direccion: json['direccion'],
        imagen: json['logo_url'],
        fechaRegistro: DateTime.parse(json['fecha_registro']),
        condicionPago: json['condicion_pago'],
        numeroCuenta: json['numero_cuenta'],
        bancoIndustrial: json['banco_industrial'],
        tipoCuenta: json['tipo_cuenta'],
        moneda: json['moneda'],
        tasaAnual: json['tasa_anual'],
        formula: json['formula'],
        acuerdoComercial: json['acuerdo_comercial'],
        sociedad: json['sociedad'],
        activo: json['activo']);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ClienteSap && other.clienteId == clienteId && other.codigoCliente == codigoCliente;
  }

  @override
  int get hashCode => Object.hash(clienteId, codigoCliente);
}
