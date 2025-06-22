// lib/services/firebase_service.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:rent_a_house/services/firebase_options.dart'; // For kDebugMode

/// A service class to handle all Firebase Authentication operations.
class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Initializes Firebase. This must be called before using any Firebase services.
  static Future<void> initializeFirebase() async {
    // Ensure Firebase is not initialized multiple times.
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  }

  /// Returns the currently signed-in Firebase user, or null if no user is signed in.
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  /// Registers a new user with email and password using Firebase Authentication.
  /// Throws [FirebaseAuthException] on Firebase-specific errors.
  /// Throws [Exception] on other general errors.
  Future<UserCredential> registerWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print('Firebase Registration Error: ${e.code} - ${e.message}');
      }
      // Provide more user-friendly messages for common errors
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage =
              'The email address is already in use by another account.';
          break;
        case 'weak-password':
          errorMessage = 'The password provided is too weak.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        default:
          errorMessage = 'An unexpected Firebase error occurred: ${e.message}';
      }
      throw Exception(errorMessage);
    } catch (e) {
      if (kDebugMode) {
        print('General Registration Error: $e');
      }
      throw Exception('Failed to register: $e');
    }
  }

  /// Signs in an existing user with email and password using Firebase Authentication.
  /// Throws [FirebaseAuthException] on Firebase-specific errors.
  /// Throws [Exception] on other general errors.
  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print('Firebase Login Error: ${e.code} - ${e.message}');
      }
      // Provide more user-friendly messages for common errors
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found for that email.';
          break;
        case 'wrong-password':
          errorMessage = 'Wrong password provided for that user.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        case 'user-disabled':
          errorMessage = 'This user account has been disabled.';
          break;
        default:
          errorMessage = 'An unexpected Firebase error occurred: ${e.message}';
      }
      throw Exception(errorMessage);
    } catch (e) {
      if (kDebugMode) {
        print('General Login Error: $e');
      }
      throw Exception('Failed to sign in: $e');
    }
  }

  /// Signs out the current Firebase user.
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      if (kDebugMode) {
        print('Firebase Sign Out Error: $e');
      }
      throw Exception('Failed to sign out: $e');
    }
  }
}
