import 'dart:io';

import 'package:chat_app/models/mensajes.dart';
import 'package:chat_app/models/usuario.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/chat_service.dart';
import 'package:chat_app/services/socket_service.dart';
import 'package:chat_app/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  late ChatService chatService;
  late Usuario usuario;
  late SocketService socketService;
  late AuthService authService;

  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<ChatMessage> _messages = [];

  bool _estaEscribiendo = false;

  @override
  void initState() {
    Future.delayed(
      Duration.zero,
      () {
        chatService = Provider.of<ChatService>(context, listen: false);
        socketService = Provider.of<SocketService>(context, listen: false);
        authService = Provider.of<AuthService>(context, listen: false);
        usuario = chatService.usuarioPara;
        socketService.socket.on('mensaje-personal', _escucharMensaje);

        _cargarHistorial(chatService.usuarioPara.uid);
      },
    );
    super.initState();
  }

  void _escucharMensaje(dynamic data) {
    ChatMessage newMessage = ChatMessage(
      mensaje: data['mensaje'],
      uid: data['de'],
      animationController: AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      ),
    );

    setState(() {
      _messages.insert(0, newMessage);
    });

    newMessage.animationController.forward();
  }

  @override
  void dispose() {
    for (ChatMessage element in _messages) {
      element.animationController.dispose();
    }
    socketService.socket.off('mensaje-personal');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatService = Provider.of<ChatService>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue[100],
              child: Text(
                chatService.usuarioPara.nombre.substring(0, 2),
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
            const SizedBox(width: 3),
            Text(chatService.usuarioPara.nombre),
          ],
        ),
      ),
      body: Column(
        children: [
          Flexible(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: _messages.length,
              itemBuilder: (context, index) => _messages[index],
              reverse: true,
            ),
          ),
          const Divider(height: 1),
          Container(
            height: 50,
            color: Colors.white,
            child: _inputChat(),
          )
        ],
      ),
    );
  }

  Widget _inputChat() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                keyboardType: TextInputType.text,
                controller: _textController,
                focusNode: _focusNode,
                onSubmitted: _handleSubmit,
                onChanged: (value) {
                  setState(() {
                    if (value.trim().isNotEmpty) {
                      _estaEscribiendo = true;
                    } else {
                      _estaEscribiendo = false;
                    }
                  });
                },
                decoration:
                    const InputDecoration.collapsed(hintText: 'Enviar mensaje'),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: Platform.isIOS
                  ? CupertinoButton(
                      onPressed: _estaEscribiendo
                          ? () => _handleSubmit(_textController.text.trim())
                          : null,
                      child: const Text("Enviar"),
                    )
                  : Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      child: IconTheme(
                        data: IconThemeData(color: Colors.blue[400]),
                        child: IconButton(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onPressed: _estaEscribiendo
                                ? () =>
                                    _handleSubmit(_textController.text.trim())
                                : null,
                            icon: const Icon(Icons.send)),
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }

  void _handleSubmit(String mensaje) {
    // print(mensaje);
    _focusNode.requestFocus();
    if (mensaje.isNotEmpty) {
      _textController.clear();

      final newMessage = ChatMessage(
        mensaje: mensaje,
        uid: authService.usuario!.uid,
        animationController: AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 400),
        ),
      );

      _messages.insert(0, newMessage);
      newMessage.animationController.forward();
      setState(() {
        _estaEscribiendo = false;
      });

      socketService.emit('mensaje-personal', {
        "de": authService.usuario!.uid,
        "para": chatService.usuarioPara.uid,
        "mensaje": mensaje,
      });
    }
  }

  void _cargarHistorial(String uid) async {
    final response = await chatService.getChat(idUsuario: uid);
    List<Mensajes> mensajes = response['data'];

    final history = mensajes
        .map(
          (m) => ChatMessage(
            mensaje: m.mensaje,
            uid: m.de,
            animationController: AnimationController(
              vsync: this,
              duration: const Duration(milliseconds: 0),
            )..forward(),
          ),
        )
        .toList();

    setState(() {
      _messages = history;
    });
  }
}
