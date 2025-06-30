// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rent_a_house/firebase_options.dart'; // Importe o firebase_options.dart
import 'package:rent_a_house/providers/connectivity_provider.dart';
import 'package:rent_a_house/providers/housesprovider.dart';
import 'package:rent_a_house/providers/internet_connection_provider.dart';
import 'package:rent_a_house/services/authservices.dart'; // Seu serviço de autenticação
import 'package:rent_a_house/my_app.dart'; // Seu MyApp principal

void main() async {
  // Garante que os widgets Flutter estejam inicializados
  WidgetsFlutterBinding.ensureInitialized();
  // Inicializa o Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    // MultiProvider para fornecer todos os estados necessários para a aplicação
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => ConnectivityProvider()),
        ChangeNotifierProvider(create: (context) => InternetConnectionProvider()),
        ChangeNotifierProvider(create: (context) => HousesProvider()),
      ],
      child: const MyApp(),
    ),
  );
}