// lib/my_app.dart
import 'package:flutter/material.dart';
import 'package:rent_a_house/combined_connection_handler_screen.dart';
import 'package:rent_a_house/providers/connectivity_provider.dart';
import 'package:rent_a_house/providers/internet_connection_provider.dart';
import 'package:rent_a_house/screens/login.dart';
import 'package:rent_a_house/screens/my_houses_screen.dart';
import 'package:rent_a_house/screens/register_house_page.dart';
import 'package:rent_a_house/services/authservices.dart';
import 'package:provider/provider.dart';
import 'package:rent_a_house/screens/no_internet_screen.dart';
import 'package:rent_a_house/screens/home_page.dart'; // Importa a nova HomePage

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplicativo de Conectividade e Autenticação',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AuthCheck(), // AuthCheck continua sendo o ponto de entrada
      routes: {
        '/auth': (context) => const AuthCheck(),
        '/login': (context) => const MyLoginPage(),
        '/home_authenticated': (context) => const HomePage(), // Agora aponta para a nova HomePage
        '/nointernet': (context) => const NoInternetScreen(),
        '/registerhouse': (context) =>  RegisterHousePage(),
        '/myhouses': (context) =>  MyHousesScreen(),
      },
    );
  }
}

// ============== WIDGETS DE AUTHSERVICESS.DART ADAPTADOS ==============

// Classe de exceção de autenticação
class AuthException implements Exception {
  String message;
  AuthException(this.message);
}

// Widget de loading
Widget loading() {
  return const Scaffold(body: Center(child: CircularProgressIndicator()));
}

// AuthCheck agora consome os providers de conectividade E verifica o login offline
class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final connectivityProvider = Provider.of<ConnectivityProvider>(context);
    final internetProvider = Provider.of<InternetConnectionProvider>(context);
    final bool isOnline = connectivityProvider.isConnected && internetProvider.isConnectedToInternet;

    if (auth.isLoading) {
      return loading();
    } else {
      if (auth.usuario != null) {
        debugPrint('AuthCheck: Usuário logado: ${auth.usuario?.email ?? auth.usuario?.displayName}');
        // Se o usuário está logado, vai para o handler de conexão/home principal
        return const CombinedConnectionHandlerScreen();
      } else {
        // Se não há usuário logado, verifica a conexão para decidir entre login e sem internet
        if (!isOnline) {
          debugPrint('AuthCheck: Sem internet e sem login. Exibindo NoInternetScreen.');
          return const NoInternetScreen();
        } else {
          debugPrint('AuthCheck: Online, mas sem usuário logado. Exibindo MyLoginPage.');
          return const MyLoginPage();
        }
      }
    }
  }
}
