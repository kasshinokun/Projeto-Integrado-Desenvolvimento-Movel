//Bibliotecas Default
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


//Lottie
//import 'package:lottie/lottie.dart';

//Classes
import 'package:rent_a_house/pages/login2.dart';
import 'package:rent_a_house/pages/logged.dart';

//Isolar depois---------------------------------------------------------------------------------------------------------------
class AuthException implements Exception {
  String message;
  AuthException(this.message);
}

//Isolar depois---------------------------------------------------------------------------------------------------------------
class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<ScaffoldMessengerState> snackbarKey =
      GlobalKey<ScaffoldMessengerState>();
  User? usuario;
  String? idToken;
  bool isLoading = true;
  //bool isLogged = false;
  AuthService() {
    _authCheck();
  }
  _authCheck() {
    _auth.authStateChanges().listen((User? user) async {
      usuario = (user == null) ? null : user;
      //Captura de idToken
      idToken = (user == null) ? null : await _auth.currentUser!.getIdToken();
      if (usuario == null) {
        snackbarKey.currentState?.showSnackBar(
          SnackBar(
            content: Text('O(A) cliente\nestá\ndesconectado(a)\nno momento!'),
          ),
        );
      } else {
        snackbarKey.currentState?.showSnackBar(
          SnackBar(content: Text('O(A) cliente\nestá\nconectado(a)!')),
        );
      }
      isLoading = false;
      //isLogged = (user == null || user.isAnonymous) ? false : true;
      notifyListeners();
    });
  }

  _getUser() {
    usuario = _auth.currentUser;
    notifyListeners();
  }

  registerUser(String email, String password, String name) async {
    try {
      // Cria o usuário no Firebase Authentication
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = result.user;

      // Se o usuário foi criado com sucesso
      if (user != null) {
        // Salva os dados no Firestore
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': user.email,
          'name': name,
          'createdAt': FieldValue.serverTimestamp(),
        });

        _getUser(); // Atualiza o estado do usuário
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw AuthException('A senha fornecida é muito fraca.');
      } else if (e.code == 'email-already-in-use') {
        throw AuthException('Já existe uma conta para este email.');
      } else {
        throw AuthException('Erro: ${e.message}');
      }
    } catch (e) {
      throw AuthException('Erro inesperado: ${e.toString()}');
    }
  }


  loginUser(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      //isLogged = true;
      _getUser();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw AuthException('O email não encontrado.\nPor favor cadastre-se');
      } else if (e.code == 'wrong-password') {
        throw AuthException('Senha errada\ntente novamente\npor favor.');
      }
    }
  }

  loginGuestUser() async {
    try {
      await _auth.signInAnonymously();
      //
      _getUser();
    } on FirebaseAuthException catch (e) {
      switch (e.code) {}
    }
  }

  signOutUser() async {
    await _auth.signOut();
    _getUser();
  }
}

//Isolar depois---------------------------------------------------------------------------------------------------------------
Widget loading() {
  return Scaffold(body: Center(child: CircularProgressIndicator()));
}

//Isolar depois---------------------------------------------------------------------------------------------------------------
class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  @override
  Widget build(BuildContext context) {
    AuthService auth = Provider.of<AuthService>(context);
    if (auth.isLoading) {
      return loading();
    } else if (auth.usuario == null) {
      return MyLoginPage();
    } else {
      return MyLoggedPage(/*AuthService().isLogged*/);
    }
  }
}
