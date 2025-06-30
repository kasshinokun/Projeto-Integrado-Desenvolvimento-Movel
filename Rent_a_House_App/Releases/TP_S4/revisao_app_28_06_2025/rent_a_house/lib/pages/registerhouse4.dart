//--->>https://www.coderzheaven.com/2019/10/17/googles-flutter-tutorial-save-image-as-string-in-sqlite-database/

import 'dart:typed_data';
import 'package:rent_a_house/pages/model/utility.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
//import 'utility.dart';
import 'dbdao/dbhelper.dart'; // Mantido caso ainda esteja em uso para SQLite
import 'dart:async';

// Firebase imports adicionados para salvar no Firestore e Storage
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Para upload de imagens

// O main aqui é apenas para que o arquivo possa ser executado isoladamente para teste.
// Em uma aplicação real, o main principal estaria em 'main.dart'.
void main() {
  runApp(MyNotesApp());
}

class MyNotesApp extends StatelessWidget {
  const MyNotesApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter SQLite CRUD',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: RegisterHousePage(),
    );
  }
}

class RegisterHousePage extends StatefulWidget {
  //
  const RegisterHousePage({super.key});

  final String title = "Registro de Imóveis";
  @override
  State<RegisterHousePage> createState() => _RegisterHousePageState();
}

class _RegisterHousePageState extends State<RegisterHousePage> {
  //
  final ImagePicker _picker = ImagePicker();
  late int idHouse; // Mantido para compatibilidade com SQLite
  late Future<File> imageFile; // Mantido para compatibilidade com SQLite
  late Image image; // Mantido para compatibilidade com SQLite
  late DBHelper dbHelper; // Mantido caso ainda esteja em uso para SQLite
  late List<Photo> images; // Mantido caso ainda esteja em uso para SQLite

  // Controladores para os TextFormFields
  final TextEditingController _houseNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Lista para armazenar múltiplas imagens selecionadas
  List<File> _pickedHouseImages = [];
  final int _maxImages = 5; // Limite de 5 imagens

  @override
  void initState() {
    super.initState();
    images = []; // Inicialização para compatibilidade com SQLite, se ainda em uso
    dbHelper = DBHelper.instance; // Inicialização para compatibilidade com SQLite
    refreshImages(); // Chamada para compatibilidade com SQLite
  }

  // Função para simular o refresh de imagens, mantida por causa do código original
  void refreshImages() async {
    // Implemente a lógica de refresh de imagens aqui, se necessário para SQLite
  }

