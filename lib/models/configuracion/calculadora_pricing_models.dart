import 'dart:convert';

class CalculadoraPricing {
    int? id;
    DateTime? createdAt;
    int? costoFinanciero;
    int? costoOperativo;
    int? tarifaGo;
    int? isr;
    int? asignacionCapital;
    int? costoCapital;
    int? probabilidadIncremento;
    int? perdidaIncumplimineto;

    CalculadoraPricing({
        this.id,
        this.createdAt,
        this.costoFinanciero,
        this.costoOperativo,
        this.tarifaGo,
        this.isr,
        this.asignacionCapital,
        this.costoCapital,
        this.probabilidadIncremento,
        this.perdidaIncumplimineto,
    });

    factory CalculadoraPricing.fromJson(String str) => CalculadoraPricing.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory CalculadoraPricing.fromMap(Map<String, dynamic> json) => CalculadoraPricing(
        id: json["id"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        costoFinanciero: json["costo_financiero"],
        costoOperativo: json["costo_operativo"],
        tarifaGo: json["tarifa_GO"],
        isr: json["ISR"],
        asignacionCapital: json["asignacion_capital"],
        costoCapital: json["costo_capital"],
        probabilidadIncremento: json["probabilidad_incremento"],
        perdidaIncumplimineto: json["perdida_incumplimineto"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "created_at": createdAt?.toIso8601String(),
        "costo_financiero": costoFinanciero,
        "costo_operativo": costoOperativo,
        "tarifa_GO": tarifaGo,
        "ISR": isr,
        "asignacion_capital": asignacionCapital,
        "costo_capital": costoCapital,
        "probabilidad_incremento": probabilidadIncremento,
        "perdida_incumplimineto": perdidaIncumplimineto,
    };
}
