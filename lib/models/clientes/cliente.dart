import 'dart:convert';

import 'package:acp_web/helpers/globals.dart';
import 'package:acp_web/models/clientes/contacto.dart';

class Cliente {
  Cliente({
    this.clienteId,
    required this.codigoCliente,
    required this.nombreFiscal,
    required this.identificadorFiscal,
    required this.sociedadActual,
    required this.sociedades,
    required this.direccion,
    this.imagen,
    required this.fechaRegistro,
    required this.condicionPago,
    required this.numeroCuenta,
    this.bancoIndustrial,
    this.tipoCuenta,
    this.moneda,
    this.tasaAnual,
    this.tasaPreferencial,
    this.facturacionMayorA,
    this.acuerdoComercial,
    this.fechaContrato,
    required this.activo,
    required this.contactos,
  });

  int? clienteId;
  String codigoCliente;
  String nombreFiscal;
  String identificadorFiscal;
  String sociedadActual;
  List<String> sociedades;
  String direccion;
  String? imagen;
  DateTime fechaRegistro;
  int condicionPago;
  String numeroCuenta;
  String? bancoIndustrial;
  String? tipoCuenta;
  String? moneda;
  num? tasaAnual;
  num? tasaPreferencial;
  num? facturacionMayorA;
  String? acuerdoComercial;
  DateTime? fechaContrato;
  bool activo;
  List<Contacto> contactos;

  String get estatus => activo ? 'Activo' : 'Inactivo';

  String? get imageUrl => imagen != null ? supabase.storage.from('logo-clientes').getPublicUrl(imagen!) : null;

  factory Cliente.fromJson(String str) => Cliente.fromMap(json.decode(str));

  factory Cliente.fromMap(Map<String, dynamic> json) {
    return Cliente(
      clienteId: json["cliente_id"],
      codigoCliente: json["codigo_cliente"],
      nombreFiscal: json['nombre_fiscal'],
      identificadorFiscal: json['identificador_fiscal'],
      direccion: json['direccion'],
      sociedadActual: json['sociedad'],
      imagen: json['logo'],
      fechaRegistro: DateTime.parse(json['fecha_registro']),
      condicionPago: json['condicion_pago'],
      numeroCuenta: json['numero_cuenta'],
      bancoIndustrial: json['banco_industrial'],
      tipoCuenta: json['tipo_cuenta'],
      moneda: json['moneda'],
      tasaAnual: json['tasa_anual'],
      tasaPreferencial: json['tasa_preferencial'],
      facturacionMayorA: json['facturacion_mayor_a'],
      acuerdoComercial: json['acuerdo_comercial'],
      fechaContrato: json['fecha_contrato'] != null ? DateTime.parse(json['fecha_contrato']) : null,
      sociedades: (json['sociedades'] as List<dynamic>).map((e) => e as String).toList(),
      activo: json['activo'],
      contactos: (json['contactos'] as List).map((contacto) => Contacto.fromMap(contacto)).toList(),
    );
  }

  factory Cliente.fromClienteSap(Map<String, dynamic> json) {
    return Cliente(
      codigoCliente: json["codigo_cliente"],
      nombreFiscal: json['nombre_fiscal'],
      identificadorFiscal: json['identificador_fiscal'],
      sociedadActual: json['sociedad'],
      direccion: json['direccion'],
      fechaRegistro: DateTime.now(),
      condicionPago: json['condicion_pago'],
      numeroCuenta: json['numero_cuenta'],
      bancoIndustrial: json['banco_industrial'],
      tipoCuenta: json['tipo_cuenta'],
      moneda: json['moneda'],
      sociedades: [json['sociedad']],
      activo: true,
      contactos: [],
    );
  }

  Map<String, dynamic> toMapTablaCliente() => {
        "codigo_cliente": codigoCliente,
        "nombre_fiscal": nombreFiscal,
        "identificador_fiscal": identificadorFiscal,
        "direccion": direccion,
        "logo": imagen,
        "numero_cuenta": numeroCuenta,
        "banco_industrial": bancoIndustrial,
        "tipo_cuenta": tipoCuenta,
        "moneda": moneda,
      };

  Map<String, dynamic> toMapTablaClienteSociedad() => {
        "condicion_pago": condicionPago,
        "tasa_anual": tasaAnual,
        "tasa_preferencial": tasaPreferencial,
        "facturacion_mayor_a": facturacionMayorA,
        "acuerdo_comercial": acuerdoComercial,
        "fecha_contrato": fechaContrato?.toIso8601String(),
      };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Cliente && other.clienteId == clienteId && other.codigoCliente == codigoCliente;
  }

  @override
  int get hashCode => Object.hash(clienteId, codigoCliente);
}
