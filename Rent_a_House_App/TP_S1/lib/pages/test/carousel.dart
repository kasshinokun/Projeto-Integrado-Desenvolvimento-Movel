import 'package:cached_network_image/cached_network_image.dart';
import 'package:rent_a_house/pages/home/navbar.dart';
import 'package:rent_a_house/pages/welcome/welcome.dart';
import 'package:flutter/material.dart';

//Lista de URLs de imagens como Objeto
List<String> images = [
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

//Lista de imagens como Objeto teste A
List imagesGenerate(context) {
  return List.generate(
    // List.generate
    images.length,
    (index) => Hero(
      tag: images[index],
      child: Stack(
        alignment: AlignmentDirectional.bottomStart,
        children: <Widget>[
          ClipRect(
            child: OverflowBox(
              maxWidth: MediaQuery.sizeOf(context).height * 7 / 8,
              minWidth: MediaQuery.sizeOf(context).height * 7 / 8,
              child: CachedNetworkImage(
                imageUrl: images[index],
                fit: BoxFit.cover,
                fadeInDuration: Duration.zero,
              ), // CachedNetworkImage
            ), //
          ), //
        ], //
      ), //
    ), // Hero
  ); // List.generate
}

//Lista de imagens como Objeto B (em uso)
final imagesFull = List.generate(
  // List.generate
  images.length,
  (index) => Hero(
    tag: images[index],
    child: CachedNetworkImage(
      imageUrl: images[index],
      //fit: BoxFit.fill
      height: 150,
      width: 150,
      fit: BoxFit.cover,
      fadeInDuration: Duration.zero,
    ), // CachedNetworkImage
  ), // Hero
); // List.generate

//Carousel como função
Widget setMyCarousel(context) {
  return ConstrainedBox(
    // ConstrainedBox
    constraints: BoxConstraints(
      // BoxConstraints
      maxWidth: MediaQuery.sizeOf(context).width - 20,
      maxHeight: MediaQuery.sizeOf(context).height,
    ), // Fim do BoxConstraints
    //
    child: CarouselView.weighted(
      // CarouselView
      onTap:
          (index) => Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  (context) => Scaffold(
                    extendBody: true,
                    body: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: imagesFull[index],
                    ),
                  ),
            ),
          ),
      flexWeights: [9, 2],
      //itemExtent: 330,
      shrinkExtent: 200,
      itemSnapping: true,
      padding: const EdgeInsets.all(10.0),
      children: imagesFull,
    ), // Fim do CarouselView
  ); // Fim do ConstrainedBox
}

//Controller para Carousel
final controller = CarouselController(initialItem: 1);

//Classe - Construtor
class CarouselScreen extends StatefulWidget {
  const CarouselScreen({super.key});

  @override
  State<CarouselScreen> createState() => _CarouselScreenState();
}

// State da Classe
class _CarouselScreenState extends State<CarouselScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Navbar(), //Navigation Bar
      appBar: AppBar(
        //------------------------------------> AppBar
        backgroundColor: Colors.green,
        title: Text('Carousel'),
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: Icon(Icons.person_2_rounded),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ), // IconButton
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
                //Função para alterar imagem-background
                MediaQuery.of(context).size.height,
                MediaQuery.of(context).size.width,
              ),
            ), // Fim do AssetImage
          ), // Fim do DecorationImage
        ), // Fim do BoxDecoration
        child: setMyCarousel(context), //Carousel como Função
      ), // Fim do Container
      //=============================================> Fim do Itens na Tela
      //Adicione mais Widgets aqui neste espaço
      //=============================================>
    ); // Fim do Scaffold
  } // Fim do Metodo
}//Fim da classe

/* Teste futuro A:
Container(
          margin:EdgeInsets.all(8.0),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
            child: InkWell(
              onTap: () => print("ciao"),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      topRight: Radius.circular(8.0),
                    ),
                    child: Image.network(
                        'https://placeimg.com/640/480/any',
                        // width: 300,
                        height: 150,
                        fit:BoxFit.fill

                    ),
                  ),
                  ListTile(
                    title: Text('Pub 1'),
                    subtitle: Text('Location 1'),
                  ),
                ],
              ),
            ),
          ),
        ),
*/
/* Imagem usuário:
CircleAvatar(
  backgroundImage: NetworkImage("https://picsum.photos/id/237/200/300"),
  radius: 100,
)
*/


