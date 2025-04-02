import 'package:flutter/material.dart';
//import 'package:carousel_slider/carousel_slider.dart';
//import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:rent_a_house/pages/s1/pages/home/navbar.dart';
//import 'package:carousel_slider/carousel_slider.dart';
import 'package:rent_a_house/pages/s1/pages/manage/customsearchdelegate.dart';

List<String> lastVisualizationsAddress = [
  '1 Rua Alegre, 12345, bairro Brasil - Belo Horizonte',
  '2 Rua Javae, 3456, bairro Nogueirinha - Itaúna',
  '3 Rua César Dacorso Filho, 678, bairro Barreiro - Belo Horizonte',
  "4 Rua Rua Três, 3456, bairro Olhos D'Água - Belo Horizonte",
  '5 Rua Rosa de Pedra, 678, bairro Etelvina Carneiro - Belo Horizonte',
];
List<String> lastVisualizationsItems = [
  'https://raw.githubusercontent.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/refs/heads/main/Rent_a_House_App/Imagens_S2/App/House/house-1.jpg',
  'https://raw.githubusercontent.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/refs/heads/main/Rent_a_House_App/Imagens_S2/App/Apart/apart-1.jpg',
  'https://raw.githubusercontent.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/refs/heads/main/Rent_a_House_App/Imagens_S2/App/Apart/apart-2.jpg',
  'https://raw.githubusercontent.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/refs/heads/main/Rent_a_House_App/Imagens_S2/App/Beach/beach-1.jpg',
  'https://raw.githubusercontent.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/refs/heads/main/Rent_a_House_App/Imagens_S2/App/Beach/beach-2.jpg',
];

List<String> addressItens = [
  '1 Rua Alegre, 12345, bairro Brasil - Belo Horizonte',
  '2 Rua Javae, 3456, bairro Nogueirinha - Itaúna',
  '3 Rua César Dacorso Filho, 678, bairro Barreiro - Belo Horizonte',
  "4 Rua Rua Três, 3456, bairro Olhos D'Água - Belo Horizonte",
  '5 Rua Rosa de Pedra, 678, bairro Etelvina Carneiro - Belo Horizonte',
  '6 Avenida Perimetral, 12345, bairro Jardim Arizona - Sete Lagoas',
  '7 Rua Virgínia de Oliveira Maciel, 3456, bairro Morro do Claro - Sete Lagoas',
  '8 Rua Manoel Correa da Cunha, 678, bairro Recanto do Cedro - Sete Lagoas',
  '9 Rua Rei Salomão, 3456, bairro Esperança - Sete Lagoas',
  '10 Rua Q, 678, bairro Eldorado - Sete Lagoas',
  '11 Rua Geraldo Francisco de Azevedo, 340, bairro Centro - Ouro Branco',
  '12 Rua Alvarenga, 494, bairro Cabeças - Ouro Preto',
  '13 Rua Marieta de Barros Valadão, 678, bairro Nossa Senhora de Fátima - Patos de Minas',
  '14 Rua dos Otis, 3456, bairro Suzana - Belo Horizonte',
  '15 Avenida Manoel Pinheiro Diniz, 265, bairro Pinheiros - Itatiaiuçu',
];

