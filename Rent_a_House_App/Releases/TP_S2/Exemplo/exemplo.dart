/*
Ideia inicial: https://blog.codemagic.io/building-responsive-applications-with-flutter/

Rode antes o comando abaixo:
flutter pub add responsive_builder
flutter pub add breakpoint
flutter pub add device_preview
flutter pub add responsive_framework

*/
//Biblioteca Padrão 
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

//---> Responsive Framework 
// ignore: depend_on_referenced_packages
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:minimal/pages/pages.dart';
import 'package:minimal/routes.dart';
import 'package:responsive_framework/responsive_framework.dart';

//Responsive Builder
import 'package:responsive_builder/responsive_builder.dart';

//---> Breakpoint
import 'dart:io';
import 'package:breakpoint/breakpoint.dart';

//Device Preview
import 'package:device_preview/device_preview.dart';
import 'basic.dart';
import 'custom_plugin.dart';






//Páginas

//Rodar dentro de um runApp -->p/ Device Preview 
//Ler: https://pub.dev/packages/device_preview/example
void getDeviceApp(Material BasicApp) {
  return DevicePreview(
      enabled: true,
      tools: const [
        ...DevicePreview.defaultTools,
        CustomPlugin(),
      ],
      builder: (context) => BasicApp(),
  );
}

//Breakpoint 
void main0() {
  // Desktop platforms aren't a valid platform.
  if (!kIsWeb) _setTargetPlatformForDesktop();
  return runApp(MyApp0());
}

/// If the current platform is desktop, override the default platform to
/// a supported platform (iOS for macOS, Android for Linux and Windows).
/// Otherwise, do nothing.
void _setTargetPlatformForDesktop() {
  TargetPlatform targetPlatform;
  if (Platform.isMacOS) {
    targetPlatform = TargetPlatform.iOS;
  } else if (Platform.isLinux || Platform.isWindows) {
    targetPlatform = TargetPlatform.android;
  }
  if (targetPlatform != null) {
    debugDefaultTargetPlatformOverride = targetPlatform;
  }
}

class MyApp0 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage0(),
    );
  }
}

class MyHomePage0 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, constraints) {
      final _breakpoint = Breakpoint.fromConstraints(constraints);
      return Scaffold(
        appBar: AppBar(
          title: Text('Breakpoint Example: ${_breakpoint.toString()}'),
        ),
        body: Container(
          padding: EdgeInsets.all(_breakpoint.gutters),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: _breakpoint.columns,
              crossAxisSpacing: _breakpoint.gutters,
              mainAxisSpacing: _breakpoint.gutters,
            ),
            itemCount: 200,
            itemBuilder: (_, index) {
              return Container(
                child: Card(
                  child: Text(
                    index.toString(),
                  ),
                ),
              );
            },
          ),
        ),
      );
    });
  }
}
//Responsive Builder
//https://pub.dev/packages/responsive_builder/example
void main1() => runApp(MyApp1());

class MyApp1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveApp(
      builder: (context) {
        return MaterialApp(
          title: 'Flutter Demo',
          home: HomeView(),
        );
      },
    );
  }
}


