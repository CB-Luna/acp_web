import 'dart:convert';

class Cliente {
  Cliente({
    required this.clienteId,
    required this.codigoAcreedor,
    required this.sociedad,
  });

  int clienteId;
  String codigoAcreedor;
  String sociedad;

  factory Cliente.fromJson(String str) => Cliente.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Cliente.fromMap(Map<String, dynamic> json) {
    return Cliente(
      clienteId: json["cliente_id"],
      codigoAcreedor: json["codigo_acreedor"],
      sociedad: json['sociedad'],
    );
  }

  Map<String, dynamic> toMap() => {
        "cliente_id": clienteId,
        "codigo_acreedor": codigoAcreedor,
        'sociedad': sociedad,
      };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Cliente && other.clienteId == clienteId && other.codigoAcreedor == codigoAcreedor;
  }

  @override
  int get hashCode => Object.hash(clienteId, codigoAcreedor);
}
