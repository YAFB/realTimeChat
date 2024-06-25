import 'package:chat_app/models/usuario.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/chat_service.dart';
import 'package:chat_app/services/socket_service.dart';
import 'package:chat_app/services/usuarios_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UsuariosPage extends StatefulWidget {
  const UsuariosPage({super.key});

  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  List<Usuario> usuarios = [];

  @override
  void initState() {
    Future.delayed(
      Duration.zero,
      () {
        _cargarUsuarios();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final Usuario usuario = authService.usuario!;
    final socketService = Provider.of<SocketService>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(usuario.nombre),
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            socketService.disconnect();
            AuthService.deleteToken();
            Navigator.of(context).pushReplacementNamed('login');
          },
          icon: const Icon(Icons.exit_to_app),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: socketService.serveStatus == ServerStatus.online
                ? Icon(Icons.check_circle, color: Colors.blue[400])
                : Icon(Icons.offline_bolt, color: Colors.red[400]),
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
      onTap: () {
        final chatService = Provider.of<ChatService>(context, listen: false);
        chatService.usuarioPara = usuario;

        Navigator.of(context).pushNamed('chat');
      },
    );
  }

  Future<void> _cargarUsuarios() async {
    final usuariosService = UsuariosService();
    final response = await usuariosService.getUsuarios();
    usuarios = response["data"];
    setState(() {});
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
  }
}
