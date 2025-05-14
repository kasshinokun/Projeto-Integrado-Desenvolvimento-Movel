import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';

// --- Data Models (with database mapping) ---
class PageItem {
  final String id;
  final String title;
  final String content;
  final String? imageAssetPath; // Path to the image in assets folder

  PageItem({
    required this.id,
    required this.title,
    required this.content,
    this.imageAssetPath,
  });

  // Convert a PageItem into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'image_asset_path': imageAssetPath,
      // 'category_id' will be added when inserting into page_items table by DatabaseHelper
    };
  }

  // Implement 'fromMap' constructor to create a PageItem from a Map
  factory PageItem.fromMap(Map<String, dynamic> map) {
    return PageItem(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      imageAssetPath: map['image_asset_path'],
    );
  }

  @override
  String toString() {
    return 'PageItem{id: $id, title: $title, imageAssetPath: $imageAssetPath}';
  }
}

class Category {
  final String id;
  final String name;
  final List<PageItem> items;

  Category({required this.id, required this.name, required this.items});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }

  factory Category.fromMap(Map<String, dynamic> map, List<PageItem> items) {
    return Category(id: map['id'], name: map['name'], items: items);
  }

  @override
  String toString() {
    return 'Category{id: $id, name: $name, items_count: ${items.length}}';
  }
}

