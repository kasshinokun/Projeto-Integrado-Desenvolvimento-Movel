import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:rent_a_house/pages/s1/pages/home/navbar.dart';

//Lista de URLs de imagens como Objeto
List<String> imagesList = [
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
  'https://images.unsplash.com/photo-1586953983027-d7508a64f4bb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1650&q=80',
];

List<String> addressClient = [
  'Rua Alegre, 12345, bairro Brasil - Belo Horizonte',
  'Rua Alfa, 3456, bairro França - Ouro Preto',
  'Rua Puc Minas, 678, bairro Argentina - Sete Lagoas',
  'Rua Alfa, 3456, bairro França - Ouro Branco',
  'Rua Puc Minas, 678, bairro Argentina - Lagoa Santa',
  'Rua Alegre, 12345, bairro Brasil - Belo Horizonte',
  'Rua Alfa, 3456, bairro França - Ouro Preto',
  'Rua Puc Minas, 678, bairro Argentina - Sete Lagoas',
  'Rua Alfa, 3456, bairro França - Ouro Branco',
  'Rua Puc Minas, 678, bairro Argentina - Lagoa Santa',
  'Rua Alegre, 12345, bairro Brasil - Belo Horizonte',
  'Rua Alfa, 3456, bairro França - Ouro Preto',
  'Rua Puc Minas, 678, bairro Argentina - Sete Lagoas',
  'Rua Alfa, 3456, bairro França - Ouro Branco',
  'Rua Puc Minas, 678, bairro Argentina - Lagoa Santa',
];

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
          children: [getTitleHouse(4), getExpandedDetailsHouse()],
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
    