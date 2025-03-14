import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rent_a_house/pages/test/carousel.dart';
import 'package:rounded_background_text/rounded_background_text.dart';
import 'package:rent_a_house/pages/welcome/welcome.dart';
import 'package:rent_a_house/pages/home/navbar.dart';

List<String> addressClient = [
  'Rua Alegre, 12345, bairro Brasil - Belo Horizonte',
  'Rua Alfa, 3456, bairro França - Ouro Preto',
  'Rua Puc Minas, 678, bairro Argentina - Sete Lagoas',
  'Rua Alfa, 3456, bairro França - Ouro Branco',
  'Rua Puc Minas, 678, bairro Argentina - Lagoa Santa',
];

List<String> carouselItems = [
  'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',

  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',

  'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',

  'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',

  'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
];

Widget getListAddress() {
  return ListView.builder(
    itemCount: addressClient.length - 1,
    itemBuilder: (BuildContext context, int index) {
      return ListTile(
        leading: Icon(Icons.home),
        title: Text(
          getAddressMyHouse(addressClient[index + 1]),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 20.0 * MediaQuery.of(context).devicePixelRatio,
          ), //
        ), //
        onTap: () {
          // Handle item tap (e.g., navigate to a details screen)
        },
      ); //
    }, //
  ); //
}

String getDate() {
  final dateFormatter = DateFormat('dd-MM-yyyy');
  final DateTime now = DateTime.now();
  final formattedDate = dateFormatter.format(now);
  return formattedDate;
}

String getAddressMyHouse(String address) {
  return address;
}

class ClientScreen extends StatefulWidget {
  const ClientScreen({super.key});

  @override
  State<ClientScreen> createState() => _ClientScreen();
}

class _ClientScreen extends State<ClientScreen> {
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //int currentIndex = 0;
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
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ), //
                      child: Center(
                        child: Text(
                          getAddressMyHouse(addressClient[0]),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 20.0,
                          ), //
                        ), //
                      ), //
                    ), //
                  ), //
                  //Carousel Slider
                  setMyCarousel(
                    carouselItems,
                    context,
                    0.4,
                  ), //Carousel de Imagens
                ], //
              ), //
            ), //
            Expanded(
              flex: 2,

              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ), //
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            'Status da locação Ativo / Encerrado',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 20.0,
                            ), //
                          ), //
                        ), //
                        SizedBox(height: 12),
                        Padding(
                          padding: EdgeInsets.all(16.0),
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
                    ), //
                  ), //
                ), //
              ), //
            ), //
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 32.0),
                child: RoundedBackgroundText(
                  'Locações Finalizadas',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.cyan,
                    fontSize: 20.0,
                  ), //
                  backgroundColor: Colors.blue[50],
                  innerRadius: 15.0,
                  outerRadius: 10.0,
                ), //
              ), //
            ), //
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2,
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: const Color.fromARGB(255, 230, 158, 158),
                    ), //
                    child: getListAddress(), //ListView
                  ), //
                ), //
              ), //
            ), //
          ], //
        ), //
        //=============================================> Fim do Itens na Tela
        //Adicione mais Widgets aqui neste espaço
        //=============================================>
      ), // Fim do Container
    ); // Fim do Scaffold
  } // Fim do retorno
} // Fim do Metodo
