// lib/services/auth_service.dart
import 'package:flutter/foundation.dart'; // For kDebugMode

import '../models/user_model.dart';
import 'firebase_service.dart';
import 'local_database_service.dart';
import 'connectivity_services.dart';

/// A service class that orchestrates user authentication,
/// deciding between Firebase (online) and SQLite (offline) based on connectivity.
class AuthService {
  final FirebaseService _firebaseService = FirebaseService();
  final LocalDatabaseService _localDatabaseService = LocalDatabaseService();

  /// Registers a new user with email and password.
  /// Requires an active internet connection to register with Firebase.
  /// On successful Firebase registration, the user is saved locally.
  Future<UserModel?> register(
    String email,
    String password,
    String displayName,
  ) async {
    final hasInternet = await ConnectivityService.isConnected();

    if (!hasInternet) {
      throw Exception('Registration requires an active internet connection.');
    }

    try {
      final userCredential = await _firebaseService
          .registerWithEmailAndPassword(email, password);
      final firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        // Update display name on Firebase
        await firebaseUser.updateDisplayName(displayName);

        final newUser = UserModel(
          uid: firebaseUser.uid,
          displayName: displayName,
          email: firebaseUser.email!,
          passwordStatus: password, // Assuming email/password registration
        );
        await _localDatabaseService.insertUser(newUser);
        return newUser;
      }
    } catch (e) {
      if (kDebugMode) {
        print('AuthService Registration Error: $e');
      }
      // Re-throw the specific exception from FirebaseService or a general one.
      rethrow;
    }
    return null; // Should ideally not reach here if exceptions are rethrown
  }

  /// Logs in a user.
  /// If online, attempts Firebase login and saves user locally on success.
  /// If offline, attempts to authenticate against the local SQLite database.
  Future<UserModel?> login(String email, String password) async {
    final hasInternet = await ConnectivityService.isConnected();

    if (hasInternet) {
      try {
        final userCredential = await _firebaseService
            .signInWithEmailAndPassword(email, password);
        final firebaseUser = userCredential.user;

        if (firebaseUser != null) {
          // Store/update user in local database after successful Firebase login
          final loggedInUser = UserModel(
            uid: firebaseUser.uid,
            displayName: firebaseUser.displayName,
            email: firebaseUser.email!,
            passwordStatus: 'PASSWORD_SET', // Assuming password login
          );
          await _localDatabaseService.insertUser(loggedInUser);
          return loggedInUser;
        }
      } catch (e) {
        if (kDebugMode) {
          print('AuthService Online Login Error: $e');
        }
        // Re-throw the specific exception from FirebaseService
        rethrow;
      }
    } else {
      // Offline login attempt
      try {
        final localUser = await _localDatabaseService.getUser(email);
        if (localUser != null && localUser.passwordStatus == 'PASSWORD_SET') {
          // IMPORTANT SECURITY NOTE:
          // For a real application, you MUST store securely hashed passwords
          // locally and compare the entered password's hash against the stored hash.
          // This simplified example only checks if a user with that email exists
          // and has a 'PASSWORD_SET' status. It does NOT validate the actual password.
          // This is a significant security vulnerability in a production app.
          if (kDebugMode) {
            print('Offline login successful for: ${localUser.email}');
          }
          return localUser;
        }
        throw Exception(
          'Offline login failed: User not found locally or invalid credentials. An internet connection is required for new users.',
        );
      } catch (e) {
        if (kDebugMode) {
          print('AuthService Offline Login Error: $e');
        }
        rethrow;
      }
    }
    return null; // Should not be reached if exceptions are thrown
  }

  /// Signs out the current user from Firebase.
  Future<void> signOut() async {
    try {
      await _firebaseService.signOut();
      // Optionally, clear specific user data from local database on sign out.
      // For simplicity, we're not clearing local data here, allowing offline login.
    } catch (e) {
      if (kDebugMode) {
        print('AuthService Sign Out Error: $e');
      }
      rethrow;
    }
  }

  /// Retrieves the current authenticated user.
  /// Prioritizes Firebase (if online) then falls back to local data.
  Future<UserModel?> getCurrentUser() async {
    final hasInternet = await ConnectivityService.isConnected();
    if (hasInternet) {
      final firebaseUser = _firebaseService.getCurrentUser();
      if (firebaseUser != null && firebaseUser.email != null) {
        // Ensure the Firebase user is also in the local database
        final userModel = UserModel(
          uid: firebaseUser.uid,
          displayName: firebaseUser.displayName,
          email: firebaseUser.email!,
          passwordStatus:
              'PASSWORD_SET', // Assuming they logged in via Firebase
        );
        await _localDatabaseService.insertUser(
          userModel,
        ); // Keep local data synced
        return userModel;
      }
    }
    // If no internet or no Firebase user, try to get from local database.
    // This part is tricky for "current user" in an offline multi-user scenario.
    // For simplicity, we'll return null if no online user.
    // A more complex app might store a 'last_logged_in_user_id' locally.
    return null;
  }
}
