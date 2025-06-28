import 'dart:async'; // For StreamSubscription
import 'dart:convert'; // For json.decode
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart'; // For checking current user
import 'package:cloud_firestore/cloud_firestore.dart'; // For saving house data
import 'package:firebase_storage/firebase_storage.dart'; // For uploading images
import 'package:http/http.dart' as http; // For Viacep API calls

// Remove unnecessary old imports related to local SQLite storage
// import 'dart:typed_data';
// import 'package:rent_a_house/pages/model/utility.dart';
// import 'dbdao/dbhelper.dart';

void main() {
  // Ensure Firebase is initialized before running the app
  // This typically happens in main.dart or a wrapper widget
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(MyNotesApp());
}

class MyNotesApp extends StatelessWidget {
  const MyNotesApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase CRUD', // Changed title to reflect Firebase
      theme: ThemeData(primarySwatch: Colors.blue),
      home: RegisterHousePage(),
      // Define routes for navigation
      routes: {
        '/auth': (context) => Container(), // Placeholder for your auth page
        // You should replace this with your actual MyLoginPage or a routing setup
        // For example: '/auth': (context) => const MyLoginPage(),
      },
    );
  }
}

class RegisterHousePage extends StatefulWidget {
  const RegisterHousePage({super.key});

  final String title = "Registro de Imóveis";
  @override
  State<RegisterHousePage> createState() => _RegisterHousePageState();
}

class _RegisterHousePageState extends State<RegisterHousePage> {
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  // Text controllers for form fields
  final _cepController = TextEditingController();
  final _logradouroController = TextEditingController();
  final _numeroController = TextEditingController();
  final _complementoController = TextEditingController();
  final _bairroController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _ufController = TextEditingController();
  final _valorController = TextEditingController();
  final _descricaoController = TextEditingController();

  List<File> _pickedImages = []; // Stores actual File objects for display and upload
  bool _isLoading = false; // To show loading indicators
  User? _currentUser; // Current Firebase user
  late StreamSubscription<User?> _authStateChangesSubscription; // To listen for auth changes

