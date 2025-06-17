// lib/services/local_database_service.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart'; // For kDebugMode

import '../models/user_model.dart';

/// A service class to manage local user data persistence using SQLite.
class LocalDatabaseService {
  static Database? _database;
  static final LocalDatabaseService _instance =
      LocalDatabaseService._internal();

  factory LocalDatabaseService() {
    return _instance;
  }

  LocalDatabaseService._internal();

  /// Returns the initialized database instance.
  /// If the database is not yet initialized, it will initialize it.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  /// Initializes the SQLite database.
  /// Creates the 'users' table if it doesn't exist.
  Future<Database> _initDb() async {
    try {
      final documentsDirectory = await getApplicationDocumentsDirectory();
      final path = join(documentsDirectory.path, 'user_database.db');
      return await openDatabase(path, version: 1, onCreate: _onCreate);
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing database: $e');
      }
      throw Exception('Failed to initialize local database: $e');
    }
  }

  /// Callback for database creation. Defines the 'users' table schema.
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        uid TEXT PRIMARY KEY,
        displayName TEXT,
        email TEXT UNIQUE,
        passwordStatus TEXT
      )
      ''');
  }

  /// Inserts a new user or updates an existing user in the 'users' table.
  /// Uses [ConflictAlgorithm.replace] to handle conflicts based on the primary key (uid).
  Future<void> insertUser(UserModel user) async {
    try {
      final db = await database;
      await db.insert(
        'users',
        user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      if (kDebugMode) {
        print('User inserted/updated in SQLite: ${user.email}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error inserting/updating user in SQLite: $e');
      }
      throw Exception('Failed to save user locally: $e');
    }
  }

  /// Retrieves a user from the 'users' table by their email address.
  /// Returns [UserModel] if found, otherwise `null`.
  Future<UserModel?> getUser(String email) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [email],
      );

      if (maps.isNotEmpty) {
        return UserModel.fromMap(maps.first);
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting user from SQLite: $e');
      }
      throw Exception('Failed to retrieve user locally: $e');
    }
  }

  /// Retrieves all users from the 'users' table.
  Future<List<UserModel>> getAllUsers() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query('users');
      return List.generate(maps.length, (i) {
        return UserModel.fromMap(maps[i]);
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error getting all users from SQLite: $e');
      }
      throw Exception('Failed to retrieve all users locally: $e');
    }
  }

  /// Deletes a user from the 'users' table by their UID.
  Future<void> deleteUser(String uid) async {
    try {
      final db = await database;
      await db.delete('users', where: 'uid = ?', whereArgs: [uid]);
      if (kDebugMode) {
        print('User deleted from SQLite: $uid');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting user from SQLite: $e');
      }
      throw Exception('Failed to delete user locally: $e');
    }
  }

  /// Deletes all users from the 'users' table.
  Future<void> deleteAllUsers() async {
    try {
      final db = await database;
      await db.delete('users');
      if (kDebugMode) {
        print('All users deleted from SQLite.');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting all users from SQLite: $e');
      }
      throw Exception('Failed to delete all users locally: $e');
    }
  }

  /// Closes the database connection.
  Future<void> close() async {
    if (_database != null && _database!.isOpen) {
      await _database!.close();
      _database = null;
      if (kDebugMode) {
        print('SQLite database closed.');
      }
    }
  }
}
