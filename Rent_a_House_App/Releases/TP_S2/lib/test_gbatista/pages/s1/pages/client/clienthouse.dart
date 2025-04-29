import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rounded_background_text/rounded_background_text.dart';
import 'package:rent_a_house/pages/s1/pages/home/navbar.dart';
import 'package:rent_a_house/pages/s1/pages/welcome/welcome.dart';
import 'package:carousel_slider/carousel_slider.dart';

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
List<String> carouselItems = [
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
String getDate() {
  final dateFormatter = DateFormat('dd-MM-yyyy');
  final DateTime now = DateTime.now();
  final formattedDate = dateFormatter.format(now);
  return formattedDate;
}

//
//
//Inicio do Inicializador
void main() {
  runApp(ClientScreenApp());
}

class ClientScreenApp extends StatelessWidget {
  const ClientScreenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/', //Rotas
      routes: {
        '/': (context) => ClientScreen(), //Página Inicial
      },
    );
  }
}

//Fim do Inicializador
//
//
class ClientScreen extends StatefulWidget {
  const ClientScreen({super.key});

  @override
  State<ClientScreen> createState() => _ClientScreen();
}

class _ClientScreen extends State<ClientScreen> {
  TextEditingController textEditingController = TextEditingController();
  final ScrollController _controllerScroll = ScrollController();
  final int lastLocation = 0;
  @override
  void dispose() {
    _controllerScroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    final currentHeight = MediaQuery.of(context).size.height;

    return myScaffold(currentWidth, currentHeight);
  }

