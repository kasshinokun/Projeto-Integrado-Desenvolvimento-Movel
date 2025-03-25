import 'package:flutter/material.dart';
import 'package:rent_a_house/pages/home/homepage.dart';

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
        '/':
            (context) =>
                MyHomePage(title: 'Flutter Demo Home Page'), //Página Inicial
        //'/login': (context) => WelcomePage(), //Página de Login MyHomePage(title: 'Flutter Demo Home Page'),
      },
    );
  }
}
