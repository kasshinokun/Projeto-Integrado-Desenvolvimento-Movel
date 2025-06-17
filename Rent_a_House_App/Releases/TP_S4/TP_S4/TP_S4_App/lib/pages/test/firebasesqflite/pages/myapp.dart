import 'package:flutter/material.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:rent_a_house/pages/login.dart';
import 'package:rent_a_house/pages/test/firebasesqflite/dao/helper.dart';
import 'package:rent_a_house/services/authservices.dart';

//import 'package:sqflite/sqflite.dart';
//import 'package:path/path.dart';
//import 'package:fluttertoast/fluttertoast.dart';
//import 'package:loading_animation_widget/loading_animation_widget.dart';
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase User to SQLite',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Inter'),
      initialRoute: '/wrapper', //Trecho 1 - teste
      //trecho 2 -teste
      //initialRoute: auth.currentUser == null ? '/login' : '/logged',
      //Fim dos trechos de teste
      routes: {
        '/auth': (context) => AuthCheck(), //Checagem de estado do login
        /*
            (context) => ConnectivityListener(
              child: AuthCheck(), //Checagem de estado do login
            ), //Checagem de estado da conexão
            */
        '/login': (context) => MyLoginPage(),
        '/wrapper': (context) => AuthenticationWrapper(),
      },
      home: AuthenticationWrapper(),
    );
  }
}
