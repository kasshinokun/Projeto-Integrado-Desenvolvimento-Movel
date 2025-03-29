import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
//==================================================================
import 'package:rent_a_house/pages/s1/pages/welcome/welcome.dart';
import 'package:rent_a_house/pages/s1/pages/Home/home.dart';
import 'package:rent_a_house/pages/s1/pages/Manage/renthouse.dart';
import 'package:rent_a_house/pages/s1/pages/Client/clienthouse.dart';
import 'package:rent_a_house/pages/s1/pages/Manage/registerhouse.dart'
    as defaultreg;
import 'package:rent_a_house/pages/s1/pages/Manage/settings.dart';
import 'package:rent_a_house/pages/s1/pages/Manage/terms.dart';
//==================================> Testes <======================
import 'package:rent_a_house/pages/s1/pages/Test/curved.dart';
import 'package:rent_a_house/pages/s1/pages/Test/curvedlabeled.dart';
import 'package:rent_a_house/pages/s1/pages/Test/carousel.dart';
import 'package:rent_a_house/pages/s1/pages/Test/imagepicker.dart';
import 'package:rent_a_house/pages/s1/pages/Test/notifications.dart';
import 'package:rent_a_house/pages/s1/pages/test/testregisterhouse.dart'
    as testereg;
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
