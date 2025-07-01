// lib/screens/my_houses_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:rent_a_house/services/authservices.dart';
import 'package:rent_a_house/providers/housesprovider.dart'; // Para o modelo House
import 'package:intl/intl.dart'; // Para formatação de moeda
import 'package:rent_a_house/screens/details_screen.dart'; // Para navegar para os detalhes do imóvel
import 'package:rent_a_house/screens/register_house_page.dart'; // Para o FAB

class MyHousesScreen extends StatelessWidget {
  const MyHousesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final String? currentUserUid = authService.usuario?.uid;

    if (currentUserUid == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Meus Imóveis')),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person_off, size: 80, color: Colors.grey),
                SizedBox(height: 20),
                Text(
                  'Você precisa estar logado para ver seus imóveis.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Imóveis'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('houses')
            .where('ownerUid', isEqualTo: currentUserUid)
            .orderBy('createdAt', descending: true) // Ordena pelos mais recentes
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            debugPrint('Erro ao carregar imóveis: ${snapshot.error}');
            return Center(child: Text('Erro ao carregar seus imóveis: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.house_siding, size: 80, color: Colors.grey[400]),
                    const SizedBox(height: 20),
                    const Text(
                      'Você ainda não possui imóveis registrados.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Comece a anunciar seu imóvel agora!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RegisterHousePage()),
                        );
                      },
                      icon: const Icon(Icons.add_home_work),
                      label: const Text('Registrar Novo Imóvel'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final List<House> myHouses = snapshot.data!.docs
              .map((doc) => House.fromFirestore(doc))
              .toList();

          return ListView.builder(
            padding: const EdgeInsets.all(12.0),
            itemCount: myHouses.length,
            itemBuilder: (context, index) {
              final house = myHouses[index];
              final currencyFormatter = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsScreen(houseId: house.id),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(15),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          house.name,
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tipo: ${house.type}',
                          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 18, color: Colors.grey[600]),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                '${house.address}, ${house.number}',
                                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            currencyFormatter.format(house.price),
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // Botão de Editar
                            TextButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Editar imóvel: ${house.name}')),
                                );
                                //Implementar navegação para tela de edição
                              },
                              icon: const Icon(Icons.edit, size: 20),
                              label: const Text('Editar'),
                              style: TextButton.styleFrom(foregroundColor: Colors.blue),
                            ),
                            const SizedBox(width: 8),
                            // Botão de Excluir
                            TextButton.icon(
                              onPressed: () {
                                //Implementar lógica de exclusão (com confirmação)
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Excluir imóvel: ${house.name}')),
                                );
                              },
                              icon: const Icon(Icons.delete, size: 20),
                              label: const Text('Excluir'),
                              style: TextButton.styleFrom(foregroundColor: Colors.red),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RegisterHousePage()),
          );
        },
        icon: const Icon(Icons.add_home_work),
        label: const Text('Novo Imóvel'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 6,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
