// To parse this JSON data, do
//
//     final mensajes = mensajesFromJson(jsonString);

import 'dart:convert';

List<Mensajes> mensajesFromJson(String str) =>
    List<Mensajes>.from(json.decode(str).map((x) => Mensajes.fromJson(x)));

String mensajesToJson(List<Mensajes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Mensajes {
  String de;
  String para;
  String mensaje;
  DateTime createdAt;
  DateTime updatedAt;

  Mensajes({
    required this.de,
    required this.para,
    required this.mensaje,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Mensajes.fromJson(Map<String, dynamic> json) => Mensajes(
        de: json["de"],
        para: json["para"],
        mensaje: json["mensaje"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "de": de,
        "para": para,
        "mensaje": mensaje,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
