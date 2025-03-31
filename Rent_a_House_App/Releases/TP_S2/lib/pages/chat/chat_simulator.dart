import 'package:flutter/material.dart';
import 'package:rent_a_house/pages/s1/pages/home/navbar.dart';
import 'package:rent_a_house/pages/s1/pages/Home/home.dart' as sone;

void main() {
  runApp(ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat App',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        colorScheme: ColorScheme.light(
          primary: Colors.cyan,
          secondary: Colors.orange,
        ),
      ),
      initialRoute: '/chat', //Rotas
      routes: {
        '/chat': (context) => ChatScreen(), //Aplicação de chat
        '/': (context) => sone.HomeScreen(), //Página Inicial
      },
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreen();
}

class _ChatScreen extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isLocatario = true;

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(
          text: _messageController.text.trim(),
          isSentByLocatario: _isLocatario,
          timestamp: DateTime.now(),
        ),
      );
      _messageController.clear();
    });
  }

  void _simulateReply() {
    setState(() {
      _messages.add(
        ChatMessage(
          text:
              _isLocatario ? "Resposta do inquilino" : "Resposta do locatário",
          isSentByLocatario: !_isLocatario,
          timestamp: DateTime.now(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Navbar(),
      appBar: AppBar(
        //------------------------------------> AppBar
        backgroundColor: Colors.cyan[700],
        title: Text("Chat Simulator", style: TextStyle(color: Colors.white)),

        leading: Builder(
          builder:
              (context) => IconButton(
                icon: Icon(Icons.person_2_rounded),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
        ), // Fim do Icone Home
        actions: [
          Row(
            children: [
              Text(
                _isLocatario ? "Locatário" : "Inquilino",
                style: TextStyle(color: Colors.white),
              ),
              Switch(
                value: _isLocatario,
                activeColor: Colors.orange,
                onChanged: (value) {
                  setState(() {
                    _isLocatario = value;
                  });
                },
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[_messages.length - 1 - index];
                return _buildMessageBubble(message);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.attach_file, color: Colors.cyan[700]),
                  onPressed: () {
                    // Ação para anexar arquivo (não implementada)
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Funcionalidade de anexar arquivo (não desenvolvida)",
                        ),
                      ),
                    );
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Digite uma mensagem...",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.cyan),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Column(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _sendMessage,
                      child: Text("Enviar"),
                    ),
                    SizedBox(height: 4),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyan[700],
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _simulateReply,
                      child: Text("Simular"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isMe = message.isSentByLocatario == _isLocatario;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isMe ? Colors.cyan[100] : Colors.orange[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isMe ? Colors.cyan[300]! : Colors.orange[300]!,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(message.text, style: TextStyle(fontSize: 16)),
              SizedBox(height: 4),
              Text(
                '${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2, '0')}',
                style: TextStyle(
                  fontSize: 10,
                  color: isMe ? Colors.cyan[800] : Colors.orange[800],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isSentByLocatario;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isSentByLocatario,
    required this.timestamp,
  });
}
