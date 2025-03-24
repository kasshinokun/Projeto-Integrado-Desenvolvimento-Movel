<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
//==================================================================
import 'package:rent_a_house/pages/welcome/welcome.dart';
import 'package:rent_a_house/Pages/Home/home.dart';
import 'package:rent_a_house/Pages/Manage/renthouse.dart';
import 'package:rent_a_house/Pages/Client/clienthouse.dart';
import 'package:rent_a_house/Pages/Manage/registerhouse.dart' as defaultreg;
import 'package:rent_a_house/Pages/Manage/settings.dart';
import 'package:rent_a_house/Pages/Manage/terms.dart';
//==================================> Testes <======================
import 'package:rent_a_house/Pages/Test/curved.dart';
import 'package:rent_a_house/Pages/Test/curvedlabeled.dart';
import 'package:rent_a_house/Pages/Test/carousel.dart';
import 'package:rent_a_house/Pages/Test/imagepicker.dart';
import 'package:rent_a_house/Pages/Test/notifications.dart';
import 'package:rent_a_house/pages/test/testregisterhouse.dart' as testereg;
//==================================================================

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    // etc.
  };
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rent a House',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      scrollBehavior: MyCustomScrollBehavior(), //Scroll
      initialRoute: '/', //Rotas
      routes: {
        '/': (context) => HomeScreen(), //Página Inicial

        '/login': (context) => WelcomePage(), //Página de Login

        '/client': (context) => ClientScreen(),
        '/rent': (context) => RentScreen(),
        '/register': (context) => defaultreg.RegisterScreen(),
        '/settings': (context) => SettingsScreen(),
        '/terms': (context) => TermsScreen(),
        //==================================> Testes <======================
        '/curved': (context) => CurvedNavBar(),
        '/curvedlabeled': (context) => CurvedLabeledNavBar(),
        '/carousel': (context) => CarouselScreen(),
        '/imagepicker': (context) => ImagePickerScreen(),
        '/notifications': (context) => NotificationsScreen(),
        '/paginateste': (context) => testereg.TestScreen(),
        //==================================================================
      },
    );
  }
}
=======
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
//==================================================================
import 'package:rent_a_house/pages/welcome/welcome.dart';
import 'package:rent_a_house/Pages/Home/home.dart';
import 'package:rent_a_house/Pages/Manage/renthouse.dart';
import 'package:rent_a_house/Pages/Client/clienthouse.dart';
import 'package:rent_a_house/Pages/Manage/registerhouse.dart' as defaultreg;
import 'package:rent_a_house/Pages/Manage/settings.dart';
import 'package:rent_a_house/Pages/Manage/terms.dart';
//==================================> Testes <======================
import 'package:rent_a_house/Pages/Test/curved.dart';
import 'package:rent_a_house/Pages/Test/curvedlabeled.dart';
import 'package:rent_a_house/Pages/Test/carousel.dart';
import 'package:rent_a_house/Pages/Test/imagepicker.dart';
import 'package:rent_a_house/Pages/Test/notifications.dart';
import 'package:rent_a_house/pages/test/testregisterhouse.dart' as testereg;
//==================================================================

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    // etc.
  };
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rent a House',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      scrollBehavior: MyCustomScrollBehavior(), //Scroll
      initialRoute: '/', //Rotas
      routes: {
        '/': (context) => HomeScreen(), //Página Inicial

        '/login': (context) => WelcomePage(), //Página de Login

        '/client': (context) => ClientScreen(),
        '/rent': (context) => RentScreen(),
        '/register': (context) => defaultreg.RegisterScreen(),
        '/settings': (context) => SettingsScreen(),
        '/terms': (context) => TermsScreen(),
        //==================================> Testes <======================
        '/curved': (context) => CurvedNavBar(),
        '/curvedlabeled': (context) => CurvedLabeledNavBar(),
        '/carousel': (context) => CarouselScreen(),
        '/imagepicker': (context) => ImagePickerScreen(),
        '/notifications': (context) => NotificationsScreen(),
        '/paginateste': (context) => testereg.TestScreen(),
        //==================================================================
      },
    );
  }
}
>>>>>>> 42ef54f772b549574d2519cb976583f7ae711d7b
