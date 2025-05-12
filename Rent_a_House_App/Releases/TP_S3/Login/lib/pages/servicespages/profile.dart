//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:path/path.dart';
//import 'package:rent_a_house/services/authservices.dart';
//import 'package:rent_a_house/pages/model/widgets/security.dart';
//import 'package:rent_a_house/pages/model/widgets/widgetfiles.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 10,
          children: [
            Text('Perfis', style: TextStyle(fontSize: 24)),
            UserAccountsDrawerHeader(
              accountName: Text("urlUserName"),
              accountEmail: Text("urlUserEmail"),
              currentAccountPicture: CircleAvatar(
                child: SizedBox(
                  width: 400,
                  height: 400,
                  child: ClipRect(
                    child: Image.asset(
                      "assets/app/user.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              decoration: BoxDecoration(color: Colors.blue),
            ),
            Text('Estado Usuario: Logado', style: TextStyle(fontSize: 24)),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                spacing: 30,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 60.0,
                        height: 60.0,
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Text("Geral"),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        width: 60.0,
                        height: 60.0,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Text("Casas"),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        width: 60.0,
                        height: 60.0,
                        decoration: BoxDecoration(
                          color: Colors.pinkAccent,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Text("Aluguel"),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        width: 60.0,
                        height: 60.0,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Text("Conta"),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        width: 60.0,
                        height: 60.0,
                        decoration: BoxDecoration(
                          color: Colors.purple,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Text("Dados 5"),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        width: 60.0,
                        height: 60.0,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Text("Dados 6"),
                    ],
                  ),
                ],
              ),
            ),

            Column(
              spacing: 15,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    'Nome do Usuario',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Mudar senha', style: TextStyle(fontSize: 24)),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Mudar email', style: TextStyle(fontSize: 24)),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    'Ver casas alugadas',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/registerhouse');
                    Navigator.popAndPushNamed(context, '/registerhouse');
                  },
                  child: Text(
                    'Registrar uma House',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 45, right: 45),
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.account_box),
                        Icon(Icons.delete),
                        Text('Cancelar Conta', style: TextStyle(fontSize: 24)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
