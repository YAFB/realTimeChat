import 'package:flutter/material.dart';

mostrarAlert({
  required BuildContext context,
  required String mensaje,
  required Color color,
}) {
  final snackBarWidget = SnackBar(
    content: Text(
      mensaje,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
    ),
    backgroundColor: color,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBarWidget);
}