  // New state variables for categories
  List<String> _categories = [];
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    // Get initial user state
    _currentUser = FirebaseAuth.instance.currentUser;
    // Listen for authentication state changes to dynamically update the UI
    _authStateChangesSubscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      setState(() {
        _currentUser = user;
      });
    });

    _fetchCategories(); // Fetch categories when the page initializes
  }

  @override
  void dispose() {
    // Dispose all text controllers to prevent memory leaks
    _cepController.dispose();
    _logradouroController.dispose();
    _numeroController.dispose();
    _complementoController.dispose();
    _bairroController.dispose();
    _cidadeController.dispose();
    _ufController.dispose();
    _valorController.dispose();
    _descricaoController.dispose();
    _authStateChangesSubscription.cancel(); // Cancel the auth state listener
    super.dispose();
  }

  // --- Category Fetching Logic ---
  Future<void> _fetchCategories() async {
    try {
      // Fetch documents from the 'categories' collection
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('categories').get();
      
      setState(() {
        _categories = snapshot.docs.map((doc) => doc['name'] as String).toList();
        // Optional: If you want to pre-select the first category if available
        // if (_categories.isNotEmpty && _selectedCategory == null) {
        //   _selectedCategory = _categories.first;
        // }
      });
    } catch (e) {
      _showSnackBar('Erro ao carregar categorias: $e');
      debugPrint('Error fetching categories: $e');
    }
  }

  // --- Image Picking Logic ---
  Future<void> _pickImages() async {
    // Limit to a maximum of 5 images
    if (_pickedImages.length >= 5) {
      _showSnackBar('Você pode adicionar no máximo 5 imagens.');
      return;
    }

    try {
      // Allow picking multiple images
      final List<XFile>? selectedXFiles = await _picker.pickMultiImage();

      if (selectedXFiles != null && selectedXFiles.isNotEmpty) {
        setState(() {
          // Add selected images, respecting the 5-image limit
          for (var xFile in selectedXFiles) {
            if (_pickedImages.length < 5) {
              _pickedImages.add(File(xFile.path));
            } else {
              break; // Stop if limit is reached
            }
          }
        });
      }
    } catch (e) {
      _showSnackBar('Erro ao selecionar imagens: $e');
      debugPrint("Error picking images: $e");
    }
  }

  // Function to remove an image from the list
  void _removeImage(int index) {
    setState(() {
      _pickedImages.removeAt(index);
    });
  }

  // --- Viacep API Integration ---
  Future<void> _fetchAddressFromCep() async {
    final cep = _cepController.text.replaceAll('.', '').replaceAll('-', ''); // Clean CEP string
    if (cep.length != 8) {
      // Clear fields if CEP is not 8 digits long
      _logradouroController.clear();
      _bairroController.clear();
      _cidadeController.clear();
      _ufController.clear();
      return; // Invalid CEP length
    }

    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      final response = await http.get(Uri.parse('https://viacep.com.br/ws/$cep/json/'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['erro'] == true) {
          _showSnackBar('CEP não encontrado.');
          _logradouroController.clear();
          _bairroController.clear();
          _cidadeController.clear();
          _ufController.clear();
        } else {
          // Populate text fields with fetched data
          _logradouroController.text = data['logradouro'] ?? '';
          _bairroController.text = data['bairro'] ?? '';
          _cidadeController.text = data['localidade'] ?? '';
          _ufController.text = data['uf'] ?? '';
        }
      } else {
        _showSnackBar('Erro ao buscar CEP: ${response.statusCode}');
      }
    } catch (e) {
      _showSnackBar('Erro de rede ao buscar CEP: $e');
      debugPrint('Error fetching CEP: $e');
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }

  // --- House Registration Logic ---
  Future<void> _registerHouse() async {
    if (!_formKey.currentState!.validate()) {
      _showSnackBar('Por favor, preencha todos os campos obrigatórios.');
      return;
    }

    if (_pickedImages.isEmpty) {
      _showSnackBar('Por favor, adicione pelo menos uma imagem do imóvel.');
      return;
    }

    if (_selectedCategory == null) {
      _showSnackBar('Por favor, selecione uma categoria para o imóvel.');
      return;
    }

    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      // Ensure user is logged in and not anonymous
      if (_currentUser == null || _currentUser!.isAnonymous) {
        _showSnackBar('Você precisa estar logado para registrar um imóvel.');
        return;
      }

      final uid = _currentUser!.uid;
      final houseCollection = FirebaseFirestore.instance.collection('houses');

      // 1. Create a new document reference to get its ID before uploading images
      final newHouseDocRef = houseCollection.doc();
      final houseId = newHouseDocRef.id;

      // 2. Upload images to Firebase Storage
      List<String> imageUrls = [];
      for (int i = 0; i < _pickedImages.length; i++) {
        final imageFile = _pickedImages[i];
        final fileName = 'house_${houseId}_${DateTime.now().millisecondsSinceEpoch}_$i.png'; // Unique filename
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('houses/$houseId/$fileName'); // Storage path: houses/{houseId}/{filename}

        final uploadTask = storageRef.putFile(imageFile); // Upload the file
        final snapshot = await uploadTask.whenComplete(() {}); // Wait for upload to complete
        final downloadUrl = await snapshot.ref.getDownloadURL(); // Get the public download URL
        imageUrls.add(downloadUrl); // Add URL to list
      }

      // 3. Save house data to Firestore
      await newHouseDocRef.set({
        'userId': uid, // Link to the user who registered it
        'category': _selectedCategory, // Store the selected category
        'cep': _cepController.text.trim(),
        'logradouro': _logradouroController.text.trim(),
        'numero': _numeroController.text.trim(),
        'complemento': _complementoController.text.trim(),
        'bairro': _bairroController.text.trim(),
        'cidade': _cidadeController.text.trim(),
        'uf': _ufController.text.trim(),
        'valor': double.tryParse(_valorController.text.trim()) ?? 0.0,
        'descricao': _descricaoController.text.trim(),
        'imageUrls': imageUrls, // Store list of image URLs
        'createdAt': FieldValue.serverTimestamp(), // Timestamp for creation
      });

      _showSnackBar('Imóvel registrado com sucesso!');
      _clearForm(); // Clear form after successful registration
    } catch (e) {
      _showSnackBar('Erro ao registrar imóvel: $e');
      debugPrint('Error registering house: $e');
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }

  // Clears all form fields and picked images
  void _clearForm() {
    _cepController.clear();
    _logradouroController.clear();
    _numeroController.clear();
    _complementoController.clear();
    _bairroController.clear();
    _cidadeController.clear();
    _ufController.clear();
    _valorController.clear();
    _descricaoController.clear();
    setState(() {
      _pickedImages.clear();
      _selectedCategory = null; // Clear selected category
    });
  }

  // Helper to show a SnackBar message
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // --- UI Elements ---
  Widget _buildImageGridView() {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 3, // Adjusted height for better display
          child: _pickedImages.isEmpty
              ? Center(
                  child: Text(
                    'Nenhuma imagem selecionada.',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                )
              : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: _pickedImages.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      alignment: Alignment.topRight,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.file(
                            _pickedImages[index], // Display picked image
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.cancel, color: Colors.red, size: 28), // Remove image button
                          onPressed: () => _removeImage(index),
                        ),
                      ],
                    );
                  },
                ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Imagens: ${_pickedImages.length}/5', // Show current image count
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Conditional UI based on user login status
    if (_currentUser == null || _currentUser!.isAnonymous) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: <Widget>[
            TextButton.icon(
              label: Text("Voltar", style: TextStyle(fontSize: 18)),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/auth'); // Navigate back to auth page
              },
              icon: Icon(Icons.arrow_back),
            ),
          ],
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock, size: 80, color: Colors.grey),
                SizedBox(height: 20),
                Text(
                  'Você precisa estar logado com uma conta não anônima para registrar um imóvel.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.redAccent),
                ),
                SizedBox(height: 10),
                Text(
                  'Por favor, faça login ou cadastre-se para continuar.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.blueGrey),
                ),
                SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/auth');
                  },
                  icon: Icon(Icons.person),
                  label: Text('Ir para Tela de Login/Cadastro', style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }

    // Main UI for logged-in non-anonymous users
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          TextButton.icon(
            label: Text("Menu", style: TextStyle(fontSize: 18)),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/auth'); // Navigate to main menu/auth page
            },
            icon: Icon(Icons.arrow_back),
          ),
        ],
      ),
      // Floating Action Button for saving the house
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color.fromRGBO(82, 170, 94, 1.0),
        onPressed: _isLoading ? null : _registerHouse, // Disable button if loading
        icon: _isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2), // Loading spinner
              )
            : const Icon(
                Icons.save,
                color: Colors.white,
                size: 25,
              ),
        label: Text(
          _isLoading ? 'Registrando...' : 'Registrar Imóvel', // Dynamic button text
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Full screen loading indicator
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey, // Associate form key for validation
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Image Selection Section
                    _buildImageGridView(),
                    SizedBox(height: 16),
                    Center(
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.add_photo_alternate),
                        label: Text(
                          "Adicionar Imagens (${_pickedImages.length}/5)",
                          style: TextStyle(fontSize: 18),
                        ),
                        onPressed: _pickedImages.length < 5 ? _pickImages : null, // Disable if 5 images already selected
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                    SizedBox(height: 24), // Spacer

                    // Category Dropdown
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: InputDecoration(
                        labelText: 'Categoria do Imóvel',
                        hintText: 'Selecione a categoria',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                        suffixIcon: Icon(Icons.category),
                      ),
                      items: _categories.map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedCategory = newValue;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, selecione uma categoria';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),


                    // Form Fields
                    TextFormField(
                      controller: _cepController,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'CEP',
                        hintText: 'Digite o CEP',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.search),
                          onPressed: _fetchAddressFromCep,
                        ),
                      ),
                      maxLength: 8, // Enforce 8 digits for CEP
                      onChanged: (value) {
                        if (value.length == 8) {
                          _fetchAddressFromCep(); // Trigger lookup as soon as 8 digits are entered
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'CEP é obrigatório';
                        }
                        if (value.length != 8) {
                          return 'CEP inválido (8 dígitos)';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _logradouroController,
                      decoration: InputDecoration(
                        labelText: 'Logradouro/Rua',
                        hintText: 'Preenchido automaticamente pelo CEP',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                        suffixIcon: Icon(Icons.home),
                      ),
                      readOnly: true, // Make this field read-only as it's auto-filled
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Logradouro é obrigatório';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _numeroController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Número',
                        hintText: 'Número do imóvel',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                        suffixIcon: Icon(Icons.format_list_numbered),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Número é obrigatório';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _complementoController,
                      decoration: InputDecoration(
                        labelText: 'Complemento (Opcional)',
                        hintText: 'Apto, Bloco, etc.',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                        suffixIcon: Icon(Icons.add_box),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _bairroController,
                      decoration: InputDecoration(
                        labelText: 'Bairro',
                        hintText: 'Preenchido automaticamente pelo CEP',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                        suffixIcon: Icon(Icons.location_on),
                      ),
                      readOnly: true, // Make this field read-only
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Bairro é obrigatório';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _cidadeController,
                      decoration: InputDecoration(
                        labelText: 'Cidade',
                        hintText: 'Preenchido automaticamente pelo CEP',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                        suffixIcon: Icon(Icons.apartment),
                      ),
                      readOnly: true, // Make this field read-only
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Cidade é obrigatória';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _ufController,
                      decoration: InputDecoration(
                        labelText: 'Estado (UF)',
                        hintText: 'Preenchido automaticamente pelo CEP',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                        suffixIcon: Icon(Icons.map),
                      ),
                      readOnly: true, // Make this field read-only
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Estado é obrigatório';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _valorController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Valor (R\$)',
                        hintText: 'Preço do imóvel',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                        suffixIcon: Icon(Icons.attach_money),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Valor é obrigatório';
                        }
                        if (double.tryParse(value) == null || double.parse(value) <= 0) {
                          return 'Valor inválido';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Descrição",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: _descricaoController,
                      maxLines: 5, // Allow multiple lines for description
                      decoration: InputDecoration(
                        hintText: 'Detalhes do imóvel (ex: número de quartos, banheiros, etc.)',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                        alignLabelWithHint: true,
                      ),
                      keyboardType: TextInputType.multiline,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Descrição é obrigatória';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 80), // Spacer to prevent FAB from covering content
                  ],
                ),
              ),
            ),
    );
  }
}