  //====================================================================================================
  // ATUALIZADO: Função para selecionar UMA imagem por vez
  Future<void> _pickImage() async {
    if (_pickedHouseImages.length >= _maxImages) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Limite máximo de 5 imagens atingido.')),
      );
      return;
    }

    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery); // Seleciona apenas UMA imagem

      if (pickedFile != null) {
        setState(() {
          _pickedHouseImages.add(File(pickedFile.path)); // Adiciona a imagem à lista
        });
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha ao selecionar imagem: $e')),
      );
    }
  }

  // Função para remover uma imagem da lista
  void _removeImage(int index) {
    setState(() {
      _pickedHouseImages.removeAt(index);
    });
  }

  // ====================================================================================================
  // FUNÇÃO PARA SALVAR DETALHES DO IMÓVEL NO FIRESTORE (SEM ALTERAÇÕES SIGNIFICATIVAS NESTA VERSÃO)
  Future<void> _saveHouseDetailsToFirestore() async {
    if (_houseNameController.text.trim().isEmpty ||
        _addressController.text.trim().isEmpty ||
        _priceController.text.trim().isEmpty ||
        _descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos do imóvel.')),
      );
      return;
    }

    if (_pickedHouseImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecione pelo menos uma imagem para o imóvel.')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registrando imóvel...')),
    );

    try {
      // 1. Salvar os detalhes principais do imóvel no Firestore na coleção 'houses'
      final DocumentReference houseDocRef = await FirebaseFirestore.instance.collection('houses').add({
        'name': _houseNameController.text.trim(),
        'address': _addressController.text.trim(),
        'price': double.parse(_priceController.text.trim()), // Converter preço para double
        'description': _descriptionController.text.trim(),
        'isRented': false, // NOVO ATRIBUTO: Define o imóvel como não alugado por padrão
        'createdAt': FieldValue.serverTimestamp(),
      });

      final String houseId = houseDocRef.id; // Obtém o ID do documento do imóvel recém-criado

      // 2. Upload de cada imagem para o Firebase Storage e salvamento na subcoleção 'images'
      for (int i = 0; i < _pickedHouseImages.length; i++) {
        File imageFile = _pickedHouseImages[i];
        final String imageFileName = 'image_${i}_${DateTime.now().millisecondsSinceEpoch}.png';
        final Reference storageRef = FirebaseStorage.instance
            .ref()
            .child('house_photos')
            .child(houseId) // Cria uma pasta com o ID do imóvel
            .child(imageFileName);

        final UploadTask uploadTask = storageRef.putFile(imageFile);
        final TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
        final String imageUrl = await snapshot.ref.getDownloadURL();

        // Salvar metadados da imagem na subcoleção 'images'
        await houseDocRef.collection('images').add({
          'imageUrl': imageUrl,
          'houseId': houseId, // Redundante, mas pode ser útil para consultas
          'index': i, // Índice da imagem na lista (0 a 4)
          'uploadedAt': FieldValue.serverTimestamp(),
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Imóvel registrado com sucesso!')),
      );

      // Limpar campos e imagens após o registro bem-sucedido
      _houseNameController.clear();
      _addressController.clear();
      _priceController.clear();
      _descriptionController.clear();
      setState(() {
        _pickedHouseImages.clear(); // Limpa a lista de imagens selecionadas
      });

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha ao registrar imóvel: $e')),
      );
      debugPrint("Erro ao registrar imóvel: $e");
    }
  }

  @override
  void dispose() {
    _houseNameController.dispose();
    _addressController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Campo para a Imagem do Imóvel (agora uma lista horizontal)
              Card(
                margin: const EdgeInsets.symmetric(vertical: 20.0),
                elevation: 8.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _pickedHouseImages.isEmpty
                          ? Container(
                              height: 200,
                              width: double.infinity,
                              color: Colors.blueGrey[50],
                              child: Icon(
                                Icons.image,
                                size: 80,
                                color: Colors.blueGrey[300],
                              ),
                            )
                          : SizedBox(
                              height: 200, // Altura fixa para o ListView horizontal
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _pickedHouseImages.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(10.0),
                                          child: Image.file(
                                            _pickedHouseImages[index],
                                            height: 180,
                                            width: 180,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Positioned(
                                          top: 5,
                                          right: 5,
                                          child: GestureDetector(
                                            onTap: () => _removeImage(index),
                                            child: const CircleAvatar(
                                              radius: 15,
                                              backgroundColor: Colors.red,
                                              child: Icon(
                                                Icons.close,
                                                color: Colors.white,
                                                size: 15,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                      const SizedBox(height: 24.0),
                      ElevatedButton.icon(
                        onPressed: _pickedHouseImages.length < _maxImages
                            ? _pickImage // Chama a função para adicionar UMA imagem
                            : null, // Desabilita o botão se o limite for atingido
                        icon: const Icon(Icons.add_photo_alternate),
                        label: Text(
                          _pickedHouseImages.length < _maxImages
                              ? 'Adicionar Imagem (${_pickedHouseImages.length}/$_maxImages)'
                              : 'Limite de Imagens Atingido',
                          style: const TextStyle(fontSize: 18),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Campos de texto para detalhes do imóvel
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  controller: _houseNameController,
                  decoration: const InputDecoration(
                    labelText: 'Nome do Imóvel',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    labelText: 'Endereço',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Preço do Aluguel',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  controller: _descriptionController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'Descrição do Imóvel',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Botão para registrar o imóvel
              ElevatedButton.icon(
                onPressed: _saveHouseDetailsToFirestore, // Chama a função de salvar no Firestore
                icon: const Icon(Icons.save),
                label: const Text(
                  'Registrar Imóvel',
                  style: TextStyle(fontSize: 20),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
