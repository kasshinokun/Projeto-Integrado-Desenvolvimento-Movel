// lib/screens/house_screen.dart (Agora um StatelessWidget)
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rent_a_house/providers/housesprovider.dart';
import 'package:rent_a_house/screens/details_screen.dart'; // Importe seu HousesProvider

// Como esses modelos são usados apenas aqui e em housesprovider.dart,
// eles poderiam ser movidos para um arquivo separado como 'models/house_data.dart'
// para evitar duplicação ou se outras partes do app precisarem deles.
// Por simplicidade, mantidos dentro de housesprovider.dart e importados.


class HouseScreen extends StatelessWidget {
  final TabController tabController;
  final List<String> categories;
  final Map<String, List<House>> categorizedHouses;
  final HousesProvider housesProvider; // Passando o provider para acessar fetchHousePhoto

  const HouseScreen({
    super.key,
    required this.tabController,
    required this.categories,
    required this.categorizedHouses,
    required this.housesProvider,
  });

  @override
  Widget build(BuildContext context) {
    // Agora, o HouseScreen recebe o TabController e as categorias do pai.
    // Ele não precisa mais ser um Consumer ou StatefulWidget para gerenciar o TabController.

    // Já que o HomePage lida com os estados de carregamento/erro/vazio,
    // HouseScreen assume que categories NÃO será vazia e tabController NÃO será nulo
    // quando ele for construído, a menos que haja um erro lógico no pai.
    // No entanto, é boa prática adicionar checagens defensivas se for um widget reutilizável.
    if (categories.isEmpty || tabController == null) {
      return const Center(child: Text('Nenhuma categoria ou controller disponível.'));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Imóveis por Categoria'),
        bottom: TabBar(
          controller: tabController, // Usando o controller passado
          isScrollable: true,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          tabs: categories.map((category) {
            return Tab(
              child: Text(category, style: const TextStyle(fontSize: 15)),
            );
          }).toList(),
        ),
      ),
      body: TabBarView(
        controller: tabController, // Usando o controller passado
        children: categories.map((categoryName) {
          final List<House> housesInCategory = categorizedHouses[categoryName] ?? [];

          if (housesInCategory.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Nenhum imóvel disponível na categoria "$categoryName" no momento.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ),
            );
          }

          return ListView.builder(
            key: PageStorageKey(categoryName), // Preserva a posição de rolagem
            padding: const EdgeInsets.all(8.0),
            itemCount: housesInCategory.length,
            itemBuilder: (context, index) {
              final house = housesInCategory[index];
              return FutureBuilder<HousePhoto?>(
                future: housesProvider.fetchHousePhoto(house.id, 0), // Usa o provider passado para buscar a foto de índice 0
                builder: (context, snapshot) {
                  Widget imageWidget;
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    imageWidget = Container(
                      height: 200,
                      color: Colors.grey[200],
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  } else if (snapshot.hasError) {
                    imageWidget = Container(
                      height: 200,
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(Icons.error_outline, color: Colors.red, size: 50),
                      ),
                    );
                  } else if (snapshot.hasData && snapshot.data != null) {
                    final String base64Image = snapshot.data!.base64String;
                    try {
                      final decodedBytes = base64Decode(base64Image);
                      imageWidget = Image.memory(
                        decodedBytes,
                        fit: BoxFit.cover,
                        height: 200,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 200,
                            color: Colors.grey[200],
                            child: const Center(
                              child: Icon(Icons.broken_image, color: Colors.blueGrey, size: 50),
                            ),
                          );
                        },
                      );
                    } catch (e) {
                      debugPrint('Erro ao decodificar Base64 para ${house.name}: $e');
                      imageWidget = Container(
                        height: 200,
                        color: Colors.grey[200],
                        child: const Center(
                          child: Icon(Icons.broken_image, color: Colors.blueGrey, size: 50),
                        ),
                      );
                    }
                  } else {
                    imageWidget = Container(
                      height: 200,
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(Icons.image_not_supported, color: Colors.grey, size: 50),
                      ),
                    );
                  }

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12.0)),
                          child: imageWidget,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                house.name,
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                house.address,
                                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'R\$ ${house.price.toStringAsFixed(2)}',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                              ),
                              const SizedBox(height: 8),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Navega para a tela de detalhes do imóvel, passando o ID do imóvel
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailsScreen(houseId: house.id),
                                      ),
                                    );
                                  },
                                  child: const Text('Ver Detalhes'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
