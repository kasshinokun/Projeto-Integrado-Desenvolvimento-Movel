import 'package:flutter/material.dart';
//import 'package:sqflite/sqflite.dart';
//import 'package:path/path.dart';
//import 'package:path_provider/path_provider.dart';
import 'dart:async';

//import 'package:rent_a_house/pages/test/categorydb/Models/categorydb.dart';
//import 'package:rent_a_house/pages/test/categorydb/Models/pageitemdb.dart';
import 'package:rent_a_house/pages/test/categorydb/DAO/daocategory.dart';
import 'package:rent_a_house/pages/test/categorydb/MyApp/myappcategorydb.dart';

//---------------------------------------------------------------------->CallerCategory Dart
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
  //print("Database initialized/checked for main.");

  runApp(CallerCategoryDB());
}

//---------------------------------------------------------------------->CallerCategory Dart
class CallerCategoryDB extends StatelessWidget {
  const CallerCategoryDB({super.key});

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
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        tabBarTheme: TabBarTheme(
          labelColor: Colors.white,
          unselectedLabelColor: Colors.deepOrange[100],
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            color: Colors.deepOrange[700],
          ),
        ),
        cardTheme: CardTheme(
          elevation: 2.0,
          margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CategoriesWithPagesTabView(),
      debugShowCheckedModeBanner: false,
    );
  }
}
