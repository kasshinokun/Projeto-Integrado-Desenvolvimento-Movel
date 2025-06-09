import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class LocalChatPage extends StatefulWidget {
  const LocalChatPage({Key? key}) : super(key: key);

  @override
  State<LocalChatPage> createState() => _LocalChatPageState();
}

class _LocalChatPageState extends State<LocalChatPage> {
  final TextEditingController _controller = TextEditingController();
  final CollectionReference _chatCollection =
  FirebaseFirestore.instance.collection('chat_messages');

  void _addMessage(String text) {
    if (text.trim().isEmpty) return;

    _chatCollection.add({
      'text': text.trim(),
      'timestamp': Timestamp.now(),
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
      appBar: AppBar(
        title: const Text('Chat Local com Firebase'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
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
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _chatCollection
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
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
                      );
                    },
                  );
                },
              ),
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

  const ChatMessageTile({
    required this.text,
    required this.timestamp,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(
        timestamp,
        style: const TextStyle(color: Colors.grey),
      ),
      title: Text(text),
    );
  }
}
