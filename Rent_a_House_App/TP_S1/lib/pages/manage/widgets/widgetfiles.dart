import 'package:flutter/material.dart';
import 'package:rent_a_house/pages/client/clienthouse.dart';

//Auttenticação local
//import 'package:local_auth/local_auth.dart';

//Rode antes: flutter pub add url_launcher
//import 'package:url_launcher/url_launcher_string.dart'; //Acesso Web
bool setLanguage = true;

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

//Idioma
bool getLanguage(bool lang) {
  return !lang;
}

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
          onTap: () => setLanguage = getLanguage(setLanguage),
        ),
      ],
    ),
  );
}
//Segurança

//Sobre o projeto parte 1
Widget widgetAbout(context) {
  return Container(
    padding: EdgeInsets.all(8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "PUC Coração Eucaristico Corporation\n",
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ), //
        ), //
        Text(
          "Desenvolvido por: Diego Vitor Pinto Mariano Portella\n",
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ), //
        ), //
        Text(
          "Desenvolvido por: Gabriel Batista de Almeida\n",
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ), //
        ), //
        Text(
          "Desenvolvido por: Gabriel da Silva Cassino\n",
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ), //
        ), //
        Text(
          "Versão: Alpha 0.1.${getDate()}",
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ), //
        ), //
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: widgetAbout2(context),
        ),
      ],
    ),
  );
}

//Sobre o Projeto parte 2
Widget widgetAbout2(context) {
  return Container(
    padding: EdgeInsets.all(8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '\nAcerca da aplicação:',
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ), //
        ), //
        Text(
          "\nO aplicativo Rent a House tem como objetivo facilitar o aluguel\nde imóveis por temporada, conectando locatários e localizadores em uma\nplataforma digital intuitiva e segura.\n\nAlém da funcionalidade tradicional\nde listagem e reserva de imóveis, o sistema se diferencia ao integrar \num hardware de prototipagem (ESP32 ou Arduino), permitindo a automação\ne monitoramento remoto dos imóveis por meio de sensores e atuadores .",
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ), //
        ), //
        Text(
          "\n\nOs dados coletados pelos dispositivos serão armazenados e gerenciados\nem uma base de dados na nuvem , como o Firebase ou outro SGBD, garantindo \nacessibilidade, segurança e eficiência na comunicação entre os usuários e\no sistema.\n\nDessa forma, o Rent a House oferece mais praticidade e inovação\nao setor de aluguel por temporada.",

          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ), //
        ), //
        /*
        Text(
          '\nPublico-alvo:',
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ), //
        ), //
        Text(
          'O público-alvo do Rent a House é composto por dois principais grupos de usuários:',
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ), //
        ), //
        Text(
          "\nInquilinos/viajantes :",
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ), //
        ), //
        Text(
          "Pessoas que procuram alugar imóveis por temporada, \nseja para viagens a trabalho, lazer ou estadias temporárias. Esse grupo inclui \nturistas, profissionais em deslocamento, estudantes e famílias que residem \nem uma residência provisória. Eles valorizam praticidade, segurança e um processo\nde locação simplificado;",
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ), //
        ), //
        Text(
          "\nProprietários/Anfitriões :",
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ), //
        ), //
        Text(
          "Donos de imóveis que desejam disponibilizá-los\npara aluguel por temporada de forma segura e eficiente. Esse grupo inclui desde\npequenos proprietários até investidores do setor imobiliário, que buscam uma plataforma\nconfiável para gerenciar seus aluguéis e otimizar a ocupação de imóveis.",
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ), //
        ), //
        Text(
          '\nPrincipais funcionalidades que planejamos implementar:',
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ), //
        ), //
        Text(
          "\nInquilinos/viajantes :",
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ), //
        ), //
        ListTile(
          leading: Icon(Icons.check),
          title: Text(
            "Busca e Filtros de Imóveis – Pesquisa avançada por localização, preço, comodidades e disponibilidade;",
          ), //
        ), //
        ListTile(
          leading: Icon(Icons.check),
          title: Text(
            "Visualização de Imóveis – Lista com imagens, descrição detalhada, endereço e avaliações de outros usuários;",
          ), //
        ), //
        ListTile(
          leading: Icon(Icons.check),
          title: Text(
            "Reserva e Pagamento Online – Processo rápido e seguro para alugar um imóvel diretamente pelo app;",
          ), //
        ), //
        ListTile(
          leading: Icon(Icons.check),
          title: Text(
            "Gerenciamento de Locações – Histórico de reservas, status de locação e notificações sobre prazos;",
          ), //
        ), //
        ListTile(
          leading: Icon(Icons.check),
          title: Text(
            "Acesso Inteligente ao Imóvel – Integração com hardware (ESP32/Arduino) para controle de fechaduras eletrônicas e sensores.",
          ), //
        ), //
        Text("\nProprietários/Anfitriões :"),
        ListTile(
          leading: Icon(Icons.check),
          title: Text(
            "Cadastro de Imóveis – Inclusão de fotos (com Image Picker e carrossel), descrição, localização (CEP) e valores;",
          ), //
        ), //
        ListTile(
          leading: Icon(Icons.check),
          title: Text(
            "Gerenciamento de Anúncios – Ativação, edição e remoção de imóveis reservados;",
          ), //
        ), //
        ListTile(
          leading: Icon(Icons.check),
          title: Text(
            "Monitoramento Inteligente – Sensores para controle de acesso, temperatura, iluminação e consumo de energia;",
          ), //
        ), //
        ListTile(
          leading: Icon(Icons.check),
          title: Text(
            "Gestão de Reservas – Controle de ocupação, calendário de disponibilidade e comunicação com locatários;",
          ), //
        ), //
        ListTile(
          leading: Icon(Icons.check),
          title: Text(
            "Notificações e Alertas – Avisos sobre novas reservas, pagamentos e status do imóvel.",
          ), //
        ), //
        Text("Funcionalidades Gerais:"),
        ListTile(
          leading: Icon(Icons.check),
          title: Text(
            "Cadastro e Login – Autenticação via e-mail, Google ou redes sociais;",
          ), //
        ), //
        ListTile(
          leading: Icon(Icons.check),
          title: Text(
            "Chat Integrado – Comunicação direta entre locatário e localizador dentro do app;",
          ), //
        ), //
        ListTile(
          leading: Icon(Icons.check),
          title: Text(
            "Avaliações e Feedback – Sistema de avaliações e notas para imóveis e usuários;",
          ), //
        ), //
        ListTile(
          leading: Icon(Icons.check),
          title: Text(
            "Integração com Firebase ou outro SGBD – Armazenamento seguro e sincronização em tempo real;",
          ), //
        ), //
        ListTile(
          leading: Icon(Icons.check),
          title: Text(
            "Painel de Controle – Dashboard com estatísticas sobre locações, faturamento e desempenho dos imóveis.",
          ), //
        ), //
        */
      ], //
    ), //
  ); //
}
