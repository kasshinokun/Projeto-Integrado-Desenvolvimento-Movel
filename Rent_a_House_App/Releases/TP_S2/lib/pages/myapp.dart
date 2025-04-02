import 'package:flutter/material.dart';
import 'package:rent_a_house/pages/home/homepage.dart' as stwo;
import 'package:rent_a_house/pages/responsive/responsive.dart';
import 'package:rent_a_house/pages/s1/pages/manage/registerhouse.dart';

//==================================================================
import 'package:rent_a_house/pages/s1/pages/welcome/welcome.dart';
import 'package:rent_a_house/pages/s1/pages/Home/home.dart' as sone;
import 'package:rent_a_house/pages/s1/pages/Manage/renthouse.dart';
import 'package:rent_a_house/pages/s1/pages/Client/clienthouse.dart';
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
import 'package:rent_a_house/pages/chat/chat_simulator.dart';
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

//==================================================================
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //final Size size = MediaQuery.sizeOf(context);
    //final double currentWidth = size.width;
    //final double currentHeight = size.height;
    return MaterialApp(
      debugShowCheckedModeBanner: false, //tirar o banner
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/', //Rotas
      routes: {
        '/sprint2':
            (context) => stwo.MyHomePage(
              title: 'Flutter Demo Home Page',
            ), //Página Inicial
        '/responsive':
            (context) => MyResponsivePage(
              title: 'Flutter Responsive Home Page',
            ), //Página de Login MyHomePage(title: 'Flutter Demo Home Page'),
        '/': (context) => sone.HomeScreen(), //Página Inicial

        '/login': (context) => WelcomePage(), //Página de Login

        '/client': (context) => ClientScreen(),
        '/rent': (context) => RentScreen(),
        '/register': (context) => RegisterHouseScreen(),
        '/settings': (context) => SettingsScreen(),
        '/terms': (context) => TermsScreen(),

        //==================================> Testes <======================
        '/curved': (context) => CurvedNavBar(),
        '/curvedlabeled': (context) => CurvedLabeledNavBar(),
        '/carousel': (context) => CarouselScreen(),
        '/imagepicker': (context) => ImagePickerScreen(),
        '/chat': (context) => ChatScreen(),
        '/notifications': (context) => NotificationsScreen(),
        '/paginateste': (context) => testereg.TestScreen(),

        //==================================================================
      },
    );
  }
}
