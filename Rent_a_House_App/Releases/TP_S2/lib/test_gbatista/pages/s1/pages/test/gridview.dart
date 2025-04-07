import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:rent_a_house/pages/s1/pages/home/navbar.dart';
import 'package:rent_a_house/pages/s1/pages/test/carousel.dart';

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
  'Rua Alegre, 12345, bairro Brasil - Belo Horizonte',
  'Rua Javae, 3456, bairro Nogueirinha - Itaúna',
  'Rua César Dacorso Filho, 678, bairro Barreiro - Belo Horizonte',
  "Rua Rua Três, 3456, bairro Olhos D'Água - Belo Horizonte",
  'Rua Rosa de Pedra, 678, bairro Etelvina Carneiro - Belo Horizonte',
  'Avenida Perimetral, 12345, bairro Jardim Arizona - Sete Lagoas',
  'Rua Virgínia de Oliveira Maciel, 3456, bairro Morro do Claro - Sete Lagoas',
  'Rua Manoel Correa da Cunha, 678, bairro Recanto do Cedro - Sete Lagoas',
  'Rua Rei Salomão, 3456, bairro Esperança - Sete Lagoas',
  'Rua Q, 678, bairro Eldorado - Sete Lagoas',
  'Rua Geraldo Francisco de Azevedo, 340, bairro Centro - Ouro Branco',
  'Rua Alvarenga, 494, bairro Cabeças - Ouro Preto',
  'Rua Marieta de Barros Valadão, 678, bairro Nossa Senhora de Fátima - Patos de Minas',
  'Rua dos Otis, 3456, bairro Suzana - Belo Horizonte',
  'Avenida Manoel Pinheiro Diniz, 265, bairro Pinheiros - Itatiaiuçu',
];

void main() {
  runApp(MyGrid());
}

class MyGrid extends StatefulWidget {
  const MyGrid({super.key});

  @override
  State<MyGrid> createState() => _MyGridState();
}

class _MyGridState extends State<MyGrid> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: myScaffold()); //MaterialApp
  }

  Widget myScaffold() {
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
            Padding(
              //-----------------------------------> padding
              padding: EdgeInsets.all(16.0),
              child: mySearchBar(),
            ),
            Text("Ultimas Visualizações"),
            setMyCarousel(imagesList, context, 0.4), //Carousel de Imagens

            Text("Destaques"),
            Padding(
              //-----------------------------------> padding
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width / 4,
                top: 8.0,
              ),
              child: carouselGrid(),
            ), //
          ], //
        ), //
      ),
    ); //
  }

  //Teste
  Widget carouselGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CarouselSlider(
          items: [
            Container(
              height: MediaQuery.of(context).size.height,
              margin: EdgeInsets.all(2),
              child: SingleChildScrollView(
                //child: myGridView(), //Test
                child: myStaggeredGrid(), //Modelo Inicial
              ),
            ),
          ],
          options: CarouselOptions(aspectRatio: 1, viewportFraction: 1),
        ),
      ],
    );
  }

  Widget mySearchBar() {
    TextEditingController textEditingController = TextEditingController();
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
    return Column(
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
                          child: Column(
                            children: [
                              Image.network(
                                imagesList[index],
                                fit: BoxFit.cover,
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
                              ),
                              detailsHouseClip(index, 0.75),
                            ],
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
    );
  }

  Widget imageClip(int index) {
    return Image.network(imagesList[index], fit: BoxFit.fill);
  }

  Widget addressClip(int index, double aspectValue) {
    return Container(
      height: 500 * aspectValue,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Text(
        addressClient[index],
        style: TextStyle(
          fontSize: 20,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ), //
      ), //
    ); //
  }

  Widget detailsHouseClip(int index, double aspectValue) {
    return Container(
      height: 500 * aspectValue,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: getDetailsHouse(index), //
    ); //
  }

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

/*
  Widget getDetailsHouse(int index) {
    return //
    SingleChildScrollView(
      child: Padding(
        //-----------------------------------> padding
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
            ExpansionTile(
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
                    Text(
                      "Casa comercial para locação no Palmares!\n\nBenefícios:\n\n- Localização privilegiada, fácil acesso àAv. Cristiano Machado.\n- Próximo á Estação Minas Shopping, Minas Shopping, Mixpão Palmares.",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                      ),
                    ),

                    Text(
                      "Casa:\n1º piso\n\n- Sala ampla para dois ambientes\n- Sala de jantar\n- Lavabo;\n- Banho social com armários e box de vidro temperado\n- Cozinha ampla com bancada em granito e armários\n",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Text(
                      "- Despensa\n- Dependência Completa de Empregada\n- Área de Serviço\n- Área externa com churrasqueira.\n\n2º piso\n- Sala de estar íntimo;\n- 03 Quartos com armários, sendo um suíte com varanda.\n",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Text(
                      "\n\nGaragem:\n- 15 vagas de garagem.\n\n\nOs valores de venda e dos encargos (IPTU/condomínio etc.) exibidos poderão sofrer mudanças e aumentos sem prévio aviso.\n",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Text(
                      "Por esse motivo os valores deverão ser confirmados no nosso setor comercial e os encargos no prédio/condomínio e IPTU na Prefeitura.",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ], //
                ), //
              ], //
            ), //
          ],
        ), //
      ), //
    ); //
  }
}

*/
