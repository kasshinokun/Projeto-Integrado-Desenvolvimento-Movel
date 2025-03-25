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
    return currentWidth < 600
        ? Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,

            title: Text(widget.title),
          ),
          body: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                //
                Expanded(flex: 2, child: Text(currentWidth.toString())),
                Expanded(flex: 2, child: Text(currentHeight.toString())),
              ],
            ),
          ),
        )
        : Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.onPrimary, //
            title: Text(widget.title),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(flex: 2, child: Text(currentWidth.toString())),
                Expanded(flex: 2, child: Text(currentHeight.toString())),
              ],
            ),
          ),
        );
  }
}
