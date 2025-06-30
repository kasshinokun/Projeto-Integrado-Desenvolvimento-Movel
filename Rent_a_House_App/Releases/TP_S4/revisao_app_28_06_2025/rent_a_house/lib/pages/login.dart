import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:rent_a_house/services/authservices.dart';

//adaptação teste registro com foto
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

//Salva localmente por hora
Future<void> saveImage(XFile image) async {
  final directory = await getApplicationDocumentsDirectory();
  final path = directory.path;
  final fileName = DateTime.now().millisecondsSinceEpoch.toString();
  final File newImage = await File(image.path).copy('$path/$fileName.png');
  print("Imagem salva em: ${newImage.path}");
}


class MyLoginPage extends StatefulWidget {
  const MyLoginPage({super.key});

  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> snackbarLoginKey =
  GlobalKey<ScaffoldMessengerState>();

  File? _pickedImage; // Variavel para guardar a imagem selecionada
  final _nameUserController = TextEditingController();
  final _emailUserController = TextEditingController();
  final _passwordUserController = TextEditingController();

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

  void manageUser() {
    if (_formKey.currentState!.validate()) {
      if (isLogin) {
        executeLogin();
      } else {
        executeRegister();
      }
    }
  }

  executeLogin() async {
    try {
      await context.read<AuthService>().loginUser(
        _emailUserController.text,
        _passwordUserController.text,
      );
    } on AuthException catch (e) {
      snackbarLoginKey.currentState?.showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    }
  }

  executeRegister() async {
    try {
      await context.read<AuthService>().registerUser(
        _emailUserController.text,
        _passwordUserController.text,
        _nameUserController.text,
      );

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': user.email,
          'name': _nameUserController.text.trim(),
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    } on AuthException catch (e) {
      snackbarLoginKey.currentState?.showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    }
  }

  callGuest() async {
    try {
      await context.read<AuthService>().loginGuestUser();
    } on AuthException catch (e) {
      snackbarLoginKey.currentState?.showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    }
  }

  void clearFields() {
    _nameUserController.clear();
    _emailUserController.clear();
    _passwordUserController.clear();
  }

