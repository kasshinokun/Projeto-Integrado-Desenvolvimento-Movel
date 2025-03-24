<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ChatApp());
}

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: TestScreen(),
    );
  }
}

/// Tela de Teste com um botão para enviar mensagens de teste.
class TestScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Função para enviar uma mensagem de teste para o Firestore
  void _sendTestMessage() {
    _firestore.collection("messages").add({
      "text": "Mensagem de teste",
      "timestamp": FieldValue.serverTimestamp(),
      "isRead": false,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tela de Teste")),
      body: Column(
        children: [
          Expanded(child: ChatScreen()), // Exibe a tela do chat
          Padding(
            padding: EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _sendTestMessage,
              child: Text("Enviar Mensagem de Teste"),
            ),
          ),
        ],
      ),
    );
  }
}

/// Tela do Chat que exibe mensagens em tempo real e permite enviar novas mensagens.
class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _messageController = TextEditingController();

  // Função para enviar uma mensagem digitada pelo usuário
  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return; // Não envia mensagens vazias
    _firestore.collection("messages").add({
      "text": _messageController.text.trim(),
      "timestamp": FieldValue.serverTimestamp(),
      "isRead": false,
    });
    _messageController.clear(); // Limpa o campo de texto após o envio
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat com Firebase"),
        actions: [
          // Botão para acessar a tela de notificações
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationsScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Exibe as mensagens em tempo real
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection("messages")
                  .orderBy("timestamp", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator());
                var messages = snapshot.data!.docs;
                return ListView.builder(
                  reverse: true, // Exibe as mensagens mais recentes no topo
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return ListTile(title: Text(messages[index]["text"]));
                  },
                );
              },
            ),
          ),
          // Campo de texto e botão para enviar mensagens
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Digite uma mensagem...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _sendMessage,
                  child: Text("Enviar"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Tela de Notificações que exibe mensagens não lidas e permite marcá-las como lidas.
class NotificationsScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Função para marcar uma mensagem como lida
  void _markAsRead(DocumentSnapshot doc) {
    doc.reference.update({"isRead": true});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notificações")),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection("messages")
            .where("isRead", isEqualTo: false)
            .orderBy("timestamp", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          var messages = snapshot.data!.docs;
          if (messages.isEmpty)
            return Center(child: Text("Nenhuma nova notificação"));
          return ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              var message = messages[index];
              return Dismissible(
                key: Key(message.id),
                onDismissed: (direction) => _markAsRead(message),
                background: Container(
                  color: Colors.green,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 20),
                  child: Icon(Icons.check, color: Colors.white),
                ),
                child: ListTile(
                  title: Text(message["text"]),
                  trailing: IconButton(
                    icon: Icon(Icons.check),
                    onPressed: () => _markAsRead(message),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
=======
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ChatApp());
}

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: TestScreen(),
    );
  }
}

/// Tela de Teste com um botão para enviar mensagens de teste.
class TestScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Função para enviar uma mensagem de teste para o Firestore
  void _sendTestMessage() {
    _firestore.collection("messages").add({
      "text": "Mensagem de teste",
      "timestamp": FieldValue.serverTimestamp(),
      "isRead": false,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tela de Teste")),
      body: Column(
        children: [
          Expanded(child: ChatScreen()), // Exibe a tela do chat
          Padding(
            padding: EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _sendTestMessage,
              child: Text("Enviar Mensagem de Teste"),
            ),
          ),
        ],
      ),
    );
  }
}

/// Tela do Chat que exibe mensagens em tempo real e permite enviar novas mensagens.
class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _messageController = TextEditingController();

  // Função para enviar uma mensagem digitada pelo usuário
  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return; // Não envia mensagens vazias
    _firestore.collection("messages").add({
      "text": _messageController.text.trim(),
      "timestamp": FieldValue.serverTimestamp(),
      "isRead": false,
    });
    _messageController.clear(); // Limpa o campo de texto após o envio
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat com Firebase"),
        actions: [
          // Botão para acessar a tela de notificações
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationsScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Exibe as mensagens em tempo real
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection("messages")
                  .orderBy("timestamp", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator());
                var messages = snapshot.data!.docs;
                return ListView.builder(
                  reverse: true, // Exibe as mensagens mais recentes no topo
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return ListTile(title: Text(messages[index]["text"]));
                  },
                );
              },
            ),
          ),
          // Campo de texto e botão para enviar mensagens
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Digite uma mensagem...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _sendMessage,
                  child: Text("Enviar"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Tela de Notificações que exibe mensagens não lidas e permite marcá-las como lidas.
class NotificationsScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Função para marcar uma mensagem como lida
  void _markAsRead(DocumentSnapshot doc) {
    doc.reference.update({"isRead": true});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notificações")),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection("messages")
            .where("isRead", isEqualTo: false)
            .orderBy("timestamp", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          var messages = snapshot.data!.docs;
          if (messages.isEmpty)
            return Center(child: Text("Nenhuma nova notificação"));
          return ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              var message = messages[index];
              return Dismissible(
                key: Key(message.id),
                onDismissed: (direction) => _markAsRead(message),
                background: Container(
                  color: Colors.green,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 20),
                  child: Icon(Icons.check, color: Colors.white),
                ),
                child: ListTile(
                  title: Text(message["text"]),
                  trailing: IconButton(
                    icon: Icon(Icons.check),
                    onPressed: () => _markAsRead(message),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
>>>>>>> 42ef54f772b549574d2519cb976583f7ae711d7b
}