import 'package:flutter/material.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Classes
import 'package:rent_a_house/pages/servicespages/settings.dart';
import 'package:rent_a_house/pages/servicespages/profile2.dart';
import 'package:rent_a_house/pages/servicespages.dart';
import 'package:rent_a_house/pages/chat3.dart';
import 'package:rent_a_house/pages/pagamentos.dart';
import 'package:rent_a_house/pages/userslistpage.dart'; // certifique-se que existe

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
    RentaHouseScreen(),
    ProfileScreen(),
    SettingsScreen(),
    UsersListPage(), // Este pode ser substituído para abrir chat com receiverUID se quiser
    PagamentoPixPage(),
  ];

  // Método para abrir seleção de usuário e iniciar o chat
  void _abrirChatComOutroUsuario() async {
    final receiverUID = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UsersListPage()),
    );

    if (receiverUID != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const UsersListPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Logged User Demonstração'),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat),
            onPressed: _abrirChatComOutroUsuario,
            tooltip: 'Conversar com usuário',
          ),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: 0,
        color: const Color.fromARGB(255, 185, 156, 233),
        buttonBackgroundColor: Colors.amberAccent,
        backgroundColor: Colors.white,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 600),
        items: const [
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
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.chat_outlined),
            label: 'Chat',
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.pix),
            label: 'Pix',
          ),
        ],
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
        letIndexChange: (index) => true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: widgetOptions.elementAt(_page),
      ),
    );
  }
}
