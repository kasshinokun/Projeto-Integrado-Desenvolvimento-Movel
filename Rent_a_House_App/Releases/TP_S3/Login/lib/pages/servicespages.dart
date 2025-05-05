import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
                "Sair",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Profile Screen', style: TextStyle(fontSize: 24)),
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

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Settings Screen', style: TextStyle(fontSize: 24)),
    );
  }
}
