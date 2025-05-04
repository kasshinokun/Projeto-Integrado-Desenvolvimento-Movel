import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> login(String email, String senha) {
    return _auth.signInWithEmailAndPassword(email: email, password: senha);
  }

  Future<UserCredential> registrar(String email, String senha) {
    return _auth.createUserWithEmailAndPassword(email: email, password: senha);
  }

  Future<void> logout() {
    return _auth.signOut();
  }
}