  Widget myScaffold(double currentWidth, double currentHeight) {
    return Scaffold(
      drawer: Navbar(),
      appBar: AppBar(
        //------------------------------------> AppBar
        backgroundColor: Colors.green,
        title: Text('Rent a House - MyHouses'),
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: Icon(Icons.person_2_rounded),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
        ), // Fim do Icone Home
      ), // Fim do AppBar
      body: Container(
        //----------------------------------------------> Container
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,

        decoration: BoxDecoration(
          //--------------------------> BoxDecoration
          image: DecorationImage(
            //-------------------------> DecorationImage
            fit: BoxFit.fill,
            //Usarei futuramente uma função para definir a imagem
            image: AssetImage(
              //-------------------------> AssetImage
              getPathImageHome(
                MediaQuery.of(context).size.height,
                MediaQuery.of(context).size.width,
              ),
            ), // Fim do AssetImage
          ), // Fim do DecorationImage
        ), // Fim do BoxDecoration
        //=============================================>
        child: myClientHousePage(),
      ),
    );
  }

  Widget myClientHousePage() {
    //Preparação para exportar página
    return MediaQuery.of(context).size.width < 600
        //If ternario nos filhos do container
        ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            myTopSideImage(
              carouselItems[lastLocation], //irrelevante no estágio atual
              addressClient[lastLocation],
              Colors.pink,
            ),
            mySingleChildScrollView(myList()),
          ],
        )
        : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            mySingleChildScrollView(
              myTopSideImage(
                carouselItems[lastLocation], //irrelevante no estágio atual
                addressClient[lastLocation],
                Colors.cyanAccent,
              ),
            ),
            mySingleChildScrollView(myList()),
          ],
        );
  }

  Widget myTopSideImage(String url, String id, Color cor) {
    return Column(
      children:
          MediaQuery.of(context).orientation == Orientation.landscape
              ? [
                //Landscape Layout
                myPaddingText("Casa na Praia", Colors.white), //
                myCarouselSlider(),
                //myImageContainer(url),
                //myContainer(myImage(url), cor), //
                myPaddingText(id, Colors.white), //
                myStatusHouse(),
              ] //
              : [
                //Portrait Layout
                myPaddingText("Casa na Praia", Colors.white), //
                myCarouselSlider(),
                //myImageContainer(url),
                //myContainer(myImage(url), cor), //
                myPaddingText(id, Colors.white), //
              ],
    );
  }

  Widget myCarouselSlider() {
    return CarouselSlider(
      items: generateListImages(carouselItems),

      //Slider Container properties
      options: CarouselOptions(
        height:
            MediaQuery.of(context).orientation == Orientation.portrait
                ? MediaQuery.of(context).size.height / 2.2
                : MediaQuery.of(context).size.height / 1.55,

        //enlargeCenterPage: true,
        enlargeCenterPage: false,
        autoPlay: false,
        reverse: true,
        aspectRatio: 16 / 9,
        autoPlayCurve: Curves.fastOutSlowIn,
        enableInfiniteScroll: true,
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        viewportFraction: 0.8,
      ),
    );
  }

  Widget mySingleChildScrollView(Widget myObjects) {
    return Expanded(
      child: Scrollbar(
        //isAlwaysShown: true,
        controller: _controllerScroll,
        child: SingleChildScrollView(
          controller: _controllerScroll,
          scrollDirection: Axis.vertical,
          child: Column(children: [myObjects]),
        ),
      ),
    );
  }

  Widget myList() {
    return MediaQuery.of(context).orientation == Orientation.landscape
        ? Column(
          children: [
            RoundedBackgroundText(
              'Locações Finalizadas',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.cyan,
                fontSize: 20.0,
              ), //
              backgroundColor: Colors.blue[50],
              innerRadius: 15.0,
              outerRadius: 10.0,
            ),
            //Lista de endereços
            myTravel(),
            myPaddingText("Imagem 1", Colors.lightGreenAccent),
            myContainer(
              myImage(
                "https://i0.wp.com/catagua.com.br/wp-content/uploads/2023/11/veja-dicas-de-decoracao-para-apartamentos-pequenos.jpg",
              ),
              Colors.red,
            ),
            myPaddingText("Imagem 2", Colors.cyanAccent),
            myContainer(
              myImage(
                "https://i0.wp.com/catagua.com.br/wp-content/uploads/2023/11/veja-dicas-de-decoracao-para-apartamentos-pequenos.jpg",
              ),
              Colors.blue,
            ),
            myPaddingText("Imagem 3", Colors.deepOrange),
            myContainer(
              myImage(
                "https://images.homify.com/v1448129217/p/photo/image/1135013/7.jpg",
              ),
              Colors.yellow,
            ),
          ],
        )
        : Column(
          children: [
            myStatusHouse(),
            RoundedBackgroundText(
              'Locações Finalizadas',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.cyan,
                fontSize: 20.0,
              ), //
              backgroundColor: Colors.blue[50],
              innerRadius: 15.0,
              outerRadius: 10.0,
            ),
            //Lista de endereços
            myTravel(),
            myPaddingText("Imagem 1", Colors.lightGreenAccent),
            myContainer(
              myImage(
                "https://i0.wp.com/catagua.com.br/wp-content/uploads/2023/11/veja-dicas-de-decoracao-para-apartamentos-pequenos.jpg",
              ),
              Colors.red,
            ),
            myPaddingText("Imagem 2", Colors.cyanAccent),
            myContainer(
              myImage(
                "https://i0.wp.com/catagua.com.br/wp-content/uploads/2023/11/veja-dicas-de-decoracao-para-apartamentos-pequenos.jpg",
              ),
              Colors.blue,
            ),
            myPaddingText("Imagem 3", Colors.deepOrange),
            myContainer(
              myImage(
                "https://images.homify.com/v1448129217/p/photo/image/1135013/7.jpg",
              ),
              Colors.yellow,
            ),
          ],
        );
  }

  Widget myTravel() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Container(
            height: addressClient.length * 20.0,
            width:
                MediaQuery.of(context).orientation == Orientation.portrait
                    ? MediaQuery.of(context).size.width
                    : MediaQuery.of(context).size.width / 2.05,

            decoration: BoxDecoration(
              color: Colors.pink.shade100,
              //--------------------------> BoxDecoration
              borderRadius: BorderRadius.circular(30),
            ), // Fim do BoxDecoration
            child: getListAddress(),
          ), //
        ),
      ],
    );
  }

  //Carousel de Imagens
  //
  //
  //
  List<Widget> generateListImages(List<String> images) {
    return List.generate(
      images.length,
      (index) => myImageContainer(images[index]),
    );
  }

  Widget myImageContainer(String url) {
    return Padding(
      padding: EdgeInsets.all(4.0),
      child: Container(
        margin: EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
          color: Colors.white,
        ),
        height:
            MediaQuery.of(context).orientation == Orientation.portrait
                ? MediaQuery.of(context).size.height / 2.2
                : MediaQuery.of(context).size.height / 1.55,
        width:
            MediaQuery.of(context).orientation == Orientation.portrait
                ? MediaQuery.of(context).size.width
                : MediaQuery.of(context).size.width / 2.05,

        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder:
                    (context) => Scaffold(
                      extendBody: true,

                      body: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),

                        child: SizedBox(
                          //----------------------------------------------> SizedBox
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          //
                          child:
                              MediaQuery.of(context).size.width < 600
                                  //If ternario nos filhos do container
                                  ? Column(
                                    children: [
                                      myContainer(
                                        Image.network(
                                          url,
                                          fit: BoxFit.cover,
                                          height:
                                              MediaQuery.of(
                                                        context,
                                                      ).orientation ==
                                                      Orientation.portrait
                                                  ? MediaQuery.of(
                                                        context,
                                                      ).size.height /
                                                      2.2
                                                  : MediaQuery.of(
                                                        context,
                                                      ).size.height /
                                                      1.55,
                                        ),
                                        Colors.purple,
                                      ),
                                      detailsHouseClip(lastLocation),
                                    ],
                                  )
                                  : Row(
                                    children: [
                                      myContainer(
                                        Image.network(
                                          url,
                                          fit: BoxFit.cover,
                                          height:
                                              MediaQuery.of(
                                                        context,
                                                      ).orientation ==
                                                      Orientation.portrait
                                                  ? MediaQuery.of(
                                                        context,
                                                      ).size.height /
                                                      2.2
                                                  : MediaQuery.of(
                                                        context,
                                                      ).size.height /
                                                      1.55,
                                        ),
                                        Colors.green,
                                      ),
                                      detailsHouseClip(lastLocation),
                                    ],
                                  ),
                        ),
                      ),
                    ),
              ),
            );
          },
        ),
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
        color: cor,
        child: children,
      ),
    );
  }

  Widget myStatusHouse() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        width:
            MediaQuery.of(context).orientation == Orientation.portrait
                ? MediaQuery.of(context).size.width
                : MediaQuery.of(context).size.width / 2.05,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(9.0),
        ),
        child: Align(
          alignment: Alignment.topLeft,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: RichText(
                  text: TextSpan(
                    text: 'Status da locação: ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                        text: ' Ativo ',
                        style: TextStyle(
                          color: Colors.white,
                          backgroundColor: Colors.teal,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: ' / ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: ' Encerrado ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ), //
              SizedBox(height: 12),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Data final do Aluguel - ${getDate()}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 20.0,
                  ), //
                ), //
              ), //
            ], //
          ),
        ), //
      ),
    );
  }

  Widget myPaddingText(String id, Color cor) {
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
              id,
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

  Widget getListAddress() {
    return ListView.builder(
      itemCount: addressClient.length - 1,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          leading: Icon(Icons.home),
          title: Text(
            addressClient[index + 1],
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 20.0,
            ), //
          ), //
          onTap: () {
            // Handle item tap (e.g., navigate to a details screen)
          },
        ); //
      }, //
    ); //
  }

  //========================================================================================================
  //Detalhes do imovel
  Widget detailsHouseClip(int index) {
    return mySingleChildScrollView(getDetailsHouse(index)); //
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
      padding: EdgeInsets.all(4.0),
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: <Widget>[
                Text(
                  'Casa com 3 Quartos e 2 banheiros para Alugar, 274 m² por 10.000 reais/Mês',
                  style: TextStyle(
                    fontSize: 20,
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
/*
MediaQuery.of(context).orientation ==
                                    Orientation.portrait
                                ? Column(
                                  children: [
                                    Image.network(
                                      url,
                                      fit: BoxFit.cover,
                                      height:
                                          MediaQuery.of(context).orientation ==
                                                  Orientation.portrait
                                              ? MediaQuery.of(
                                                    context,
                                                  ).size.height /
                                                  2.2
                                              : MediaQuery.of(
                                                    context,
                                                  ).size.height /
                                                  1.55,
                                    ),
                                    detailsHouseClip(lastLocation),
                                  ],
                                )
                                : Row(
                                  children: [
                                    Image.network(
                                      url,
                                      fit: BoxFit.cover,
                                      height:
                                          MediaQuery.of(context).orientation ==
                                                  Orientation.portrait
                                              ? MediaQuery.of(
                                                    context,
                                                  ).size.height /
                                                  2.2
                                              : MediaQuery.of(
                                                    context,
                                                  ).size.height /
                                                  1.55,
                                    ),
                                    detailsHouseClip(lastLocation),
                                  ],
                                ),
                                */