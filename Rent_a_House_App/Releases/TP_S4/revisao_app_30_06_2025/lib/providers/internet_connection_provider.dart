// lib/providers/internet_connection_provider.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

/// Um Change Notifier que gerencia e expõe o status de conexão real à internet
/// usando `internet_connection_checker_plus`.
class InternetConnectionProvider extends ChangeNotifier {
  bool _isConnectedToInternet = false;
  StreamSubscription? _internetConnectionStreamSubscription;

  /// Retorna verdadeiro se houver acesso real à internet.
  bool get isConnectedToInternet => _isConnectedToInternet;

  InternetConnectionProvider() {
    _initConnectivityListener();
  }

  /// Inicializa o listener de status de conexão à internet.
  void _initConnectivityListener() {
    _internetConnectionStreamSubscription = InternetConnection().onStatusChange
        .listen((InternetStatus status) {
          final newConnectionStatus = status == InternetStatus.connected;
          // Atualiza o status apenas se houver uma mudança
          if (_isConnectedToInternet != newConnectionStatus) {
            _isConnectedToInternet = newConnectionStatus;
            notifyListeners(); // Notifica os listeners quando o status muda
          }
        });
  }

  @override
  void dispose() {
    _internetConnectionStreamSubscription?.cancel();
    super.dispose();
  }
}
