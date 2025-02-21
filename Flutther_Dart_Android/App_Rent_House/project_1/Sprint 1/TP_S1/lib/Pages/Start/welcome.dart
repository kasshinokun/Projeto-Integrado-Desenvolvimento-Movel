//Update 1_21_02_2025

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

String _setImage_path = ""; //Armazenará o caminho da imagem de fundo

//Função para definir a imagem de fundo
String _getImage_path(double _height, double _width) {
  if (_height < _width) {
    _setImage_path = "assets/welcome/fullHD_portrait.jpg";
  } else {
    _setImage_path = "assets/welcome/fullHD_landscape.jpg";
  }
  return _setImage_path;
}

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});
  @override
  _WelcomePage createState() => _WelcomePage();
}

class _WelcomePage extends State<WelcomePage> {
  //Instancia a Janela de boas-vindas
  @override
  Widget build(BuildContext context) {
    //AppBar (no topo da tela)
    return MaterialApp(
      //-------------------------------------------> MaterialApp
      home: Scaffold(
        //------------------------------------------------> Scaffold
        appBar: AppBar(
          //------------------------------------------------> AppBar
          title: Text("Rent a House"), //Texto da Barra do App
          backgroundColor: Color(0xffB0E0E6), //Cor da Barra do App
        ), // Fim do AppBar
        body:
        //Preventivo para ajustar widgets a telas de smartphones ou menores
        SingleChildScrollView(
          //------------------------> SingleChildScrollView

          //Encapsulamento de itens da tela
          child: Container(
            //----------------------------------------------> Container
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,

            decoration: BoxDecoration(
              //--------------------------> BoxDecoration
              image: DecorationImage(
                //-------------------------> DecorationImage
                fit: BoxFit.fill,
                //Usarei futuramente uma função para definir a imagem
                image: AssetImage("assets/welcome/fullHD_landscape.jpg"),
              ), // Fim do DecorationImage
            ), // Fim do BoxDecoration
            //===================================================================
            child: Padding(
              //-------------------------------------------> Padding
              padding: const EdgeInsets.only(top: 8.0),
              child: Padding(
                //----------------------------------------------> Padding
                padding: const EdgeInsets.all(12.0),
                child: 
                  TextField(
                  //-------------------------------------> TextField
                  inputFormatters: [LengthLimitingTextInputFormatter(10)],
                  decoration: InputDecoration(
                    //------------------> InputDecoration
                    filled: true,
                    fillColor: const Color.fromARGB(255, 140, 233, 132),
                    labelText: 'Nome do Usuário',
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    floatingLabelStyle: TextStyle(
                      //--------------> Estilo do Texto
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 37, 37, 37),
                      fontSize: 20,
                    ), // Fim do Estilo do Texto
                    hintMaxLines: 1,
                    icon: Icon(Icons.person),
                    hintText: 'Informe o seu nome de usuário',
                    border: OutlineInputBorder(
                      //--------------> OutlineInputBorder
                      borderRadius: BorderRadius.circular(30),
                    ), // Fim do OutlineInputBorder
                  ), // Fim do InputDecoration
                ), // Fim do TextField
                


              ), // Fim do Padding
            ), // Fim do Padding
          ), // Fim do Container
        ), // Fim do SingleChildScrollView
      ), // Fim do Scaffold
    ); // Fim do MaterialApp
  }
}
