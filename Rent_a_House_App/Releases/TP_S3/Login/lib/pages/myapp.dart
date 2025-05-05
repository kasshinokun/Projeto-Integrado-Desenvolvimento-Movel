//Bibliotecas Padrão
import 'package:flutter/material.dart';

//Classes
import 'package:rent_a_house/pages/login.dart';
import 'package:rent_a_house/pages/logged.dart';
import 'package:rent_a_house/services/authservices.dart';
//import 'package:rent_a_house/services/connectionservices.dart';
import 'package:rent_a_house/pages/nointernet.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //FirebaseAuth _auth = FirebaseAuth.instance;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login Demonstração',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      //initialRoute: '/login', //Trecho anterior

      //Em caso de erro, comente no trecho 1 ou 2 e descomente o trecho anterior
      initialRoute: '/auth', //Trecho 1 - teste
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
        '/login': (context) => MyLoginPage(), //Pagina de Login
        '/logged': (context) => MyLoggedPage(), //HomePage
        '/nointernet': (context) => NoInternet(), //HomePage sem Internet
      },
    );
  }
}
