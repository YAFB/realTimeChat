import 'package:chat_app/pages/usuarios_page.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Loading Page"),
      ),
      body: Scaffold(
        body: FutureBuilder(
          future: checkLoginState(context),
          builder: (context, snapshot) {
            return Center();
          },
        ),
      ),
    );
  }

  Future checkLoginState(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);

    final autenticado = await authService.isLoggedIn();

    if (autenticado["ok"]) {
      Navigator.of(context).pushReplacementNamed('usuarios');
      // Navigator.of(context).pushReplacement(PageRouteBuilder(
      //   pageBuilder: (_, __, ___) => const UsuariosPage(),
      // ));
    } else {
      Navigator.of(context).pushReplacementNamed('login');
    }
  }
}
