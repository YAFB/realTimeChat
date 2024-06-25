// To parse this JSON data, do
//
//     final usuario = usuarioFromJson(jsonString);

import 'dart:convert';

Usuario usuarioFromJson(String str) => Usuario.fromJson(json.decode(str));

String usuarioToJson(Usuario data) => json.encode(data.toJson());

List<Usuario> usuariosListFromJson(String str) =>
    List<Usuario>.from(json.decode(str).map((x) => Usuario.fromJson(x)));

String usuariosListToJson(List<Usuario> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Usuario {
  String nombre;
  String email;
  bool online;
  String uid;

  Usuario({
    required this.nombre,
    required this.email,
    required this.online,
    required this.uid,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        nombre: json["nombre"],
        email: json["email"],
        online: json["online"],
        uid: json["uid"],
      );

  Map<String, dynamic> toJson() => {
        "nombre": nombre,
        "email": email,
        "online": online,
        "uid": uid,
      };
}
