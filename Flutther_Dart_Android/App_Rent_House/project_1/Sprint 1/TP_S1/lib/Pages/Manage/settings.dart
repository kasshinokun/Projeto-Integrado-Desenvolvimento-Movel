import 'package:flutter/material.dart';
import 'package:rent_house/Pages/Home/navbar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreen();
}

class _SettingsScreen extends State<SettingsScreen> {
  //Controler
  TextEditingController textEditingController = TextEditingController();
  //Bluettoth Controller
  //FlutterBlue flutterBlue = FlutterBlue.instance;
  //List<BluetoothDevice> devices = [];

  //Processo inicial de Busca
  //
  //
  //

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Navbar(),
      appBar: AppBar(
        //------------------------------------> AppBar
        backgroundColor: Colors.green,
        title: Text('Rent a House - Configurações'),
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: Icon(Icons.person_2_rounded),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
        ), // Fim do Icone Home
      ), // Fim do AppBar
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Geral",
            style: TextStyle(
              fontSize: 24,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 12),
          ListTile(
            title: Text("Idioma"),
            trailing: Icon(Icons.arrow_forward_ios),
            leading: Icon(Icons.language_rounded),
            onTap: () {
              //
            },
          ),
          ListTile(
            title: Text("Segurança"),
            trailing: Icon(Icons.arrow_forward_ios),
            leading: Icon(Icons.security),
            onTap: () {
              //
            },
          ),
          ListTile(
            title: Text("Buscar MyHouses"),
            trailing: Icon(Icons.rss_feed),
            leading: Icon(Icons.bluetooth_outlined),
            onTap: () {
              //
            },
          ),
          SizedBox(height: 12),
          Text(
            "Ajuda & Suporte",
            style: TextStyle(
              fontSize: 24,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 12),
          ListTile(
            title: Text("Sobre"),
            trailing: Icon(Icons.arrow_forward_ios),
            leading: Icon(Icons.info_outline_rounded),
            onTap: () {
              //
            },
          ),
          SizedBox(height: 12),
          Text(
            "Privacidade",
            style: TextStyle(
              fontSize: 24,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 12),
          ListTile(
            title: Text("Termos de Serviço"),
            trailing: Icon(Icons.arrow_forward_ios),
            leading: Icon(Icons.electrical_services_rounded),
            onTap: () {
              //
            },
          ),
          ListTile(
            title: Text("Politicas de Privacidade"),
            trailing: Icon(Icons.arrow_forward_ios),
            leading: Icon(Icons.privacy_tip_rounded),
            onTap: () {
              //
            },
          ),
          ListTile(
            title: Text("Politicas de Segurança"),
            trailing: Icon(Icons.arrow_forward_ios),
            leading: Icon(Icons.policy),
            onTap: () {
              //
            },
          ),
        ],
      ),
    );
  }

  //Processo final de Busca
  //
  //
  //
}
