import 'dart:async';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:rent_a_house/screens/internet.dart';
import 'package:rent_a_house/screens/no_internet.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => ConnectionChecker(),
        '/internet': (context) => InternetScreen(),
        '/no_internet': (context) => NoInternetScreen(),
      },
    );
  }
}

class ConnectionChecker extends StatefulWidget {
  const ConnectionChecker({super.key});

  @override
  State<ConnectionChecker> createState() => _ConnectionCheckerState();
}

class _ConnectionCheckerState extends State<ConnectionChecker> {
  bool isConnectedToInternet = false;

  StreamSubscription? _internetConnectionStreamSubscription;
  @override
  void initState() {
    super.initState();
    _internetConnectionStreamSubscription = InternetConnection().onStatusChange
        .listen(
          //
          (event) {
            print(event);
            switch (event) {
              case InternetStatus.connected:
                setState(() {
                  isConnectedToInternet = true;
                });

                break;
              case InternetStatus.disconnected:
                setState(() {
                  isConnectedToInternet = false;
                });

                break;
            }
          },
          //
        );
  }

  @override
  void dispose() {
    _internetConnectionStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (isConnectedToInternet) ? InternetScreen() : NoInternetScreen();
  }
}
