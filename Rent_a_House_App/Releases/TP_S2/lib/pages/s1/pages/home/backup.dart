//backup de home.dart
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:rent_a_house/pages/s1/pages/home/navbar.dart';

//Lista de URLs de imagens como Objeto
List<String> imagesList = [
  'https://raw.githubusercontent.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/refs/heads/main/Rent_a_House_App/Imagens_S2/App/House/house-1.jpg',
  'https://raw.githubusercontent.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/refs/heads/main/Rent_a_House_App/Imagens_S2/App/House/house-2.jpg',
  'https://raw.githubusercontent.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/refs/heads/main/Rent_a_House_App/Imagens_S2/App/House/house-3.jpg',
  'https://raw.githubusercontent.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/refs/heads/main/Rent_a_House_App/Imagens_S2/App/House/house-4.jpg',
  'https://raw.githubusercontent.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/refs/heads/main/Rent_a_House_App/Imagens_S2/App/House/house-5.jpg',
  'https://raw.githubusercontent.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/refs/heads/main/Rent_a_House_App/Imagens_S2/App/Apart/apart-1.jpg',
  'https://raw.githubusercontent.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/refs/heads/main/Rent_a_House_App/Imagens_S2/App/Apart/apart-2.jpg',
  'https://raw.githubusercontent.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/refs/heads/main/Rent_a_House_App/Imagens_S2/App/Apart/apart-3.jpg',
  'https://raw.githubusercontent.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/refs/heads/main/Rent_a_House_App/Imagens_S2/App/Apart/apart-4.jpg',
  'https://raw.githubusercontent.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/refs/heads/main/Rent_a_House_App/Imagens_S2/App/Apart/apart-5.jpg',
  'https://raw.githubusercontent.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/refs/heads/main/Rent_a_House_App/Imagens_S2/App/Beach/beach-1.jpg',
  'https://raw.githubusercontent.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/refs/heads/main/Rent_a_House_App/Imagens_S2/App/Beach/beach-2.jpg',
  'https://raw.githubusercontent.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/refs/heads/main/Rent_a_House_App/Imagens_S2/App/Beach/beach-3.jpg',
  'https://raw.githubusercontent.com/kasshinokun/Projeto-Integrado-Desenvolvimento-Movel/refs/heads/main/Rent_a_House_App/Imagens_S2/App/Beach/beach-4.jpg',
];

