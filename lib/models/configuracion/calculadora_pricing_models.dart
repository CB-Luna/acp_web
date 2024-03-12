import 'dart:convert';

class CalculadoraPricing {
    int? id;
    double? costoFinanciero;
    double? costoOperativo;
    double? tarifaGo;
    double? isr;
    double? asignacionCapital;
    double? costoCapital;
    double? probabilidadIncremento;
    double? perdidaIncumplimineto;
    String? sociedad;

    CalculadoraPricing({
        this.id,
        this.costoFinanciero,
        this.costoOperativo,
        this.tarifaGo,
        this.isr,
        this.asignacionCapital,
        this.costoCapital,
        this.probabilidadIncremento,
        this.perdidaIncumplimineto,
        this.sociedad,
    });

    factory CalculadoraPricing.fromJson(String str) => CalculadoraPricing.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory CalculadoraPricing.fromMap(Map<String, dynamic> json) => CalculadoraPricing(
        id: json["id"],
        costoFinanciero: json["costo_financiero"]?.toDouble(),
        costoOperativo: json["costo_operativo"]?.toDouble(),
        tarifaGo: json["tarifa_GO"]?.toDouble(),
        isr: json["ISR"]?.toDouble(),
        asignacionCapital: json["asignacion_capital"]?.toDouble(),
        costoCapital: json["costo_capital"]?.toDouble(),
        probabilidadIncremento: json["probabilidad_incremento"]?.toDouble(),
        perdidaIncumplimineto: json["perdida_incumplimineto"]?.toDouble(),
        sociedad: json["sociedad"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "costo_financiero": costoFinanciero,
        "costo_operativo": costoOperativo,
        "tarifa_GO": tarifaGo,
        "ISR": isr,
        "asignacion_capital": asignacionCapital,
        "costo_capital": costoCapital,
        "probabilidad_incremento": probabilidadIncremento,
        "perdida_incumplimineto": perdidaIncumplimineto,
        "sociedad": sociedad,
    };
}
