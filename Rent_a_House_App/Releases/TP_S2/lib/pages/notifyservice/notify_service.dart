import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotifyService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> initNotification() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    const initSettings = InitializationSettings(android: androidSettings);

    await _notificationsPlugin.initialize(initSettings);
  }

  static Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
  }) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'cadastro_channel_id',
        'Cadastro Notification',
        channelDescription: 'Notificações de cadastro',
        importance: Importance.high,
        priority: Priority.high,
      ),
    );

    await _notificationsPlugin.show(
      id,
      title,
      body,
      details,
    );
  }
}
