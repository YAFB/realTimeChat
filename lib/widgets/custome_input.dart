import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final String? hintText;
  final double? radius;
  final EdgeInsets? contentPadding;
  final TextEditingController controller;
  final bool? isPassword;

  const CustomInput({
    super.key,
    this.keyboardType,
    this.prefixIcon,
    this.hintText,
    this.radius,
    this.contentPadding,
    required this.controller,
    this.isPassword,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType ?? TextInputType.text,
      decoration: InputDecoration(
        contentPadding: contentPadding,
        prefixIcon: prefixIcon,
        border: OutlineInputBorder(
          borderSide: const BorderSide(),
          borderRadius: BorderRadius.circular(radius ?? 0),
        ),
        hintText: hintText,
      ),
      obscureText: isPassword ?? false,
    );
  }
}
