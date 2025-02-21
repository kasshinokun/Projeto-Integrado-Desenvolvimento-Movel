//Update 1_21_02_2025
import 'package:flutter/material.dart';
import 'package:rent_house/Pages/Start/welcome.dart';

//Primeira tela da aplicação
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //AppBar (no topo da tela)
    return MaterialApp(home: WelcomePage());
  }
}