List<String> imagesItems = [
  'https://raw.githubusercontent.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/refs/heads/main/Rent_a_House_App/Imagens_S2/App/House/house-1.jpg',
  'https://raw.githubusercontent.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/refs/heads/main/Rent_a_House_App/Imagens_S2/App/House/house-2.jpg',
  'https://raw.githubusercontent.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/refs/heads/main/Rent_a_House_App/Imagens_S2/App/House/house-3.jpg',
  'https://raw.githubusercontent.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/refs/heads/main/Rent_a_House_App/Imagens_S2/App/House/house-4.jpg',
  'https://raw.githubusercontent.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/refs/heads/main/Rent_a_House_App/Imagens_S2/App/House/house-5.jpg',
  'https://raw.githubusercontent.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/refs/heads/main/Rent_a_House_App/Imagens_S2/App/House/house-6.jpg',
  'https://raw.githubusercontent.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/refs/heads/main/Rent_a_House_App/Imagens_S2/App/House/house-7.jpg',
  'https://raw.githubusercontent.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/refs/heads/main/Rent_a_House_App/Imagens_S2/App/Apart/apart-1.jpg',
  'https://raw.githubusercontent.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/refs/heads/main/Rent_a_House_App/Imagens_S2/App/Apart/apart-2.jpg',
  'https://raw.githubusercontent.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/refs/heads/main/Rent_a_House_App/Imagens_S2/App/Apart/apart-3.jpg',
  'https://raw.githubusercontent.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/refs/heads/main/Rent_a_House_App/Imagens_S2/App/Apart/apart-4.jpg',
  'https://raw.githubusercontent.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/refs/heads/main/Rent_a_House_App/Imagens_S2/App/Apart/apart-5.jpg',
  'https://raw.githubusercontent.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/refs/heads/main/Rent_a_House_App/Imagens_S2/App/Apart/apart-6.jpg',
  'https://raw.githubusercontent.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/refs/heads/main/Rent_a_House_App/Imagens_S2/App/Apart/apart-7.jpg',
  'https://raw.githubusercontent.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/refs/heads/main/Rent_a_House_App/Imagens_S2/App/Beach/beach-1.jpg',
  'https://raw.githubusercontent.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/refs/heads/main/Rent_a_House_App/Imagens_S2/App/Beach/beach-2.jpg',
  'https://raw.githubusercontent.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/refs/heads/main/Rent_a_House_App/Imagens_S2/App/Beach/beach-3.jpg',
  'https://raw.githubusercontent.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/refs/heads/main/Rent_a_House_App/Imagens_S2/App/Beach/beach-4.jpg',
  'https://raw.githubusercontent.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/refs/heads/main/Rent_a_House_App/Imagens_S2/App/Beach/beach-5.jpg',
  'https://raw.githubusercontent.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/refs/heads/main/Rent_a_House_App/Imagens_S2/App/Beach/beach-6.jpg',
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
      debugShowCheckedModeBanner: false, //tirar o banner
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
        actions: [
          //Actions
          //SearchBar
          mySearchButton(),
        ], // Fim do Actions
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
                      Text(
                        "Ultimas Visualizações",
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      myColumnImage(
                        lastVisualizationsItems[0],
                        lastVisualizationsAddress[0],
                        Colors.pink,
                      ),
                      Text(
                        "Destaques",
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      myColumnImage(
                        imagesItems[0],
                        addressItens[0],
                        Colors.pink,
                      ),
                      myColumnImage(
                        imagesItems[1],
                        addressItens[1],
                        Colors.cyan,
                      ),
                      myColumnImage(
                        imagesItems[2],
                        addressItens[2],
                        Colors.yellow,
                      ),
                      myColumnImage(
                        imagesItems[3],
                        addressItens[3],
                        Colors.blue,
                      ),
                      myColumnImage(
                        imagesItems[4],
                        addressItens[4],
                        Colors.white,
                      ),
                      myColumnImage(
                        imagesItems[5],
                        addressItens[5],
                        Colors.greenAccent,
                      ),
                    ],
                  ),
                )
                : Row(
                  children: [
                    Column(
                      children: [
                        Text(
                          "Ultimas Visualizações",
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        myColumnImage(
                          lastVisualizationsItems[0],
                          lastVisualizationsAddress[0],
                          Colors.pink,
                        ),
                      ],
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Text(
                            "Destaques",
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          myColumnImage(
                            imagesItems[0],
                            addressItens[0],
                            Colors.pink,
                          ),
                          myColumnImage(
                            imagesItems[1],
                            addressItens[1],
                            Colors.cyan,
                          ),
                          myColumnImage(
                            imagesItems[2],
                            addressItens[2],
                            Colors.yellow,
                          ),
                          myColumnImage(
                            imagesItems[3],
                            addressItens[3],
                            Colors.blue,
                          ),
                          myColumnImage(
                            imagesItems[4],
                            addressItens[4],
                            Colors.white,
                          ),
                          myColumnImage(
                            imagesItems[5],
                            addressItens[5],
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

  Widget mySearchButton() {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 4.0,
      height: MediaQuery.of(context).size.height / 9.0,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: ElevatedButton.icon(
          label: Text(
            "Clique para pesquisar",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          onPressed: () {
            showSearch<String>(
              context: context, //
              delegate: CustomSearchDelegate(hintText: 'Buscar endereços', listAddress:addressItems), //envia a lista de endereços 
            );
          },
          icon: Icon(Icons.search),
        ),
      ),
    ); //Fim do SearchBar
  }

  Widget myColumnImage(String image, String address, Color cor) {
    return Column(
      children: [
        myContainer(myImage(image), cor),
        Text(
          address,
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
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

  Widget myImage2(String url) {
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

