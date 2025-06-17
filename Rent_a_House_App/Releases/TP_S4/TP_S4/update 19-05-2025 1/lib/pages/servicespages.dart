import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:rent_a_house/pages/model/widgets/security.dart';
//import 'package:rent_a_house/pages/model/widgets/widgetfiles.dart';
//import 'package:provider/provider.dart';
//import 'package:rent_a_house/services/authservices.dart';

//Test Palcebo Apenas
class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //signout function

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Text('Home Screen', style: TextStyle(fontSize: 24)),
            ),
            ElevatedButton(
              onPressed: () async {
                //signout function
                await _auth.signOut();
                //Definir rota futuramente
              },
              child: Text(
                "Login",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RentaHouseScreen extends StatelessWidget {
  const RentaHouseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Rent a House Screen', style: TextStyle(fontSize: 24)),
    );
  }
}
