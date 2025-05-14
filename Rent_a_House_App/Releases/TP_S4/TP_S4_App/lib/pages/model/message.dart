import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

//Model
class Message {
  int? id;
  String? senderMessage;
  String? receiverMessage;
  String? bodyMessage;
  DateTime? dateMessage;
}

//DAO
class MessageDBHelper {
  MessageDBHelper._();

  static const tableName = 'messagesUsers';

  static const columnId = 'id';
  static const columnSenderMessage = 'senderMessage';
  static const columnReceiverMessage = 'receiverMessage';
  static const columnBodyMessage = 'bodyMessage';
  static const columnDateMessage = 'dateMessage';

  static final MessageDBHelper instance = MessageDBHelper._();

  static const _dbName = 'rentahouse.db';
  static const _dbVersion = 1;

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String directory = await getDatabasesPath();
    String path = join(directory, _dbName);
    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onConfigure: _onConfigure,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableName (
      $columnId               INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnSenderMessage    TEXT    NOT NULL,
      $columnReceiverMessage  TEXT    NOT NULL,
      $columnBodyMessage      TEXT    NOT NULL,
      $columnDateMessage      INTEGER NOT NULL,)
      ''');
  }

  Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return db.insert(tableName, row);
  }

  Future<List<Map<String, dynamic>>> queryAll() async {
    Database db = await instance.database;
    return db.query(tableName);
  }

  Future<Map<String, dynamic>> queryById(int id) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> results = await db.query(
      tableName,
      where: '$columnId = ?',
      whereArgs: [id],
    );

    return results.single;
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return db.update(
      tableName,
      row,
      where: '$columnId = ?',
      whereArgs: [row[columnId]],
    );
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return db.delete(tableName, where: '$columnId = ?', whereArgs: [id]);
  }
}

//DAO Helper
class MessageHelper {
  final MessageDBHelper _dbHelper = MessageDBHelper.instance;

  Future<int> insert(Message message) async {
    return _dbHelper.insert(toMap(message));
  }

  Future<Message> queryById(int id) async {
    return fromMap(await _dbHelper.queryById(id));
  }

  Future<List<Message>> queryAll() async {
    List<Map<String, dynamic>> messageMapList = await _dbHelper.queryAll();
    return messageMapList.map((e) => fromMap(e)).toList();
  }

  Future<int> delete(int id) async {
    return _dbHelper.delete(id);
  }

  Future<int> update(Message message) async {
    return _dbHelper.update(toMap(message));
  }

  Map<String, dynamic> toMap(Message message) {
    return {
      MessageDBHelper.columnId: message.id,
      MessageDBHelper.columnSenderMessage: message.senderMessage,
      MessageDBHelper.columnReceiverMessage: message.receiverMessage,
      MessageDBHelper.columnBodyMessage: message.bodyMessage,
      MessageDBHelper.columnDateMessage:
          message.dateMessage?.millisecondsSinceEpoch,
    };
  }

  Message fromMap(Map<String, dynamic> map) {
    return Message()
      ..id = map[MessageDBHelper.columnId] as int
      ..senderMessage = map[MessageDBHelper.columnSenderMessage] as String
      ..receiverMessage = map[MessageDBHelper.columnReceiverMessage] as String
      ..bodyMessage = map[MessageDBHelper.columnBodyMessage] as String
      ..dateMessage = DateTime.fromMillisecondsSinceEpoch(
        map[MessageDBHelper.columnDateMessage] as int,
      );
  }
}
