import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
//import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:rent_a_house/pages/s1/pages/home/navbar.dart';
import 'package:rent_a_house/pages/s1/pages/manage/cdsearch/customsearchdelegate.dart';
//import 'dart:async';

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
        title: Text(
          MediaQuery.of(context).orientation == Orientation.portrait
              ? 'Página Inicial'
              : 'Rent a House - HomePage',
        ),
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
                    children: <Widget>[
                      myPaddingText(
                        "Ultimas Visualizações",
                        Colors.greenAccent,
                      ),
                      myCarousel(),
                      myPaddingText("Destaques", Colors.greenAccent),
                      myColumnImage(
                        myImage(imagesItems[0]),
                        addressItens[0],
                        Colors.pink,
                      ),
                      myColumnImage(
                        myImage(imagesItems[1]),
                        addressItens[1],
                        Colors.cyan,
                      ),
                      myColumnImage(
                        myImage(imagesItems[2]),
                        addressItens[2],
                        Colors.yellow,
                      ),
                      myColumnImage(
                        myImage(imagesItems[3]),
                        addressItens[3],
                        Colors.blue,
                      ),
                      myColumnImage(
                        myImage(imagesItems[4]),
                        addressItens[4],
                        Colors.white,
                      ),
                      myColumnImage(
                        myImage(imagesItems[5]),
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
                        myPaddingText(
                          "Ultimas Visualizações",
                          Colors.greenAccent,
                        ),
                        myCarousel(),
                      ],
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          myPaddingText("Destaques", Colors.greenAccent),

                          myColumnImage(
                            myImage(imagesItems[0]),
                            addressItens[0],
                            Colors.pink,
                          ),
                          myColumnImage(
                            myImage(imagesItems[1]),
                            addressItens[1],
                            Colors.cyan,
                          ),
                          myColumnImage(
                            myImage(imagesItems[2]),
                            addressItens[2],
                            Colors.yellow,
                          ),
                          myColumnImage(
                            myImage(imagesItems[3]),
                            addressItens[3],
                            Colors.blue,
                          ),
                          myColumnImage(
                            myImage(imagesItems[4]),
                            addressItens[4],
                            Colors.white,
                          ),
                          myColumnImage(
                            myImage(imagesItems[5]),
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

  //Carousel de Imagens
  //
  Widget myCarousel() {
    return SizedBox(
      height:
          MediaQuery.of(context).orientation == Orientation.portrait
              ? MediaQuery.of(context).size.height / 1.7
              : MediaQuery.of(context).size.height / 1.2,
      width:
          MediaQuery.of(context).orientation == Orientation.portrait
              ? MediaQuery.of(context).size.width
              : MediaQuery.of(context).size.width / 2,
      child: Center(
        child: CarouselSlider(
          items: getListImage(
            lastVisualizationsItems,
            lastVisualizationsAddress,
          ),
          //options: CarouselOptions(aspectRatio: 1, viewportFraction: 1),
          options: CarouselOptions(
            aspectRatio: 1,
            viewportFraction: 1,
            enlargeCenterPage: true, // Increase the size of the center item
            enableInfiniteScroll: true, // Enable infinite scroll
            onPageChanged: (index, reason) {
              // Optional callback when the page changes
              // You can use it to update any additional UI components
            },
          ),
        ),
      ),
    );
  }

  //Lista de Images
  List<Widget> getListImage(List<String> images, List<String> address) {
    //Lista de imagens como Objeto
    return List.generate(
      // List.generate
      images.length,
      (index) => Padding(
        padding: EdgeInsets.all(4.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9.0),
            //color: Colors.pink,
          ),
          width:
              MediaQuery.of(context).orientation == Orientation.portrait
                  ? MediaQuery.of(context).size.width
                  : MediaQuery.of(context).size.width / 2.4,
          child: Column(
            children: [
              myPaddingText(address[index], Colors.white),
              myImageLast(images[index]),
              myPaddingText(address[index], Colors.white),
            ],
          ),
        ), //
      ), //
    ); // List.generate
  }

  Widget myImageLast(String url) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            url,
            fit: BoxFit.cover,
            height:
                MediaQuery.of(context).orientation == Orientation.portrait
                    ? MediaQuery.of(context).size.height / 2.5
                    : MediaQuery.of(context).size.height / 1.8,
            width:
                MediaQuery.of(context).orientation == Orientation.portrait
                    ? MediaQuery.of(context).size.width
                    : MediaQuery.of(context).size.width / 2.6,
          ),
        ),
      ),
      onTap: () => getPage(url),
    );
  }

  Widget myPaddingText(String information, Color cor) {
    return Padding(
      padding: EdgeInsets.all(4.0),
      child: Container(
        width:
            MediaQuery.of(context).orientation == Orientation.portrait
                ? MediaQuery.of(context).size.width
                : MediaQuery.of(context).size.width / 2.05,
        decoration: BoxDecoration(
          color: cor,
          borderRadius: BorderRadius.circular(9.0),
        ), //
        child: Padding(
          padding: EdgeInsets.all(4.0),
          child: Center(
            child: Text(
              information,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 20.0,
              ), //
            ), //
          ), //
        ),
      ), //
    );
  }

  Widget mySearchButton() {
    return SizedBox(
      width:
          MediaQuery.of(context).orientation == Orientation.portrait
              ? MediaQuery.of(context).size.width / 2.5
              : MediaQuery.of(context).size.width / 4.0,
      height: MediaQuery.of(context).size.height / 9.0,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: ElevatedButton.icon(
          label: Text(
            MediaQuery.of(context).orientation == Orientation.portrait
                ? "Pesquisar"
                : "Clique para pesquisar",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          onPressed: () async {
            showSearch<String>(
              //Ainda não tem retorno
              context: context, //
              delegate: CustomSearchDelegate(
                hintText: 'Buscar endereços', //texto dica do TextField
                listAddress: addressItens, //envia a lista de endereços
              ),
            );
          },
          icon: Icon(Icons.search),
          iconAlignment: IconAlignment.end,
        ),
      ),
    ); //Fim do SearchBar
  }

  Widget myColumnImage(Widget image, String address, Color cor) {
    return Column(
      children: [
        myContainer(image, cor),
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
    return InkWell(child: myClipRect(url), onTap: () => getPage(url));
  }

  Widget myContainer(Widget children, Color cor) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.0),
      child: Container(
        height:
            MediaQuery.of(context).orientation == Orientation.portrait
                ? MediaQuery.of(context).size.height / 2.1
                : MediaQuery.of(context).size.height / 1.45,
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

  Widget myClipRect(String url) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.network(
        url,
        fit: BoxFit.cover,
        height:
            MediaQuery.of(context).orientation == Orientation.portrait
                ? MediaQuery.of(context).size.height / 2.4
                : MediaQuery.of(context).size.height / 1.55,
        width:
            MediaQuery.of(context).orientation == Orientation.portrait
                ? MediaQuery.of(context).size.width / 1.1
                : MediaQuery.of(context).size.width / 2.6,
      ), //
    );
  }

  Future<dynamic> getPage(String url) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => Scaffold(
              extendBody: true,
              body: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: SingleChildScrollView(
                  child: Column(
                    children: [Image.network(url, fit: BoxFit.cover)],
                  ),
                ),
              ),
            ),
      ),
    );
  }
}
/*ConstrainedBox(
      constraints: BoxConstraints(
        // BoxConstraints
        maxHeight:
            MediaQuery.of(context).orientation == Orientation.portrait
                ? MediaQuery.of(context).size.height / 2.1
                : MediaQuery.of(context).size.height / 1.45,
        maxWidth:
            MediaQuery.of(context).orientation == Orientation.portrait
                ? MediaQuery.of(context).size.width
                : MediaQuery.of(context).size.width / 2.4,
      ), // Fim do BoxConstraints
      child: */