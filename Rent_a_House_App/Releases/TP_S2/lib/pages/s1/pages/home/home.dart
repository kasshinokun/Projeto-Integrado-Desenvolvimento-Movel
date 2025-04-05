import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
//import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:rent_a_house/pages/s1/pages/home/navbar.dart';
import 'package:rent_a_house/pages/s1/pages/manage/cdsearch/customsearchdelegate.dart';
import 'package:rent_a_house/pages/s1/pages/manage/renthouse.dart';
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
  '16 Avenida Perimetral, 12345, bairro Jardim Arizona - Sete Lagoas',
  '17 Rua Virgínia de Oliveira Maciel, 3456, bairro Morro do Claro - Sete Lagoas',
  '18 Rua Manoel Correa da Cunha, 678, bairro Recanto do Cedro - Sete Lagoas',
  '19 Rua Rei Salomão, 3456, bairro Esperança - Sete Lagoas',
  '20 Rua Q, 678, bairro Eldorado - Sete Lagoas',
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
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Navbar(),
      appBar: AppBar(
        //------------------------------------> AppBar
        backgroundColor: Colors.green,
        title: Text(
          MediaQuery.of(context).orientation == Orientation.portrait
              ? 'Início'
              : 'Página Inicial',
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
      body:
          MediaQuery.of(context).size.width < 600
              //If ternario nos filhos do container
              ? SingleChildScrollView(
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    myPaddingText(
                      "Ultimas Visualizações",
                      Colors.lightGreenAccent,
                    ),
                    myCarousel(),
                    myPaddingText("Destaques", Colors.lightGreenAccent),
                    myListHouse(),
                  ],
                ),
              )
              : Row(
                children: [
                  SingleChildScrollView(
                    padding: EdgeInsets.all(6.0),
                    child: Column(
                      children: <Widget>[
                        myPaddingText(
                          "Ultimas Visualizações",
                          Colors.lightGreenAccent,
                        ),
                        myCarousel(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(6.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2.2,
                      decoration: BoxDecoration(
                        color: Colors.lightBlueAccent,
                        borderRadius: BorderRadius.circular(9.0),
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: <Widget>[
                            myPaddingText("Destaques", Colors.lightGreenAccent),
                            myListHouse(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
    );
  }

  Widget mySearchButton() {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2,
      height: MediaQuery.of(context).size.height / 8.5,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: ElevatedButton.icon(
          label: Text(
            "Pesquisar",
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
                //searchController: searchController, //teste para retorno
              ),
            );
            //print(searchController.text); //Exibir retorno no terminal
          },
          icon: Icon(Icons.search),
          iconAlignment: IconAlignment.end,
        ),
      ),
    ); //Fim do SearchBar
  }

  //Carousel de Imagens
  //
  Widget myCarousel() {
    return Container(
      height:
          MediaQuery.of(context).orientation == Orientation.portrait
              ? MediaQuery.of(context).size.height / 1.95
              : MediaQuery.of(context).size.height / 1.45,
      width:
          MediaQuery.of(context).orientation == Orientation.portrait
              ? MediaQuery.of(context).size.width
              : MediaQuery.of(context).size.width / 2,
      decoration: BoxDecoration(
        color: Colors.pinkAccent,
        borderRadius: BorderRadius.circular(9.0),
      ),
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
      (index) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9.0),
          //color: Colors.pink,
        ),
        width:
            MediaQuery.of(context).orientation == Orientation.portrait
                ? MediaQuery.of(context).size.width
                : MediaQuery.of(context).size.width / 2.1,
        child:
            MediaQuery.of(context).orientation == Orientation.portrait
                ? Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(4.0),
                      child: myImageLast(images[index]),
                    ),
                    myPaddingText(address[index], Colors.white),
                  ],
                )
                : Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(4.0),
                      child: myImageLast(images[index]),
                    ),
                  ],
                ),
      ),
    ); // List.generate
  }

  Widget myListHouse() {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemCount: imagesItems.length,
      itemBuilder: (context, index) {
        return myColumnImage(
          myImage(imagesItems[index]),
          addressItens[index],
          Colors.pinkAccent,
        );
      },
      separatorBuilder: (context, i) {
        return Divider();
      },
    );
  }

  Widget myImageLast(String url) {
    return InkWell(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          url,
          fit: BoxFit.cover,
          height:
              MediaQuery.of(context).orientation == Orientation.portrait
                  ? MediaQuery.of(context).size.height / 2.6
                  : MediaQuery.of(context).size.height / 1.65,
          width:
              MediaQuery.of(context).orientation == Orientation.portrait
                  ? MediaQuery.of(context).size.width
                  : MediaQuery.of(context).size.width / 2,
        ),
      ),

      onTap:
          () => getPage(
            "Ultimas Visualizações",
            url,
            lastVisualizationsAddress[lastVisualizationsItems.indexOf(url)],
          ),
    );
  }

  int searchValue() {
    int value = 0;

    return value;
  }

  Widget myPaddingText(String information, Color cor) {
    return Padding(
      padding: EdgeInsets.all(4.0),
      child: Container(
        width:
            MediaQuery.of(context).orientation == Orientation.portrait
                ? MediaQuery.of(context).size.width
                : MediaQuery.of(context).size.width / 2.2,
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

  Widget myColumnImage(Widget image, String address, Color cor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        myPaddingText(address, Colors.lightGreenAccent),
        myContainer(image, cor),
        myPaddingText(address, Colors.white),
      ],
    );
  }

  Widget myImage(String url) {
    return InkWell(
      child: myClipRect(url),
      onTap:
          () => getPage("Alugar", url, addressItens[imagesItems.indexOf(url)]),
    );
  }

  Widget myContainer(Widget children, Color cor) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.0),
      child: Container(
        height:
            MediaQuery.of(context).orientation == Orientation.portrait
                ? MediaQuery.of(context).size.height / 1.95
                : MediaQuery.of(context).size.height / 1.45,
        width:
            MediaQuery.of(context).orientation == Orientation.portrait
                ? MediaQuery.of(context).size.width
                : MediaQuery.of(context).size.width / 2.2,
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

  Future<dynamic> getPage(String title, String url, String address) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => RentScreen(title: title, url: url, query: address),
      ),
    );
  }
}
