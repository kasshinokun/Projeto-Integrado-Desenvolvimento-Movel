import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart';
import 'package:rent_a_house/pages/test/firebasesqflite/model/localuser.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class LocalDatabase {
  static final _databaseName = "'rentahouse.db";
  static final _databaseVersion = 1;

  static final table = 'users';

  static final columnUid = 'uid';
  static final columnEmail = 'email';
  static final columnDisplayName = 'displayName';
  static final columnIdToken = 'idToken';

  // Make this a singleton class
  LocalDatabase._privateConstructor();
  static final LocalDatabase instance = LocalDatabase._privateConstructor();

  // Only have a single app-wide reference to the database
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;

    // Lazily instantiate the database if unavailable
    _database = await _initLocalDatabase();
    return _database!;
  }

  // Open the database, creating if it doesn't exist
  _initLocalDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
             CREATE TABLE $table (
             $columnUid TEXT PRIMARY KEY,
             $columnEmail TEXT NOT NULL,
             $columnDisplayName TEXT NOT NULL,
             $columnIdToken TEXT NOT NULL
           )
           ''');
  }

  // Insert a Local User into the database
  Future<void> insert(LocalUser localuser) async {
    Database db = await instance.database;
    await db.insert(
      table,
      localuser.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Insert a Local User into the database from Firebase
  Future<int> insertFirebase(User user) async {
    Database db = await instance.database;
    // Get the ID token.  This is the key change.
    final idToken = await user.getIdToken();

    return await db.insert(table, {
      'uid': user.uid,
      'email': user.email,
      'displayName': user.displayName,
      'idToken': idToken, // Store the ID token,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Retrieve all notes from the database
  Future<List<LocalUser>> getAllUsers() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(table);
    return List.generate(maps.length, (i) {
      return LocalUser.fromMap(maps[i]);
    });
  }

  // Update a note in the database
  Future<int> update(LocalUser localuser) async {
    Database db = await instance.database;
    return await db.update(
      table,
      localuser.toMap(),
      where: '$columnUid = ?',
      whereArgs: [localuser.uid],
    );
  }

  // Delete a note from the database
  Future<int> delete(String uid) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnUid = ?', whereArgs: [uid]);
  }
}
