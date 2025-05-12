//https://www.coderzheaven.com/2019/10/17/googles-flutter-tutorial-save-image-as-string-in-sqlite-database/
import 'dart:typed_data';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
//import 'dart:async';
import 'dart:convert';

class Utility {
  static Image imageFromBase64String(String base64String) {
    return Image.memory(base64Decode(base64String), fit: BoxFit.fill);
  }

  static Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  static String base64String(Uint8List data) {
    return base64Encode(data);
  }
}

class Photo {
  final int id;
  final String photoName;

  Photo({required this.id, required this.photoName});

  // Convert a Photo into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, Object?> fromMap() {
    return {'id': id, 'photo_name': photoName};
  }

  // Implement toString to make it easier to see information about
  // each photo when using the print statement.
  @override
  String toString() {
    return 'Image{id: $id, name: $photoName}';
  }
}
