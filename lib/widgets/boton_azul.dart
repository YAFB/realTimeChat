import 'package:flutter/material.dart';

class BotonAzul extends StatelessWidget {
  final String textButton;
  final void Function()? onPressed;

  const BotonAzul({
    super.key,
    required this.textButton,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: const ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(Colors.blue),
      ),
      child: SizedBox(
        width: double.infinity,
        child: Text(
          textButton,
          style: const TextStyle(color: Colors.white, fontSize: 17),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