  @override
  void dispose() {
    _nameUserController.dispose();
    _emailUserController.dispose();
    _passwordUserController.dispose();
    super.dispose();
  }
  //====================================================================================================
  // Function to handle the image picking process, including permission checks
Future<void> _pickImage() async {
  // Request permissions for photos (gallery) and camera
  final PermissionStatus photoStatus = await Permission.photos.request();
  final PermissionStatus cameraStatus = await Permission.camera.request();

  // Check if either photo or camera permission is granted
  if (photoStatus.isGranted || cameraStatus.isGranted) {
    // If permissions are granted, show the image source selection sheet
    _showImageSourceActionSheet(context);
  } else if (photoStatus.isDenied || cameraStatus.isDenied) {
    // If permissions are denied (but not permanently), show a denial dialog
    _showPermissionDeniedDialog();
  } else if (photoStatus.isPermanentlyDenied || cameraStatus.isPermanentlyDenied) {
    // If permissions are permanently denied, show a dialog with an option to open settings
    _showPermissionPermanentlyDeniedDialog();
  }
}
// Displays a modal bottom sheet for the user to choose image source (gallery or camera)
void _showImageSourceActionSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min, // Make the column take minimum space
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Photo Library'),
              onTap: () {
                Navigator.pop(context); // Close the bottom sheet
                _pickImageFromSource(ImageSource.gallery); // Pick from gallery
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context); // Close the bottom sheet
                _pickImageFromSource(ImageSource.camera); // Pick from camera
              },
            ),
          ],
        ),
      );
    },
  );
}
// Picks an image from the specified source (gallery or camera)
Future<void> _pickImageFromSource(ImageSource source) async {
  final ImagePicker picker = ImagePicker();
  try {
    final XFile? pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      // If an image is picked, update the state to display it
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    }
  } catch (e) {
    // Log any errors during image picking
    debugPrint("Error picking image: $e");
    // Optionally show a user-friendly message if an error occurs
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to pick image: $e')),
    );
  }
}
  // Shows an AlertDialog when permissions are denied (but not permanently)
  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Permission Denied'),
          content: const Text('Permission to access photos or camera was denied. Please enable it in app settings to pick an image.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
  // Shows an AlertDialog when permissions are permanently denied, offering to open app settings
  void _showPermissionPermanentlyDeniedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Permission Permanently Denied'),
          content: const Text('Permission to access photos or camera was permanently denied. Please go to app settings and enable it manually.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Open Settings'),
              onPressed: () {
                openAppSettings(); // Open app settings using permission_handler
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
  //====================================================================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 100.0, left: 8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () => callGuest(),
                    icon: Icon(Icons.close, size: 40.0),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        titulo,
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -1.5,
                        ),
                      ),
                    ),
                    // CAMPO IMAGEM
                    if (!isLogin)
                      Card(
                      margin: const EdgeInsets.all(20.0), // Margin around the card
                      elevation: 8.0, // Shadow effect for the card
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0), // Rounded corners for the card
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0), // Padding inside the card
                        child: Column(
                          mainAxisSize: MainAxisSize.min, // Make column take minimum vertical space
                          children: [
                            // Display area for the picked image or a placeholder
                            ClipRRect( // Clip image to rounded rectangle
                              borderRadius: BorderRadius.circular(10.0),
                              child: _pickedImage != null
                                  ? Image.file(
                                      _pickedImage!,
                                      height: 200,
                                      width: 200,
                                      fit: BoxFit.cover, // Cover the box while maintaining aspect ratio
                                    )
                                  : Container(
                                      height: 200,
                                      width: 200,
                                      color: Colors.blueGrey[50], // Placeholder background color
                                      child: Icon(
                                        Icons.image,
                                        size: 80,
                                        color: Colors.blueGrey[300], // Placeholder icon color
                                      ),
                                    ),
                            ),
                            const SizedBox(height: 24.0), // Spacer below the image/placeholder
                            ElevatedButton.icon(
                              onPressed: _pickImage, // Call the image picking function when pressed
                              icon: const Icon(Icons.add_photo_alternate), // Icon for the button
                              label: const Text(
                                'Select Image',
                                style: TextStyle(fontSize: 18),
                              ),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10), // Rounded button corners
                                ),
                                elevation: 5, // Button shadow
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // CAMPO NOME
                    if (!isLogin)
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: TextFormField(
                          controller: _nameUserController,
                          decoration: InputDecoration(
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


                    // CAMPO EMAIL
                    Padding(
                      padding: EdgeInsets.all(24.0),
                      child: TextFormField(
                        controller: _emailUserController,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        decoration: InputDecoration(
                          labelText: 'Email do(a) Cliente',
                          labelStyle: TextStyle(fontSize: 20),
                          hintText: 'Email por favor',
                          hintStyle: TextStyle(fontSize: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          suffixIcon: Icon(Icons.email_outlined),
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
                      padding: EdgeInsets.all(24.0),
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: _passwordUserController,
                        obscureText: !_visible,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        decoration: InputDecoration(
                          labelText: 'Senha do(a) Cliente',
                          labelStyle: TextStyle(fontSize: 20),
                          hintText: 'Senha por favor',
                          hintStyle: TextStyle(fontSize: 16),
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
                      padding: EdgeInsets.all(24.0),
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
                            Icon(Icons.check),
                            Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                actionButton,
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // TOGGLE ENTRE LOGIN/REGISTRO
                    TextButton(
                      onPressed: () => setFormAction(!isLogin),
                      child: Text(
                        toggleButton,
                        textAlign: TextAlign.center,
                        style: TextStyle(
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
