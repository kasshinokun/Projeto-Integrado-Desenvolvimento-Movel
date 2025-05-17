//Exemplo a ser adaptado
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rent_a_house/services/authservices.dart';
import 'package:rent_a_house/services/firebase_options.dart';

const Color darkBlue = Color.fromARGB(255, 18, 32, 47);

const messageLimit = 30;

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
  } catch (e, st) {
    throw AuthException('$e \n $st');
  }

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  //
  await FirebaseAuth.instance.signInAnonymously();
  //
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final DateFormat formatter = DateFormat('MM/dd HH:mm:SS');

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              Text(
                'Digite um nova mensagem',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Text(
                'Você pode digitar uma mensagem neste campo e pressionar a tecla Enter '
                'para adicioná-lo ao fluxo. As regras de segurança para o '
                'O banco de dados do Firestore permite apenas algumas palavras! Verifique '
                'os comentários no código à esquerda para detalhes.',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              FractionallySizedBox(
                widthFactor: 0.5,
                child: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Digite sua mensagem e por favor pressione Enter',
                  ),
                  onSubmitted: (String value) {
                    FirebaseFirestore.instance.collection('chat').add({
                      'message': value,
                      'timestamp': DateTime.now().millisecondsSinceEpoch,
                    });
                  },
                ),
              ),

              const SizedBox(height: 32),
              Text(
                'Últimas mensagens',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream:
                      FirebaseFirestore.instance
                          .collection('chat')
                          .orderBy('timestamp', descending: true)
                          .limit(messageLimit)
                          .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('$snapshot.error'));
                    } else if (!snapshot.hasData) {
                      return const Center(
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    var docs = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: docs.length,
                      itemBuilder: (context, i) {
                        return ListTile(
                          leading: DefaultTextStyle.merge(
                            style: const TextStyle(color: Colors.indigo),
                            child: Text(
                              formatter.format(
                                DateTime.fromMillisecondsSinceEpoch(
                                  docs[i]['timestamp'],
                                ),
                              ),
                            ),
                          ),
                          title: Text('${docs[i]['message']}'),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
