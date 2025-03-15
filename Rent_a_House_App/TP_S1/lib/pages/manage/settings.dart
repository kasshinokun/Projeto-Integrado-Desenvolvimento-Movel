import 'package:flutter/material.dart';
import 'package:rent_a_house/pages/manage/widgets/widgetfiles.dart';
import 'package:rent_a_house/pages/home/navbar.dart';
import 'package:rent_a_house/pages/manage/widgets/security.dart';

double aspect = 1.0;

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreen();
}

class _SettingsScreen extends State<SettingsScreen> {
  //Controler
  TextEditingController textEditingController = TextEditingController();

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
              ),//
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
                  fontSize: 24 * aspect,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),//
              ),//
              leading: Icon(Icons.electrical_services_rounded),
              controlAffinity: ListTileControlAffinity.leading,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.check),
                  title: Text(
                    "Configure o idioma do aplicativo",
                    textAlign: TextAlign.left,
                    //textAlign: TextAlign.start, //precaução 
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w300,
                    ), //
                  ), //
                ), //
                ListTile(
                  leading: Icon(Icons.check),
                  title: Text(
                    "Organize a segurança",
                    textAlign: TextAlign.left,
                    //textAlign: TextAlign.start,//precaução 
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w300,
                    ), //
                  ), //
                ), //
                ListTile(
                  leading: Icon(Icons.check),
                  title: Text(
                    "Busca por sua MyHouse Ativa",
                    textAlign: TextAlign.left,
                    //textAlign: TextAlign.start,//precaução 
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w300,
                    ), //
                  ), //
                ), //
              ],//
            ),//
            SizedBox(height: 12 * aspect),
            ExpansionTile(
              title: Text(
                "Idioma",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ), //
              ), //
              trailing: Icon(Icons.arrow_forward_ios),
              leading: Icon(Icons.language_rounded),
              controlAffinity: ListTileControlAffinity.leading,
              children: <Widget>[widgetLanguage(context)],
            ),//
            ExpansionTile(
              title: Text(
                "Segurança",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ), //
              ), //
              trailing: Icon(Icons.arrow_forward_ios),
              leading: Icon(Icons.security),
              controlAffinity: ListTileControlAffinity.leading,
              children: <Widget>[
                //Align(
                //   alignment: Alignment.topLeft,
                //   child: 
                TextButton(
                  child: Text(
                    "Habilitar Autenticação Biométrica",
                    style: TextStyle(fontSize: 20 * aspect),
                  ),//
                  onPressed: () => authenticate(),
                ),//
                //),//
              ],//
            ),//
            ListTile(
              title: Text(
                "Buscar MyHouses",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ), //
              ), //
              trailing: Icon(Icons.rss_feed),
              leading: Icon(Icons.bluetooth_outlined),
              onTap: () {
                //
              },//
            ),//
            SizedBox(height: 12 * aspect),
            ExpansionTile(
              title: Text(
                "Ajuda & Suporte",
                style: TextStyle(
                  fontSize: 24 * aspect,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),//
              ),//
              leading: Icon(Icons.electrical_services_rounded),
              controlAffinity: ListTileControlAffinity.leading,
              children: <Widget>[polities(context)],
            ),//
            SizedBox(height: 12 * aspect),
            ExpansionTile(
              title: Text(
                "Sobre",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ), //
              ), //
              trailing: Icon(Icons.arrow_forward_ios),
              leading: Icon(Icons.info_outline_rounded),
              controlAffinity: ListTileControlAffinity.leading,
              children: <Widget>[
                SingleChildScrollView(child: widgetAbout(context)),
              ],//
            ),//
            SizedBox(height: 12 * aspect),//
            ExpansionTile(
              title: Text(
                "Privacidade",
                style: TextStyle(
                  fontSize: 24 * aspect,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),//
              ),//
              leading: Icon(Icons.electrical_services_rounded),
              controlAffinity: ListTileControlAffinity.leading,
              children: <Widget>[polities(context)],
            ),//
            SizedBox(height: 12 * aspect),//
            ExpansionTile(
              title: Text("Termos de Serviço"),
              trailing: Icon(Icons.arrow_forward_ios),
              leading: Icon(Icons.electrical_services_rounded),
              controlAffinity: ListTileControlAffinity.leading,
              children: <Widget>[polities(context)],
            ),//
            ExpansionTile(
              title: Text("Politicas de Privacidade"),
              trailing: Icon(Icons.arrow_forward_ios),
              leading: Icon(Icons.privacy_tip_rounded),
              controlAffinity: ListTileControlAffinity.leading,
              children: <Widget>[polities(context)],
            ),//
            ExpansionTile(
              title: Text("Politicas de Segurança"),
              trailing: Icon(Icons.arrow_forward_ios),
              leading: Icon(Icons.policy),
              controlAffinity: ListTileControlAffinity.leading,
              children: <Widget>[polities(context)],
            ),//
          ],//
        ),//
      ),//
    );//
  }//
}//
