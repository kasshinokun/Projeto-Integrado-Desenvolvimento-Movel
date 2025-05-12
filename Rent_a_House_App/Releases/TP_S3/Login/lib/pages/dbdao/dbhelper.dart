//--->>https://www.coderzheaven.com/2019/10/17/googles-flutter-tutorial-save-image-as-string-in-sqlite-database/

import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rent_a_house/pages/model/utility.dart';

class DBHelper {
  String idPhoto = 'id';
  String photoName = 'photoName';
  String tableName = 'HousePhotosTable';
  String dbNAME = 'rentahouse.db';

  DBHelper._();

  static final DBHelper instance = DBHelper._();

  // tem somente uma referência ao banco de dados
  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) return _db;
    // instancia o db na primeira vez que for acessado
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, dbNAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
      "CREATE TABLE $tableName ($idPhoto INTEGER, $photoName TEXT)",
    );
  }

  // Define a function that inserts Photos into the database
  Future<void> insertPhoto(Photo photo) async {
    // Get a reference to the database.
    Database? db = DBHelper._db;

    // Insert the Photo into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same Photo is inserted twice.
    //
    // In this case, replace any previous data.
    await db?.insert(
      tableName,
      photo.fromMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // A method that retrieves all the Photos from the Photo table.
  Future<List<Photo>> getPhotos() async {
    // Get a reference to the database.
    Database? db = DBHelper._db;

    // Query the table for all the Photo.
    final List<Map<String, Object?>> photoMaps =
        db?.query(tableName) as List<Map<String, Object?>>;

    // Convert the list of each Photo's fields into a list of `Photo` objects.
    return [
      for (final {'id': id as int, 'photoName': name as String} in photoMaps)
        Photo(id: id, photoName: name),
    ];
  }

  Future close() async {
    var dbClient = DBHelper._db;
    dbClient?.close();
  }
}