List<String> addressClient = [
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
  TextEditingController textEditingController = TextEditingController();

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            mySearchBar(), //Barra de Pesquisa
            Text(
              "Ultimas Visualizações",
              style: TextStyle(
                fontSize: 24,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            myCarousel(), //Carousel de Imagens
            Text(
              "Destaques",
              style: TextStyle(
                fontSize: 24,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            carouselGrid(),
          ],
        ), //Column
      ), //SingleChildScrollView
    ); //Scafold
  }

  Widget mySearchBar() {
    return Padding(
      padding: EdgeInsets.all(24.0),
      child: TextField(
        //-------------------------------------> TextField
        decoration: InputDecoration(
          //------------------> InputDecoration
          filled: true,
          fillColor: const Color.fromARGB(255, 246, 248, 246),
          labelText: 'Pesquisar',
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          floatingLabelStyle: TextStyle(
            //--------------> Estilo do Texto
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 37, 37, 37),
            fontSize: 20,
          ), // Fim do Estilo do Texto
          hintMaxLines: 1,

          suffixIcon: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () => textEditingController.clear(),
          ),
          // Add a search icon or button to the search bar
          prefixIcon: IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Perform the search here
            },
          ),
          hintText: 'Informe um endereço por favor',
          border: OutlineInputBorder(
            //--------------> OutlineInputBorder
            borderRadius: BorderRadius.circular(20),
          ), // Fim do OutlineInputBorder
        ), // Fim do InputDecoration
      ),
    );
  }

  //
  Widget myCarousel() {
    return ConstrainedBox(
      constraints: BoxConstraints(
        // BoxConstraints
        maxWidth: MediaQuery.sizeOf(context).width * 0.9,
        maxHeight: MediaQuery.sizeOf(context).height * 0.8,
      ), // Fim do BoxConstraints
      child: CarouselSlider(
        items: getListImage(imagesList),
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
    );
  }

  List<Widget> getListImage(List<String> images) {
    //Lista de imagens como Objeto
    return List.generate(
      // List.generate
      images.length,
      (index) => Padding(
        padding: EdgeInsets.all(16.0),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          width: MediaQuery.of(context).size.width * 0.7,
          child: imageWidget(index),
        ), //
      ), //
    ); // List.generate
  }

  //
  Widget carouselGrid() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CarouselSlider(
            items: [
              Container(
                height: MediaQuery.of(context).size.height,
                margin: EdgeInsets.all(2),
                child: SingleChildScrollView(
                  child: myStaggeredGrid(), //Modelo Inicial
                ),
              ),
            ],
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
        ],
      ),
    );
  }

  Widget myStaggeredGrid() {
    return StaggeredGrid.count(
      crossAxisCount: imagesList.length,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: generateListImages(imagesList.length),
    );
  }

  List<Widget> generateListImages(int valor) {
    return List.generate(
      valor,
      (index) => StaggeredGridTile.count(
        crossAxisCellCount: 10, //Largura
        mainAxisCellCount: 5, //Altura
        child: SingleChildScrollView(child: imageWidget(index)),
      ),
    );
  }

  Widget imageWidget(int index) {
    return SingleChildScrollView(
      child: Column(
        children: [
          InkWell(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: imageClip(index),
            ), //
            onTap:
                () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder:
                        (context) => Scaffold(
                          extendBody: true,
                          body: GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Image.network(
                                    imagesList[index],
                                    fit: BoxFit.cover,
                                    height:
                                        MediaQuery.of(context).size.height *
                                        0.5,
                                  ),
                                  detailsHouseClip(index, 0.75),
                                ],
                              ),
                            ),
                          ),
                        ),
                  ),
                ),
          ), //
          Padding(
            //-----------------------------------> padding
            padding: EdgeInsets.all(16.0),
            child: addressClip(index, 0.25),
          ),
        ],
      ),
    );
  }

  Widget imageClip(int index) {
    return Image.network(imagesList[index], fit: BoxFit.fill);
  }

  Widget addressClip(int index, double aspectValue) {
    return Container(
      height: MediaQuery.of(context).size.height * aspectValue / 1.75,
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        //-----------------------------------> padding
        padding: EdgeInsets.all(16.0),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            addressClient[index],
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ), //
          ), //
        ),
      ),
    ); //
  }

  //
  Widget detailsHouseClip(int index, double aspectValue) {
    return Container(
      height: MediaQuery.of(context).size.height * aspectValue,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: getDetailsHouse(index), //
    ); //
  }

  //======================================================================================
  Widget getDetailsHouse(int index) {
    return //
    Padding(
      padding: EdgeInsets.all(24.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [getTitleHouse(index), getExpandedDetailsHouse()],
        ),
      ),
    );
  }

  Widget getTitleHouse(int index) {
    return Padding(
      //-----------------------------------> padding
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: <Widget>[
                Text(
                  'Casa com 3 Quartos e 2 banheiros para Alugar, 274 m² por 10.000 reais/Mês',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  addressClient[index],
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ); //
  }

  Widget getExpandedDetailsHouse() {
    return ExpansionTile(
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      expandedAlignment: Alignment.topLeft,
      title: Text(
        "Descrição",
        style: TextStyle(
          fontSize: 24,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
      leading: Icon(Icons.list_rounded),
      controlAffinity: ListTileControlAffinity.leading,
      children: <Widget>[
        Column(
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Casa comercial para locação no Palmares!\n\nBenefícios:\n\n- Localização privilegiada, fácil acesso àAv. Cristiano Machado.\n- Próximo á Estação Minas Shopping, Minas Shopping, Mixpão Palmares.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Casa:\n1º piso\n\n- Sala ampla para dois ambientes\n- Sala de jantar\n- Lavabo;\n- Banho social com armários e box de vidro temperado\n- Cozinha ampla com bancada em granito e armários\n",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "- Despensa\n- Dependência Completa de Empregada\n- Área de Serviço\n- Área externa com churrasqueira.\n\n2º piso\n- Sala de estar íntimo;\n- 03 Quartos com armários, sendo um suíte com varanda.\n",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "\n\nGaragem:\n- 15 vagas de garagem.\n\n\nOs valores de venda e dos encargos (IPTU/condomínio etc.) exibidos poderão sofrer mudanças e aumentos sem prévio aviso.\n",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Por esse motivo os valores deverão ser confirmados no nosso setor comercial e os encargos no prédio/condomínio e IPTU na Prefeitura.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            //
          ],
        ),
      ],
    );
  }
}
    
    
    
    
    
    
    
    
    
    
//================================================================================    
    