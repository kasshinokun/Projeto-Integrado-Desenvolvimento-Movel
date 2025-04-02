import 'package:flutter/material.dart';
import 'package:rent_a_house/pages/s1/pages/home/navbar.dart';
import 'package:rent_a_house/pages/s1/pages/welcome/welcome.dart';
import 'package:carousel_slider/carousel_slider.dart';

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
//
//
//Inicio do Inicializador
void main() {
  runApp(RegisterHouseScreenApp());
}

class RegisterHouseScreenApp extends StatelessWidget {
  const RegisterHouseScreenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/', //Rotas
      routes: {
        '/': (context) => RegisterHouseScreen(), //Página Inicial
      },
    );
  }
}

//Fim do Inicializador
//
//
class RegisterHouseScreen extends StatefulWidget {
  const RegisterHouseScreen({super.key});

  @override
  State<RegisterHouseScreen> createState() => _RegisterHouseScreen();
}

Widget myImageTest(double childHeight, double childWidth) {
  return Padding(
    padding: EdgeInsets.all(16.0),
    child: Container(
      height: childHeight * 0.4,
      width: childWidth * 0.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          image: AssetImage(getPathImageHome(childHeight, childWidth)),
          fit: BoxFit.cover, //ajusta a imagem no container
        ),
      ),
    ),
  );
}

class _RegisterHouseScreen extends State<RegisterHouseScreen> {
  final TextEditingController _nameController =
      TextEditingController(); //recebe o nome
  final TextEditingController _priceController =
      TextEditingController(); //recebe o valor
  final TextEditingController _descriptionController =
      TextEditingController(); //recebe a descrição
  String _selectedtype = "casa"; //tipo padrão
  bool _showlist = false; //controle da exibição dos imoveis adicionados

  //local de armazenamento temporario antes do banco de dados
  List<Map<String, dynamic>> houseslist = [];

  //função para fazer o cadastro
  void _houseregister() {
    if (_nameController.text.isNotEmpty && _priceController.text.isNotEmpty) {
      setState(() {
        houseslist.add({
          "name": _nameController.text,
          "price": _priceController.text,
          "description": _descriptionController.text,
          "type": _selectedtype,
        });

        //limpa as variaveis após o cadastro estar feito
        _nameController.clear();
        _priceController.clear();
        _descriptionController.clear();
        _selectedtype = "casa";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Navbar(),
      appBar: AppBar(
        //------------------------------------> AppBar
        backgroundColor: Colors.green,
        title: Text('Rent a House - Cadastrar para Alugar'),
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: Icon(Icons.person_2_rounded),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
        ), // Fim do Icone Home
      ), // Fim do AppBar
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          children: [
            //------------------------------------> Container igual o anterior
            Column(
              children: [
                myCarouselSlider(MediaQuery.of(context).size.height * 0.45),
                //myImageTest( MediaQuery.of(context).size.height, MediaQuery.of(context).size.width),
              ],
            ),
            //Local para preencher as informações do registro
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //preencher o nome
                    Text("Nome:"),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        hintText: "digite o nome",
                      ),
                    ),

                    //preencher o preço
                    SizedBox(height: 12),
                    Text("Preço:"),
                    TextField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        hintText: "Digite o preço do aluguel",
                      ),
                    ),

                    //preencher a descrição
                    SizedBox(height: 12),
                    Text("Descrição:"),
                    TextField(
                      controller: _descriptionController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: "Descreva brevemente seu imovel",
                      ),
                    ),

                    //selecionar o tipo
                    SizedBox(height: 12),
                    Text("Tipo do Imóvel:"),
                    DropdownButton<String>(
                      value: _selectedtype,
                      items:
                          [
                                "casa",
                                "apartamento",
                                "kitnet",
                                "sítio",
                                "pousada",
                                "outros",
                              ]
                              .map(
                                (String tipo) => DropdownMenuItem<String>(
                                  value: tipo,
                                  child: Text(tipo),
                                ),
                              )
                              .toList(),
                      onChanged: (String? novoTipo) {
                        setState(() {
                          //atualiza a tela quando a pessoa escolhe o tipo
                          _selectedtype =
                              novoTipo!; //atualiza a variavel quando o valor é diferente de null
                        });
                      },
                    ),

                    //botão para concluir o cadastro
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _houseregister,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.black,
                      ),
                      child: Text("Cadastrar Imovel"),
                    ),

                    //botão para mostrar/esconder os imoveis
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _showlist = !_showlist;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.black,
                      ),
                      child: Text(
                        _showlist ? "Esconder imóveis" : "Mostrar imóveis",
                      ),
                    ),

                    //Mostrar os imóveis cadastrados
                    SizedBox(height: 20),
                    if (_showlist)
                      Column(
                        children:
                            houseslist.map((house) {
                              return Card(
                                child: ListTile(
                                  title: Text((house["name"] ?? "Sem nome")),
                                  subtitle: Text(
                                    "Tipo de Imóvel: ${house['type']} \nPreço: R\$ ${house['price']}\nDescrição: ${house['description']}",
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                  ],
                ),
              ),
            ),
          ],
          /*//----------------------------------------------> Container
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
          //=============================================> Fim do Itens na Tela
          //Adicione mais Widgets aqui neste espaço
          //=============================================>
          */
        ), //
      ), // Fim do Container
    ); // Fim do Scaffold
  } // Fim do retorno

  List<Widget> generateListImages(List<String> images) {
    return List.generate(
      images.length,
      (index) => myImageContainer(images[index]),
    );
  }

  Widget myImageContainer(String url) {
    return Container(
      margin: EdgeInsets.all(6.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  (context) => Scaffold(
                    extendBody: true,

                    body: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),

                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(url),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
            ),
          );
        },
      ),
    );
  }

  Widget myCarouselSlider(double childHeight) {
    return CarouselSlider(
      items: generateListImages(imagesList),

      //Slider Container properties
      options: CarouselOptions(
        height: childHeight,

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
} // Fim do Metodo
