//Precisa das libs: sqflite
//import 'package:sqflite/sqflite.dart';

//Precisa das libs: path
//import 'package:path/path.dart';

//Escreva manualmente os termos abaixo no pubspec.yaml
//path: ^1.9.1
//path_provider: ^2.1.5
//hive: ^2.2.3

import 'dart:async';
//import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
//import 'package:path_provider/path_provider.dart';
import 'package:rent_a_house/pages/model/lograddouro.dart';

class DB {
  DB._();

  static final DB instance = DB._();

  static Database? _database;

  get database async {
    if (_database != null) {
      return _database;
    }
    return await _initDatabase();
  }

  _initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'rentahouse.db'),
      version: 1,
      onCreate: _onCreate,
    );
  }

  //Strings de criação das tabelas
  String get _cep => '''
      CREATE TABLE logradouro (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        cep TEXT,
        rua TEXT
      )
    ''';
  String get _user => '''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        cpf TEXT,
        nome TEXT,
        email TEXT
      )
    ''';
  String get _locador => '''CREATE TABLE locadores (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        cpf TEXT)
    ''';
  String get _locatario => '''CREATE TABLE locatarios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        cpf TEXT)
    ''';
  String get _house => '''CREATE TABLE imovel(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        numero INTEGER,
        complemento TEXT,
        id_cep INTEGER,
        descricao TEXT)''';
  String get _image => '''CREATE TABLE imageshouse(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    id_casa INTEGER,
            url TEXT)''';
  String get _renthouse => '''CREATE TABLE invoice(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    id_locatario INTEGER,
    id_casa INTEGER,
    data_inicial INTEGER,
    data_final INTEGER,
    valor REAL)''';

  _onCreate(db, version) async {
    //Cria tabelas
    await db.execute(_cep);
    await db.execute(_user);
    await db.execute(_locador);
    await db.execute(_locatario);
    await db.execute(_house);
    await db.execute(_image);
    await db.execute(_renthouse);

    //Insert's
    //CEP's predefinidos
    await db.insert(
      'logradouro',
      {'cep': '34.515-745', 'rua': 'Rua Barão, Alto do Fidalgo, Sabará, MG'},
      'logradouro',
      {
        'cep': '30.130-002',
        'rua': 'Avenida Afonso Pena, Centro, Belo Horizonte, MG',
      },
      'logradouro',
      {
        'cep': '01.311-200',
        'rua': 'Avenida Paulista, Bela Vista, São Paulo, SP',
      },
      'logradouro',
      {
        'cep': '20.210-072',
        'rua': 'Rua Marquês de Sapucaí, Santo Cristo, Rio de Janeiro, RJ',
      },
    );
    //Usuarios
    await db.insert(
      'users',
      {
        'cpf': '123.456.789-00',
        'nome': 'João da Cunha Neves',
        'email': 'jaocunha@gatomail.com',
      },
      'users',
      {
        'cpf': '456.123.789-00',
        'nome': 'Maria da Cunha Neves',
        'email': 'mariacunha@gatomail.com',
      },
      'users',
      {
        'cpf': '789.123.456-00',
        'nome': 'José da Cunha Neves',
        'email': 'zezecunha@gatomail.com',
      },
    );
    //Locador
    await db.insert('locadores', {'cpf': '123.456.789-00'});
    //Locatario
    await db.insert('locatarios', {'cpf': '456.123.789-00'});
    //Imovel
    await db.insert('imovel', {
      'id': 1,
      'numero': 15,
      'complemento': 'casa A',
      'id_cep': 1,
      'descricao':
          '2 quartos, 2 salas, 1 cozinha, 1 banheiro e 1 area de lazer',
    });
    //Imagem
    await db.insert('imageshouse', {
      'id_casa': 1,
      'url':
          'https://raw.githubusercontent.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/refs/heads/main/Rent_a_House_App/Imagens_S2/App/House/house-1.jpg',
    });
  }

  //Teste de insert, caso exista,
  //sobrescreverá o registro(não testado ainda)
  Future<void> insertTask(Logradouro logradouro) async {
    final Database db = await database;

    await db.insert(
      'logradouro',
      logradouro.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  //Querying Data
  Future<List<Map<String, dynamic>>> getLogradouros() async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query('logradouro');

    return maps;
  }

  //Updating Data
  Future<void> updateLogradouro(Logradouro logradouro) async {
    final Database db = await database;

    await db.update(
      'logradouro',
      logradouro.toMap(),
      where: 'id = ?',
      whereArgs: [logradouro.id],
    );
  }

  //Deleting Data
  Future<void> deleteLogradouro(int id) async {
    final Database db = await database;

    await db.delete('logradouro', where: 'id = ?', whereArgs: [id]);
  }

  //Verificar existencia do banco
  Future<bool> databaseExists(String path) =>
      databaseFactory.databaseExists(path);
}
