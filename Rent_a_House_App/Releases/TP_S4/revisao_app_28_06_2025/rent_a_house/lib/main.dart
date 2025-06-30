//connectivity_plus --> rode: flutter pub add connectivity_plus
//import 'package:connectivity_plus/connectivity_plus.dart';

//internet_connection_checker -->rode: flutter pub add internet_connection_checker
//import 'package:internet_connection_checker/internet_connection_checker.dart';

//internet_connection_checker_plus -->rode: flutter pub add internet_connection_checker_plus
//import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

//Bibliotecas Default
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rent_a_house/services/authservices.dart';
import 'services/firebase_options.dart';

//Lottie
//import 'package:lottie/lottie.dart';

//Classes
import 'package:rent_a_house/pages/myapp.dart';


//Isolar depois---------------------------------------------------------------------------------------------------------------
Future<void> initConfiguration() async {
  // Erro por enquanto,por isto não foi utilizado ainda
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

void main() async {
  //========================================================
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    //
    //========================================================
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => AuthService())],
      child: MyApp(),
    ),
    //const MyApp(),
  );
}
