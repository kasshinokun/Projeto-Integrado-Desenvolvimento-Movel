// lib/utils/database_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
//import 'dart:io';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String documentsDirectory = await getDatabasesPath();
    String path = join(documentsDirectory, 'rentahouse.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade, // Adicionado para lidar com futuras atualizações de esquema
    );
  }

  // Cria a tabela de usuários offline se ela não existir.
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users_offline (
        uid TEXT PRIMARY KEY,
        email TEXT UNIQUE,
        hashed_password TEXT NOT NULL,
        name TEXT,
        profile_photo_base64 TEXT -- Adicionado: para armazenar a imagem Base64
      )
    ''');
  }

  // Método para lidar com upgrades de banco de dados (se você mudar a versão)
  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Exemplo de como adicionar uma nova coluna se a versão mudar
    if (oldVersion < 1) { // Se você já tem um banco de dados e adicionou a coluna em uma versão posterior
      // Este caso é se você já tinha o banco e agora está adicionando a coluna
      // await db.execute("ALTER TABLE users_offline ADD COLUMN profile_photo_base64 TEXT");
    }
  }

  // Insere ou atualiza um usuário no banco de dados offline.
  Future<int> insertUser(Map<String, dynamic> user) async {
    Database db = await database;
    return await db.insert(
      'users_offline',
      user,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Busca um usuário pelo email para login offline.
  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    Database db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'users_offline',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (results.isNotEmpty) {
      return results.first;
    }
    return null;
  }

  // Deleta um usuário pelo UID.
  Future<int> deleteUser(String uid) async {
    Database db = await database;
    return await db.delete(
      'users_offline',
      where: 'uid = ?',
      whereArgs: [uid],
    );
  }

  // Limpa todos os dados da tabela de usuários offline.
  Future<void> clearAllUsers() async {
    Database db = await database;
    await db.delete('users_offline');
  }
}
