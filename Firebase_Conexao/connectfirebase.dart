//connectivity_plus --> rode: flutter pub add connectivity_plus
import 'package:connectivity_plus/connectivity_plus.dart';

//internet_connection_checker -->rode: flutter pub add internet_connection_checker
import 'package:internet_connection_checker/internet_connection_checker.dart';

//internet_connection_checker_plus -->rode: flutter pub add internet_connection_checker_plus
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

//Bibliotecas Default
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//Lottie
import 'package:lottie/lottie.dart';

void main(){
  runApp(
    const MyApp()
  );
}

//==================================================================
//MyApp(Inicializador da aplicação)
class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false, //tirar o banner
      title: 'Flutter Demo',
      theme: ThemeData(
        //brightness: Brightness.light //Light Mode
        //brightness: Brightness.dark //Dark Mode
        //primarySwatch: Colors.lightGreen, //Cor Inicial
      ),
      initialRoute: '/register', //Rotas
      routes: {
        '/':(context) => MyHomePage(), 
        //==================================> Testes <======================
        '/login':(context) => MyLoginPage(title: "Login"), 
        '/register': (context) => MyRegisterPage(title: "Registro"), , 
      //==================================================================
      },
    );
  }
}

//Página Inicial
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      body:Center(child:Text("Logado"))
    );
  }
}

//Registro
class MyLoginPage extends StatefulWidget {
  final String title;
  const MyLoginPage({super.key, required this.title}) : super();
  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  
  bool executeLogin=true;
  final _formKey()=GlobalKey<FormState>();
  
  final TextEditingController _nameController =
      TextEditingController(); //recebe o nome
  final TextEditingController _cpfController =
      TextEditingController(); //recebe o cpf
  final TextEditingController _emailController =
      TextEditingController(); //recebe o email
  final TextEditingController _passwordController =
      TextEditingController(); //recebe a senha
  void _clerfields(){
    setState(() {  
    //limpa as variaveis após o cadastro estar feito
      _nameController.clear();
      _cpfController.clear();
      _emailController.clear();
      _passwordController.clear();
       });
    }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      appBar: AppBar(
        //------------------------------------> AppBar
        backgroundColor: Colors.green,
        title: Text(widget.title), //Text
      ), 
      body: 
        Stack(
          children:[
            Container(
              child:Column(
                crossAxisAlignment:CrossAxisAlignment.start,
                children:[
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Nome Completo',
                    ),
                    validator:(String? value){
                      if (value==null){
                        return "Nome do Cliente ausente";
                      }
                      if (value.length<5){ //Yu Li -->5 caracteres
                        return "Nome do Cliente curto";
                      }
                      if (!value.contains(" ")){ //Yu Li -->tem espaço
                        return "Nome do Cliente inválido";
                      }
                      return null;
                    }
                  ),
                  TextFormField(
                    controller: _cpfController,
                    decoration: InputDecoration(
                      labelText: 'CPF do Clente',
                    ),
                    validator:(String? value){
                      if (value==null){
                        return "CPF do Cliente ausente";
                      }
                      if (!value.length==11){ //12345678901 -->11 caracteres
                        return "CPF do Cliente inválido";
                      }
                      if (value.contains(" ")){ //12345 678901  -->tem espaço
                        return "CPF do Cliente inválido";
                      }
                      //Criar função verificadora de CPF no futuro
                      return null;
                    }
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email do Clente',
                    ),
                    validator:(String? value){
                      if (value==null){
                        return "Email do Cliente ausente";
                      }
                      if (!value.length<10){ //yuli@ig.com -->11 caracteres
                        return "Email do Cliente curto";
                      }
                      if (value.contains("@")){ //yuli@ig.com --> tem @
                        return "Email do Cliente inválido";
                      }
                      return null;
                    }
                  ),
                  TextFormField(
                    controller: _passwordController,
                    obscuredText:true,
                    decoration: InputDecoration(
                      labelText: 'Senha do Clente',
                    ),
                    validator:(String? value){
                      RegExp regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                      /*Sobre o regex:
                      r'^
                        (?=.*[A-Z]) // deve conter pelo menos uma letra maiúscula
                        (?=.*[a-z]) // deve conter pelo menos uma letra minúscula
                        (?=.*?[0-9]) // deve conter pelo menos um dígito
                        (?=.*?[!@#\$&*~]) // deve conter pelo menos um caractere especial
                        .{8,} // Deve ter pelo menos 8 caracteres
                      $*/
                      if (value==null){
                        return "Senha do Cliente ausente";
                      }
                      if (!regex.hasMatch(value)) {//
                        return "Senha do Cliente precisa conter Maiuscula, simbolo especial e minuscula";
                      }
                      return null;
                    }                  
                 ),
                //Botoes
              ]
            )
          )
        ]
      )
    );
  }
  //Função para tratar boolean da Classe
}
                          
class MyRegisterPage extends StatefulWidget {
  final String title;
  const MyRegisterPage({super.key, required this.title}) : super();
  @override
  State<MyRegisterPage> createState() => _MyRegisterPageState();
}

class _MyRegisterPageState extends State<MyRegisterPage> {
  bool executeRegister=true;
  final _formKey()=GlobalKey<FormState>();
  final TextEditingController _emailController =
      TextEditingController(); //recebe o email
  final TextEditingController _passwordController =
      TextEditingController(); //recebe a senha
  void _clerfields(){
    setState(() {  
    //limpa as variaveis após o cadastro estar feito
      _emailController.clear();
      _passwordController.clear();
       });
    }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      appBar: AppBar(
        //------------------------------------> AppBar
        backgroundColor: Colors.green,
        title: Text(widget.title), //Text
      ), 
      body: 
        Stack(
          children:[
            Container(
              child:Column(
                crossAxisAlignment:CrossAxisAlignment.start,
                children:[
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Email do Clente',
                    ),
                    validator:(String? value){
                      if (value==null){
                        return "Email do Cliente ausente";
                      }
                      if (!value.length<10){ //yuli@ig.com -->11 caracteres
                        return "Email do Cliente curto";
                      }
                      if (value.contains("@")){ //yuli@ig.com --> tem @
                        return "Email do Cliente inválido";
                      }
                      return null;
                    }
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Senha do Clente',
                    ),
                    validator:(String? value){
                      RegExp regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                      /*Sobre o regex:
                      r'^
                        (?=.*[A-Z]) // deve conter pelo menos uma letra maiúscula
                        (?=.*[a-z]) // deve conter pelo menos uma letra minúscula
                        (?=.*?[0-9]) // deve conter pelo menos um dígito
                        (?=.*?[!@#\$&*~]) // deve conter pelo menos um caractere especial
                        .{8,} // Deve ter pelo menos 8 caracteres
                      $*/
                      if (value==null){
                        return "Senha do Cliente ausente";
                      }
                      if (!regex.hasMatch(value)) {//
                        return "Senha do Cliente precisa conter Maiuscula, simbolo especial e minuscula";
                      }
                      return null;
                    }
                  ),
                //Botoes
              ]
            )
          )
        ]
      )
    );
  }
  //Função para tratar boolean da Classe
}
