//import 'dart:io';

import 'package:flutter/material.dart';
//import 'package:sqflite/sqflite.dart';
//import 'package:path/path.dart';
//import 'package:path_provider/path_provider.dart';
import 'dart:async';

import 'package:rent_a_house/pages/test/categorydb/Models/categorydb.dart';
//import 'package:rent_a_house/pages/test/categorydb/Models/pageitemdb.dart';
import 'package:rent_a_house/pages/test/categorydb/DAO/daocategory.dart';

//---------------------------------------------------------------------->CallerPageCategory Dart
// --- Categories and Pages View Widget (Stateful) ---
class CategoriesWithPagesTabView extends StatefulWidget {
  const CategoriesWithPagesTabView({super.key});

  @override
  State<CategoriesWithPagesTabView> createState() =>
      _CategoriesWithPagesTabViewState();
}

class _CategoriesWithPagesTabViewState extends State<CategoriesWithPagesTabView>
    with SingleTickerProviderStateMixin {
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
      final categoriesFromDb =
          await DatabaseHelper.instance.getAllCategoriesWithItems();
      if (mounted) {
        setState(() {
          _categories = categoriesFromDb;
          if (_categories.isNotEmpty) {
            // Dispose existing controller if it exists before creating a new one
            _tabController?.dispose();
            _tabController = TabController(
              length: _categories.length,
              vsync: this,
            );
          } else {
            _tabController?.dispose();
            _tabController = null;
          }
          _isLoading = false;
        });
      }
    } catch (e, s) {
      //print("Error loading data from DB: $e\n$s");
      if (mounted) {
        setState(() {
          _error = "Failed to load data. Please try again. ($e)\n($s)";
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
        appBar: AppBar(title: Text('MyHouse Categorias')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: Text('MyHouse Categorias')),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error: $_error',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _loadDataFromDb,
                  child: Text("Retry"),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_categories.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('MyHouse Categorias')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('No categories available at the moment.'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _loadDataFromDb,
                child: Text("Refresh Data"),
              ),
            ],
          ),
        ),
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
        title: Text('MyHouse Categorias'),
        bottom: TabBar(
          controller: _tabController!,
          isScrollable: true,
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          tabs:
              _categories.map((Category category) {
                return Tab(
                  child: Text(category.name, style: TextStyle(fontSize: 15)),
                );
              }).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController!,
        children:
            _categories.map((Category category) {
              if (category.items.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
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
                padding: EdgeInsets.all(8.0),
                itemCount: category.items.length,
                itemBuilder: (context, index) {
                  final item = category.items[index];
                  return Card(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 300.0,
                          width: 300, // fixed width and height
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child:
                                (item.imageAssetPath != null &&
                                        item.imageAssetPath!.isNotEmpty)
                                    ? Image(
                                      image: AssetImage(
                                        item.imageAssetPath as String,
                                      ),
                                      height: 126,
                                      width: 116,
                                      fit: BoxFit.cover,
                                      errorBuilder: (
                                        context,
                                        error,
                                        stackTrace,
                                      ) {
                                        // Fallback for broken asset links
                                        return Container(
                                          height: 126,
                                          width: 116,
                                          color: Colors.grey[200],
                                          child: Column(
                                            children: [
                                              Text(
                                                item.imageAssetPath as String,
                                              ),
                                              Icon(
                                                Icons.broken_image,
                                                size: 30,
                                                color: Colors.grey[400],
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    )
                                    : Container(
                                      // Placeholder if no image path is provided
                                      height: 126,
                                      width: 116,
                                      color: Colors.grey[200],
                                      child: Icon(
                                        Icons.image_not_supported,
                                        size: 30,
                                        color: Colors.grey[400],
                                      ),
                                    ),
                          ),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 16.0,
                          ),
                          title: Text(
                            item.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColorDark,
                            ),
                          ),
                          subtitle: Padding(
                            padding: EdgeInsets.only(top: 5.0),
                            child: Text(
                              item.content,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                            color: Colors.grey[400],
                          ),

                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Tapped on ${item.title} in ${category.name}',
                                ),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            }).toList(),
      ),
    );
  }
}
