import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/category_model.dart';
import '../models/product_item_model.dart';

class LocalDatabaseService {
  static final LocalDatabaseService instance = LocalDatabaseService._();
  static Database? _database;

  LocalDatabaseService._();

  Future<void> initializeDatabase() async {
    if (_database != null) return;
    _database = await _openDatabase();
  }

  Future<Database> _openDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'product_catalog.db');
    return await openDatabase(path, version: 1, onCreate: _createSchema);
  }

  Future<void> _createSchema(Database db, int version) async {
    await db.execute('''
      CREATE TABLE categories (
        id TEXT PRIMARY KEY,
        name TEXT
      )''');
    await db.execute('''
      CREATE TABLE product_items (
        id TEXT PRIMARY KEY,
        title TEXT,
        description TEXT,
        image_path TEXT,
        category_id TEXT,
        FOREIGN KEY (category_id) REFERENCES categories(id)
      )''');

    await _populateInitialData(db);
  }

  Future<void> _populateInitialData(Database db) async {
    final sampleCategories = [
      {
        'id': 'cat1',
        'name': 'Electronics',
        'items': [
          {'id': 'el1', 'title': 'Phone', 'description': 'Latest smartphone', 'image_path': ''},
        ]
      },
      {
        'id': 'cat2',
        'name': 'Books',
        'items': [
          {'id': 'bk1', 'title': 'Book Title', 'description': 'A good read', 'image_path': ''},
        ]
      }
    ];

    for (var cat in sampleCategories) {
      await db.insert('categories', {'id': cat['id'], 'name': cat['name']});
      for (var item in cat['items'] as List<Map<String, String>>) {
        await db.insert('product_items', {
          'id': item['id']!,
          'title': item['title']!,
          'description': item['description']!,
          'image_path': item['image_path'],
          'category_id': cat['id']!,
        });
      }
    }
  }

  Future<List<CategoryModel>> getAllCategoriesWithItems() async {
    final db = _database!;
    final categoriesData = await db.query('categories');

    final categories = <CategoryModel>[];

    for (var category in categoriesData) {
      final productItemsData = await db.query(
        'product_items',
        where: 'category_id = ?',
        whereArgs: [category['id']],
      );

      final productItems = productItemsData.map((e) => ProductItemModel.fromMap(e)).toList();
      categories.add(CategoryModel.fromMap(category, productItems));
    }

    return categories;
  }
}