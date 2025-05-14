import 'package:rent_a_house/pages/test/categorydb/Models/pageitemdb.dart';

/*
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
*/
// --- Data Models (with database mapping) ---
//---------------------------------------------------------------------->Model Category Dart
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
