//Update 2_21_02_2025
  
import 'package:flutter/material.dart';
import 'package:rent_house/Pages/Home/home.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});
  @override
  _WelcomePage createState() => _WelcomePage();
}

class _WelcomePage extends State<WelcomePage> {
  //Instancia a Janela de boas-vindas

  bool passwordVisible = true;
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
        Container(
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

          child: Column(
            children: <Widget>[
              //=============================================> Nome do Usuário
              Padding(
                //-------------------------------------------> Padding
                padding: const EdgeInsets.only(top: 8.0),
                child: Padding(
                  //----------------------------------------------> Padding
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    //-------------------------------------> TextField
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
                  ), // Fim do TextField --------> Caixa de texto (Nome)
                ), // Fim do Padding ------------> Caixa de texto (Nome)
              ), // Fim do Padding --------------> Caixa de texto (Nome)
              //=============================================> Senha do Usuário
              Padding(
                //-------------------------------------------> Padding
                padding: const EdgeInsets.only(top: 8.0),
                child: Padding(
                  //----------------------------------------------> Padding
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    //-------------------------------------> TextField
                    obscureText: passwordVisible,
                    decoration: InputDecoration(
                      //------------------> InputDecoration
                      filled: true,
                      fillColor: const Color.fromARGB(255, 140, 233, 132),
                      labelText: 'Senha do Usuário',
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      floatingLabelStyle: TextStyle(
                        //--------------> Estilo do Texto
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 37, 37, 37),
                        fontSize: 20,
                      ), // Fim do Estilo do Texto
                      hintMaxLines: 1,
                      icon: Icon(Icons.key),
                      hintText: 'Informe a senha nome de usuário',
                      helperText: "A senha deve conter caracteres especiais",
                      border: OutlineInputBorder(
                        //--------------> OutlineInputBorder
                        borderRadius: BorderRadius.circular(30),
                      ), // Fim do OutlineInputBorder
                      helperStyle: TextStyle(color: Colors.green),
                      suffixIcon: IconButton(
                        icon: Icon(
                          passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            passwordVisible = !passwordVisible;
                          });
                        },
                      ), //Fim do IconButton(Olho)
                    ), // Fim do InputDecoration
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done,
                  ), // Fim do TextField --------> Caixa de texto (Senha)
                ), // Fim do Padding ------------> Caixa de texto (Senha)
              ), // Fim do Padding --------------> Caixa de texto (Senha)
              //=============================================> Botão da Tela
              Padding(
                //-------------------------------------------> Padding
                padding: const EdgeInsets.only(top: 8.0),
                child: Padding(
                  //----------------------------------------------> Padding
                  padding: const EdgeInsets.all(12.0),
                  child: ElevatedButton(
                    child: Text('Entrar na Aplicação'),
                    style: ElevatedButton.styleFrom(
                      side: BorderSide(color: Colors.yellow, width: 5),
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    onPressed:
                        () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                        ),
                  ),
                ),
              ),
            ], // Fim do children<Widget>[]
          ), // Fim da Column
        ), // Fim do Container
      ), // Fim do Scaffold
    ); // Fim do MaterialApp
  } // Fim do retorno
} // Fim do Metodo
