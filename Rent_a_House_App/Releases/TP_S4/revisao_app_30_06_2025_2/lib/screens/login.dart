// lib/screens/login2.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:rent_a_house/services/authservices.dart';
//import 'package:firebase_storage/firebase_storage.dart'; // Mantido caso haja outras necessidades de Storage
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rent_a_house/providers/connectivity_provider.dart';
import 'package:rent_a_house/providers/internet_connection_provider.dart';
import 'dart:convert'; // Importado para Base64
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

var maskTelefone = MaskTextInputFormatter(
  mask: '+## (##) ####-####', 
  filter: { "#": RegExp(r'[0-9]') },
  type: MaskAutoCompletionType.lazy
);
var maskCelular = MaskTextInputFormatter(
  mask: '+## (##) #####-####', 
  filter: { "#": RegExp(r'[0-9]') },
  type: MaskAutoCompletionType.lazy
);

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({super.key});

  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> snackbarLoginKey = GlobalKey<ScaffoldMessengerState>();

  File? _pickedImage;
  final _nameUserController = TextEditingController();
  final _emailUserController = TextEditingController();
  final _passwordUserController = TextEditingController();
  final _phoneUserController = TextEditingController();

  bool _visible = true;
  bool isLogin = true;
  late String titulo;
  late String actionButton;
  late String toggleButton;
  late String signGoogle;

  @override
  void initState() {
    _visible = false;
    super.initState();
    setFormAction(true);
  }

  setFormAction(bool validateAction) {
    setState(() {
      isLogin = validateAction;
      if (isLogin) {
        titulo = 'Bem-vindo caro(a) Cliente';
        actionButton = 'Entrar';
        toggleButton = 'Ainda não tem uma conta?\nCadastre-se agora.';
        signGoogle = 'Continuar com o Google';
      } else {
        titulo = 'Crie sua conta';
        actionButton = 'Cadastrar';
        toggleButton = 'Voltar ao Login';
        signGoogle = 'Registrar com o Google';
      }
    });
  }

  void manageUser() async {
    final connectivityProvider = Provider.of<ConnectivityProvider>(context, listen: false);
    final internetProvider = Provider.of<InternetConnectionProvider>(context, listen: false);
    final bool isOnline = connectivityProvider.isConnected && internetProvider.isConnectedToInternet;

    if (_formKey.currentState!.validate()) {
      if (isLogin) {
        await executeLogin(isOnline);
      } else {
        await executeRegister(isOnline);
      }
    }
  }

  executeLogin(bool isOnline) async {
    try {
      await context.read<AuthService>().loginUser(
            _emailUserController.text,
            _passwordUserController.text,
            isOnline: isOnline,
          );
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message), backgroundColor: Colors.red),
      );
    }
  }

  executeRegister(bool isOnline) async {
    if (!isOnline) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registro requer conexão com a internet.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // Cria o usuário no Firebase Authentication
      UserCredential result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailUserController.text,
        password: _passwordUserController.text,
      );
      final user = result.user;

      if (user != null) {
        String? profilePhotoBase64;

        if (_pickedImage != null) {
          try {
            List<int> imageBytes = await _pickedImage!.readAsBytes();
            profilePhotoBase64 = base64Encode(imageBytes);
            debugPrint('Imagem convertida para Base64. Tamanho: ${profilePhotoBase64.length} caracteres');
          } catch (e) {
            debugPrint('Erro ao converter imagem para Base64: $e');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Erro ao processar imagem para Base64: $e'), backgroundColor: Colors.orange),
            );
          }
        }

        // Salvar dados do usuário no Firestore
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': user.email,
          'name': _nameUserController.text.trim(),
          'phone': _phoneUserController.text.trim(),
          'profilePhotoBase64': profilePhotoBase64, // Salva a imagem como Base64
          'createdAt': FieldValue.serverTimestamp(),
        });
        debugPrint('Dados do usuário (incluindo telefone e imagem Base64) salvos no Firestore.');

        // Força a atualização do AuthService para que ele cacheie os dados offline
        await context.read<AuthService>().loginUser(
              _emailUserController.text,
              _passwordUserController.text,
              isOnline: true, // Força a rota online para cachear os dados
            );

      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw AuthException('A senha fornecida é muito fraca.');
      } else if (e.code == 'email-already-in-use') {
        throw AuthException('Já existe uma conta para este email.');
      } else {
        throw AuthException('Erro Firebase: ${e.message}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha ao registrar: $e'), backgroundColor: Colors.red),
      );
    }
  }

  callGuest() async {
    final connectivityProvider = Provider.of<ConnectivityProvider>(context, listen: false);
    final internetProvider = Provider.of<InternetConnectionProvider>(context, listen: false);
    final bool isOnline = connectivityProvider.isConnected && internetProvider.isConnectedToInternet;

    try {
      await context.read<AuthService>().loginGuestUser(isOnline: isOnline);
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message), backgroundColor: Colors.red),
      );
    }
  }

  void clearFields() {
    _nameUserController.clear();
    _emailUserController.clear();
    _passwordUserController.clear();
    _phoneUserController.clear();
    setState(() {
      _pickedImage = null;
    });
  }

  @override
  void dispose() {
    _nameUserController.dispose();
    _emailUserController.dispose();
    _passwordUserController.dispose();
    _phoneUserController.dispose();
    super.dispose();
  }

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
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _pickedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      debugPrint("Erro ao selecionar imagem: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha ao selecionar imagem: $e'), backgroundColor: Colors.red),
      );
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 100.0, left: 8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () => callGuest(),
                    icon: const Icon(Icons.close, size: 40.0),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        titulo,
                        style: const TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -1.5,
                        ),
                      ),
                    ),
                    // CAMPO IMAGEM (só para registro)
                    if (!isLogin)
                      Card(
                        margin: const EdgeInsets.all(20.0),
                        elevation: 8.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: _pickedImage != null
                                    ? Image.file(
                                        _pickedImage!,
                                        height: 200,
                                        width: 200,
                                        fit: BoxFit.cover,
                                      )
                                    : Container(
                                        height: 200,
                                        width: 200,
                                        color: Colors.blueGrey[50],
                                        child: Icon(
                                          Icons.image,
                                          size: 80,
                                          color: Colors.blueGrey[300],
                                        ),
                                      ),
                              ),
                              const SizedBox(height: 24.0),
                              ElevatedButton.icon(
                                onPressed: _pickImage,
                                icon: const Icon(Icons.add_photo_alternate),
                                label: const Text(
                                  'Selecionar Imagem',
                                  style: TextStyle(fontSize: 18),
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
                    // CAMPO NOME (só para registro)
                    if (!isLogin)
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: TextFormField(
                          controller: _nameUserController,
                          decoration: const InputDecoration(
                            labelText: 'Nome completo',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Digite seu nome completo';
                            }
                            return null;
                          },
                        ),
                      ),
                    // CAMPO TELEFONE (NOVO, só para registro)
                    if (!isLogin)
                      Padding(
                        padding: EdgeInsets.all(24.0),
                        child: TextFormField(
                          controller: _phoneUserController,
                          keyboardType: TextInputType.phone,
                          //inputFormatters: [maskCelular],
                          decoration: InputDecoration(
                            labelText: 'Telefone',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Digite seu telefone';
                            }
                            if (value.length < 10) return 'Telefone muito curto.';
                            return null;
                          },
                        ),
                      ),

                    // CAMPO EMAIL
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: TextFormField(
                        controller: _emailUserController,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        decoration: InputDecoration(
                          labelText: 'Email do(a) Cliente',
                          labelStyle: const TextStyle(fontSize: 20),
                          hintText: 'Email por favor',
                          hintStyle: const TextStyle(fontSize: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          suffixIcon: const Icon(Icons.email_outlined),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (email) {
                          if (email == null || email.isEmpty) return 'Email vazio';
                          if (email.length < 10) return 'Email curto.';
                          if (!email.contains("@")) return 'Email inválido.';
                          return null;
                        },
                      ),
                    ),

                    // CAMPO SENHA
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: _passwordUserController,
                        obscureText: !_visible,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        decoration: InputDecoration(
                          labelText: 'Senha do(a) Cliente',
                          labelStyle: const TextStyle(fontSize: 20),
                          hintText: 'Senha por favor',
                          hintStyle: const TextStyle(fontSize: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _visible ? Icons.visibility : Icons.visibility_off,
                              color: Colors.black87,
                            ),
                            onPressed: () {
                              setState(() {
                                _visible = !_visible;
                              });
                            },
                          ),
                        ),
                        validator: (String? validatePassword) {
                          RegExp regex = RegExp(
                            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,24}$',
                          );
                          if (validatePassword == null || validatePassword.isEmpty) {
                            return "Senha vazia";
                          }
                          if (!regex.hasMatch(validatePassword)) {
                            return "Senha inválida. Use 8-24 caracteres com símbolo, número, maiúscula e minúscula.";
                          }
                          return null;
                        },
                      ),
                    ),

                    // BOTÃO DE ENTRAR OU CADASTRAR
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: ElevatedButton(
                        onPressed: () => manageUser(),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.check),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                actionButton,
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // TOGGLE ENTRE LOGIN/REGISTRO
                    TextButton(
                      onPressed: () {
                        setFormAction(!isLogin);
                        clearFields();
                      },
                      child: Text(
                        toggleButton,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}