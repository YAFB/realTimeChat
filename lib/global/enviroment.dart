import 'dart:io';

class Enviroment {
  static String apiUrl = Platform.isAndroid
      ? "http://192.168.1.71:3002/api"
      : "http://localhost:3002/api";

  static String socketUrl =
      Platform.isAndroid ? "http://192.168.1.71:3002" : "http://localhost:3002";
}
