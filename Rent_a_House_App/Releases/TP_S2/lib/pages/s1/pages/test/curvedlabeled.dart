import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:rent_a_house/pages/s1/pages/home/navbar.dart';
import 'package:flutter/material.dart';

List<String> imageBottonNavBar = [
  'https://images.homify.com/v1591213520/p/photo/image/3509801/foto2-m.jpg',
  'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
];

List<Color> colorItems = [
  const Color.fromARGB(255, 210, 138, 212),
  Colors.redAccent,
  Colors.greenAccent,
  Colors.blueAccent,
  Colors.pinkAccent,
  Colors.amberAccent,
];
List<String> titlePage = [
  'Página Inicial',
  'Chat App',
  'MyHouses',
  'Cadastrar House',
  'Configurações',
];

//
//
//Inicio do Inicializador
void main() {
  runApp(MyCurvedLabeledNavBarApp());
}

class MyCurvedLabeledNavBarApp extends StatelessWidget {
  const MyCurvedLabeledNavBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/', //Rotas
      routes: {
        '/': (context) => CurvedLabeledNavBar(), //Página Inicial
        //'/login': (context) => WelcomePage(), //Página de Login MyHomePage(title: 'Flutter Demo Home Page'),
      },
    );
  }
}

//Fim do Inicializador
//
//
class CurvedLabeledNavBar extends StatefulWidget {
  const CurvedLabeledNavBar({super.key});

  @override
  State<CurvedLabeledNavBar> createState() => _CurvedLabeledNavBarState();
}

class _CurvedLabeledNavBarState extends State<CurvedLabeledNavBar> {
  int _page = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Navbar(),
      appBar: AppBar(
        //------------------------------------> AppBar
        backgroundColor: colorItems[_page],
        title: Text(titlePage[_page]),
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: Icon(Icons.person_2_rounded),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
        ), // Fim do Icone Home
      ), // Fim do AppBar
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: 0,
        items: [
          CurvedNavigationBarItem(
            child: Icon(Icons.home_outlined),
            label: 'Página Inicial',
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.chat_bubble_outline),
            label: 'Chat App',
          ),
          CurvedNavigationBarItem(child: Icon(Icons.house), label: 'MyHouses'),
          CurvedNavigationBarItem(
            child: Icon(Icons.room_service_rounded),
            label: 'Cadastrar',
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.perm_identity),
            label: 'Configurações',
          ),
        ],
        color: Colors.white,
        buttonBackgroundColor:
            _page == 0
                ? colorItems[colorItems.length - 2]
                : colorItems[colorItems.length - 1],

        backgroundColor:
            _page == 0
                ? colorItems[colorItems.length - 1]
                : colorItems[_page - 1],
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 600),
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
        letIndexChange: (index) => true,
      ),
      body: myBody(),
    );
  }

  Widget myBody() {
    return Container(
      //----------------------------------------------> Container
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,

      decoration: BoxDecoration(
        //--------------------------> BoxDecoration
        color:
            _page == 0
                ? colorItems[colorItems.length - 1]
                : colorItems[_page - 1],
      ), // Fim do BoxDecoration
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,

          children: <Widget>[
            backToHome(),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                width: double.maxFinite,
                height:
                    _page == 0
                        ? MediaQuery.of(context).size.height / 1.32
                        : MediaQuery.of(context).size.height / 1.42,
                decoration: BoxDecoration(
                  color: colorItems[_page],
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    ) // Fim do Container
    ; // Fim do Scaffold
  }

  Widget backToHome() {
    return _page != 0
        ? Column(
          children: [
            /*
            Text(
              _page.toString(),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            */
            Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: ElevatedButton(
                child: Text('Go To Home Page'),
                onPressed: () {
                  final CurvedNavigationBarState? navBarState =
                      _bottomNavigationKey.currentState;
                  navBarState?.setPage(0);
                },
              ),
            ),
          ],
        )
        : Column();
  }
}
