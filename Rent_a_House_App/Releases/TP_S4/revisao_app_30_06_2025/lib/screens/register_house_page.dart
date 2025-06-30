// lib/screens/register_house_page.dart v3
import 'dart:io';
import 'dart:typed_data'; // Para Uint8List
import 'dart:convert'; // Para base64Encode
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart'; // Mantido removido, conforme solicitado
import 'package:rent_a_house/utils/viacep.dart';
import 'package:rent_a_house/utils/resultcep.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rent_a_house/services/authservices.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
// import 'package:path_provider/path_provider.dart'; // Não é estritamente necessário para compressão que retorna bytes

class RegisterHousePage extends StatefulWidget {
  const RegisterHousePage({super.key});

  final String title = "Registrar Imóvel";

  @override
  State<RegisterHousePage> createState() => _RegisterHousePageState();
}

class _RegisterHousePageState extends State<RegisterHousePage> {
  final ImagePicker _picker = ImagePicker();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _houseNameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _complementHouseController = TextEditingController();
  final TextEditingController _numberHouseController = TextEditingController();

  String _selectedHouseType = "Apartamento";
  final List<String> _houseTypes = [
    "Apartamento", "Kitnet", "Pousada", "Casa", "Casa de Campo", "Sítio", "Casa de Praia", "Outros"
  ];

  List<File> _pickedHouseImages = [];
  final int _maxImages = 5;

  bool _isSearchingCep = false;

  @override
  void dispose() {
    _houseNameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _cepController.dispose();
    _addressController.dispose();
    _complementHouseController.dispose();
    _numberHouseController.dispose();
    super.dispose();
  }

