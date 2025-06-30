// lib/screens/connection_pannel_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rent_a_house/providers/connectivity_provider.dart';
import 'package:rent_a_house/providers/internet_connection_provider.dart';
import 'package:rent_a_house/services/authservices.dart';
import 'dart:io'; // Para usar Image.file

class ConnectionPannelScreen extends StatelessWidget {
  const ConnectionPannelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.usuario;

    // Adiciona depuração mais detalhada para o caminho da imagem
    if (user?.photoURL != null) {
      debugPrint('ConnectionPannelScreen: user.photoURL é: ${user!.photoURL}'); // Usar user! para garantir que não é nulo após a verificação
      final file = File(user.photoURL!); // Usar user! para garantir que não é nulo
      debugPrint('ConnectionPannelScreen: O arquivo da imagem existe localmente? ${file.existsSync()}');
      if (!file.existsSync()) {
        debugPrint('ConnectionPannelScreen: ATENÇÃO: Arquivo da imagem não encontrado no caminho: ${user.photoURL}');
      }
    } else {
      debugPrint('ConnectionPannelScreen: photoURL do usuário é nulo. Imagem padrão será exibida.');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Painel de Conexão"), // Novo título para a tela de status
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Exibe a imagem de perfil
            if (user?.photoURL != null && File(user!.photoURL!).existsSync())
              ClipOval(
                child: Image.file(
                  File(user.photoURL!),
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    debugPrint('ConnectionPannelScreen: Erro no Image.file ao carregar: $error');
                    return const CircleAvatar(
                      radius: 60,
                      child: Icon(Icons.person, size: 60),
                    );
                  },
                ),
              )
            else
              const CircleAvatar(
                radius: 60,
                child: Icon(Icons.person, size: 60),
              ),
            const SizedBox(height: 20),
            Text(
              "Bem-vindo, ${user?.displayName ?? user?.email ?? 'Usuário'}!", // Exibe o nome ou email
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              "UID: ${user?.uid ?? 'Não disponível'}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Consumer<InternetConnectionProvider>(
              builder: (context, internetProvider, child) {
                return Text(
                  'Status Internet Checker: ${internetProvider.isConnectedToInternet ? 'Conectado' : 'Desconectado'}',
                  style: TextStyle(
                    color: internetProvider.isConnectedToInternet ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
            Consumer<ConnectivityProvider>(
              builder: (context, connectivityProvider, child) {
                return Column(
                  children: [
                    Text(
                      'Status Connectivity Plus: ${connectivityProvider.isConnected ? 'Conectado à Rede' : 'Sem Rede'}',
                      style: TextStyle(
                        color: connectivityProvider.isConnected ? Colors.green : Colors.red,
                      ),
                    ),
                    Text('Wi-Fi: ${connectivityProvider.isWifiConnected ? 'Conectado' : 'Desconectado'}'),
                    Text('Dados Móveis: ${connectivityProvider.isMobileDataConnected ? 'Conectado' : 'Desconectado'}'),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}