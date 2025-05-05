//Bibliotecas Padrão
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

//Classes
import 'package:rent_a_house/services/authservices.dart';

//Isolar depois---------------------------------------------------------------------------------------------------------------
class MyLoginPage extends StatefulWidget {
  const MyLoginPage({super.key});
  //title: 'Login Demonstração'
  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> snackbarLoginKey =
      GlobalKey<ScaffoldMessengerState>();

  final _emailUserController = TextEditingController(); //
  final _passwordUserController = TextEditingController(); //

  bool _visible = true; //
  bool isLogin = true; //
  late String titulo;
  late String actionButton;
  late String toggleButton;
  late String signGoogle;
  @override
  void initState() {
    _visible = false;
    super.initState();
    setFormAction(true);
  }

  setFormAction(bool validateAction) {
    setState(() {
      isLogin = validateAction;
      if (isLogin) {
        titulo = 'Bem-vindo caro(a) Cliente';
        actionButton = 'Entrar';
        toggleButton = 'Ainda não tem uma conta?\nCadastre-se agora.';
        signGoogle = 'Continuar com o Google';
      } else {
        titulo = 'Crie sua conta';
        actionButton = 'Cadastrar';
        toggleButton = 'Voltar ao Login';
        signGoogle = 'Registrar com o Google';
      }
    });
  }

  //Função do Botao Login/Registro
  void manageUser() {
    if (_formKey.currentState!.validate()) {
      if (isLogin) {
        executeLogin();
      } else {
        executeRegister();
      }
    }
  }

  //Login
  executeLogin() async {
    try {
      await context.read<AuthService>().loginUser(
        _emailUserController.text,
        _passwordUserController.text,
      );
    } on AuthException catch (e) {
      snackbarLoginKey.currentState?.showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    }
  }

  //Registrar
  executeRegister() async {
    try {
      await context.read<AuthService>().registerUser(
        _emailUserController.text,
        _passwordUserController.text,
      );
    } on AuthException catch (e) {
      snackbarLoginKey.currentState?.showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    }
  }
  //Alterar
  //Sair

  //Deletar
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
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 100.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  titulo,
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -1.5,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(24.0),
                  child: TextFormField(
                    controller: _emailUserController,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    decoration: InputDecoration(
                      labelText: 'Email do(a) Cliente',
                      labelStyle: TextStyle(fontSize: 20),
                      hintText:
                          MediaQuery.of(context).orientation ==
                                  Orientation.portrait
                              ? 'Email por favor'
                              : 'Caro(a) Cliente, entre com o seu email por favor',
                      hintStyle: TextStyle(fontSize: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      suffixIcon: Icon(Icons.email_outlined),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (String? validateEmail) {
                      if (validateEmail!.isEmpty) {
                        return MediaQuery.of(context).orientation ==
                                Orientation.portrait
                            ? "Email vazio"
                            : "Caro(a) Cliente, não há email para prosseguir.";
                      }
                      if (validateEmail.length < 10) {
                        //yuli@ig.com -->11 caracteres
                        return MediaQuery.of(context).orientation ==
                                Orientation.portrait
                            ? "Email curto."
                            : "Caro(a) Cliente, o email digitado está curto.";
                      }
                      if (!validateEmail.contains("@")) {
                        //yuli@ig.com --> tem @
                        return MediaQuery.of(context).orientation ==
                                Orientation.portrait
                            ? "Email inválido."
                            : "Caro(a) Cliente, o email digitado está inválido";
                      }
                      return null;
                    },
                  ), //TextFormField E-mail
                ), //Padding
                Padding(
                  padding: EdgeInsets.all(24.0),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _passwordUserController,
                    obscureText: !_visible,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    decoration: InputDecoration(
                      labelText: 'Senha do(a) Cliente',
                      labelStyle: TextStyle(fontSize: 20),
                      hintText:
                          MediaQuery.of(context).orientation ==
                                  Orientation.portrait
                              ? 'Senha por favor'
                              : 'Caro(a) Cliente, entre com sua senha por favor',
                      hintStyle: TextStyle(fontSize: 16),
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
                        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,24}$',
                      );
                      /*Sobre o regex:
                        r'^
                          (?=.*[A-Z]) // deve conter pelo menos uma letra maiúscula
                          (?=.*[a-z]) // deve conter pelo menos uma letra minúscula
                          (?=.*?[0-9]) // deve conter pelo menos um dígito
                          (?=.*?[!@#\$&*~]) // deve conter pelo menos um caractere especial
                          .{8,24} // Deve ter pelo menos 8 até 24 caracteres
                        $*/
                      if (validatePassword!.isEmpty) {
                        return MediaQuery.of(context).orientation ==
                                Orientation.portrait
                            ? "Senha vazia"
                            : "Caro(a) Cliente, não há senha para prosseguir.";
                      }
                      if (!regex.hasMatch(validatePassword)) {
                        //
                        return MediaQuery.of(context).orientation ==
                                Orientation.portrait
                            ? "Senha inválida"
                            : "Caro(a) Cliente, sua senha precisa ter de 8-24 caracteres e conter Maiuscula, simbolo especial e minuscula";
                      }
                      return null;
                    },
                  ), //TextFormField Senha
                ), //Padding
                Padding(
                  padding: EdgeInsets.all(24.0),
                  child: ElevatedButton(
                    onPressed: () {
                      manageUser();
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20), //Borda
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check),
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            actionButton,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              //letterSpacing:-1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(24.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Button action
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20), //Borda
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //ImageIcon(AssetImage('assets/app/google_logo.png')),
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            signGoogle,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              //letterSpacing:-1.5,
                            ),
                          ),
                        ),
                        CustomPaint(
                          painter: GoogleLogoPainter(),
                          size: Size.square(20),
                        ),
                      ],
                    ),
                  ),
                ), //Padding
                if (isLogin)
                  Padding(
                    padding: EdgeInsets.all(24.0),
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        'Esqueci minha senha',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ), //Registro
                  ),
                TextButton(
                  onPressed: () => setFormAction(!isLogin),
                  child: Text(
                    toggleButton,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ), //Registro
              ], //children
            ), //Column
            //--------------------------------------------------
          ), //Form
        ), //Padding
      ), //SingleChildScrollView
    ); //Scaffold
  } //Método
} //Classe

class GoogleLogoPainter extends CustomPainter {
  @override
  bool shouldRepaint(_) => true;

  @override
  void paint(Canvas canvas, Size size) {
    final length = size.width;
    final verticalOffset = (size.height / 2) - (length / 2);
    final bounds = Offset(0, verticalOffset) & Size.square(length);
    final center = bounds.center;
    final arcThickness = size.width / 4.5;
    final paint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = arcThickness;

    void drawArc(double startAngle, double sweepAngle, Color color) {
      final Paint paintColor = paint..color = color;
      canvas.drawArc(bounds, startAngle, sweepAngle, false, paintColor);
    }

    drawArc(3.5, 1.9, Colors.red);
    drawArc(2.5, 1.0, Colors.amber);
    drawArc(0.9, 1.6, Colors.green.shade600);
    drawArc(-0.18, 1.1, Colors.blue.shade600);

    canvas.drawRect(
      Rect.fromLTRB(
        center.dx,
        center.dy - (arcThickness / 2),
        bounds.centerRight.dx + (arcThickness / 2) - 4,
        bounds.centerRight.dy + (arcThickness / 2),
      ),
      paint
        ..color = Colors.blue.shade600
        ..style = PaintingStyle.fill
        ..strokeWidth = 0,
    );
  }
}
