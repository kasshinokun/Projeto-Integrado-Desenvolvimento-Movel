import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import 'package:rent_a_house/services/authservices.dart';

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
