import 'package:flutter/material.dart';
import 'package:rent_a_house/myapp.dart';
import 'package:provider/provider.dart';
import 'package:rent_a_house/services/teste/internetprovider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => InternetConnectionProvider(),
      child: const MyApp(),
    ),
  );
}
