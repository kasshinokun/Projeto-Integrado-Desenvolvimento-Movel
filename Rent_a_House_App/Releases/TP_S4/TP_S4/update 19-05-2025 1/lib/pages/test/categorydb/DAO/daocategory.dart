//import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
//import 'package:path_provider/path_provider.dart';
import 'dart:async';

import 'package:rent_a_house/pages/test/categorydb/Models/categorydb.dart';
import 'package:rent_a_house/pages/test/categorydb/Models/pageitemdb.dart';

//---------------------------------------------------------------------->DAO Category Dart
// --- Database Helper ---
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('rentahouse.db'); // Added version to db name
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE categories (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE page_items (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        category_id TEXT NOT NULL,
        image_asset_path TEXT,
        FOREIGN KEY (category_id) REFERENCES categories (id) ON DELETE CASCADE
      )
    ''');
    print("Database tables created.");
    await _populateInitialData(db);
  }

  // Raw data for initial population
  List<Map<String, dynamic>> _getInitialRawSampleData() {
    final List<String> sampleImageApartPaths = [
      "assets/images/Apart/apart-1.jpeg",
      "assets/images/Apart/apart-2.jpeg",
      "assets/images/Apart/apart-3.jpeg",
      "assets/images/Apart/apart-4.jpeg",
      "assets/images/Apart/apart-5.jpeg",
      "assets/images/Apart/apart-6.jpeg",
      "assets/images/Apart/apart-7.jpeg",
    ];
    final List<String> sampleImageBeachPaths = [
      "assets/images/Beach/beach-1.jpeg",
      "assets/images/Beach/beach-2.jpeg",
      "assets/images/Beach/beach-3.jpeg",
      "assets/images/Beach/beach-4.jpeg",
      "assets/images/Beach/beach-5.jpeg",
      "assets/images/Beach/beach-6.jpeg",
    ];
    final List<String> sampleImageHousePaths = [
      "assets/images/House/house-1.jpeg",
      "assets/images/House/house-2.jpeg",
      "assets/images/House/house-3.jpeg",
      "assets/images/House/house-4.jpeg",
      "assets/images/House/house-5.jpeg",
      "assets/images/House/house-6.jpeg",
      "assets/images/House/house-7.jpeg",
    ];
    int imageApartPathIndex = 0;
    int imageBeachPathIndex = 0;
    int imageHousePathIndex = 0;

    return [
      // ... (Structure from your previous sampleCategories, adapted)
      // Example for one category:
      {
        'id': 'Apartamentos',
        'name': 'Apartamentos',
        'items': List.generate(sampleImageApartPaths.length, (index) {
          final path =
              sampleImageApartPaths[imageApartPathIndex %
                  sampleImageApartPaths.length];
          imageApartPathIndex++;
          return {
            'id': 'e$index',
            'title': 'Gadget ${index + 1}',
            'content': 'Details for Gadget ${index + 1}.',
            'image_asset_path': path,
          };
        }),
      },
      {
        'id': 'Praia',
        'name': 'Praia',
        'items': List.generate(sampleImageBeachPaths.length, (index) {
          final path =
              sampleImageBeachPaths[imageBeachPathIndex %
                  sampleImageBeachPaths.length];
          imageBeachPathIndex++;
          return {
            'id': 'b$index',
            'title': 'Book ${index + 1}',
            'content': 'Summary of Book ${index + 1}.',
            'image_asset_path': path,
          };
        }),
      },
      {
        'id': 'Casas',
        'name': 'Casas',
        'items': List.generate(sampleImageHousePaths.length, (index) {
          final path =
              sampleImageHousePaths[imageHousePathIndex %
                  sampleImageHousePaths.length];
          imageHousePathIndex++;
          return {
            'id': 'c$index',
            'title': 'Fashion Item ${index + 1}',
            'content': 'Description of Fashion Item ${index + 1}.',
            'image_asset_path': path,
          };
        }),
      },
    ];
  }

  Future<void> _populateInitialData(Database db) async {
    final List<Map<String, dynamic>> existingCategories = await db.query(
      'categories',
      limit: 1,
    );
    if (existingCategories.isNotEmpty) {
      print("Database already populated.");
      return;
    }
    print("Populating initial data into database...");

    final List<Map<String, dynamic>> rawCategories = _getInitialRawSampleData();
    Batch batch = db.batch();

    for (var categoryData in rawCategories) {
      batch.insert('categories', {
        'id': categoryData['id'],
        'name': categoryData['name'],
      });
      if (categoryData['items'] != null) {
        for (var itemData in categoryData['items']) {
          batch.insert('page_items', {
            'id': itemData['id'],
            'title': itemData['title'],
            'content': itemData['content'],
            'category_id': categoryData['id'],
            'image_asset_path': itemData['image_asset_path'],
          });
        }
      }
    }
    await batch.commit(noResult: true);
    print("Initial data populated.");
  }

  Future<List<Category>> getAllCategoriesWithItems() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> categoryMaps = await db.query(
      'categories',
      orderBy: 'id',
    );

    if (categoryMaps.isEmpty) return [];

    List<Category> categories = [];
    for (var catMap in categoryMaps) {
      final List<Map<String, dynamic>> itemMaps = await db.query(
        'page_items',
        where: 'category_id = ?',
        whereArgs: [catMap['id']],
        orderBy: 'title',
      );
      List<PageItem> items =
          itemMaps.map((itemMap) => PageItem.fromMap(itemMap)).toList();
      categories.add(Category.fromMap(catMap, items));
    }
    return categories;
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
    _database = null; // Reset the static database instance
  }
}
