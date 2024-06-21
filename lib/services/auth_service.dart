import 'dart:convert';

import 'package:chat_app/global/enviroment.dart';
import 'package:chat_app/models/login_response.dart';
import 'package:chat_app/models/usuario.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService with ChangeNotifier {
  final Dio dio = Dio();
  Response? response;

  Usuario? usuario;

  bool _autenticando = false;

  // Create storage
  final storage = const FlutterSecureStorage();

  bool get autenticando => _autenticando;
  set autenticando(bool valor) {
    _autenticando = valor;
    notifyListeners();
  }

  // getters del token de fomra estatica
  static Future<String> getToken() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    return token!;
  }

  static Future<void> deleteToken() async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: 'token');
  }

  Future<Map<String, dynamic>> login(
      {required String email, required String password}) async {
    autenticando = true;

    final data = {
      'email': email,
      'password': password,
    };

    try {
      response = await dio.post(
        "${Enviroment.apiUrl}/login",
        data: jsonEncode(data),
        options: Options(
          headers: {'content-Type': 'application/json'},
        ),
      );
      // print(response!.data);
      final LoginResponse userInfo =
          loginResponseFromJson(jsonEncode(response!.data));
      usuario = userInfo.usuario;
      await _guardarToken(userInfo.token);
      autenticando = false;
      return {
        "ok": true,
        "data": userInfo,
      };
    } on DioException catch (e) {
      autenticando = false;
      return {"ok": false, "msg": e.error ?? e.response!.data["msg"]};
    }
  }

  Future<Map<String, dynamic>> register(
      {required String nombre,
      required String email,
      required String password}) async {
    autenticando = true;

    final data = {
      'nombre': nombre,
      'email': email,
      'password': password,
    };

    try {
      response = await dio.post(
        "${Enviroment.apiUrl}/login/new",
        data: jsonEncode(data),
        options: Options(
          headers: {'content-Type': 'application/json'},
        ),
      );

      final LoginResponse userInfo =
          loginResponseFromJson(jsonEncode(response!.data));
      usuario = userInfo.usuario;
      await _guardarToken(userInfo.token);

      autenticando = false;
      return {
        "ok": true,
      };
    } on DioException catch (e) {
      autenticando = false;
      return {"ok": false, "msg": e.error ?? e.response!.data["msg"]};
    }
  }

  Future<Map<String, dynamic>> isLoggedIn() async {
    final token = await storage.read(key: 'token');
    try {
      response = await dio.get(
        "${Enviroment.apiUrl}/login/renew",
        options: Options(
          headers: {
            'content-Type': 'application/json',
            'x-token': token,
          },
        ),
      );
      final LoginResponse userInfo =
          loginResponseFromJson(jsonEncode(response!.data));
      usuario = userInfo.usuario;
      await _guardarToken(userInfo.token);
      return {
        "ok": true,
      };
    } on DioException catch (e) {
      logOut();
      return {
        "ok": false,
        "msg": e.error ?? e.response!.data["msg"],
      };
    }
  }

  Future<dynamic> _guardarToken(String token) async {
    // Write value
    return await storage.write(key: 'token', value: token);
  }

  Future<void> logOut() async {
    await storage.delete(key: 'token');
  }
}
