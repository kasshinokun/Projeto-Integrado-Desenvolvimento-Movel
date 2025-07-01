// lib/services/authservices.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert'; // Para utf8 e base64
import 'dart:io'; // Para File
import 'package:path_provider/path_provider.dart'; // Para getApplicationDocumentsDirectory

import 'package:rent_a_house/services/fakeruser.dart'; // Importa a classe FakeUser
import 'package:rent_a_house/utils/database_helper.dart';

// Classe de exceção de autenticação
class AuthException implements Exception {
  String message;
  AuthException(this.message);
}

// Serviço de autenticação
class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<ScaffoldMessengerState> snackbarKey = GlobalKey<ScaffoldMessengerState>();
  User? usuario; // Agora pode ser um User real ou um FakeUser
  String? idToken;
  bool isLoading = true;

  final DatabaseHelper _dbHelper = DatabaseHelper();

  AuthService() {
    _authCheck();
  }

  // Helper para salvar imagem Base64 em um arquivo local
  // Retorna o caminho do arquivo salvo.
  Future<String?> _saveBase64ImageToFile(String base64String, String uid) async {
    try {
      final bytes = base64Decode(base64String);
      final directory = await getApplicationDocumentsDirectory();
      final profilePicsDir = Directory('${directory.path}/profile_pics');
      if (!await profilePicsDir.exists()) {
        await profilePicsDir.create(recursive: true);
      }
      final filePath = '${profilePicsDir.path}/$uid.png';
      final file = File(filePath);
      await file.writeAsBytes(bytes);
      debugPrint('AuthService: Imagem salva localmente em: $filePath');
      return filePath;
    } catch (e) {
      debugPrint('AuthService: Erro ao salvar imagem Base64 em arquivo: $e');
      return null;
    }
  }

  // Hashing da senha usando SHA256 e o email como "sal" (parte do input para o hash)
  String _generateHashedPassword(String email, String password) {
    final String combinedString = email + password;
    final List<int> bytes = utf8.encode(combinedString);
    final Digest digest = sha256.convert(bytes);
    return base64Encode(digest.bytes);
  }

  // Método para carregar o usuário offline no início do aplicativo
  // e definir o `AuthService.usuario`
  Future<void> _loadAndSetOfflineUser() async {
    final prefs = await SharedPreferences.getInstance();
    final offlineUid = prefs.getString('offline_uid');
    final offlineEmail = prefs.getString('offline_email');
    final offlineName = prefs.getString('offline_name');
    final offlinePhotoPath = prefs.getString('offline_photo_path');

    if (offlineUid != null && offlineEmail != null) {
      debugPrint('AuthService: Tentando carregar usuário offline de SharedPreferences.');
      usuario = FakeUser(offlineUid, offlineEmail, offlineName, offlinePhotoPath);
      debugPrint('AuthService: Usuário offline carregado: ${usuario?.email}, Nome: ${usuario?.displayName}, Foto: ${usuario?.photoURL}');
    } else {
      debugPrint('AuthService: Nenhum dado de usuário offline encontrado em SharedPreferences.');
      await _clearOfflineLoginStatus();
      usuario = null;
    }
    isLoading = false;
    notifyListeners();
  }

  _authCheck() {
    _auth.authStateChanges().listen((User? firebaseUser) async {
      idToken = (firebaseUser == null) ? null : await firebaseUser.getIdToken();

      if (firebaseUser == null) {
        await _loadAndSetOfflineUser();
      } else {
        usuario = firebaseUser;
        if (firebaseUser.isAnonymous == false) {
          final userDoc = await FirebaseFirestore.instance.collection('users').doc(firebaseUser.uid).get();
          if (userDoc.exists) {
            final userData = userDoc.data();
            final String? name = userData?['name'];
            final String? profilePhotoBase64 = userData?['profilePhotoBase64'];

            // Atualiza o displayName do usuário Firebase
            if (name != null && firebaseUser.displayName != name) {
              await firebaseUser.updateDisplayName(name);
              // Recarrega o usuário para que as mudanças no displayName sejam refletidas
              await firebaseUser.reload();
              usuario = _auth.currentUser; // Obtém o usuário atualizado
              debugPrint('AuthService: DisplayName do Firebase User atualizado para: $name');
            }

            await _saveUserForOfflineLogin(
              firebaseUser.uid,
              firebaseUser.email,
              name,
              null, // A senha não vem do Firebase auth
              profilePhotoBase64,
            );
          }
        }
        isLoading = false;
        notifyListeners();
        debugPrint('AuthService: Usuário Firebase autenticado. Email: ${usuario?.email}, Nome: ${usuario?.displayName}, isLoading: $isLoading');
      }
    });
  }

  _getUser() {
    // Ao chamar _getUser(), garantimos que o 'usuario' seja o User atualizado do Firebase Auth
    // ou o _FakeUser já definido pela lógica offline/loadAndSetOfflineUser.
    usuario = _auth.currentUser;
    // Se o _auth.currentUser ainda for null aqui, tenta carregar do cache offline
    if (usuario == null) {
      _loadAndSetOfflineUser(); // Assegura que o usuario seja setado se houver offline data
    }
    notifyListeners();
  }

  // Salva os dados do usuário no SQLite e SharedPreferences após login/registro online
  Future<void> _saveUserForOfflineLogin(String uid, String? email, String? name, String? password, String? profilePhotoBase64) async {
    if (email == null) return;

    String hashedPassword = '';
    if (password != null) {
      hashedPassword = _generateHashedPassword(email, password);
    } else {
      final userInDb = await _dbHelper.getUserByEmail(email);
      if (userInDb != null && userInDb['hashed_password'] != null) {
        hashedPassword = userInDb['hashed_password'];
      }
    }

    String? localProfilePhotoPath;
    if (profilePhotoBase64 != null && profilePhotoBase64.isNotEmpty) {
      localProfilePhotoPath = await _saveBase64ImageToFile(profilePhotoBase64, uid);
    }

    // Salva no SQLite
    await _dbHelper.insertUser({
      'uid': uid,
      'email': email,
      'hashed_password': hashedPassword,
      'name': name ?? '',
      'profile_photo_base64': profilePhotoBase64 ?? '',
    });

    // Salva nas SharedPreferences (para status de login e dados básicos)
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('offline_uid', uid);
    await prefs.setString('offline_name', name ?? '');
    await prefs.setString('offline_email', email);
    if (localProfilePhotoPath != null) {
      await prefs.setString('offline_photo_path', localProfilePhotoPath);
    } else {
      await prefs.remove('offline_photo_path');
    }
    debugPrint('AuthService: Dados offline salvos/atualizados. Caminho da foto: $localProfilePhotoPath');
  }

  // Limpa o status de login offline
  Future<void> _clearOfflineLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('offline_uid');
    await prefs.remove('offline_name');
    await prefs.remove('offline_email');
    await prefs.remove('offline_photo_path');
    await _dbHelper.clearAllUsers();
    debugPrint('AuthService: Dados offline limpos.');
  }

  Future<void> registerUser(String email, String password, String name) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = result.user;

      if (user != null) {
        // Define o displayName para o usuário recém-registrado no Firebase
        if (name.isNotEmpty) {
          await user.updateDisplayName(name);
          // Recarrega o usuário para que as mudanças no displayName sejam refletidas
          await user.reload();
          usuario = _auth.currentUser; // Obtém o usuário atualizado
          notifyListeners(); // Notifica os listeners após a atualização do displayName
          debugPrint('AuthService: DisplayName do usuário registrado atualizado para: $name');
        }

        _getUser(); // Garante que o usuário atualizado seja definido
        debugPrint('AuthService: Usuário registrado no Firebase: ${user.email}');
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
      throw AuthException('Erro inesperado durante o registro: ${e.toString()}');
    }
  }

  Future<void> loginUser(String email, String password, {required bool isOnline}) async {
    if (isOnline) {
      try {
        UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
        User? user = credential.user;

        if (user != null) {
          final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
          String? name;
          String? profilePhotoBase64;
          if (userDoc.exists) {
            final userData = userDoc.data();
            name = userData?['name'];
            profilePhotoBase64 = userData?['profilePhotoBase64'];
          }

          // Atualiza o displayName do usuário Firebase após o login
          if (name != null && user.displayName != name) {
            await user.updateDisplayName(name);
            await user.reload(); // Recarrega para obter as propriedades atualizadas
            usuario = _auth.currentUser; // Atribui o usuário atualizado do Firebase Auth
            notifyListeners(); // Notifica após a atualização do displayName
            debugPrint('AuthService: DisplayName do Firebase User após login atualizado para: $name');
          }

          await _saveUserForOfflineLogin(user.uid, email, name, password, profilePhotoBase64);
          _getUser(); // Garante que o usuario está atualizado no Provider
          debugPrint('AuthService: Login online bem-sucedido para ${user.email}');
        }
        return;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'network-request-failed' || e.code == 'unavailable') {
          debugPrint('AuthService: Login online falhou devido a problema de rede. Tentando login offline...');
          await _loginOffline(email, password);
        } else {
          if (e.code == 'user-not-found') {
            throw AuthException('O email não encontrado.\nPor favor cadastre-se');
          } else if (e.code == 'wrong-password') {
            throw AuthException('Senha errada\ntente novamente.');
          } else {
            throw AuthException('Erro Firebase: ${e.message}');
          }
        }
      } catch (e) {
        debugPrint('AuthService: Erro inesperado durante login online: $e');
        throw AuthException('Erro inesperado durante o login online: ${e.toString()}');
      }
    } else {
      debugPrint('AuthService: Não online. Tentando login offline...');
      await _loginOffline(email, password);
    }
  }

  // Lógica de login offline
  Future<void> _loginOffline(String email, String password) async {
    final storedUser = await _dbHelper.getUserByEmail(email);

    if (storedUser == null) {
      throw AuthException('Usuário não encontrado no cache offline. Conecte-se para fazer login.');
    }

    final String hashedPasswordInput = _generateHashedPassword(email, password);
    if (hashedPasswordInput == storedUser['hashed_password']) {
      String? localProfilePhotoPath;
      final String? profilePhotoBase64 = storedUser['profile_photo_base64'];
      if (profilePhotoBase64 != null && profilePhotoBase64.isNotEmpty) {
        localProfilePhotoPath = await _saveBase64ImageToFile(profilePhotoBase64, storedUser['uid']);
      }

      usuario = FakeUser(
        storedUser['uid'],
        storedUser['email'],
        storedUser['name'], // Nome do usuário do SQLite
        localProfilePhotoPath,
      );
      notifyListeners();
      debugPrint('AuthService: Login offline bem-sucedido para ${storedUser['email']}, Nome: ${storedUser['name']}, Foto: $localProfilePhotoPath');
    } else {
      throw AuthException('Senha offline incorreta.');
    }
  }

  Future<void> loginGuestUser({required bool isOnline}) async {
    if (isOnline) {
      try {
        await _auth.signInAnonymously();
        _getUser();
        debugPrint('AuthService: Login de convidado online bem-sucedido.');
      } on FirebaseAuthException catch (e) {
        throw AuthException('Erro ao fazer login como convidado: ${e.message}');
      }
    } else {
      throw AuthException('Login de convidado não disponível offline. Conecte-se para continuar.');
    }
  }

  Future<void> signOutUser() async {
    debugPrint('AuthService: Tentando fazer logout.');
    await _auth.signOut();
    await _clearOfflineLoginStatus();
    usuario = null;
    notifyListeners();
    debugPrint('AuthService: Logout concluído.');
  }
}

// Widget de loading (mantido em authservices.dart por conveniência)
Widget loading() {
  return const Scaffold(body: Center(child: CircularProgressIndicator()));
}
