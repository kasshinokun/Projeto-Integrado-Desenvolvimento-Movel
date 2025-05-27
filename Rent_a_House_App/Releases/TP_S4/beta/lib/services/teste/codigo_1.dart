// lib/providers/connectivity_provider.dart

import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

/// A Change Notifier provider to manage and expose network connectivity status.
class ConnectivityProvider extends ChangeNotifier {
  // Singleton instance of Connectivity.
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  // Stores the current connectivity status.
  // We use a List to be consistent with connectivity_plus, but
  // for our logic, we primarily care if 'none' is present.
  List<ConnectivityResult> _currentConnectivityResults = [ConnectivityResult.none];

  bool _hasShownNoInternetDialog = false;

  ConnectivityProvider() {
    _initConnectivityMonitoring();
  }

  /// Initializes the connectivity monitoring.
  void _initConnectivityMonitoring() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((results) {
      _currentConnectivityResults = results;
      notifyListeners(); // Notify all listeners about the change.
    });
    // Also check initial connectivity
    _checkInitialConnectivity();
  }

  Future<void> _checkInitialConnectivity() async {
    _currentConnectivityResults = await _connectivity.checkConnectivity();
    notifyListeners();
  }

  /// Returns true if there's any active connection (Wi-Fi or mobile data).
  bool get isConnected {
    return !_currentConnectivityResults.contains(ConnectivityResult.none);
  }

  /// Returns true if connected via Wi-Fi.
  bool get isWifiConnected {
    return _currentConnectivityResults.contains(ConnectivityResult.wifi);
  }

  /// Returns true if connected via mobile data.
  bool get isMobileDataConnected {
    return _currentConnectivityResults.contains(ConnectivityResult.mobile);
  }

  // Getter for the raw connectivity results
  List<ConnectivityResult> get currentConnectivityResults => _currentConnectivityResults;

  /// Call this when the no internet dialog is shown.
  void setNoInternetDialogShown(bool value) {
    _hasShownNoInternetDialog = value;
  }

  /// Checks if the no internet dialog has been shown.
  bool get hasShownNoInternetDialog => _hasShownNoInternetDialog;


  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }
}