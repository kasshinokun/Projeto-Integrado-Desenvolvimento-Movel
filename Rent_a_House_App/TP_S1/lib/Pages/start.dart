import 'package:flutter/material.dart';
import 'package:rent_house/Pages/Home/home.dart';
import 'package:rent_house/Pages/Manage/renthouse.dart';
import 'package:rent_house/Pages/Start/welcome.dart';
import 'package:rent_house/Pages/Client/clienthouse.dart';
import 'package:rent_house/Pages/Manage/registerhouse.dart';
import 'package:rent_house/Pages/Manage/settings.dart';
import 'package:rent_house/Pages/Manage/terms.dart';
//==================================> Testes <======================
import 'package:rent_house/Pages/Test/curved.dart';
import 'package:rent_house/Pages/Test/curvedlabeled.dart';
//==================================================================

//Chamada da primeira tela da aplicação
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //Constroi a aplicação ao dar o retorno

    //Retorno sem usar Rotas como NodeJS
    //return MaterialApp(home: WelcomePage());

    //Retorno usando o conceito de Rotas como NodeJS
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/', //Rotas
      routes: {
        '/': (context) => HomeScreen(), //Página Inicial
        '/login': (context) => WelcomePage(), //Página de Login
        '/client': (context) => ClientScreen(),
        '/rent': (context) => RentScreen(),
        '/register': (context) => RegisterScreen(),
        '/settings': (context) => SettingsScreen(),
        '/terms': (context) => TermsScreen(),
        //==================================> Testes <======================
        '/curved': (context) => CurvedNavBar(),
        '/curvedlabeled': (context) => CurvedLabeledNavBar(),
        //==================================================================
      },
    );
  }
}
