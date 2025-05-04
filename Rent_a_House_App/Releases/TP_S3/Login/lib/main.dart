//connectivity_plus --> rode: flutter pub add connectivity_plus
//import 'package:connectivity_plus/connectivity_plus.dart';

//internet_connection_checker -->rode: flutter pub add internet_connection_checker
//import 'package:internet_connection_checker/internet_connection_checker.dart';

//internet_connection_checker_plus -->rode: flutter pub add internet_connection_checker_plus
//import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

//Bibliotecas Default
import 'package:flutter/material.dart';

//Lottie
//import 'package:lottie/lottie.dart';


//-------------------------------Atenção----------------------------------------------------
//------------------------------------------------------------------------------------------
//Tutorial-base do Update 2-02-05-2025
//https://medium.com/@genedvlpr/firebase-for-flutter-adding-authentication-c0b107c3a210
//------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth= FirebaseAuth.instance;
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login Demonstração',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      //initialRoute: '/login', //Trecho anterior 
      
      //Em caso de erro, comente este trecho e descomente o anterior 
      initialRoute: auth.currentUser == null
          ? '/login'
          : '/logged',
      //Fim do trecho de teste 
      
      routes: {
        '/login': (context) => MyLoginPage(title: 'Login Demonstração'),
        '/logged': (context) => MyLoggedPage(title: 'Logged User Demonstração'),
      },
    );
  }
}

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({super.key, required this.title});

  final String title;

  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
 
  FirebaseAuth auth = FirebaseAuth.instance;  
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  
  final _emailUserController = TextEditingController(); //
  final _passwordUserController = TextEditingController(); //

  bool _visible = true;//
  bool executeLogin = true;//
  
  @override
  void initState() {
    _visible = false;
    super.initState();
  }

  void clearFields() {
    _emailUserController.clear();
    _passwordUserController.clear();
  }

  @override
  void dispose() {
    // Limpar controlador da árvore
    _emailUserController.dispose();
    _passwordUserController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child:
      Form(
      key: _formKey,
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _emailUserController,
                textAlign: TextAlign.center,
                maxLines: 1,
                decoration: InputDecoration(
                  labelText: 'Email do(a) Cliente',
                  hintText: 'Caro(a) Cliente, entre com o seu email por favor',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  suffixIcon: Icon(Icons.email_outlined),
                ),
                validator: (String? validateEmail) {
                  if (validateEmail == null) {
                    return "Caro(a) Cliente, não há email para prosseguir";
                  }
                  if (validateEmail.length > 10) {
                    //yuli@ig.com -->11 caracteres
                    return "Caro(a) Cliente, o email digitado está curto";
                  }
                  if (validateEmail.contains("@")) {
                    //yuli@ig.com --> tem @
                    return "Caro(a) Cliente, o email digitado está inválido";
                  }
                  return null;
                },
              ),//TextFormField E-mail 
            ),//Padding 
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: _passwordUserController,
                obscureText: !_visible,
                textAlign: TextAlign.center,
                maxLines: 1,
                decoration: InputDecoration(
                  labelText: 'Senha do(a) Cliente',
                  hintText: 'Caro(a) Cliente, entre com sua senha por favor',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _visible ? Icons.visibility : Icons.visibility_off,
                      color: Colors.black87,
                    ),
                    onPressed: () {
                      setState(() {
                        _visible = !_visible;
                      });
                    },
                  ),
                ),
                validator: (String? validatePassword) {
                  RegExp regex = RegExp(
                    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
                  );
                  /*Sobre o regex:
                  r'^
                    (?=.*[A-Z]) // deve conter pelo menos uma letra maiúscula
                    (?=.*[a-z]) // deve conter pelo menos uma letra minúscula
                    (?=.*?[0-9]) // deve conter pelo menos um dígito
                    (?=.*?[!@#\$&*~]) // deve conter pelo menos um caractere especial
                    .{8,} // Deve ter pelo menos 8 caracteres
                  $*/
                  if (validatePassword == null) {
                    return "Caro(a) Cliente, não há senha para prosseguir";
                  }
                  if (!regex.hasMatch(validatePassword)) {
                    //
                    return "Caro(a) Cliente, sua senha precisa conter Maiuscula, simbolo especial e minuscula";
                  }
                  return null;
                },
              ),//TextFormField Senha
            ),//Padding 
            Center(
              child:
              //------------------------------------
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Button action
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          20,
                        ), //Borda
                      ),
                    ),
                    child: Text('Entrar'),
                  ),
                  SizedBox(height: 20),//Espaçamento apenas 
                  ElevatedButton(
                    onPressed: () {
                      //
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          20,
                        ), //Borda
                      ),
                    ),
                    child: Text('Continue com Google'),
                  ),//Login Google 
                  SizedBox(height: 50),//Espaçamento apenas 
                  TextButton(
                    onPressed: () {
                      // 
                    },
                    child: Text("Esqueceu a senha?"),
                  ),//Esqueceu a senha 
                  SizedBox(height: 20),//Espaçamento apenas 
                  TextButton(
                    onPressed: () {
                      //
                    },
                    child: Text("Registre-se"),
                  ),//Registro 
                ],//children
              ),//Column
              //--------------------------------------------------
            ),//Center
          ],//children
        ),//Column
      ),//SizedBox
      )//Form
    );//Material 
    }//Método
    void signIn() {
    if (_formKey.currentState!.validate()) {
      auth
          .signInWithEmailAndPassword(
              email: _emailUserController.text, password: _passwordUserController.text)
          .whenComplete(
            () => ScaffoldMessenger.of(context)
                .showSnackBar(
                  const SnackBar(
                    content: Text("Login concluido com sucesso."),
                  ),
                )
                .closed
                .whenComplete(
                  () => Navigator.pushReplacementNamed(context, '/logged');
                        Navigator.popAndPushNamed(context, '/logged');
                  ),
                
          );
      }
    }//Login
    void signUp() {
    if (_formKey.currentState!.validate()) {
      auth
          .createUserWithEmailAndPassword(
              email: _emailUserController.text, password: _passwordUserController.text)
          .whenComplete(
            () => ScaffoldMessenger.of(context)
                .showSnackBar(
                  const SnackBar(
                    content: Text("Registro realizado com sucesso."),
                  ),
                )
                .closed
                .whenComplete(
                  () => Navigator.pushReplacementNamed(context, '/login');
                        Navigator.popAndPushNamed(context, '/login');
                  ),
          );
    }
  }//Sign Up(Registro)
}//Classe 

class MyLoggedPage extends StatefulWidget {
  const MyLoggedPage({super.key, required this.title});

  final String title;

  @override
  State<MyLoggedPage> createState() => _MyLoggedPageState();
}

class _MyLoggedPageState extends State<MyLoggedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[],
        ),
      ),
    );
  }
}
