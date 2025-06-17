import 'package:flutter/material.dart';

class LocalChatPage extends StatefulWidget {
  const LocalChatPage({Key? key}) : super(key: key);

  @override
  State<LocalChatPage> createState() => _LocalChatPageState();
}

class _LocalChatPageState extends State<LocalChatPage> {
  final List<_ChatMessage> _messages = [];
  final TextEditingController _controller = TextEditingController();

  void _addMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.insert(0, _ChatMessage(text, DateTime.now()));
    });

    _controller.clear();
  }

  String _formatTimestamp(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/'
        '${dt.month.toString().padLeft(2, '0')} '
        '${dt.hour.toString().padLeft(2, '0')}:'
        '${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Local'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Digite sua mensagem',
                border: OutlineInputBorder(),
              ),
              onSubmitted: _addMessage,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _messages.isEmpty
                  ? const Center(child: Text('Nenhuma mensagem ainda'))
                  : ListView.builder(
                reverse: true,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  return ListTile(
                    leading: Text(
                      _formatTimestamp(msg.timestamp),
                      style: const TextStyle(color: Colors.grey),
                    ),
                    title: Text(msg.text),
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

class _ChatMessage {
  final String text;
  final DateTime timestamp;

  _ChatMessage(this.text, this.timestamp);
}
