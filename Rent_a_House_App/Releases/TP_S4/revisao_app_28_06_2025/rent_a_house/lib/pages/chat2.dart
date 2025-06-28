import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String clienteUID;
  final String vendedorUID;

  const ChatPage({
   super.key,
    required this.clienteUID,
    required this.vendedorUID,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();

  CollectionReference get _chatCollection {
    // Monta o ID da conversa ordenando os UIDs para evitar duplicidade
    final ids = [widget.clienteUID, widget.vendedorUID]..sort();
    final chatId = ids.join('_');
    return FirebaseFirestore.instance.collection('chats').doc(chatId).collection('messages');
  }

  void _addMessage(String text) {
    final user = FirebaseAuth.instance.currentUser;
    if (text.trim().isEmpty || user == null) return;

    _chatCollection.add({
      'text': text.trim(),
      'timestamp': Timestamp.now(),
      'author': user.uid,
    });

    _controller.clear();
  }

  String _formatTimestamp(Timestamp ts) {
    final dt = ts.toDate();
    return '${dt.day.toString().padLeft(2, '0')}/'
        '${dt.month.toString().padLeft(2, '0')} '
        '${dt.hour.toString().padLeft(2, '0')}:'
        '${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    // Verifica se o usuário está logado E se NÃO é um usuário anônimo
    final User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null || currentUser.isAnonymous) {
      // Se não houver usuário logado OU se for um usuário anônimo, mostra a tela de login necessário
      return Scaffold(
        appBar: AppBar(title: const Text('Chat')),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person_off,
                  size: 80,
                  color: Colors.grey,
                ),
                SizedBox(height: 20),
                Text(
                  'Por favor, faça login para usar o chat.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                SizedBox(height: 10),
                Text(
                  'Você precisa estar autenticado para enviar e receber mensagens.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Se o usuário estiver logado e NÃO for anônimo, exibe a interface normal do chat
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _chatCollection.orderBy('timestamp').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text('Erro ao carregar mensagens'));
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final docs = snapshot.data!.docs;

                  if (docs.isEmpty) {
                    return const Center(child: Text('Nenhuma mensagem ainda'));
                  }

                  return ListView.builder(
                    reverse: true,
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final data = docs[index];
                      // Ajusta o índice para exibir as mensagens na ordem correta,
                      // pois reverse: true inverte a ordem do ListView
                      final reversedIndex = docs.length - 1 - index;
                      final messageData = docs[reversedIndex];

                      return ChatMessageTile(
                        text: messageData['text'],
                        timestamp: _formatTimestamp(messageData['timestamp']),
                        author: messageData['author'],
                      );
                    },
                  );
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Digite sua mensagem',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: _addMessage,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _addMessage(_controller.text),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessageTile extends StatelessWidget {
  final String text;
  final String timestamp;
  final String author;

  const ChatMessageTile({
    required this.text,
    required this.timestamp,
    required this.author,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    bool isMe = author == FirebaseAuth.instance.currentUser?.uid;
    return ListTile(
      leading: isMe ? null : Text(timestamp, style: const TextStyle(color: Colors.grey)),
      trailing: isMe ? Text(timestamp, style: const TextStyle(color: Colors.grey)) : null,
      title: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isMe ? Colors.blueAccent : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            text,
            style: TextStyle(color: isMe ? Colors.white : Colors.black),
          ),
        ),
      ),
      subtitle: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Text(
          isMe ? 'Você' : 'Outro usuário',
          style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
        ),
      ),
    );
  }
}
