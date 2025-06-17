import 'package:flutter/material.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';

//Classes
import 'package:rent_a_house/pages/servicespages/settings.dart';
import 'package:rent_a_house/pages/servicespages/profile.dart';
import 'package:rent_a_house/pages/servicespages.dart';
//import 'package:rent_a_house/pages/test/category/callercategory.dart';
import 'package:rent_a_house/pages/test/categorydb/callercategoryapp.dart';

class MyLoggedPage extends StatefulWidget {
  //final bool isLogged;
  const MyLoggedPage( /*this.isLogged, */ {super.key});

  @override
  State<MyLoggedPage> createState() => _MyLoggedPageState();
}

class _MyLoggedPageState extends State<MyLoggedPage> {
  int _page = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  final List<Widget> widgetOptions = [
    CallerCategoryDB(),
    HomeScreen(),
    RentaHouseScreen(),
    ProfileScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text('Logged User Demonstração'),
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: Icon(Icons.person_2_rounded),
                onPressed: () {},
              ),
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: 0,
        color: const Color.fromARGB(255, 185, 156, 233),
        buttonBackgroundColor: Colors.amberAccent,
        backgroundColor: Colors.white,
        animationCurve: Curves.easeInOut,
        items: [
          CurvedNavigationBarItem(
            child: Icon(Icons.shopify),
            label: 'Home',
            labelStyle: TextStyle(),
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.house_outlined),
            label: 'Alugar',
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.person_outlined),
            label: 'Perfil',
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.settings_applications_sharp),
            label: 'Ajustes',
            labelStyle: TextStyle(),
          ),
        ],

        animationDuration: Duration(milliseconds: 600),
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
        letIndexChange: (index) => true,
      ),

      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: widgetOptions.elementAt(_page),
      ),
    );
  }
}
