//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rent_a_house/pages/model/widgets/security.dart';
import 'package:rent_a_house/pages/model/widgets/widgetfiles.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  final bool logged = true;
  final bool manager = true;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
            children: <Widget>[
              ListTile(
                title: Text(
                  'Funções - Descrição:',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.check),
                title: Text(
                  "Configure o idioma do aplicativo",
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
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w300,
                  ), //
                ), //
              ), //
            ],
          ),
          SizedBox(height: 12),
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
          ),
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

            children: <Widget>[mySetHouse()],
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
            ],
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
    );
  }

  Widget mySetHouse() {
    return logged == false
        ? Column(
          children: [
            //Habilitar digital
            ListTile(
              title: Text(
                "Habilitar Autenticação Biométrica",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ), //
              ), //
              trailing: Icon(Icons.rss_feed),
              leading: Icon(Icons.fingerprint),
              onTap: () => authenticate(),
            ),
            //Habilitar busca
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
              },
            ),
            //Se for o dono da casa
            manager == false
                ? Column(
                  children: [
                    ListTile(
                      title: Text(
                        "Gestor - Ativar MyHouse",
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
                      },
                    ),
                    ListTile(
                      title: Text(
                        "Gestor - Abrir MyHouse",
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
                      },
                    ),
                  ],
                )
                : ListTile(
                  title: Text(
                    "Acesso Usuário",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
          ],
        )
        : ListTile(
          title: Text(
            "Favor logar para Habilitar Serviços",
            style: TextStyle(fontSize: 20),
          ),
        );
  }
}
