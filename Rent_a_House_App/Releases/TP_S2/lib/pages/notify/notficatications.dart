import 'package:flutter/material.dart';
//import 'package:rent_a_house/pages/s1/pages/home/navbar.dart';
//import 'package:rent_a_house/pages/s1/pages/Home/home.dart' as sone;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() {
  //
  WidgetsFlutterBinding.ensureInitialized();

  //Inicialização: Serviço de Notificação
  NotifyService().initNotification();

  //Rodando a aplicação
  runApp(NotifyApp());
}

class NotifyApp extends StatelessWidget {
  const NotifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: NotifyScreen());
  }
}

class NotifyScreen extends StatefulWidget {
  const NotifyScreen({super.key});

  @override
  State<NotifyScreen> createState() => _NotifyScreenState();
}

class _NotifyScreenState extends State<NotifyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () {
            NotifyService().showNotification(title: "Title", body: "Body");
          },
          label: Text("Send Notification"),
          icon: Icon(Icons.send_to_mobile_rounded),
        ),
      ),
    );
  }
}

//
//===========================================Serviço de Notificação
class NotifyService {
  final notificationsPlugin = FlutterLocalNotificationsPlugin();

  final bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  //Inicialização: sistema de notificações
  Future<void> initNotification() async {
    if (_isInitialized) return; //Prevenção para reinicialização

    //Preparação: Configurações iniciais do Android
    const initSettingsAndroid = AndroidInitializationSettings(
      '@mimap/ic_launcher', //logo da aplicação
    );

    //Configurações: Inicialização
    const initSettings = InitializationSettings(android: initSettingsAndroid);

    //Inicialização: Plugin
    await notificationsPlugin.initialize(initSettings);
  }

  //Configuração: detalhes das notificações
  NotificationDetails notificationDetails() {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_channel_id', //channelId
        'Daily Notifications', //channelName
        channelDescription: 'Daily Notifications Channel', //Descrição do canal
        importance: Importance.high, //Importãncia
        priority: Priority.high, //Prioridade
        //playSound: true, //--->Habilite se desejar
      ),
    );
  }

  //Exibição: notificações
  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
  }) async {
    return notificationsPlugin.show(
      id,
      title,
      body,
      const NotificationDetails(),
    );
  }

  //Gestos: Toque sobre a notificação
}
