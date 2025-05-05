//Bibliotecas Default
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Lottie
//import 'package:lottie/lottie.dart';

//Classes
import 'package:rent_a_house/pages/login.dart';
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
  bool isLoading = true;
  AuthService() {
    _authCheck();
  }
  _authCheck() {
    _auth.authStateChanges().listen((User? user) {
      usuario = (user == null) ? null : user;
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
      notifyListeners();
    });
  }

  _getUser() {
    usuario = _auth.currentUser;
    notifyListeners();
  }

  registerUser(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _getUser();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw AuthException('A senha\nfornecida\né muito fraca.');
      } else if (e.code == 'email-already-in-use') {
        throw AuthException('A conta\nencontrada\npara este email.');
      }
    }
  }

  loginUser(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      _getUser();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw AuthException('O email não encontrado.\nPor favor cadastre-se');
      } else if (e.code == 'wrong-password') {
        throw AuthException('Senha errada\ntente novamente\npor favor.');
      }
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
      return MyLoggedPage();
    }
  }
}
