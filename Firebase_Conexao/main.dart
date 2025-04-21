//connectivity_plus --> rode: flutter pub add connectivity_plus
import 'package:connectivity_plus/connectivity_plus.dart';

//internet_connection_checker -->rode: flutter pub add internet_connection_checker
import 'package:internet_connection_checker/internet_connection_checker.dart';

//internet_connection_checker_plus -->rode: flutter pub add internet_connection_checker_plus
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

//Bibliotecas Default
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//Lottie
import 'package:lottie/lottie.dart';

class ConnectionNotifier extends InheritedNotifier<ValueNotifier<bool>>{
  const ConnectionNotifier({
    super.key,
    required super.notifier,
    required super.child
    }
  );
  static ValueNotifier<bool>of(BuildContext context) {
     return context.dependOnInheritedWidgetofExactType<ConnectionNotifier>()!.notifier;
  }
}

void main() async{
  final hasConnection= await InternetConnectionChecker().hasConnection;
  runApp(
    ConnectionNotifier(
      notifier:ValueNotifier(hasConnection),
      child:const MyApp())
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
  Iate final StreamSubscription<InternetConnectionChecker> listener;
  @override
  void initState(){
    super.initState();
    listener=InternetConnectionChecker().onStatusChange.listen((status){
      final notifier = ConnectionNotifier.of(context);
      notifier.value = status => InternetConnectionStatus.connected?true:false;
    });
  }
  
  @override
  void dispose(){
    listener.cancel();
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
      initialRoute: '/', //Rotas
      routes: {
        '/':(context) => MyHomePage(), 
        //==================================> Testes <======================
        '/connectivity':(context) => MyConnectPage(), 
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
    return Scaffold( 
      
    );
  }
}

//Teste de Conexão
class MyConnectPage extends StatefulWidget {
  const MyConnectPage({super.key});
  @override
  State<MyConnectPage> createState() => _MyConnectPageState();
}

class _MyConnectPageState extends State<MyConnectPage> {
  final hasConnection= ConnectionNotifier.of(context).value;
  final asset=hasConnection?'network':'no_connection';
  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      body:Center(
        child:Lottie.asset('asset/$asset.json'),
      )
    );
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
    return Scaffold( 
    );
  }
}
