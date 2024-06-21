import 'package:chat_app/models/usuario.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UsuariosPage extends StatefulWidget {
  const UsuariosPage({super.key});

  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  final usuarios = [
    Usuario(online: true, email: "test1@test.com", nombre: "Yardiel", uid: "1"),
    Usuario(online: false, email: "test2@test.com", nombre: "Maria", uid: "2"),
    Usuario(online: true, email: "test3@test.com", nombre: "Jose", uid: "3"),
  ];

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final Usuario usuario = authService.usuario!;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(usuario.nombre),
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            AuthService.deleteToken();
            Navigator.of(context).pushReplacementNamed('login');
          },
          icon: const Icon(Icons.exit_to_app),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: Icon(Icons.check_circle, color: Colors.blue[400]),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _cargarUsuarios,
        child: _listViewUsuarios(),
      ),
    );
  }

  ListView _listViewUsuarios() {
    return ListView.separated(
      itemBuilder: (context, index) => _usuarioListTile(usuarios[index]),
      separatorBuilder: (context, index) => const Divider(),
      itemCount: usuarios.length,
    );
  }

  ListTile _usuarioListTile(Usuario usuario) {
    return ListTile(
      title: Text(usuario.nombre),
      subtitle: Text(usuario.email),
      leading: CircleAvatar(
        child: Text(usuario.nombre.substring(0, 2)),
      ),
      trailing: Icon(
        Icons.circle,
        color: usuario.online ? Colors.green[300] : Colors.red,
        size: 10,
      ),
    );
  }

  Future<void> _cargarUsuarios() async {
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
  }
}
