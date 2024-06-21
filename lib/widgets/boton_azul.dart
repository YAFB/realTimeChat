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
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return Colors.grey; // Color cuando el botón está deshabilitado
            }
            return Colors.blue; // Color cuando el botón está habilitado
          },
        ),
        foregroundColor: WidgetStateProperty.resolveWith<Color>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return Colors
                  .black; // Color del texto cuando el botón está deshabilitado
            }
            return Colors
                .white; // Color del texto cuando el botón está habilitado
          },
        ),
      ),
      onPressed: onPressed,
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
