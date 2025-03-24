<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:rent_a_house/pages/home/navbar.dart';
import 'package:rent_a_house/pages/welcome/welcome.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreen();
}

class _RegisterScreen extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();//recebe o nome
  final TextEditingController _priceController = TextEditingController();//recebe o valor
  final TextEditingController _descriptionController = TextEditingController();//recebe a descrição
  String _selectedtype = "casa";//tipo padrão
  bool _showlist=false;//controle da exibição dos imoveis adicionados

  //local de armazenamento temporario antes do banco de dados
  List<Map<String, dynamic>> houseslist= [];

  //função para fazer o cadastro
  void _houseregister(){
    if(_nameController.text.isNotEmpty && _priceController.text.isNotEmpty){
      setState((){
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
        _selectedtype= "casa";
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
      body: Column(
        children: [
          //------------------------------------> Container igual o anterior
          Container(
            width: double.infinity,
            height: 200,// Altura da imagem
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  getPathImageHome(
                    MediaQuery.of(context).size.height,
                    MediaQuery.of(context).size.width,
                  ),
                ),
                fit: BoxFit.cover, //ajusta a imagem no container
              ),
            ),
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
                      border: OutlineInputBorder(),
                      hintText: "digite o nome",
                    ),
                  ),

                  //preencher o preço
                  SizedBox(height: 12),
                  Text("Price:"),
                  TextField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "digite o preço do aluguel"
                    ),
                  ),

                  //preencher a descrição
                  SizedBox(height: 12),
                  Text("description:"),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 5,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "descreva brevemente seu imovel"
                    ),
                  ),


                  //selecionar o tipo
                  SizedBox(height: 12),
                  Text("Tipo do Imóvel:"),
                  DropdownButton<String>(
                    value: _selectedtype,
                    items: ["casa","Apartamento","Kitnet","Sítio","Pousada","Outros"]
                        .map((String tipo) => DropdownMenuItem<String>(
                      value: tipo,
                      child: Text(tipo),
                    ))
                      .toList(),
                    onChanged: (String? novoTipo){
                      setState((){ //atualiza a tela quando a pessoa escolhe o tipo
                        _selectedtype=novoTipo!;//atualiza a variavel quando o valor é diferente de null
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
                      onPressed: (){
                        setState(() {
                          _showlist = !_showlist;
                        });
                      },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.black,
                    ),
                      child: Text(_showlist ? "Esconder imóveis": "Mostrar imóveis"),
                  ),

                  //Mostrar os imóveis cadastrados
                  SizedBox(height: 20),
                  if(_showlist)
                    Column(
                      children: houseslist.map((house){
                        return Card(
                        child:ListTile(
                        title: Text((house["name"]??"Sem nome")),
                          subtitle: Text(
                              "Type: ${house['type']} | Price: R\$ ${house['price']}\nDescription: ${house['description']}"),
                        ),
                        );
                      }).toList(),
                    )
                ],
              ),
            ),
          )
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
      ), // Fim do Container
    ); // Fim do Scaffold
  } // Fim do retorno
} // Fim do Metodo
=======
import 'package:flutter/material.dart';
import 'package:rent_a_house/pages/home/navbar.dart';
import 'package:rent_a_house/pages/welcome/welcome.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreen();
}

class _RegisterScreen extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();//recebe o nome
  final TextEditingController _priceController = TextEditingController();//recebe o valor
  final TextEditingController _descriptionController = TextEditingController();//recebe a descrição
  String _selectedtype = "casa";//tipo padrão
  bool _showlist=false;//controle da exibição dos imoveis adicionados

  //local de armazenamento temporario antes do banco de dados
  List<Map<String, dynamic>> houseslist= [];

  //função para fazer o cadastro
  void _houseregister(){
    if(_nameController.text.isNotEmpty && _priceController.text.isNotEmpty){
      setState((){
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
        _selectedtype= "casa";
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
      body: Column(
        children: [
          //------------------------------------> Container igual o anterior
          Container(
            width: double.infinity,
            height: 200,// Altura da imagem
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  getPathImageHome(
                    MediaQuery.of(context).size.height,
                    MediaQuery.of(context).size.width,
                  ),
                ),
                fit: BoxFit.cover, //ajusta a imagem no container
              ),
            ),
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
                      border: OutlineInputBorder(),
                      hintText: "digite o nome",
                    ),
                  ),

                  //preencher o preço
                  SizedBox(height: 12),
                  Text("Price:"),
                  TextField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "digite o preço do aluguel"
                    ),
                  ),

                  //preencher a descrição
                  SizedBox(height: 12),
                  Text("description:"),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 5,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "descreva brevemente seu imovel"
                    ),
                  ),


                  //selecionar o tipo
                  SizedBox(height: 12),
                  Text("Tipo do Imóvel:"),
                  DropdownButton<String>(
                    value: _selectedtype,
                    items: ["casa","Apartamento","Kitnet","Sítio","Pousada","Outros"]
                        .map((String tipo) => DropdownMenuItem<String>(
                      value: tipo,
                      child: Text(tipo),
                    ))
                      .toList(),
                    onChanged: (String? novoTipo){
                      setState((){ //atualiza a tela quando a pessoa escolhe o tipo
                        _selectedtype=novoTipo!;//atualiza a variavel quando o valor é diferente de null
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
                      onPressed: (){
                        setState(() {
                          _showlist = !_showlist;
                        });
                      },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.black,
                    ),
                      child: Text(_showlist ? "Esconder imóveis": "Mostrar imóveis"),
                  ),

                  //Mostrar os imóveis cadastrados
                  SizedBox(height: 20),
                  if(_showlist)
                    Column(
                      children: houseslist.map((house){
                        return Card(
                        child:ListTile(
                        title: Text((house["name"]??"Sem nome")),
                          subtitle: Text(
                              "Type: ${house['type']} | Price: R\$ ${house['price']}\nDescription: ${house['description']}"),
                        ),
                        );
                      }).toList(),
                    )
                ],
              ),
            ),
          )
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
      ), // Fim do Container
    ); // Fim do Scaffold
  } // Fim do retorno
} // Fim do Metodo
>>>>>>> 42ef54f772b549574d2519cb976583f7ae711d7b
