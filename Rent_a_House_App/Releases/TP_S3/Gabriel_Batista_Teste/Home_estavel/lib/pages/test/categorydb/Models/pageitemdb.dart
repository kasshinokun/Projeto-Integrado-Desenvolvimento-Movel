/*
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
*/
// --- Data Models (with database mapping) ---
//---------------------------------------------------------------------->Page Item Dart
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
