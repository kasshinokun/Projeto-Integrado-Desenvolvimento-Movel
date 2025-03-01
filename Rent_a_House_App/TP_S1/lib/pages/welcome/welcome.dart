import 'package:flutter/material.dart';
import 'package:rent_a_house/pages/home/home.dart';
import 'package:rent_a_house/pages/client/register.dart';

bool connection = false;
bool setConnectionState() {
  connection = !connection; //Gerar a Mudança
  return connection;
}

String getPathImageHome(double height, double width) {
  return height < width
      ? "assets/welcome/fullHD_landscape.jpg"
      : "assets/welcome/fullHD_portrait.jpg";
}

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});
  @override
  State<WelcomePage> createState() => _WelcomePage();
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
          title: Text("Login de Usuário"), //Texto da Barra do App
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
                            builder: (context) => const HomeScreen(),
                          ),
                        ),
                    child: Text('Entrar na Aplicação'),
                  ), // Fim do ElevationButton --> Botão da Tela
                ), // Fim do Padding -------------> Botão da Tela
              ), // Fim do Padding ---------------> Botão da Tela
              //======================================================================
              Padding(
                //-------------------------------------------> Padding
                padding: const EdgeInsets.only(top: 8.0),
                child: Padding(
                  //----------------------------------------------> Padding
                  padding: EdgeInsets.fromLTRB(10.0, 3.0, 10.0, 3.0),
                  child: ElevatedButton(
                    //---------------------> Botão
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
                            builder: (context) => const RegisterScreen(),
                          ),
                        ),
                    child: Text('Registrar Novo Usuário'),
                  ), // Fim do ElevationButton --> Botão da Tela 2
                ), // Fim do Padding -------------> Botão da Tela 2
              ), // Fim do Padding ---------------> Botão da Tela 2
              //======================================================================
              Padding(
                //-------------------------------------------> Padding
                padding: const EdgeInsets.only(top: 8.0),
                child: Padding(
                  //----------------------------------------------> Padding
                  padding: EdgeInsets.fromLTRB(10.0, 3.0, 10.0, 3.0),
                  child: Row(
                    //-------------------------------> Row
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: <Widget>[
                      //-----------------> children-Social
                      OutlinedButton.icon(
                        //Botão login com Google
                        onPressed: () {
                          // Add your on pressed event here
                        },
                        style: OutlinedButton.styleFrom(
                          iconColor: Colors.green,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        icon: Image.asset(
                          //-------------------> Image
                          'assets/app/google_logo.png',
                          height: 20,
                          width: 20,
                          fit: BoxFit.cover,
                        ), //Fim da Imagem
                        label: const Text('Entrar com'),
                        iconAlignment: IconAlignment.end,
                      ), // Fim do Botão login com Google
                    ], // Fim do children<Widget>[] Social
                  ), // Fim do Row
                ), // Fim do Container
              ), // Fim do Padding -------------> Row
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

        ), // Fim do Container
      ), // Fim do Scaffold
    ); // Fim do MaterialApp
  } // Fim do retorno
} // Fim do Metodo
