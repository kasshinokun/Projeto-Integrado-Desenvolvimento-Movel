// lib/combined_connection_handler_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rent_a_house/providers/connectivity_provider.dart';
import 'package:rent_a_house/providers/internet_connection_provider.dart';
import 'package:rent_a_house/services/authservices.dart';
import 'package:rent_a_house/screens/home_page.dart'; // Importa a nova HomePage
import 'package:rent_a_house/screens/no_internet_screen.dart';
import 'package:rent_a_house/screens/login.dart'; // Importa a tela de login

/// Um widget que atua como um listener combinado para ambos os providers de conectividade,
/// gerenciando a exibição de diálogos e a navegação entre telas para usuários AUTENTICADOS.
class CombinedConnectionHandlerScreen extends StatefulWidget {
  const CombinedConnectionHandlerScreen({super.key});

  @override
  State<CombinedConnectionHandlerScreen> createState() =>
      _CombinedConnectionHandlerScreenState();
}

class _CombinedConnectionHandlerScreenState extends State<CombinedConnectionHandlerScreen> {
  bool _lastCombinedConnectionStatus = false;
  bool _lastCombinedConnectionStatusInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (mounted && !_lastCombinedConnectionStatusInitialized) {
      final connectivityProvider = Provider.of<ConnectivityProvider>(context, listen: false);
      final internetConnectionProvider = Provider.of<InternetConnectionProvider>(context, listen: false);
      _lastCombinedConnectionStatus =
          connectivityProvider.isConnected && internetConnectionProvider.isConnectedToInternet;
      _lastCombinedConnectionStatusInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Consumer3 escuta as mudanças de ambos os providers de conectividade e o AuthService.
    return Consumer3<ConnectivityProvider, InternetConnectionProvider, AuthService>(
      builder: (context, connectivityProvider, internetConnectionProvider, authService, child) {
        final currentCombinedConnectionStatus =
            connectivityProvider.isConnected && internetConnectionProvider.isConnectedToInternet;

        // Se o status da conexão mudou, mostra um diálogo.
        if (currentCombinedConnectionStatus != _lastCombinedConnectionStatus) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _showStatusDialog(context, currentCombinedConnectionStatus);
            }
          });
          _lastCombinedConnectionStatus = currentCombinedConnectionStatus;
        }

        // Lógica de Redirecionamento principal:
        // 1. Se o usuário NÃO está autenticado no AuthService, redireciona para a tela de login.
        if (authService.usuario == null) {
          debugPrint('CombinedConnectionHandlerScreen: Usuário deslogado. Redirecionando para /login.');
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              // Usa pushAndRemoveUntil para limpar a pilha de navegação e ir para o login
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const MyLoginPage()),
                (Route<dynamic> route) => false,
              );
            }
          });
          return Container(); // Retorna um container vazio enquanto redireciona
        }
        // 2. Se o usuário está autenticado:
        else {
          // Se está offline, mostra a tela de sem internet.
          if (!currentCombinedConnectionStatus) {
            return const NoInternetScreen();
          }
          // Se está online e autenticado, mostra a nova HomePage.
          else {
            return const HomePage(); // Redireciona para a nova HomePage principal
          }
        }
      },
    );
  }

  /// Função para exibir um diálogo com o status da conexão.
  void _showStatusDialog(BuildContext context, bool isConnected) {
    String title = isConnected ? "Online!" : "Offline!";
    String content = isConnected
        ? "Você está online e pode acessar a internet."
        : "Você está offline. Por favor, verifique sua conexão.";
    Color dialogColor = isConnected ? Colors.green : Colors.red;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(color: dialogColor, fontWeight: FontWeight.bold),
          ),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