  // Funções para gerenciamento de imagens (ImagePicker)
  Future<void> _pickImage() async {
    final PermissionStatus photoStatus = await Permission.photos.request();
    final PermissionStatus cameraStatus = await Permission.camera.request();

    if (photoStatus.isGranted || cameraStatus.isGranted) {
      _showImageSourceActionSheet(context);
    } else if (photoStatus.isDenied || cameraStatus.isDenied) {
      _showPermissionDeniedDialog();
    } else if (photoStatus.isPermanentlyDenied || cameraStatus.isPermanentlyDenied) {
      _showPermissionPermanentlyDeniedDialog();
    }
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Biblioteca de Fotos'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromSource(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Câmera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromSource(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImageFromSource(ImageSource source) async {
    if (_pickedHouseImages.length >= _maxImages) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Limite máximo de 5 imagens atingido.')),
      );
      return;
    }

    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _pickedHouseImages.add(File(pickedFile.path));
        });
      }
    } catch (e) {
      debugPrint("Erro ao selecionar imagem: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha ao selecionar imagem: $e')),
      );
    }
  }

  void _removeImage(int index) {
    setState(() {
      _pickedHouseImages.removeAt(index);
    });
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Permissão Negada'),
          content: const Text(
              'A permissão para acessar fotos ou câmera foi negada. Por favor, habilite-a nas configurações do aplicativo para selecionar uma imagem.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showPermissionPermanentlyDeniedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Permissão Negada Permanentemente'),
          content: const Text(
              'A permissão para acessar fotos ou câmera foi negada permanentemente. Por favor, vá para as configurações do aplicativo e habilite-a manualmente.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Abrir Configurações'),
              onPressed: () {
                openAppSettings();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _searchCep() async {
    if (_cepController.text.isEmpty || _cepController.text.length != 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, digite um CEP válido (8 dígitos).')),
      );
      return;
    }

    setState(() {
      _isSearchingCep = true;
      _addressController.clear();
    });

    try {
      final String cep = _cepController.text;
      final ResultCep resultCep = await ViaCepService.fetchCep(cep: cep);

      if (resultCep.logradouro != null) {
        setState(() {
          _addressController.text =
              "${resultCep.logradouro}, ${resultCep.bairro} - ${resultCep.localidade}, ${resultCep.estado}, CEP: ${resultCep.cep}";
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('CEP encontrado com sucesso!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('CEP não encontrado ou inválido.')),
        );
        _addressController.clear();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao buscar CEP: $e')),
      );
      _addressController.clear();
    } finally {
      setState(() {
        _isSearchingCep = false;
      });
    }
  }

  Future<void> _saveHouseDetailsToFirestore() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos obrigatórios.')),
      );
      return;
    }

    if (_pickedHouseImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecione pelo menos uma imagem para o imóvel.')),
      );
      return;
    }

    final authService = Provider.of<AuthService>(context, listen: false);
    final String? ownerUid = authService.usuario?.uid;

    if (ownerUid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro: Usuário não autenticado. Faça login para registrar um imóvel.')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registrando imóvel...')),
    );

    try {
      // 1. Salvar os detalhes gerais do imóvel na coleção 'houses'
      final DocumentReference houseDocRef = await FirebaseFirestore.instance.collection('houses').add({
        'name': _houseNameController.text.trim(),
        'address': _addressController.text.trim(),
        'number': _numberHouseController.text.trim(),
        'complement': _complementHouseController.text.trim(),
        'zipcode': _cepController.text.trim(),
        'price': double.parse(_priceController.text.trim()),
        'description': _descriptionController.text.trim(),
        'type': _selectedHouseType,
        'isRented': false,
        'createdAt': FieldValue.serverTimestamp(),
        'ownerUid': ownerUid,
      });

      final String houseId = houseDocRef.id; // Obtém o ID do documento do imóvel recém-criado

      // 2. Processar e salvar cada imagem na coleção 'house_photos'
      debugPrint('RegisterHousePage: Processando e salvando imagens na coleção top-level house_photos...');
      for (int i = 0; i < _pickedHouseImages.length; i++) {
        File imageFile = _pickedHouseImages[i];
        debugPrint('RegisterHousePage: Lendo imagem ${i+1}: ${imageFile.path}');

        if (!imageFile.existsSync()) {
          debugPrint('RegisterHousePage: ERRO CRÍTICO: Arquivo da imagem NÃO existe no caminho: ${imageFile.path}. Pulando esta imagem.');
          continue;
        }

        Uint8List? bytesToProcess;
        int originalSize = imageFile.lengthSync(); // Tamanho original em bytes
        // Mantém o limite de 0.9 MB para Base64, para tentar não exceder o limite de 1MB do documento
        const int maxSizeBytesForCompression = 900 * 1024;

        if (originalSize > maxSizeBytesForCompression) {
          debugPrint('RegisterHousePage: Imagem ${i+1} é maior que ${maxSizeBytesForCompression / 1024}KB (${(originalSize / 1024 / 1024).toStringAsFixed(2)}MB). Tentando comprimir...');
          try {
            CompressFormat format = CompressFormat.png;
            if (imageFile.path.toLowerCase().endsWith('.jpg') || imageFile.path.toLowerCase().endsWith('.jpeg')) {
              format = CompressFormat.jpeg;
            }

            bytesToProcess = await FlutterImageCompress.compressWithFile(
              imageFile.absolute.path,
              minWidth: 1080,
              minHeight: 1080,
              quality: 80,
              format: format,
            );

            if (bytesToProcess != null) {
              debugPrint('RegisterHousePage: Imagem ${i+1} comprimida para ${ (bytesToProcess.length / 1024 / 1024).toStringAsFixed(2)}MB.');
            } else {
              debugPrint('RegisterHousePage: Falha na compressão da imagem ${i+1}. Usando bytes originais.');
              bytesToProcess = await imageFile.readAsBytes(); // Fallback para bytes originais
            }
          } catch (e) {
            debugPrint('RegisterHousePage: Erro durante a compressão da imagem ${i+1}: $e. Usando bytes originais.');
            bytesToProcess = await imageFile.readAsBytes(); // Fallback para bytes originais
          }
        } else {
          debugPrint('RegisterHousePage: Imagem ${i+1} (${(originalSize / 1024 / 1024).toStringAsFixed(2)}MB) está dentro do limite. Não é necessário comprimir.');
          bytesToProcess = await imageFile.readAsBytes();
        }

        // Verifica se bytesToProcess não é nulo e não está vazio
        if (bytesToProcess != Uint8List(0) && bytesToProcess.isNotEmpty) {
          String base64String = base64Encode(bytesToProcess);
          // Salva cada imagem na coleção 'house_photos' (agora de nível superior)
          await FirebaseFirestore.instance.collection('house_photos').add({
            'houseId': houseId, // ID do imóvel ao qual a foto está vinculada
            'photoIndex': i, // Índice da foto em relação às fotos da casa
            'base64String': base64String, // A string Base64 da imagem
            'ownerUid': ownerUid, // Adicionando ownerUid ao documento da foto
            'uploadedAt': FieldValue.serverTimestamp(),
          });
          debugPrint('RegisterHousePage: Imagem ${i+1} (Base64) salva na coleção house_photos.');
        } else {
          debugPrint('RegisterHousePage: Bytes da imagem ${i+1} são nulos ou vazios após processamento. Pulando.');
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Imóvel registrado com sucesso!')),
      );

      // Limpar campos e imagens após o registro bem-sucedido
      _formKey.currentState?.reset();
      _houseNameController.clear();
      _priceController.clear();
      _descriptionController.clear();
      _cepController.clear();
      _addressController.clear();
      _complementHouseController.clear();
      _numberHouseController.clear();
      setState(() {
        _pickedHouseImages.clear();
        _selectedHouseType = "Apartamento";
      });

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha ao registrar imóvel: $e')),
      );
      debugPrint("Erro ao registrar imóvel: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey[50],
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Icon(
                                  Icons.image,
                                  size: 80,
                                  color: Colors.blueGrey[300],
                                ),
                              )
                            : SizedBox(
                                height: 200,
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
                              ? _pickImage
                              : null,
                          icon: const Icon(Icons.add_photo_alternate),
                          label: Text(
                            _pickedHouseImages.length < _maxImages
                                ? 'Adicionar Imagem (${_pickedHouseImages.length}/$_maxImages)'
                                : 'Limite de Imagens Atingido',
                            style: const TextStyle(fontSize: 18),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: Colors.blueAccent,
                            foregroundColor: Colors.white,
                            elevation: 5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                TextFormField(
                  controller: _houseNameController,
                  decoration: const InputDecoration(
                    labelText: 'Nome do Imóvel',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.house),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, digite o nome do imóvel';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),

                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Preço do Aluguel',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, digite o preço do aluguel';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Preço inválido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),

                TextFormField(
                  controller: _descriptionController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Descrição do Imóvel',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.description),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, digite uma descrição';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),

                InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Tipo de Imóvel',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.category),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedHouseType,
                      isExpanded: true,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedHouseType = newValue!;
                        });
                      },
                      items: _houseTypes.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                TextFormField(
                  controller: _cepController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(8),
                  ],
                  decoration: InputDecoration(
                    labelText: 'CEP do Imóvel',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.location_on),
                    suffixIcon: _isSearchingCep
                        ? const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: _searchCep,
                          ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length != 8) {
                      return 'Por favor, digite um CEP válido (8 dígitos)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),

                TextFormField(
                  controller: _addressController,
                  maxLines: 2,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Endereço Completo',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.map),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'O endereço será preenchido após a busca do CEP';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),

                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _numberHouseController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: const InputDecoration(
                          labelText: 'Número',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.format_list_numbered),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Digite o número';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: TextFormField(
                        controller: _complementHouseController,
                        decoration: const InputDecoration(
                          labelText: 'Complemento',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.add_location_alt),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                ElevatedButton.icon(
                  onPressed: _saveHouseDetailsToFirestore,
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
                    elevation: 5,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
