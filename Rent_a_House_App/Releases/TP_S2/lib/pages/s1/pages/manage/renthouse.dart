import 'package:flutter/material.dart';
//import 'package:rent_a_house/pages/s1/pages/welcome/welcome.dart';
//import 'package:rent_a_house/pages/s1/pages/Home/navbar.dart';
import 'package:carousel_slider/carousel_slider.dart';

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
        '/':
            (context) => RentScreen(
              title: "Teste",
              index: 1,
              query: "Rua Bendita da Silva, 1500, Caldas Novas - Minas Gerais",
            ), //Página Inicial
      },
    );
  }
}

//Fim do Inicializador
//
//

class RentScreen extends StatefulWidget {
  final String query;
  final int index;
  final String title;
  const RentScreen({
    super.key,
    required this.title,
    required this.index,
    required this.query,
  }) : super();

  @override
  State<RentScreen> createState() => _RentScreen();
}

class _RentScreen extends State<RentScreen> {
  TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //------------------------------------> AppBar
        backgroundColor: Colors.green,
        title: Text(widget.title), //Text
      ), //Appbar
      extendBody: true,
      body: GestureDetector(
        onTap: () => Navigator.of(context).pop(),

        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          //
          child:
              MediaQuery.of(context).size.width < 600
                  //If ternario nos filhos do container
                  ? SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        myContainerSearch(widget.index, widget.query),
                        myCarousel(),
                        detailsHouseClip(),
                      ],
                    ),
                  )
                  : Row(
                    children: [
                      myContainerSearch(widget.index, widget.query),
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 32.0),
                              child: myCarousel(),
                            ),
                            detailsHouseClip(),
                          ],
                        ),
                      ),
                    ],
                  ),
          //
        ),
      ),
    ); // Fim do Scaffold
  } // Fim do retorno

  //Carousel de Imagens
  //
  Widget myCarousel() {
    return ConstrainedBox(
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
      child: Center(
        child: CarouselSlider(
          items: getListImage(imagesItems),
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
  List<Widget> getListImage(List<String> images) {
    //Lista de imagens como Objeto
    return List.generate(
      // List.generate
      images.length,
      (index) => Padding(
        padding: EdgeInsets.all(8.0),
        child: SizedBox(
          height:
              MediaQuery.of(context).orientation == Orientation.portrait
                  ? MediaQuery.of(context).size.height / 2.1
                  : MediaQuery.of(context).size.height / 1.45,
          width:
              MediaQuery.of(context).orientation == Orientation.portrait
                  ? MediaQuery.of(context).size.width
                  : MediaQuery.of(context).size.width / 2.4,
          child: myImageSearch(index),
        ), //
      ), //
    ); // List.generate
  }

  //
  Widget myContainerSearch(int index, String resultado) {
    return Container(
      color: Colors.pink.shade50,
      child: Column(
        children: [
          myPaddingText("Clique sobre a imagem para voltar", Colors.pink),
          myImageSearch(index),
          myPaddingText(resultado, Colors.pink),
        ],
      ),
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

  Widget myImageSearch(int index) {
    return InkWell(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          imagesItems[index],
          fit: BoxFit.cover,
          height:
              MediaQuery.of(context).orientation == Orientation.portrait
                  ? MediaQuery.of(context).size.height / 2.2
                  : MediaQuery.of(context).size.height / 1.55,
          width:
              MediaQuery.of(context).orientation == Orientation.portrait
                  ? MediaQuery.of(context).size.width
                  : MediaQuery.of(context).size.width / 2.6,
        ), //
      ),
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
                              imagesItems[index],
                              fit: BoxFit.cover,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
            ),
          ),
    );
  }

  //======================================================================================
  Widget detailsHouseClip() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width:
                MediaQuery.of(context).orientation == Orientation.portrait
                    ? MediaQuery.of(context).size.width
                    : MediaQuery.of(context).size.width / 2.6,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: getDetailsHouse(), //
          ),
        ],
      ),
    );
  }

  Widget getDetailsHouse() {
    return //
    Padding(
      padding: EdgeInsets.all(24.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [getTitleHouse(), getExpandedDetailsHouse()],
        ),
      ),
    );
  }

  //Detalhes iniciais genericos do imovel
  Widget getTitleHouse() {
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
                  widget.query,
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

  //Detalhes gerais genericos do Imovel
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
} // Fim do Metodo
