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

void main() {
  runApp(const MyApp());
}

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
            (context) => MyResponsivePage(
              title: 'Flutter Responsive Home Page',
            ), //Página Inicial
        //'/login': (context) => WelcomePage(), //Página de Login MyHomePage(title: 'Flutter Demo Home Page'),
      },
    );
  }
}

class MyResponsivePage extends StatefulWidget {
  const MyResponsivePage({super.key, required this.title});

  final String title;

  @override
  State<MyResponsivePage> createState() => _MyResponsivePageState();
}

class _MyResponsivePageState extends State<MyResponsivePage> {
  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    final currentHeight = MediaQuery.of(context).size.height;
    return myScaffold(currentWidth, currentHeight);
  }

  Widget myScaffold(double currentWidth, double currentHeight) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          Padding(
            //-----------------------------------> padding
            padding: EdgeInsets.only(right: 16.0),
            child: IconButton(
              // ------> Icone Home
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/sprint2');
                Navigator.popAndPushNamed(context, '/sprint2');
              },
              icon: Icon(Icons.home_rounded),
            ), // Fim do Icone Home
          ), // Fim do Padding
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: Colors.white),
        child:
            currentWidth < 600
                //If ternario nos filhos do container
                ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    myImage(
                      "https://i0.wp.com/catagua.com.br/wp-content/uploads/2023/11/veja-dicas-de-decoracao-para-apartamentos-pequenos.jpg",
                      "Imagem Topo",
                    ),
                    mySingleChildScrollView(),
                  ],
                )
                : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    myImage(
                      "https://i0.wp.com/catagua.com.br/wp-content/uploads/2023/11/veja-dicas-de-decoracao-para-apartamentos-pequenos.jpg",
                      "Imagem Lateral",
                    ),
                    mySingleChildScrollView(),
                  ],
                ),
      ),
    );
  }

  Widget myImage(String url, String id) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(id),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.network(
            url,
            fit: BoxFit.cover,
            height:
                MediaQuery.of(context).orientation == Orientation.portrait
                    ? MediaQuery.of(context).size.height / 2.5
                    : MediaQuery.of(context).size.height / 1.6,
            width:
                MediaQuery.of(context).orientation == Orientation.portrait
                    ? MediaQuery.of(context).size.width
                    : MediaQuery.of(context).size.width / 2.6,
          ),
        ),
      ],
    );
  }

  Widget mySingleChildScrollView() {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              height:
                  MediaQuery.of(context).orientation == Orientation.portrait
                      ? MediaQuery.of(context).size.height / 2.2
                      : MediaQuery.of(context).size.height / 1.4,
              width:
                  MediaQuery.of(context).orientation == Orientation.portrait
                      ? MediaQuery.of(context).size.width
                      : MediaQuery.of(context).size.width / 2.2,
              color: Colors.red,
              child: myImage(
                "https://i0.wp.com/catagua.com.br/wp-content/uploads/2023/11/veja-dicas-de-decoracao-para-apartamentos-pequenos.jpg",
                "Imagem 1",
              ),
            ),
            Container(
              height:
                  MediaQuery.of(context).orientation == Orientation.portrait
                      ? MediaQuery.of(context).size.height / 2.2
                      : MediaQuery.of(context).size.height / 1.4,
              width:
                  MediaQuery.of(context).orientation == Orientation.portrait
                      ? MediaQuery.of(context).size.width
                      : MediaQuery.of(context).size.width / 2.2,
              color: Colors.blue,
              child: myImage(
                "https://i0.wp.com/catagua.com.br/wp-content/uploads/2023/11/veja-dicas-de-decoracao-para-apartamentos-pequenos.jpg",
                "Imagem 2",
              ),
            ),
            Container(
              height:
                  MediaQuery.of(context).orientation == Orientation.portrait
                      ? MediaQuery.of(context).size.height / 2.2
                      : MediaQuery.of(context).size.height / 1.4,
              width:
                  MediaQuery.of(context).orientation == Orientation.portrait
                      ? MediaQuery.of(context).size.width
                      : MediaQuery.of(context).size.width / 2.2,
              color: Colors.green,
              child: myImage(
                "https://images.homify.com/v1448129217/p/photo/image/1135013/7.jpg",
                "Imagem 3",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
