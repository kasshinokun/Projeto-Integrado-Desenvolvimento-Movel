import 'package:cached_network_image/cached_network_image.dart';
import 'package:rent_a_house/pages/s1/pages/home/navbar.dart';
import 'package:rent_a_house/pages/s1/pages/welcome/welcome.dart';
import 'package:flutter/material.dart';
//import 'package:dots_indicator/dots_indicator.dart';

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

List<Widget> getListImage(List<String> images) {
  //Lista de imagens como Objeto
  return List.generate(
    // List.generate
    images.length,
    (index) => Hero(
      tag: images[index],
      child: CachedNetworkImage(
        imageUrl: images[index],
        fit: BoxFit.cover,

        fadeInDuration: Duration.zero,
      ), // CachedNetworkImage
    ), // Hero
  ); // List.generate
}

//Carousel como função
Widget setMyCarousel(List<String> images, context, double aspectRatio) {
  final imageFull = getListImage(images);
  return Column(
    children: <Widget>[
      ConstrainedBox(
        // ConstrainedBox
        constraints: BoxConstraints(
          // BoxConstraints
          maxWidth: MediaQuery.sizeOf(context).width * aspectRatio - 20,
          maxHeight: MediaQuery.sizeOf(context).height * aspectRatio,
        ), // Fim do BoxConstraints

        child: CarouselView.weighted(
          // CarouselView
          onTap: (index) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder:
                    (context) => Scaffold(
                      extendBody: true,

                      body: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),

                        child: imageFull[index],
                      ),
                    ),
              ),
            );
          },
          flexWeights: [9, 2],
          //itemExtent: 330,
          shrinkExtent: 200,
          itemSnapping: true,
          padding: const EdgeInsets.all(10.0),
          children: imageFull,
        ), // Fim do CarouselView
      ), // Fim do ConstrainedBox
    ], // Fim do <Widget>[]
  ); // Fim do Column
}

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
        child: setMyCarousel(imagesList, context, 0.9), //Carousel como Função
      ), // Fim do Container
      //=============================================> Fim do Itens na Tela
      //Adicione mais Widgets aqui neste espaço
      //=============================================>
    ); // Fim do Scaffold
  } // Fim do Metodo
}//Fim da classe

