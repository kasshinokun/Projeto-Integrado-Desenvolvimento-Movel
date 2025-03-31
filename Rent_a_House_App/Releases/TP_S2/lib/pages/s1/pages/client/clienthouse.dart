import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rounded_background_text/rounded_background_text.dart';
import 'package:rent_a_house/pages/s1/pages/home/navbar.dart';
import 'package:rent_a_house/pages/s1/pages/welcome/welcome.dart';
import 'package:carousel_slider/carousel_slider.dart';

List<String> addressClient = [
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

List<String> carouselItems = [
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

String getDate() {
  final dateFormatter = DateFormat('dd-MM-yyyy');
  final DateTime now = DateTime.now();
  final formattedDate = dateFormatter.format(now);
  return formattedDate;
}

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
        child:
            currentWidth < 600
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
                ),
      ),
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