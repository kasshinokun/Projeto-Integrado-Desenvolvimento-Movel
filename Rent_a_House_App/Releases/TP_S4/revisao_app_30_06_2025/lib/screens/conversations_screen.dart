// lib/screens/conversations_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';
import 'package:rent_a_house/screens/chat_page.dart'; // Importe sua ChatPage
import 'package:cloud_firestore/cloud_firestore.dart'; // Para _fetchUserName
import 'package:intl/intl.dart';
import 'package:rent_a_house/services/authservices.dart'; // Para formatação de data e hora

class ConversationsScreen extends StatelessWidget {
  final String? currentUserUid; // Agora recebido como parâmetro

  const ConversationsScreen({super.key, required this.currentUserUid});

  @override
  Widget build(BuildContext context) {
    // Acessa o AuthService para obter o usuário logado e reagir a mudanças
    final authService = Provider.of<AuthService>(context);
    final user = authService.usuario;

    final DatabaseReference userChatsRef = FirebaseDatabase.instance.ref('userChats');
    
    return (user != null && !user.isAnonymous)?
    Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Conversas'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),
      body: StreamBuilder(
        // Usamos currentUserUid diretamente
        stream: userChatsRef.child(currentUserUid!).orderByChild('timestamp').onValue,
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            debugPrint('Erro ao carregar conversas: ${snapshot.error}');
            return const Center(child: Text('Erro ao carregar conversas.'));
          }
          if (!snapshot.hasData || snapshot.data?.snapshot.value == null) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.chat_bubble_outline, size: 80, color: Colors.grey),
                  SizedBox(height: 20),
                  Text(
                    'Você ainda não tem conversas.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Encontre imóveis e inicie um chat com os proprietários!',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          final chatsMap = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
          final chatsList = <Map<String, dynamic>>[];

          chatsMap.forEach((key, value) {
            chatsList.add(Map<String, dynamic>.from(value));
          });

          // Inverte a lista para que as conversas mais recentes apareçam no topo
          chatsList.sort((a, b) => (b['timestamp'] as int).compareTo(a['timestamp'] as int));

          // Limita a 5 conversas, se houver mais
          final limitedChats = chatsList.take(5).toList();

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: limitedChats.length,
            itemBuilder: (context, index) {
              final chatData = limitedChats[index];
              final partnerId = chatData['partnerId'] as String;
              final partnerName = chatData['partnerName'] as String;
              final lastMessage = chatData['lastMessage'] as String;
              final timestamp = chatData['timestamp'] as int;
              final houseName = chatData['houseName'] as String?; // NOVO: Pega o nome do imóvel

              String subtitleText = lastMessage;
              if (houseName != null && houseName.isNotEmpty) {
                subtitleText = 'Imóvel: $houseName - $lastMessage';
              }

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 0),
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                    child: Icon(Icons.person, size: 30, color: Theme.of(context).colorScheme.secondary),
                  ),
                  title: Text(
                    partnerName,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      subtitleText, // Exibe o nome do imóvel no subtítulo
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                  trailing: Text(
                    DateFormat('HH:mm').format(DateTime.fromMillisecondsSinceEpoch(timestamp)),
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(
                          partnerUID: partnerId,
                          partnerName: partnerName,
                          houseId: chatData['houseId'] as String?, // Passa o houseId para a ChatPage
                          houseName: houseName, // Passa o houseName para a ChatPage
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    ):Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.info_outline,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              "Favor fazer Login",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
