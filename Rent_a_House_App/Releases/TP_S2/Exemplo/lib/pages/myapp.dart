import 'package:flutter/material.dart';
import 'package:rent_a_house/pages/home/homepage.dart';
import 'package:rent_a_house/pages/responsive/responsive.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/', //Rotas
      routes: {
        '/home':
            (context) =>
                MyHomePage(title: 'Flutter Demo Home Page'), //Página Inicial
        '/':
            (context) => MyResponsivePage(
              title: 'Flutter Responsive Home Page',
            ), //Página de Login MyHomePage(title: 'Flutter Demo Home Page'),
      },
    );
  }
}