// --- Database Helper ---
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('categories_items_v1.db'); // Added version to db name
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
    final List<String> sampleImagePaths = [
      //coloque as imagens que desejar no caminho
      //caso deseje carregar da Web, mude de ASSETIMAGE para 
      //NETWORKIMAGE ou CACHEDNETWORKIMAGE(eu acho ou similar)
      'assets/images/placeholder1.png',
      'assets/images/placeholder2.png',
      'assets/images/placeholder3.png',
    ];
    int imagePathIndex = 0;

    return [
      // ... (Structure from your previous sampleCategories, adapted)
      // Example for one category:
      {
        'id': 'cat1', 'name': 'Electronics', 'items': List.generate(5, (index) {
            final path = sampleImagePaths[imagePathIndex % sampleImagePaths.length];
            imagePathIndex++;
            return {'id': 'e$index', 'title': 'Gadget ${index + 1}', 'content': 'Details for Gadget ${index + 1}.', 'image_asset_path': path};
          }),
      },
      {
        'id': 'cat2', 'name': 'Books', 'items': List.generate(3, (index) {
            final path = sampleImagePaths[imagePathIndex % sampleImagePaths.length];
            imagePathIndex++;
            return {'id': 'b$index', 'title': 'Book ${index + 1}', 'content': 'Summary of Book ${index + 1}.', 'image_asset_path': path};
          }),
      },
       {
        'id': 'cat3', 'name': 'Apparel', 'items': List.generate(6, (index) {
            final path = sampleImagePaths[imagePathIndex % sampleImagePaths.length];
            imagePathIndex++;
            return {'id': 'c$index', 'title': 'Fashion Item ${index + 1}', 'content': 'Description of Fashion Item ${index + 1}.', 'image_asset_path': path};
          }),
      },
      { 'id': 'cat4', 'name': 'Empty Category', 'items': [] },
    ];
  }

  Future<void> _populateInitialData(Database db) async {
    final List<Map<String, dynamic>> existingCategories = await db.query('categories', limit: 1);
    if (existingCategories.isNotEmpty) {
      print("Database already populated.");
      return;
    }
    print("Populating initial data into database...");

    final List<Map<String, dynamic>> rawCategories = _getInitialRawSampleData();
    Batch batch = db.batch();

    for (var categoryData in rawCategories) {
      batch.insert('categories', {'id': categoryData['id'], 'name': categoryData['name']});
      if (categoryData['items'] != null) {
        for (var itemData in categoryData['items']) {
          batch.insert('page_items', {
            'id': itemData['id'],
            'title': itemData['title'],
            'content': itemData['content'],
            'category_id': categoryData['id'],
            'image_asset_path': itemData['image_asset_path']
          });
        }
      }
    }
    await batch.commit(noResult: true);
    print("Initial data populated.");
  }

  Future<List<Category>> getAllCategoriesWithItems() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> categoryMaps = await db.query('categories', orderBy: 'name');

    if (categoryMaps.isEmpty) return [];

    List<Category> categories = [];
    for (var catMap in categoryMaps) {
      final List<Map<String, dynamic>> itemMaps = await db.query(
        'page_items',
        where: 'category_id = ?',
        whereArgs: [catMap['id']],
        orderBy: 'title',
      );
      List<PageItem> items = itemMaps.map((itemMap) => PageItem.fromMap(itemMap)).toList();
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


// --- Main Application Widget ---
Future<void> main() async {
  // Ensure Flutter bindings are initialized for plugins
  WidgetsFlutterBinding.ensureInitialized();

  // Optional: For easy debugging - delete DB on every restart
  // final dbPath = join(await getDatabasesPath(), 'categories_items_v1.db');
  // await deleteDatabase(dbPath);
  // print("Database deleted for fresh start.");

  // Initialize the database (this will create and populate if it's the first run)
  await DatabaseHelper.instance.database;
  print("Database initialized/checked for main.");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Categories SQL Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepOrange,
          elevation: 1,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        tabBarTheme: TabBarTheme(
          labelColor: Colors.white,
          unselectedLabelColor: Colors.deepOrange[100],
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: BoxDecoration(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            color: Colors.deepOrange[700],
          ),
        ),
        cardTheme: CardTheme(
          elevation: 2.0,
          margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const CategoriesWithPagesTabView(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// --- Categories and Pages View Widget (Stateful) ---
class CategoriesWithPagesTabView extends StatefulWidget {
  const CategoriesWithPagesTabView({super.key});

  @override
  State<CategoriesWithPagesTabView> createState() => _CategoriesWithPagesTabViewState();
}

class _CategoriesWithPagesTabViewState extends State<CategoriesWithPagesTabView> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  List<Category> _categories = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDataFromDb();
  }

  Future<void> _loadDataFromDb() async {
    setState(() {
      _isLoading = true; // Set loading true at the start of data fetch
      _error = null;
    });
    try {
      final categoriesFromDb = await DatabaseHelper.instance.getAllCategoriesWithItems();
      if (mounted) {
        setState(() {
          _categories = categoriesFromDb;
          if (_categories.isNotEmpty) {
            // Dispose existing controller if it exists before creating a new one
            _tabController?.dispose();
            _tabController = TabController(length: _categories.length, vsync: this);
          } else {
             _tabController?.dispose();
             _tabController = null;
          }
          _isLoading = false;
        });
      }
    } catch (e, s) {
      print("Error loading data from DB: $e\n$s");
      if (mounted) {
        setState(() {
          _error = "Failed to load data. Please try again. ($e)";
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    // Consider if DatabaseHelper.instance.close() is needed.
    // Usually, for an app-wide database, you don't close it until app termination.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Product Categories')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Product Categories')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: $_error', textAlign: TextAlign.center, style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 20),
                ElevatedButton(onPressed: _loadDataFromDb, child: const Text("Retry"))
              ],
            ),
          )
        ),
      );
    }

    if (_categories.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Product Categories')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('No categories available at the moment.'),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _loadDataFromDb, child: const Text("Refresh Data"))
            ],
          ),
        )
      );
    }
    
    // Ensure _tabController is not null when categories are available.
    // This should be guaranteed by _loadDataFromDb logic.
    if (_tabController == null && _categories.isNotEmpty) {
        // This state indicates an issue, possibly _loadDataFromDb didn't set up controller.
        // Re-initialize tab controller as a fallback.
        _tabController = TabController(length: _categories.length, vsync: this);
    }


    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Categories'),
        bottom: TabBar(
          controller: _tabController!,
          isScrollable: true,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          tabs: _categories.map((Category category) {
            return Tab(child: Text(category.name, style: const TextStyle(fontSize: 15)));
          }).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController!,
        children: _categories.map((Category category) {
          if (category.items.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'No items currently available in ${category.name}.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ),
            );
          }
          return ListView.builder(
            key: PageStorageKey(category.id), // Preserves scroll position
            padding: const EdgeInsets.all(8.0),
            itemCount: category.items.length,
            itemBuilder: (context, index) {
              final item = category.items[index];
              Widget imageWidget;

              if (item.imageAssetPath != null && item.imageAssetPath!.isNotEmpty) {
                imageWidget = Image.asset(
                  item.imageAssetPath!,
                  width: 70, height: 70, fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback for broken asset links
                    return Container(
                      width: 70, height: 70, color: Colors.grey[200],
                      child: Icon(Icons.broken_image, size: 30, color: Colors.grey[400]),
                    );
                  },
                );
              } else {
                // Placeholder if no image path is provided
                imageWidget = Container(
                  width: 70, height: 70, color: Colors.grey[200],
                  child: Icon(Icons.image_not_supported, size: 30, color: Colors.grey[400]),
                );
              }

              return Card(
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: imageWidget,
                  ),
                  title: Text(
                    item.title,
                    style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColorDark),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      item.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[400]),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Tapped on ${item.title} in ${category.name}'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
