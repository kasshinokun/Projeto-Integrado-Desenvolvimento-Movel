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
  final TextEditingController _cepController =
      TextEditingController(); //recebe o cep
  final TextEditingController _addressController =
      TextEditingController(); //recebe o endereço inicial via api
  final TextEditingController _complementHouseController =
      TextEditingController(); //recebe o complemento
  final TextEditingController _numberHouseController =
      TextEditingController(); //recebe o numero
  /*
  final TextEditingController _numberRoomsController=
      TextEditingController(); //recebe o numero de quartos
  final TextEditingController _numberBathroomController=
      TextEditingController(); //recebe o numero de banheiros
  final TextEditingController _sizeHouseController =
      TextEditingController(); //recebe o tamanho da casa
  */

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
          "zipcode": _cepController.text,
          "address": _addressController.text,
          "complement": _complementHouseController.text,
          "number house": _numberHouseController.text,
          /*
          "rooms": _numberRoomsController.text,
          "bathrooms": _numberBathroomController.text,
          "size": sizeHouseController.text,
          */
          "description": _descriptionController.text,
          "type": _selectedtype,
        });

        //limpa as variaveis após o cadastro estar feito
        _nameController.clear();
        _priceController.clear();
        _cepController.clear();
        _addressController.clear();
        _complementHouseController.clear();
        _numberHouseController.clear();
        /*
        _numberRoomsController.clear();
        _numberBathroomController.clear();
        _sizeHouseController.clear();
        */
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
      body:
          MediaQuery.of(context).size.width < 600
              //If ternario nos filhos do container
              ? SingleChildScrollView(
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    //Carousel de imagens
                    myContainer(myInit()),

                    myListForm(), //Demais detalhes
                  ],
                ),
              )
              : Row(
                children: [
                  //Carousel de imagens
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: myContainer(myInit()),
                  ),

                  Padding(
                    padding: EdgeInsets.all(6.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2.2,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(9.0),
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(children: <Widget>[myListForm()]),
                      ),
                    ),
                  ),
                ],
              ), // Fim da Row
    ); // Fim do Scaffold
  } // Fim do retorno

  Widget myContainer(Widget children) {
    return Container(
      height:
          MediaQuery.of(context).orientation == Orientation.portrait
              //If ternario nos filhos do container
              ? MediaQuery.of(context).size.height / 2.7
              : MediaQuery.of(context).size.height / 2.1,
      width:
          MediaQuery.of(context).orientation == Orientation.portrait
              //If ternario nos filhos do container
              ? MediaQuery.of(context).size.width
              : MediaQuery.of(context).size.width / 1.95,
      decoration: BoxDecoration(
        color: Colors.pinkAccent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(padding: EdgeInsets.all(4.0), child: children),
    );
  }

  Widget myInit() {
    return Column(
      children: [
        myCarouselSlider(),
        //myImageTest( MediaQuery.of(context).size.height, MediaQuery.of(context).size.width),
        IconButton(
          icon: Icon(Icons.upload_file_rounded, color: Colors.cyan[700]),
          onPressed: () {
            // Ação para anexar arquivo (não implementada)
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Funcionalidade de anexar arquivo (não desenvolvida)",
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget myPaddingText(String information, Color cor) {
    return Padding(
      padding: EdgeInsets.all(4.0),
      child: Container(
        width:
            MediaQuery.of(context).orientation == Orientation.portrait
                ? MediaQuery.of(context).size.width
                : MediaQuery.of(context).size.width / 2.2,
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

  Widget myListForm() {
    return ListView(
      padding: EdgeInsets.all(8.0),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      children: [
        myPaddingText("Dados do imovel", Colors.greenAccent),
        //preencher o nome
        Text("Nome:"),
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            hintText: "digite o nome",
          ),
        ),

        //preencher o preço
        Divider(),
        Text("Preço:"),
        TextField(
          controller: _priceController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            hintText: "Digite o preço do aluguel",
          ),
        ),

        //preencher a descrição
        Divider(),
        Text("Descrição:"),
        TextField(
          controller: _descriptionController,
          maxLines: MediaQuery.of(context).size.width < 600 ? 5 : 10,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            hintText: "Descreva brevemente seu imovel",
          ),
        ),
        //preencher o cep
        Divider(),
        Text("CEP do imovel:"),
        Divider(),
        TextField(
          controller: _cepController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            hintText: "digite o cep",
          ),
        ),
        //exibe o endereço a partir do cep
        Divider(),
        Text("Endereço:"),
        TextField(
          controller: _addressController,
          maxLines: MediaQuery.of(context).size.width < 600 ? 2 : 4,
          readOnly: true,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            hintText: "Endereço do imovel",
          ),
        ),
        MediaQuery.of(context).size.width < 600
            ? Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 4.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //preencher o numero do imovel
                      Text("Numero do imovel:"),
                      TextField(
                        controller: _numberHouseController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: "nº do imovel",
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 1.75,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //preencher a descrição
                        Text("Complemento:"),
                        TextField(
                          controller: _complementHouseController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintText: "digite o complemento",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
            : Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 4.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //preencher o numero do imovel
                      Text("Numero do imovel:"),
                      TextField(
                        controller: _numberHouseController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: "nº do imovel",
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 1.75,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //preencher a descrição
                        Text("Complemento:"),
                        TextField(
                          controller: _complementHouseController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintText: "digite o complemento",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
        //selecionar o tipo
        Divider(),
        Text("Tipo do Imóvel:"),
        DropdownButton<String>(
          value: _selectedtype,
          items:
              ["casa", "apartamento", "kitnet", "sítio", "pousada", "outros"]
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
          child: Text(_showlist ? "Esconder imóveis" : "Mostrar imóveis"),
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
                      subtitle: Text("""Tipo de Imóvel: ${house['type']} 
                                    \nPreço: R\$ ${house['price']}
                                    \nCEP: ${house['zipcode']} 
                                    \nEndereço: ${house['address']} 
                                    \nComplento ${house['complement']} 
                                    \nNumero: ${house['number house']}        
                                    \nDescrição: ${house['description']}"""),
                    ),
                  );
                }).toList(),
          ),
      ],
    );
  }

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

  Widget myCarouselSlider() {
    return CarouselSlider(
      items: generateListImages(imagesList),

      //Slider Container properties
      options: CarouselOptions(
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
