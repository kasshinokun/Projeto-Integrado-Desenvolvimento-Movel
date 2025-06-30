// lib/pages/chat_page.dart
import 'package:cloud_firestore/cloud_firestore.dart'; // Ainda usado para _fetchUserName (Firestore)
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart'; // Import para Realtime Database
import 'package:intl/intl.dart'; // Para formatação de data e hora

// Helper para buscar nome do usuário no Firestore (mantido, pois seus usuários estão lá)
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

// ==============================================================================
// TELA DE CHAT ESPECÍFICA (ChatPage)
// ==============================================================================
class ChatPage extends StatefulWidget {
  final String partnerUID; // O UID do outro participante da conversa
  final String partnerName; // O nome do outro participante
  final String? houseId; // NOVO: ID do imóvel associado à conversa (opcional)
  final String? houseName; // NOVO: Nome do imóvel associado à conversa (opcional)


  const ChatPage({
    Key? key,
    required this.partnerUID,
    required this.partnerName,
    this.houseId, // Torne o houseId opcional
    this.houseName, // Torne o houseName opcional
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final DatabaseReference _messagesRootRef = FirebaseDatabase.instance.ref('messages'); // Referência raiz para mensagens
  final DatabaseReference _userChatsRef = FirebaseDatabase.instance.ref('userChats'); // Referência para lista de chats

  String? _currentUserUid; // UID do usuário atualmente logado
  String _chatId = ''; // ID único da conversa
  String? _displayedHouseName; // NOVO: Estado para armazenar o nome do imóvel a ser exibido

  @override
  void initState() {
    super.initState();
    _currentUserUid = FirebaseAuth.instance.currentUser?.uid;
    if (_currentUserUid != null) {
      _chatId = _getChatId(_currentUserUid!, widget.partnerUID);
      _initializeChatMetadata(); // Inicializa os metadados do chat
    }

    // Listener para rolar para a última mensagem quando o StreamBuilder carrega dados
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  // Gera um ID de chat único e consistente, independentemente da ordem dos UIDs
  String _getChatId(String uid1, String uid2) {
    final List<String> uids = [uid1, uid2]..sort(); // Garante ordem alfabética
    return uids.join('_');
  }

  // Inicializa os metadados do chat (author1, author2, houseId, houseName) para as regras de segurança
  Future<void> _initializeChatMetadata() async {
    final chatMetadataRef = _messagesRootRef.child(_chatId).child('metadata');
    final snapshot = await chatMetadataRef.get();

    if (!snapshot.exists) {
      // Se não existe metadado, cria com os dados fornecidos (e.g., do DetailsScreen)
      await chatMetadataRef.set({
        'author1': _currentUserUid,
        'author2': widget.partnerUID,
        'houseId': widget.houseId, // Salva o houseId se fornecido
        'houseName': widget.houseName, // Salva o houseName se fornecido
      });
      setState(() {
        _displayedHouseName = widget.houseName; // Define o nome do imóvel para exibição inicial
      });
    } else {
      // Se já existe metadado, carrega o houseName dele
      final metadata = Map<String, dynamic>.from(snapshot.value as Map);
      setState(() {
        _displayedHouseName = metadata['houseName'] as String?;
      });
    }
  }

  void _addMessage(String text) async {
    final user = FirebaseAuth.instance.currentUser;
    if (text.trim().isEmpty || user == null || _currentUserUid == null) return;

    final messageData = {
      'text': text.trim(),
      'timestamp': ServerValue.timestamp, // Usa timestamp do servidor do Realtime Database
      'author': _currentUserUid,
    };

    // Salva a mensagem na coleção de mensagens específicas do chat
    await _messagesRootRef.child(_chatId).child('messages').push().set(messageData); // Corrigido o caminho

    // Atualiza a lista de conversas para ambos os usuários
    final formattedTime = DateFormat('HH:mm').format(DateTime.now()); // Formata hora local
    
    // Obtém o nome do usuário atual para a lista de chats do parceiro
    String currentUserName = user.displayName ?? user.email ?? 'Você';
    // Se o nome do parceiro não for "Usuário Desconhecido", use-o; caso contrário, use um fallback genérico
    String partnerNameForChatList = widget.partnerName == 'Usuário Desconhecido' ? widget.partnerUID : widget.partnerName;


    final lastMessageForClient = {
      'lastMessage': text.trim(),
      'timestamp': ServerValue.timestamp,
      'partnerId': widget.partnerUID, // O parceiro do cliente é o vendedor
      'partnerName': partnerNameForChatList, // Nome do parceiro para o cliente
      'houseId': widget.houseId, // NOVO: Passa o houseId para a lista de chats
      'houseName': widget.houseName, // NOVO: Passa o houseName para a lista de chats
    };
    final lastMessageForPartner = {
      'lastMessage': text.trim(),
      'timestamp': ServerValue.timestamp,
      'partnerId': _currentUserUid, // O parceiro do vendedor é o cliente
      'partnerName': currentUserName, // Nome do cliente para o vendedor
      'houseId': widget.houseId, // NOVO: Passa o houseId para a lista de chats
      'houseName': widget.houseName, // NOVO: Passa o houseName para a lista de chats
    };

    // Atualiza a última mensagem para o usuário atual
    await _userChatsRef.child(_currentUserUid!).child(widget.partnerUID).set(lastMessageForClient);
    // Atualiza a última mensagem para o parceiro
    await _userChatsRef.child(widget.partnerUID).child(_currentUserUid!).set(lastMessageForPartner);

    _controller.clear();
    _scrollToBottom();

    // TODO: Implementar envio de Notificação Push (FCM) aqui (requer backend/Cloud Function)
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

  String _formatTimestamp(int timestampMillis) {
    final dt = DateTime.fromMillisecondsSinceEpoch(timestampMillis);
    return DateFormat('HH:mm').format(dt);
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

    if (currentUser == null || currentUser.isAnonymous || _currentUserUid == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Chat')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.person_off, size: 80, color: Colors.grey),
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
                ElevatedButton.icon(
                  onPressed: () {
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

    // Título da AppBar: Conforme o solicitado, adiciona o nome do imóvel
    String appBarTitle = widget.partnerName;
    if (_displayedHouseName != null && _displayedHouseName!.isNotEmpty) {
      appBarTitle = '$appBarTitle - Imóvel: $_displayedHouseName';
    }


    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _messagesRootRef.child(_chatId).child('messages').orderByChild('timestamp').onValue, // Ouve mensagens no sub-caminho 'messages'
              builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  debugPrint('Erro no StreamBuilder do chat: ${snapshot.error}');
                  return const Center(child: Text('Erro ao carregar mensagens'));
                }
                if (!snapshot.hasData || snapshot.data?.snapshot.value == null) {
                  return const Center(child: Text('Nenhuma mensagem ainda. Comece a conversar!'));
                }

                final messagesMap = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
                final messagesList = <Map<String, dynamic>>[];

                // Converte o mapa de mensagens para uma lista e ordena por timestamp
                messagesMap.forEach((key, value) {
                  messagesList.add(Map<String, dynamic>.from(value));
                });
                messagesList.sort((a, b) => (a['timestamp'] as int).compareTo(b['timestamp'] as int));

                // Rola para a última mensagem após a reconstrução
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollToBottom();
                });

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: messagesList.length,
                  itemBuilder: (context, index) {
                    final messageData = messagesList[index];
                    final authorUid = messageData['author'] as String;
                    final authorDisplayName = (authorUid == _currentUserUid)
                        ? (currentUser.displayName ?? currentUser.email ?? 'Você')
                        : widget.partnerName;

                    return ChatMessageTile(
                      text: messageData['text'] as String,
                      timestamp: _formatTimestamp(messageData['timestamp'] as int),
                      author: authorUid,
                      authorName: authorDisplayName,
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Digite sua mensagem...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    maxLines: 5,
                    minLines: 1,
                    onSubmitted: _addMessage,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
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
// WIDGET ChatMessageTile (mantido e aprimorado levemente)
// ==============================================================================
class ChatMessageTile extends StatelessWidget {
  final String text;
  final String timestamp;
  final String author;
  final String? authorName;

  const ChatMessageTile({
    required this.text,
    required this.timestamp,
    required this.author,
    this.authorName,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isMe = author == FirebaseAuth.instance.currentUser?.uid;
    final alignment = isMe ? Alignment.centerRight : Alignment.centerLeft;
    final color = isMe ? Theme.of(context).colorScheme.primary : Colors.grey.shade300; // Cores do tema
    final textColor = isMe ? Colors.white : Colors.black87;
    final borderRadius = BorderRadius.circular(12);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      alignment: alignment,
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
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
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              decoration: BoxDecoration(
                color: color,
                borderRadius: isMe
                    ? borderRadius.copyWith(bottomRight: Radius.zero)
                    : borderRadius.copyWith(bottomLeft: Radius.zero),
                boxShadow: [ // Adicionado sombra para um visual 3D
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: TextStyle(color: textColor, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.bottomRight,
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
