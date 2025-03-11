import 'package:flutter/material.dart';
import 'package:rent_a_house/pages/home/navbar.dart';

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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExpansionTile(
              title: Text(
                "Geral",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              leading: Icon(Icons.electrical_services_rounded),
              controlAffinity: ListTileControlAffinity.leading,
              children: <Widget>[polities(context)],
            ),
            SizedBox(height: 12),
            ExpansionTile(
              title: Text("Idioma"),
              trailing: Icon(Icons.arrow_forward_ios),
              leading: Icon(Icons.language_rounded),
              controlAffinity: ListTileControlAffinity.leading,
              children: <Widget>[polities(context)],
            ),
            ExpansionTile(
              title: Text("Segurança"),
              trailing: Icon(Icons.arrow_forward_ios),
              leading: Icon(Icons.security),
              controlAffinity: ListTileControlAffinity.leading,
              children: <Widget>[polities(context)],
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
            ExpansionTile(
              title: Text(
                "Ajuda & Suporte",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              leading: Icon(Icons.electrical_services_rounded),
              controlAffinity: ListTileControlAffinity.leading,
              children: <Widget>[polities(context)],
            ),
            SizedBox(height: 12),
            ExpansionTile(
              title: Text("Sobre"),
              trailing: Icon(Icons.arrow_forward_ios),
              leading: Icon(Icons.info_outline_rounded),
              controlAffinity: ListTileControlAffinity.leading,
              children: <Widget>[polities(context)],
            ),
            SizedBox(height: 12),
            ExpansionTile(
              title: Text(
                "Privacidade",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              leading: Icon(Icons.electrical_services_rounded),
              controlAffinity: ListTileControlAffinity.leading,
              children: <Widget>[polities(context)],
            ),
            SizedBox(height: 12),
            ExpansionTile(
              title: Text("Termos de Serviço"),
              trailing: Icon(Icons.arrow_forward_ios),
              leading: Icon(Icons.electrical_services_rounded),
              controlAffinity: ListTileControlAffinity.leading,
              children: <Widget>[polities(context)],
            ),
            ExpansionTile(
              title: Text("Politicas de Privacidade"),
              trailing: Icon(Icons.arrow_forward_ios),
              leading: Icon(Icons.privacy_tip_rounded),
              controlAffinity: ListTileControlAffinity.leading,
              children: <Widget>[polities(context)],
            ),
            ExpansionTile(
              title: Text("Politicas de Segurança"),
              trailing: Icon(Icons.arrow_forward_ios),
              leading: Icon(Icons.policy),
              controlAffinity: ListTileControlAffinity.leading,
              children: <Widget>[polities(context)],
            ),
          ],
        ),
      ),
    );
  }

  Widget polities(context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Mission Statement:'),
          SizedBox(height: 8),
          Text(
            'Our mission is to provide high-quality products and services to our customers.',
          ),
          SizedBox(height: 16),
          Text('Values:'),
          SizedBox(height: 8),
          ListTile(
            leading: Icon(Icons.check),
            title: Text('Customer satisfaction is our top priority'),
          ),
          ListTile(
            leading: Icon(Icons.check),
            title: Text('We strive for continuous improvement'),
          ),
          ListTile(
            leading: Icon(Icons.check),
            title: Text('We value honesty and integrity in all our actions'),
          ),
        ],
      ),
    );
  }
}
