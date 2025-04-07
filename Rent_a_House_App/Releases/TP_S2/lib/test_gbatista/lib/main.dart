import 'package:flutter/material.dart';
import 'package:rent_a_house/pages/myapp.dart';
import 'package:rent_a_house/pages/notify/notify_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotifyService.initNotification();

  runApp(const MyApp());
}
