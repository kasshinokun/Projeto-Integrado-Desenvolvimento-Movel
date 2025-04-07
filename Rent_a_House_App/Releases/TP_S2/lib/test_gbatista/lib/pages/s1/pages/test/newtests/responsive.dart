//Criado para testar logica
/*
Ideia inicial: https://blog.codemagic.io/building-responsive-applications-with-flutter/

Rode antes o comando abaixo:
flutter pub add responsive_builder
flutter pub add breakpoint
flutter pub add device_preview
flutter pub add responsive_framework

*/
/*
//---> Responsive Framework
// ignore: depend_on_referenced_packages
import 'package:flutter_web_plugins/url_strategy.dart';
//import 'package:minimal/pages/pages.dart';
//import 'package:minimal/routes.dart';
import 'package:responsive_framework/responsive_framework.dart';

//Responsive Builder
import 'package:responsive_builder/responsive_builder.dart';

//---> Breakpoint
import 'dart:io';
import 'package:breakpoint/breakpoint.dart';

//Device Preview
import 'package:device_preview/device_preview.dart';
*/
//Biblioteca Padrão

//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
//orientação dos widgets
//import 'package:flutter/services.dart';
//==================================================================

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    // etc.
  };
}
//Listas

List<String> addressClient = [
  'Rua Alegre, 12345, bairro Brasil - Belo Horizonte',
  'Rua Alfa, 3456, bairro França - Ouro Preto',
  'Rua Puc Minas, 678, bairro Argentina - Sete Lagoas',
  'Rua Alfa, 3456, bairro França - Ouro Branco',
  'Rua Puc Minas, 678, bairro Argentina - Lagoa Santa',
  'Rua Alegre, 12345, bairro Brasil - Belo Horizonte',
  'Rua Alfa, 3456, bairro França - Ouro Preto',
  'Rua Puc Minas, 678, bairro Argentina - Sete Lagoas',
  'Rua Alfa, 3456, bairro França - Ouro Branco',
  'Rua Puc Minas, 678, bairro Argentina - Lagoa Santa',
  'Rua Alegre, 12345, bairro Brasil - Belo Horizonte',
  'Rua Alfa, 3456, bairro França - Ouro Preto',
  'Rua Puc Minas, 678, bairro Argentina - Sete Lagoas',
  'Rua Alfa, 3456, bairro França - Ouro Branco',
  'Rua Puc Minas, 678, bairro Argentina - Lagoa Santa',
];

List<String> carouselItems = [
  'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
  'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
  'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
  'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
  'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80',
  'https://images.unsplash.com/photo-1586882829491-b81178aa622e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2850&q=80',
  'https://images.unsplash.com/photo-1586871608370-4adee64d1794?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2862&q=80',
  'https://images.unsplash.com/photo-1586901533048-0e856dff2c0d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1650&q=80',
  'https://images.unsplash.com/photo-1586902279476-3244d8d18285?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2850&q=80',
  'https://images.unsplash.com/photo-1586943101559-4cdcf86a6f87?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1556&q=80',
  'https://images.unsplash.com/photo-1586951144438-26d4e072b891?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1650&q=80',
  'https://images.unsplash.com/photo-1586953983027-d7508a64f4bb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1650&q=80',
  'https://images.unsplash.com/photo-1586953983027-d7508a64f4bb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1650&q=80',
];

//Fim das Listas
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, //tirar o banner
      scrollBehavior: MyCustomScrollBehavior(), //habilitar scroll
      title: 'Responsive Layout Test',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      //Rotas
      initialRoute: '/test0', //Rotas
      routes: {
        '/test0': (context) => MyHomeTest(), //Página Inicial
        '/resp0': (context) => MyResponsiveTest(), //Página Inicial
      },
    );
  }
}

class MyHomeTest extends StatefulWidget {
  const MyHomeTest({super.key});
  @override
  State<MyHomeTest> createState() => _MyHomeTestState();
}

class _MyHomeTestState extends State<MyHomeTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("My Home"), //
      ), //
      body: Center(
        child: Padding(
          //-----------------------------------> padding
          padding: EdgeInsets.only(right: 16.0),
          child: IconButton(
            // ------> Icone Home
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/resp0');
              Navigator.popAndPushNamed(context, '/resp0');
            },
            icon: Icon(Icons.home_rounded),
          ), // Fim do Icone Home
        ), // Fim do Padding,
      ),
    );
  }
}

class MyResponsiveTest extends StatefulWidget {
  const MyResponsiveTest({super.key});

  @override
  State<MyResponsiveTest> createState() => _MyResponsiveTestState();
}

class _MyResponsiveTestState extends State<MyResponsiveTest> {
  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    final currentHeight = MediaQuery.of(context).size.height;
    return myScaffold(currentWidth, currentHeight, "Responsive Layout Screen");
  }

  Widget myScaffold(double currentWidth, double currentHeight, String title) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
        actions: [
          Padding(
            //-----------------------------------> padding
            padding: EdgeInsets.only(right: 16.0),
            child: IconButton(
              // ------> Icone Home
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/test0');
                Navigator.popAndPushNamed(context, '/test0');
              },
              icon: Icon(Icons.home_rounded),
            ), // Fim do Icone Home
          ), // Fim do Padding
        ],
      ),
      //body
      body: Column(children: [

        ],
      ),
    );
  }

  Widget myContainer(Widget insideScreen) {
    return Container(child: insideScreen);
  }
}
