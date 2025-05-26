import 'dart:async';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class InternetConnectionProvider extends ChangeNotifier {
  bool _isConnectedToInternet = false;
  StreamSubscription? _internetConnectionStreamSubscription;

  bool get isConnectedToInternet => _isConnectedToInternet;

  InternetConnectionProvider() {
    _initConnectivityListener();
  }

  void _initConnectivityListener() {
    _internetConnectionStreamSubscription = InternetConnection().onStatusChange
        .listen((InternetStatus status) {
          final newConnectionStatus = status == InternetStatus.connected;
          if (_isConnectedToInternet != newConnectionStatus) {
            _isConnectedToInternet = newConnectionStatus;
            notifyListeners(); // Notify listeners when the status changes
          }
        });
  }

  @override
  void dispose() {
    _internetConnectionStreamSubscription?.cancel();
    super.dispose();
  }
}
