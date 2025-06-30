// lib/screens/details_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rent_a_house/providers/housesprovider.dart'; // Modelos House e HousePhoto, e HousesProvider
import 'package:rent_a_house/services/authservices.dart'; // AuthService para checar usuário logado
import 'dart:convert'; // Para base64Decode
import 'package:rent_a_house/screens/chat_page.dart'; // Importe sua ChatPage
import 'package:rent_a_house/screens/checkout_page.dart'; // NOVO: Importe a CheckoutPage
import 'package:cloud_firestore/cloud_firestore.dart'; // Para _fetchUserName (mantido aqui por conveniência, idealmente em um serviço)


// Helper para buscar nome do usuário no Firestore (duplicado aqui para conveniência,
// idealmente deveria estar em um único lugar ou passado via Provider se necessário em muitos lugares)
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


class DetailsScreen extends StatefulWidget {
  final String houseId; // ID do imóvel a ser exibido

  const DetailsScreen({super.key, required this.houseId});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  House? _house;
  List<HousePhoto> _housePhotos = [];
  bool _isLoading = true;
  String? _error;
  PageController? _imagePageController; // Controlador para o carrossel de imagens
  int _currentImageIndex = 0; // Índice da imagem atual no carrossel

  @override
  void initState() {
    super.initState();
    _loadHouseDetails();
    _imagePageController = PageController(initialPage: _currentImageIndex);
  }

  @override
  void dispose() {
    _imagePageController?.dispose();
    super.dispose();
  }

  Future<void> _loadHouseDetails() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final housesProvider = Provider.of<HousesProvider>(context, listen: false);
      final fetchedHouse = await housesProvider.fetchHouseById(widget.houseId);
      final fetchedPhotos = await housesProvider.fetchAllHousePhotos(widget.houseId);

      if (mounted) {
        setState(() {
          _house = fetchedHouse;
          // Ordena as fotos pelo photoIndex para garantir a sequência
          _housePhotos = fetchedPhotos..sort((a, b) => a.photoIndex.compareTo(b.photoIndex));
          _isLoading = false;
          if (_house == null) {
            _error = 'Imóvel não encontrado.';
          } else if (_housePhotos.isEmpty) {
            _error = 'Nenhuma foto encontrada para este imóvel.';
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Erro ao carregar detalhes do imóvel: $e';
          _isLoading = false;
        });
        debugPrint('Erro ao carregar detalhes do imóvel: $e');
      }
    }
  }

  void _showFullScreenImage(String base64Image, String tag) {
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (BuildContext context) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Hero(
                tag: tag, // Tag única para a animação Hero
                child: Image.memory(
                  base64Decode(base64Image),
                  fit: BoxFit.contain, // Garante que a imagem se ajuste à tela
                ),
              ),
            ),
          ),
        );
      },
    ));
  }


  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final currentUserUid = authService.usuario?.uid;
    final isAnonymousUser = authService.usuario?.isAnonymous ?? false;

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Carregando...')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null || _house == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Erro')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _error ?? 'Detalhes do imóvel não disponíveis.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _loadHouseDetails,
                  child: const Text("Tentar Novamente"),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Condições para exibir os botões de Chat e Alugar
    final bool isOwner = currentUserUid == _house!.ownerUid;
    final bool showContactButtons = !isOwner && !isAnonymousUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(_house!.name),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Carrossel de Imagens
            if (_housePhotos.isNotEmpty)
              SizedBox(
                height: 250, // Altura fixa para o carrossel
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    PageView.builder(
                      controller: _imagePageController,
                      itemCount: _housePhotos.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentImageIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        final photo = _housePhotos[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: GestureDetector(
                            onTap: () => _showFullScreenImage(photo.base64String, 'imageHero${photo.id}'),
                            child: Hero(
                              tag: 'imageHero${photo.id}', // Tag única para cada imagem
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12.0),
                                child: Image.memory(
                                  base64Decode(photo.base64String),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey[200],
                                      child: const Icon(Icons.broken_image, size: 80, color: Colors.blueGrey),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    Positioned(
                      bottom: 10,
                      child: Row(
                        children: List.generate(_housePhotos.length, (index) {
                          return Container(
                            width: 8.0,
                            height: 8.0,
                            margin: const EdgeInsets.symmetric(horizontal: 4.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentImageIndex == index
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.4),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              )
            else
              Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: const Center(
                  child: Icon(Icons.image_not_supported, size: 80, color: Colors.grey),
                ),
              ),

            const SizedBox(height: 20),

            // Detalhes do Imóvel
            Text(
              _house!.name,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Tipo: ${_house!.type}',
              style: const TextStyle(fontSize: 18, color: Colors.blueGrey),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.location_on, size: 20, color: Colors.grey),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    _house!.address,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const Icon(Icons.push_pin, size: 20, color: Colors.grey),
                const SizedBox(width: 5),
                Text(
                  'Número: ${_house!.number}',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                if (_house!.complement.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      'Complemento: ${_house!.complement}',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const Icon(Icons.local_post_office, size: 20, color: Colors.grey),
                const SizedBox(width: 5),
                Text(
                  'CEP: ${_house!.zipcode}',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Descrição:',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              _house!.description,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 20),
            Text(
              'Preço do Aluguel: R\$ ${_house!.price.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 30),

            // Botões de Ação (condicionais)
            if (showContactButtons)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      final ownerName = await _fetchUserName(_house!.ownerUid);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPage(
                            partnerUID: _house!.ownerUid,
                            partnerName: ownerName,
                            houseId: _house!.id,
                            houseName: _house!.name,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.chat, color: Colors.white),
                    label: const Text('Conversar com o Proprietário', style: TextStyle(fontSize: 18, color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 15),
                  // NOVO: Botão "Tenho Interesse em Alugar" que leva para a CheckoutPage
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CheckoutPage(house: _house!), // Passa o objeto House
                        ),
                      );
                    },
                    icon: const Icon(Icons.assignment_turned_in, color: Colors.white),
                    label: const Text('Tenho Interesse em Alugar', style: TextStyle(fontSize: 18, color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
