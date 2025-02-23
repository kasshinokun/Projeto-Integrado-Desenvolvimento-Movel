import 'package:flutter/material.dart';
import 'package:rent_house/Pages/Start/welcome.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreen();
}

class _RegisterScreen extends State<RegisterScreen> {
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
          title: Text("Registro de Usuário"), //Texto da Barra do App
          backgroundColor: Color(0xffB0E0E6), //Cor da Barra do App
          actions: [
            //-----------------------------------> Actions
            Padding(
              //-----------------------------------> padding
              padding: EdgeInsets.only(right: 16.0),
              child: IconButton(
                // ------> Icone Home
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/');
                  Navigator.popAndPushNamed(context, '/');
                },
                icon: Icon(Icons.arrow_back),
              ), // Fim do Icone Home
            ), // Fim do Padding
          ], // Fim do Actions
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
              //Usando uma função para definir a imagem
              image: AssetImage(
                //-------------------------> AssetImage
                getPathImageHome(
                  MediaQuery.of(context).size.height,
                  MediaQuery.of(context).size.width,
                ),
              ), // Fim do AssetImage
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
                      labelText: 'Nome Completo',
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      floatingLabelStyle: TextStyle(
                        //--------------> Estilo do Texto
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 37, 37, 37),
                        fontSize: 20,
                      ), // Fim do Estilo do Texto
                      hintMaxLines: 1,
                      icon: Icon(Icons.person_2_rounded),
                      hintText: 'Informe o seu Nome Completo',
                      border: OutlineInputBorder(
                        //--------------> OutlineInputBorder
                        borderRadius: BorderRadius.circular(30),
                      ), // Fim do OutlineInputBorder
                    ), // Fim do InputDecoration
                  ), // Fim do TextField --------> Caixa de texto (Nome)
                ), // Fim do Padding ------------> Caixa de texto (Nome)
              ), // Fim do Padding --------------> Caixa de texto (Nome)
              //=============================================> Senha do Usuário
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
                      labelText: 'Email do Usuário',
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      floatingLabelStyle: TextStyle(
                        //--------------> Estilo do Texto
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 37, 37, 37),
                        fontSize: 20,
                      ), // Fim do Estilo do Texto
                      hintMaxLines: 1,
                      icon: Icon(Icons.email_rounded),
                      hintText: 'Informe o seu Email',
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
                      icon: Icon(Icons.key_rounded),
                      hintText: 'Informe a senha nome de usuário',
                      helperText: "A senha deve conter caracteres especiais",
                      border: OutlineInputBorder(
                        //--------------> OutlineInputBorder
                        borderRadius: BorderRadius.circular(30),
                      ), // Fim do OutlineInputBorder
                      helperStyle: TextStyle(
                        //--------------> Estilo do Texto de Ajuda
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                        fontSize: 18,
                      ), // Fim do Estilo do Texto de Ajuda
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
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
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
                            builder: (context) => const WelcomePage(),
                          ),
                        ),
                    child: Text('Registrar Usuário'),
                  ), // Fim do ElevationButton --> Botão da Tela
                ), // Fim do Padding -------------> Botão da Tela
              ), // Fim do Padding ---------------> Botão da Tela
              //======================================================================
              //
              //=============================================> Fim do Itens na Tela
              //Adicione mais Widgets aqui neste espaço
              //=============================================>
            ], // Fim do children<Widget>[]
          ), // Fim da Column
        ), // Fim do Container
      ), // Fim do Scaffold
    ); // Fim do MaterialApp
  } // Fim do retorno
} // Fim do Metodo
