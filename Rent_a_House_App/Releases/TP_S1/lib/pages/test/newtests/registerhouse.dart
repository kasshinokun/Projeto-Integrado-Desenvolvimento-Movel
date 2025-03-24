import 'package:flutter/material.dart';
import 'package:rent_a_house/pages/home/navbar.dart';
import 'package:rent_a_house/pages/welcome/welcome.dart';
import 'package:carousel_slider/carousel_slider.dart';

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

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreen();
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

class _RegisterScreen extends State<RegisterScreen> {
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
                myCarouselSlider(MediaQuery.of(context).size.height * 0.5),
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
} // Fim do Metodo
