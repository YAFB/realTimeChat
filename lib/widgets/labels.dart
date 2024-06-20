import 'package:flutter/material.dart';

class Labels extends StatelessWidget {
  final String ruta;
  final String textoUno;
  final String textoDos;
  const Labels(
      {super.key,
      required this.ruta,
      required this.textoUno,
      required this.textoDos});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          textoUno,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 15,
            fontWeight: FontWeight.w300,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pushNamed(ruta);
          },
          child: Text(
            textoDos,
            style: TextStyle(
              color: Colors.blue[600],
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
