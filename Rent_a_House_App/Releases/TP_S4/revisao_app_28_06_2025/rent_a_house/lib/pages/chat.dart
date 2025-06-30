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
                      return ChatMessageTile(
                        text: data['text'],
                        timestamp: _formatTimestamp(data['timestamp']),
                        author: data['author'],
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
