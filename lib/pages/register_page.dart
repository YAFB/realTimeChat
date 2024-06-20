import 'package:chat_app/widgets/boton_azul.dart';
import 'package:chat_app/widgets/custome_input.dart';
import 'package:chat_app/widgets/labels.dart';
import 'package:chat_app/widgets/logo.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * .9,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Logo(titulo: "Registro"),
                _Form(),
                Labels(
                  ruta: "login",
                  textoUno: "¿Ya tienes cuenta?",
                  textoDos: "Ingresa ahora",
                ),
                Text(
                  'Términos y condiciones de uso',
                  style: TextStyle(fontWeight: FontWeight.w200),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  const _Form();

  @override
  State<_Form> createState() => _FormState();
}

class _FormState extends State<_Form> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          const SizedBox(height: 15),
          CustomInput(
            keyboardType: TextInputType.text,
            radius: 20,
            hintText: "Nombre",
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            prefixIcon: const Icon(Icons.person_2_outlined),
            controller: _nameController,
          ),
          const SizedBox(height: 15),
          CustomInput(
            keyboardType: TextInputType.emailAddress,
            radius: 20,
            hintText: "Correo electronico",
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            prefixIcon: const Icon(Icons.email_outlined),
            controller: _emailController,
          ),
          const SizedBox(height: 15),
          CustomInput(
            keyboardType: TextInputType.visiblePassword,
            radius: 20,
            hintText: "Contraseña",
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            prefixIcon: const Icon(Icons.lock_outline),
            controller: _passwordController,
            isPassword: true,
          ),
          const SizedBox(height: 25),
          BotonAzul(
            textButton: "Registrar",
            onPressed: () {
              print(_emailController.text);
              print(_passwordController.text);
            },
          )
        ],
      ),
    );
  }
}
