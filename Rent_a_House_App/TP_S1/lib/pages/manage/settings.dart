import 'package:flutter/material.dart';
import 'package:rent_a_house/pages/client/clienthouse.dart';
import 'package:rent_a_house/pages/home/navbar.dart';

//Rode antes: flutter pub add url_launcher
import 'package:url_launcher/url_launcher.dart';//Acesso Web


bool setLanguage = true;

public void accessWeb(String url){
  if (await canLaunch(url)) {
    await launch(url, forceWebView: true, enableJavaScript: true);
  } else {
    throw 'Could not launch $url';
  }
}
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
              children: <Widget>[widgetLanguage(context)],
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
              children: <Widget>[widgetAbout(context)],
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

  //Sobre
  Widget widgetAbout(context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("PUC Coração Eucaristico Corporation\n"),
          InkWell(
            child: Text("Desenvolvido por: Diego Vitor Pinto Mariano Portella\n"),
            onTap: () {
              accessWeb('https://github.com/diegovitorportella')
            },
          ), 
          InkWell(
            child: Text("Desenvolvido por: Gabriel Batista de Almeida\n"),
            onTap: () {
              accessWeb('https://github.com/GabrielBatistadeAlmeida')
            },
          ),
          InkWell( 
            child: Text("Desenvolvido por: Gabriel da Silva Cassino\n"),
            onTap: () {
              accessWeb('https://github.com/kasshinokun')
            },
          ),
          Text("Versão: Alpha 0.1.${getDate()}"),
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: widgetText(context),
          ),
        ],
      ),
    );
  }

  //Idioma
  Widget widgetLanguage(context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Idioma atual: ${setLanguage ? "Português PT-BR" : "English EN-US"}",
          ),
          ListTile(
            title: Text(setLanguage ? "Português PT-BR" : "English EN-US"),
            onTap: () {
              setState(() {
                setLanguage = !setLanguage;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget widgetText(context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('\nAcerca da aplicação:'),
          Text(
            "\nO aplicativo Rent a House tem como objetivo facilitar o aluguel\nde imóveis por temporada, conectando locatários e localizadores em uma\nplataforma digital intuitiva e segura. Além da funcionalidade tradicional\nde listagem e reserva de imóveis, o sistema se diferencia ao integrar \num hardware de prototipagem (ESP32 ou Arduino), permitindo a automação\ne monitoramento remoto dos imóveis por meio de sensores e atuadores .",
          ),

          Text(
            "Os dados coletados pelos dispositivos serão armazenados e gerenciados\nem uma base de dados na nuvem , como o Firebase ou outro SGBD, garantindo \nacessibilidade, segurança e eficiência na comunicação entre os usuários e\no sistema. Dessa forma, o Rent a House oferece mais praticidade e inovação\nao setor de aluguel por temporada.",
          ),

          Text('\nPublico-alvo:'),
          Text(
            'O público-alvo do Rent a House é composto por dois principais grupos de usuários:',
          ),

          Text("\nInquilinos/viajantes :"),
          Text(
            "Pessoas que procuram alugar imóveis por temporada, \nseja para viagens a trabalho, lazer ou estadias temporárias. Esse grupo inclui \nturistas, profissionais em deslocamento, estudantes e famílias que residem \nem uma residência provisória. Eles valorizam praticidade, segurança e um processo\nde locação simplificado;",
          ),
          Text("\nProprietários/Anfitriões :"),
          Text(
            "Donos de imóveis que desejam disponibilizá-los\npara aluguel por temporada de forma segura e eficiente. Esse grupo inclui desde\npequenos proprietários até investidores do setor imobiliário, que buscam uma plataforma\nconfiável para gerenciar seus aluguéis e otimizar a ocupação de imóveis.",
          ),
          Text('\nPrincipais funcionalidades que planejamos implementar:'),
          Text("\nInquilinos/viajantes :"),
          ListTile(
            leading: Icon(Icons.check),
            title: Text(
              "Busca e Filtros de Imóveis – Pesquisa avançada por localização, preço, comodidades e disponibilidade;",
            ),
          ),
          ListTile(
            leading: Icon(Icons.check),
            title: Text(
              "Visualização de Imóveis – Lista com imagens, descrição detalhada, endereço e avaliações de outros usuários;",
            ),
          ),
          ListTile(
            leading: Icon(Icons.check),
            title: Text(
              "Reserva e Pagamento Online – Processo rápido e seguro para alugar um imóvel diretamente pelo app;",
            ),
          ),
          ListTile(
            leading: Icon(Icons.check),
            title: Text(
              "Gerenciamento de Locações – Histórico de reservas, status de locação e notificações sobre prazos;",
            ),
          ),
          ListTile(
            leading: Icon(Icons.check),
            title: Text(
              "Acesso Inteligente ao Imóvel – Integração com hardware (ESP32/Arduino) para controle de fechaduras eletrônicas e sensores.",
            ),
          ),
          Text("\nProprietários/Anfitriões :"),
          ListTile(
            leading: Icon(Icons.check),
            title: Text(
              "Cadastro de Imóveis – Inclusão de fotos (com Image Picker e carrossel), descrição, localização (CEP) e valores;",
            ),
          ),
          ListTile(
            leading: Icon(Icons.check),
            title: Text(
              "Gerenciamento de Anúncios – Ativação, edição e remoção de imóveis reservados;",
            ),
          ),
          ListTile(
            leading: Icon(Icons.check),
            title: Text(
              "Monitoramento Inteligente – Sensores para controle de acesso, temperatura, iluminação e consumo de energia;",
            ),
          ),
          ListTile(
            leading: Icon(Icons.check),
            title: Text(
              "Gestão de Reservas – Controle de ocupação, calendário de disponibilidade e comunicação com locatários;",
            ),
          ),
          ListTile(
            leading: Icon(Icons.check),
            title: Text(
              "Notificações e Alertas – Avisos sobre novas reservas, pagamentos e status do imóvel.",
            ),
          ),
          Text("Funcionalidades Gerais:"),
          ListTile(
            leading: Icon(Icons.check),
            title: Text(
              "Cadastro e Login – Autenticação via e-mail, Google ou redes sociais;",
            ),
          ),
          ListTile(
            leading: Icon(Icons.check),
            title: Text(
              "Chat Integrado – Comunicação direta entre locatário e localizador dentro do app;",
            ),
          ),
          ListTile(
            leading: Icon(Icons.check),
            title: Text(
              "Avaliações e Feedback – Sistema de avaliações e notas para imóveis e usuários;",
            ),
          ),
          ListTile(
            leading: Icon(Icons.check),
            title: Text(
              "Integração com Firebase ou outro SGBD – Armazenamento seguro e sincronização em tempo real;",
            ),
          ),
          ListTile(
            leading: Icon(Icons.check),
            title: Text(
              "Painel de Controle – Dashboard com estatísticas sobre locações, faturamento e desempenho dos imóveis.",
            ),
          ),
        ],
      ),
    );
  }
}
