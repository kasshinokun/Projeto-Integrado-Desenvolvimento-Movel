import 'package:flutter/material.dart';
import 'package:rent_a_house/pages/s1/pages/home/navbar.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

//===========================> Serviço de Notificação
class NotifyService {
  final notificationsPlugin = FlutterLocalNotificationsPlugin();

  static final _initSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  static final _initSettings =
  InitializationSettings(android: _initSettingsAndroid);

  Future<void> initNotification() async {
    await notificationsPlugin.initialize(_initSettings);
  }

  NotificationDetails notificationDetails() {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'channel_id',
        'channel_name',
        channelDescription: 'Notification channel',
        importance: Importance.high,
        priority: Priority.high,
      ),
    );
  }

  Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    await notificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails(),
    );
  }
}
//===========================> Tela da Notificações <==============

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final _controller = TextEditingController();
  final _notifyService = NotifyService();

  @override
  void initState() {
    super.initState();
    _notifyService.initNotification(); // Inicializa o serviço de notificação
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sendNotification() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      _notifyService.showNotification(
        title: 'Confirmação',
        body: text,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Notificação enviada!')),
      );
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Navbar(),
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Notificações'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.person_2_rounded),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Mensagem da notificação',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _sendNotification,
              icon: Icon(Icons.send),
              label: Text('Enviar Notificação'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
