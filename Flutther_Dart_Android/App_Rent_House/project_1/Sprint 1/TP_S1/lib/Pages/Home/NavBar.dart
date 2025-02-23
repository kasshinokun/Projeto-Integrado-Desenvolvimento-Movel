import 'package:flutter/material.dart';

class Navbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          //-----------------> children-Social
          Text(
            'Entrar/Registrar',
            style: TextStyle(
              fontSize: 20.0,
              fontFamily: 'Roboto',
              color: Color(0xFF212121),
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            // ------> Icone Home
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
              Navigator.popAndPushNamed(context, '/login');
            },
            icon: Icon(Icons.account_circle),
          ), // Fim do Icone Home// Fim do Botão google
        ], // Fim do children<Widget>[] Social
      ),
    );
  }
}
