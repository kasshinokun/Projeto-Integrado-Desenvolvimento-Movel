import 'package:flutter/material.dart';
//import 'package:carousel_slider/carousel_slider.dart';
//import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:rent_a_house/pages/s1/pages/home/navbar.dart';

List<String> addressItens = [
  '1 Rua Alegre, 12345, bairro Brasil - Belo Horizonte',
  '2 Rua Alfa, 3456, bairro França - Ouro Preto',
  '3 Rua Puc Minas, 678, bairro Argentina - Sete Lagoas',
  '4 Rua Alfa, 3456, bairro França - Ouro Branco',
  '5 Rua Puc Minas, 678, bairro Argentina - Lagoa Santa',
  '6 Rua Alegre, 12345, bairro Brasil - Belo Horizonte',
  '7 Rua Alfa, 3456, bairro França - Ouro Preto',
  '8 Rua Puc Minas, 678, bairro Argentina - Sete Lagoas',
  '9 Rua Alfa, 3456, bairro França - Ouro Branco',
  '10 Rua Puc Minas, 678, bairro Argentina - Lagoa Santa',
  '11 Rua Alegre, 12345, bairro Brasil - Belo Horizonte',
  '12 Rua Alfa, 3456, bairro França - Ouro Preto',
  '13 Rua Puc Minas, 678, bairro Argentina - Sete Lagoas',
  '14 Rua Alfa, 3456, bairro França - Ouro Branco',
  '15 Rua Puc Minas, 678, bairro Argentina - Lagoa Santa',
];

List<String> imagesItems = [
  'https://images.homify.com/v1591213520/p/photo/image/3509801/foto2-m.jpg',
  'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
  'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
  'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
  'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
  'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80',
  'https://images.unsplash.com/photo-1586882829491-b81178aa622e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2850&q=80',
  'https://images.unsplash.com/photo-1586871608370-4adee64d1794?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2862&q=80',
  'https://images.unsplash.com/photo-1586901533048-0e856dff2c0d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1650&q=80',
  'https://images.unsplash.com/photo-1586902279476-3244d8d18285?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2850&q=80',
  'https://images.unsplash.com/photo-1586943101559-4cdcf86a6f87?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1556&q=80',
  'https://images.unsplash.com/photo-1586951144438-26d4e072b891?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1650&q=80',
  'https://images.unsplash.com/photo-1586953983027-d7508a64f4bb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1650&q=80',
];

//
//
//Inicio do Inicializador
void main() {
  runApp(HomeScreenApp());
}

class HomeScreenApp extends StatelessWidget {
  const HomeScreenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/', //Rotas
      routes: {
        '/': (context) => HomeScreen(), //Página Inicial
      },
    );
  }
}

//Fim do Inicializador
//
//
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Navbar(),
      appBar: AppBar(
        //------------------------------------> AppBar
        backgroundColor: Colors.green,
        title: Text('Rent a House - HomePage'),
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: Icon(Icons.person_2_rounded),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
        ), // Fim do Icone Home
      ), // Fim do AppBar
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.white),
        child:
            MediaQuery.of(context).orientation == Orientation.portrait
                ? SingleChildScrollView(
                  child: Column(
                    children: [
                      myContainer(myImage(imagesItems[0]), Colors.pink),
                      myContainer(myImage(imagesItems[1]), Colors.cyan),
                      myContainer(myImage(imagesItems[2]), Colors.yellow),
                      myContainer(myImage(imagesItems[3]), Colors.blue),
                      myContainer(myImage(imagesItems[4]), Colors.white),
                      myContainer(myImage(imagesItems[5]), Colors.greenAccent),
                    ],
                  ),
                )
                : Row(
                  children: [
                    myContainer(myImage(imagesItems[0]), Colors.pink),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          myContainer(myImage(imagesItems[1]), Colors.cyan),
                          myContainer(myImage(imagesItems[2]), Colors.yellow),
                          myContainer(myImage(imagesItems[3]), Colors.blue),
                          myContainer(myImage(imagesItems[4]), Colors.white),
                          myContainer(
                            myImage(imagesItems[5]),
                            Colors.greenAccent,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
      ),
    );
  }

  Widget myImage(String url) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
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
    );
  }

  Widget myContainer(Widget children, Color cor) {
    return Padding(
      padding: EdgeInsets.all(4.0),
      child: Container(
        height:
            MediaQuery.of(context).orientation == Orientation.portrait
                ? MediaQuery.of(context).size.height / 2.2
                : MediaQuery.of(context).size.height / 1.55,
        width:
            MediaQuery.of(context).orientation == Orientation.portrait
                ? MediaQuery.of(context).size.width
                : MediaQuery.of(context).size.width / 2.05,
        decoration: BoxDecoration(
          color: cor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: children,
      ),
    );
  }
}

    
    
    
    
    
    
    
    
    
    
//================================================================================    
    