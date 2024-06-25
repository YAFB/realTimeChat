import 'dart:convert';

import 'package:chat_app/global/enviroment.dart';
import 'package:chat_app/models/usuario.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:dio/dio.dart';

class UsuariosService {
  final Dio dio = Dio();
  Response? response;

  Future<Map<String, dynamic>> getUsuarios() async {
    try {
      response = await dio.get("${Enviroment.apiUrl}/usuarios",
          options: Options(
            headers: {
              'content-Type': 'application/json',
              'x-token': await AuthService.getToken(),
            },
          ));

      final List<Usuario> usuarios =
          usuariosListFromJson(jsonEncode(response!.data["usuarios"]));

      return {"ok": true, "data": usuarios};
    } on DioException catch (e) {
      print(e.response!.data);
      return {"ok": false};
    }
  }
}
