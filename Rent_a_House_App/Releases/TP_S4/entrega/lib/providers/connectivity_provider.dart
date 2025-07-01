// lib/providers/connectivity_provider.dart
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

/// Um Change Notifier que gerencia e expõe o status de conectividade da rede usando `connectivity_plus`.
class ConnectivityProvider extends ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  // Armazena o status atual da conectividade.
  List<ConnectivityResult> _currentConnectivityResults = [ConnectivityResult.none];

  ConnectivityProvider() {
    _initConnectivityMonitoring();
  }

  /// Inicializa o monitoramento da conectividade.
  void _initConnectivityMonitoring() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((results) {
      _currentConnectivityResults = results;
      notifyListeners(); // Notifica todos os listeners sobre a mudança.
    });
    // Também verifica a conectividade inicial ao iniciar.
    _checkInitialConnectivity();
  }

  /// Verifica o status inicial da conectividade.
  Future<void> _checkInitialConnectivity() async {
    _currentConnectivityResults = await _connectivity.checkConnectivity();
    notifyListeners();
  }

  /// Retorna verdadeiro se houver qualquer conexão ativa (Wi-Fi ou dados móveis).
  bool get isConnected {
    return !_currentConnectivityResults.contains(ConnectivityResult.none);
  }

  /// Retorna verdadeiro se conectado via Wi-Fi.
  bool get isWifiConnected {
    return _currentConnectivityResults.contains(ConnectivityResult.wifi);
  }

  /// Retorna verdadeiro se conectado via dados móveis.
  bool get isMobileDataConnected {
    return _currentConnectivityResults.contains(ConnectivityResult.mobile);
  }

  /// Getter para os resultados brutos da conectividade.
  List<ConnectivityResult> get currentConnectivityResults => _currentConnectivityResults;

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }
}
