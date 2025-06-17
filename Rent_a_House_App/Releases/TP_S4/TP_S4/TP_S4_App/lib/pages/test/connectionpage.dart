//connectivity_plus --> rode: flutter pub add connectivity_plus
import 'dart:async';

//import 'package:connectivity_plus/connectivity_plus.dart';

//internet_connection_checker -->rode: flutter pub add internet_connection_checker
//import 'package:internet_connection_checker/internet_connection_checker.dart';

//internet_connection_checker_plus -->rode: flutter pub add internet_connection_checker_plus
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

//Bibliotecas Default
import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';

//Lottie
//import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class ConnectionNotifier extends InheritedNotifier<ValueNotifier<bool>> {
  const ConnectionNotifier({
    super.key,
    required super.notifier,
    required super.child,
  });
  static ValueNotifier<bool> of(BuildContext context) {
    return context.read()<ConnectionNotifier>()!.notifier;
  }
}

void main() async {
  final hasConnection = InternetConnection.createInstance(
    customCheckOptions: [
      InternetCheckOption(
        uri: Uri.parse('https://www.google.com'),
        responseStatusFn: (response) {
          return response.statusCode >= 69 && response.statusCode < 169;
        },
      ),
      InternetCheckOption(
        uri: Uri.parse('https://www.google.com'),
        responseStatusFn: (response) {
          return response.statusCode >= 420 && response.statusCode < 1412;
        },
      ),
    ],
  );
  runApp(
    ConnectionNotifier(
      notifier: ValueNotifier(await hasConnection.hasInternetAccess),
      child: const MyApp(),
    ),
  );
}

//==================================================================
//MyApp(Inicializador da aplicação)
class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final StreamSubscription<InternetStatus> _subscription;
  late final AppLifecycleListener _listener;
  @override
  void initState() {
    super.initState();
    _subscription = InternetConnection().onStatusChange.listen((status) {
      // Handle internet status changes
    });
    _listener = AppLifecycleListener(
      onResume: _subscription.resume,
      onHide: _subscription.pause,
      onPause: _subscription.pause,
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    _listener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //final Size size = MediaQuery.sizeOf(context);
    //final double currentWidth = size.width;
    //final double currentHeight = size.height;

    return MaterialApp(
      debugShowCheckedModeBanner: false, //tirar o banner
      title: 'Flutter Demo',
      theme: ThemeData(
        //brightness: Brightness.light //Light Mode
        //brightness: Brightness.dark //Dark Mode
        //primarySwatch: Colors.lightGreen, //Cor Inicial
      ),
      initialRoute: '/internet', //Rotas
      routes: {
        //==================================> Testes <======================
        '/connectivity': (context) => MyConnectPage(),
        '/internet': (context) => MyInternetPage(),
        //==================================================================
      },
    );
  }
}

//Página Inicial
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

//Teste de Conexão
class MyConnectPage extends StatefulWidget {
  const MyConnectPage({super.key});
  @override
  State<MyConnectPage> createState() => _MyConnectPageState();
}

class _MyConnectPageState extends State<MyConnectPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("data")));
  }
}

//Internet
class MyInternetPage extends StatefulWidget {
  const MyInternetPage({super.key});
  @override
  State<MyInternetPage> createState() => _MyInternetPageState();
}

class _MyInternetPageState extends State<MyInternetPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Text("Oi"));
  }
}
