import 'package:flutter/material.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';

//Classes
import 'package:rent_a_house/pages/servicespages.dart';

class MyLoggedPage extends StatefulWidget {
  const MyLoggedPage({super.key});

  @override
  State<MyLoggedPage> createState() => _MyLoggedPageState();
}

class _MyLoggedPageState extends State<MyLoggedPage> {
  int _page = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  final List<Widget> widgetOptions = [
    HomeScreen(),
    ProfileScreen(),
    SettingsScreen(),
    RentaHouseScreen(),
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
            child: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.person_outlined),
            label: 'Profile',
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.settings_applications_sharp),
            label: 'Settings',
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.house_outlined),
            label: 'Rent',
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

      body: widgetOptions.elementAt(_page),
    );
  }
}
