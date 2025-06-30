// lib/providers/housesprovider.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert'; // Para base64Decode

// Modelos de Dados para o Firestore
class House {
  final String id;
  final String name;
  final String address;
  final String type;
  final String ownerUid;
  final double price;
  final String description;
  final String number;
  final String complement;
  final String zipcode;

  House({
    required this.id,
    required this.name,
    required this.address,
    required this.type,
    required this.ownerUid,
    required this.price,
    required this.description,
    required this.number,
    required this.complement,
    required this.zipcode,
  });

  factory House.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return House(
      id: doc.id,
      name: data['name'] ?? '',
      address: data['address'] ?? '',
      type: data['type'] ?? '',
      ownerUid: data['ownerUid'] ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      description: data['description'] ?? '',
      number: data['number'] ?? '',
      complement: data['complement'] ?? '',
      zipcode: data['zipcode'] ?? '',
    );
  }
}

class HousePhoto {
  final String id; // ID do documento da foto na coleção house_photos
  final String houseId; // ID do imóvel ao qual a foto pertence
  final String base64String; // A imagem em string Base64
  final int photoIndex; // Índice da foto
  final String ownerUid; // UID do proprietário da foto

  HousePhoto({
    required this.id,
    required this.houseId,
    required this.base64String,
    required this.photoIndex,
    required this.ownerUid,
  });

  factory HousePhoto.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return HousePhoto(
      id: doc.id,
      houseId: data['houseId'] ?? '',
      base64String: data['base64String'] ?? '',
      photoIndex: data['photoIndex'] ?? 0,
      ownerUid: data['ownerUid'] ?? '',
    );
  }
}

// Provedor de Imóveis para gerenciar o estado e a lógica de busca
class HousesProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<House> _allHouses = [];
  Map<String, List<House>> _categorizedHouses = {};
  bool _isLoading = false;
  String? _error;

  List<House> get allHouses => _allHouses;
  Map<String, List<House>> get categorizedHouses => _categorizedHouses;
  bool get isLoading => _isLoading;
  String? get error => _error;

  HousesProvider() {
    listenToHouses(); // Chamando o método público no construtor
  }

  // Método público para iniciar o monitoramento dos imóveis
  void listenToHouses() {
    _isLoading = true;
    _error = null;
    notifyListeners();

    _firestore.collection('houses').snapshots().listen((snapshot) async {
      final List<House> fetchedHouses = snapshot.docs.map((doc) => House.fromFirestore(doc)).toList();
      _allHouses = fetchedHouses;
      await _categorizeHouses(fetchedHouses); // Recategoriza sempre que há uma mudança
      _isLoading = false;
      notifyListeners();
    }, onError: (e) {
      _error = 'Erro ao carregar imóveis: $e';
      _isLoading = false;
      notifyListeners();
      debugPrint('Erro ao carregar imóveis: $e');
    });
  }

  Future<void> _categorizeHouses(List<House> houses) async {
    final Map<String, List<House>> tempCategorizedHouses = {};
    for (var house in houses) {
      if (!tempCategorizedHouses.containsKey(house.type)) {
        tempCategorizedHouses[house.type] = [];
      }
      tempCategorizedHouses[house.type]!.add(house);
    }
    _categorizedHouses = tempCategorizedHouses;
    // Não notifica listeners aqui, pois listenToHouses já notifica
  }

  // NOVO MÉTODO: Busca um único imóvel por ID
  Future<House?> fetchHouseById(String houseId) async {
    try {
      final docSnapshot = await _firestore.collection('houses').doc(houseId).get();
      if (docSnapshot.exists) {
        return House.fromFirestore(docSnapshot);
      }
    } catch (e) {
      debugPrint('Erro ao buscar imóvel $houseId: $e');
    }
    return null;
  }

  // NOVO MÉTODO: Busca todas as fotos de um imóvel por houseId
  Future<List<HousePhoto>> fetchAllHousePhotos(String houseId) async {
    try {
      final querySnapshot = await _firestore
          .collection('house_photos')
          .where('houseId', isEqualTo: houseId)
          .orderBy('photoIndex') // Garante a ordem correta das fotos
          .get();

      return querySnapshot.docs.map((doc) => HousePhoto.fromFirestore(doc)).toList();
    } catch (e) {
      debugPrint('Erro ao buscar todas as fotos para o imóvel $houseId: $e');
      return [];
    }
  }

  // fetchHousePhoto original (ainda útil se necessário buscar uma foto específica pelo índice)
  Future<HousePhoto?> fetchHousePhoto(String houseId, int photoIndex) async {
    try {
      final querySnapshot = await _firestore
          .collection('house_photos')
          .where('houseId', isEqualTo: houseId)
          .where('photoIndex', isEqualTo: photoIndex)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return HousePhoto.fromFirestore(querySnapshot.docs.first);
      }
    } catch (e) {
      debugPrint('Erro ao buscar foto do imóvel $houseId (índice $photoIndex): $e');
    }
    return null;
  }
}
