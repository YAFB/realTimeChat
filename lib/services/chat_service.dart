import 'dart:convert';

import 'package:chat_app/global/enviroment.dart';
import 'package:chat_app/models/mensajes.dart';
import 'package:chat_app/models/usuario.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ChatService with ChangeNotifier {
  final Dio dio = Dio();
  Response? response;

  late Usuario usuarioPara;

  Future<Map<String, dynamic>> getChat({required String idUsuario}) async {
    try {
      response = await dio.get("${Enviroment.apiUrl}/mensajes/$idUsuario",
          options: Options(
            headers: {
              'content-Type': 'application/json',
              'x-token': await AuthService.getToken(),
            },
          ));

      final List<Mensajes> mensajes =
          mensajesFromJson(jsonEncode(response!.data["mensajes"]));

      return {"ok": true, "data": mensajes};
    } on DioException catch (e) {
      print(e.response!.data);
      return {"ok": false};
    }
  }
}
