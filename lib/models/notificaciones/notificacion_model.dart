import 'dart:convert';

class Notificacion {
  int? id;
  String? mensaje;
  DateTime? fechaRecepcion;
  dynamic fechaLectura;
  String? from;
  String? subject;
  String? to;
  dynamic leida;
  dynamic imagen;
  String? tipo;
  dynamic link;

  Notificacion({
    this.id,
    this.mensaje,
    this.fechaRecepcion,
    this.fechaLectura,
    this.from,
    this.subject,
    this.to,
    this.leida,
    this.imagen,
    this.tipo,
    this.link,
  });

  factory Notificacion.fromJson(String str) => Notificacion.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Notificacion.fromMap(Map<String, dynamic> json) => Notificacion(
        id: json["id"],
        mensaje: json["mensaje"],
        fechaRecepcion: json["fecha_recepcion"] == null ? null : DateTime.parse(json["fecha_recepcion"]),
        fechaLectura: json["fecha_lectura"],
        from: json["from"],
        subject: json["subject"],
        to: json["to"],
        leida: json["leida"],
        imagen: json["imagen"],
        tipo: json["tipo"],
        link: json["link"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "mensaje": mensaje,
        "fecha_recepcion": fechaRecepcion?.toIso8601String(),
        "fecha_lectura": fechaLectura,
        "from": from,
        "subject": subject,
        "to": to,
        "leida": leida,
        "imagen": imagen,
        "tipo": tipo,
        "link": link,
      };
}
