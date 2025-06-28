import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Helper para buscar nome do usuário no Firestore
// Assumimos que existe uma coleção 'users' onde o ID do documento é o UID do usuário
// e cada documento tem um campo 'name'.
Future<String> _fetchUserName(String uid) async {
  try {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (userDoc.exists && userDoc.data() != null) {
      return (userDoc.data() as Map<String, dynamic>)['name'] ?? 'Usuário Desconhecido';
    }
  } catch (e) {
    debugPrint("Erro ao buscar nome do usuário $uid: $e");
  }
  return 'Usuário Desconhecido';
}


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
  final ScrollController _scrollController = ScrollController(); // Para rolagem automática

  String _partnerName = 'Carregando...'; // Nome do outro participante do chat
  Map<String, String> _userNames = {}; // Mapa para armazenar nomes de usuários por UID

  CollectionReference get _chatCollection {
    // Monta o ID da conversa ordenando os UIDs para evitar duplicidade
    final ids = [widget.clienteUID, widget.vendedorUID]..sort();
    final chatId = ids.join('_');
    return FirebaseFirestore.instance.collection('chats').doc(chatId).collection('messages');
  }

  @override
  void initState() {
    super.initState();
    _fetchAndSetUserNames();

    // Listener para rolar para a última mensagem quando o StreamBuilder carrega dados
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  // Busca os nomes dos usuários e armazena no mapa _userNames
  void _fetchAndSetUserNames() async {
    final currentUserUid = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserUid != null) {
      String clientName = await _fetchUserName(widget.clienteUID);
      String vendorName = await _fetchUserName(widget.vendedorUID);

      setState(() {
        _userNames = {
          widget.clienteUID: clientName,
          widget.vendedorUID: vendorName,
        };
        // Define o nome do parceiro para exibir no AppBar
        _partnerName = (widget.clienteUID == currentUserUid) ? vendorName : clientName;
      });
    }
  }

  void _addMessage(String text) async {
    final user = FirebaseAuth.instance.currentUser;
    if (text.trim().isEmpty || user == null) return;

    await _chatCollection.add({
      'text': text.trim(),
      'timestamp': Timestamp.now(),
      'author': user.uid,
    });

    _controller.clear();
    _scrollToBottom(); // Rola para o final após enviar a mensagem
  }

  // Rola o ListView para a mensagem mais recente
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  String _formatTimestamp(Timestamp ts) {
    final dt = ts.toDate();
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    // Para data e hora completa:
    // return '${dt.day.toString().padLeft(2, '0')}/'
    //     '${dt.month.toString().padLeft(2, '0')} '
    //     '${dt.hour.toString().padLeft(2, '0')}:'
    //     '${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null || currentUser.isAnonymous) {
      return Scaffold(
        appBar: AppBar(title: const Text('Chat')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.person_off,
                  size: 80,
                  color: Colors.grey,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Por favor, faça login para usar o chat.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Você precisa estar autenticado para enviar e receber mensagens.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 30),
                // Exemplo de botão para ir para a tela de login (você adaptaria isso)
                ElevatedButton.icon(
                  onPressed: () {
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Implemente a navegação para sua tela de Login')),
                    );
                  },
                  icon: const Icon(Icons.login),
                  label: const Text('Fazer Login'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_partnerName), // Título do AppBar com o nome do parceiro
        centerTitle: true,
      ),
      body: Column( // Removido o Padding geral para controlar melhor o espaçamento das bolhas
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

                // Após a atualização dos dados, rola para a última mensagem
                // Usar addPostFrameCallback para garantir que o layout já foi construído
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollToBottom();
                });

                if (docs.isEmpty) {
                  return const Center(child: Text('Nenhuma mensagem ainda. Comece a conversar!'));
                }

                return ListView.builder(
                  controller: _scrollController, // Atribui o controller aqui
                  itemCount: docs.length,
                  // Remove reverse: true aqui para exibir na ordem natural e rolar para o final
                  // Com StreamBuilder orderBy('timestamp') já virá ordenado corretamente do Firestore
                  itemBuilder: (context, index) {
                    final messageData = docs[index]; // Pega o dado diretamente
                    final authorUid = messageData['author'] as String;
                    final authorDisplayName = _userNames[authorUid] ?? 'Desconhecido';

                    return ChatMessageTile(
                      text: messageData['text'] as String,
                      timestamp: _formatTimestamp(messageData['timestamp'] as Timestamp),
                      author: authorUid,
                      authorName: authorDisplayName, // Passa o nome para exibição
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0), // Padding para a área de input
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Digite sua mensagem...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0), // Bordas mais arredondadas
                        borderSide: BorderSide.none, // Remove a linha da borda se quiser um visual mais limpo
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    maxLines: 5, // Permite múltiplas linhas
                    minLines: 1, // Começa com uma linha
                    onSubmitted: _addMessage,
                  ),
                ),
                const SizedBox(width: 8),
                Container( // Container para estilizar o botão de envio
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: () => _addMessage(_controller.text),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==============================================================================
// NOVO WIDGET ChatMessageTile para bolhas de mensagem aprimoradas
// ==============================================================================
class ChatMessageTile extends StatelessWidget {
  final String text;
  final String timestamp; // Já formatado (ex: "HH:mm")
  final String author;
  final String? authorName; // Nome do autor para exibir

  const ChatMessageTile({
    required this.text,
    required this.timestamp,
    required this.author,
    this.authorName,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    bool isMe = author == FirebaseAuth.instance.currentUser?.uid;
    final alignment = isMe ? Alignment.centerRight : Alignment.centerLeft;
    final color = isMe ? Colors.blueAccent.shade400 : Colors.grey.shade300;
    final textColor = isMe ? Colors.white : Colors.black87;
    final borderRadius = BorderRadius.circular(12);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      alignment: alignment,
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Exibir nome do autor se não for o usuário logado e o nome estiver disponível
          if (!isMe && authorName != null && authorName != 'Desconhecido')
            Padding(
              padding: const EdgeInsets.only(bottom: 4, left: 8, right: 8),
              child: Text(
                authorName!,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade700, fontWeight: FontWeight.bold),
              ),
            ),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75, // Limita a largura da bolha
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              decoration: BoxDecoration(
                color: color,
                borderRadius: isMe
                    ? borderRadius.copyWith(bottomRight: Radius.zero) // Cria um "bico" para o remetente
                    : borderRadius.copyWith(bottomLeft: Radius.zero), // Cria um "bico" para o receptor
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Texto da mensagem alinhado à esquerda dentro da bolha
                children: [
                  Text(
                    text,
                    style: TextStyle(color: textColor, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.bottomRight, // Timestamp sempre no canto inferior direito da bolha
                    child: Text(
                      timestamp,
                      style: TextStyle(
                        color: isMe ? Colors.white70 : Colors.black54,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
