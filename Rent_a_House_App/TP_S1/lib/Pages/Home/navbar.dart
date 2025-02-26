import 'package:flutter/material.dart';
import 'package:rent_house/Pages/Start/welcome.dart';

String setNameAccount(bool connection) {
  return connection ? 'Offline User' : "Michiko Shindou";
}

String setEmailAccount(bool connection) {
  return connection ? "Offline Email" : "shin.michiko2004@gmail.com";
}

String setExitButton(bool connection) {
  return connection ? 'Entrar/Registrar' : 'Sair';
}

IconData getUserConnect(bool connection) {
  return connection ? Icons.exit_to_app : Icons.person_2_rounded;
}

class Navbar extends StatelessWidget {
  const Navbar({super.key});
  @override
  Widget build(BuildContext context) {
    bool connection = setConnectionState();
    String urlUserName = setNameAccount(connection);
    String urlUserEmail = setEmailAccount(connection);
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(urlUserName),
            accountEmail: Text(urlUserEmail),
            currentAccountPicture: CircleAvatar(child: ClipOval()),
            decoration: BoxDecoration(color: Colors.blue),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Página Inicial'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/');
              Navigator.popAndPushNamed(context, '/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.beach_access_rounded),
            title: Text('Alugar House'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/');
              Navigator.popAndPushNamed(context, '/');
            },
          ),
          ListTile(
            leading: Icon(Icons.house),
            title: Text('My Houses'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/client');
              Navigator.popAndPushNamed(context, '/client');
            },
          ),
          ListTile(
            leading: Icon(Icons.room_service_rounded),
            title: Text('Cadastrar House'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/register');
              Navigator.popAndPushNamed(context, '/register');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notificações'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/notifications');
              Navigator.popAndPushNamed(context, '/notifications');
            },
          ),
          ListTile(
            leading: Icon(Icons.photo_album),
            title: Text('Image Picker'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/imagepicker');
              Navigator.popAndPushNamed(context, '/imagepicker');
            },
          ),
          ListTile(
            leading: Icon(Icons.table_bar),
            title: Text('Curved NavBar'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/curved');
              Navigator.popAndPushNamed(context, '/curved');
            },
          ),
          ListTile(
            leading: Icon(Icons.table_bar),
            title: Text('Curved Labeled NavBar'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/curvedlabeled');
              Navigator.popAndPushNamed(context, '/curvedlabeled');
            },
          ),
          ListTile(
            leading: Icon(Icons.table_bar),
            title: Text('Carousel'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/carousel');
              Navigator.popAndPushNamed(context, '/carousel');
            },
          ),
          Divider(),

          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Configurações'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/settings');
              Navigator.popAndPushNamed(context, '/settings');
            },
          ),
          Divider(),
          ListTile(
            title: Text(setExitButton(connection)),
            leading: Icon(getUserConnect(connection)),
            onTap: () {
              if (connection == true) {
                Navigator.pushReplacementNamed(context, '/login');
                Navigator.popAndPushNamed(context, '/login');
              }
              //
              else {
                Navigator.pushReplacementNamed(context, '/');
                Navigator.popAndPushNamed(context, '/');
              }
            },
          ),
        ],
      ),
    );
  }
}




/*
          


*/