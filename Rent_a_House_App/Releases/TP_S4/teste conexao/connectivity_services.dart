// lib/services/connectivity_service.dart

import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async'; // For StreamSubscription

/// A service class to manage and provide network connectivity status.
class ConnectivityService {
  // Singleton instance of Connectivity to ensure consistent monitoring.
  static final Connectivity _connectivity = Connectivity();

  /// Provides a stream of connectivity changes.
  /// Emits a list of [ConnectivityResult] whenever the network status changes.
  static Stream<List<ConnectivityResult>> get connectivityStream =>
      _connectivity.onConnectivityChanged;

  /// Checks the current connectivity status.
  /// Returns `true` if there's any active connection (not `none`).
  static Future<bool> isConnected() async {
    final result = await _connectivity.checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }
}

/// A StatelessWidget that listens to connectivity changes and navigates
/// to a 'no internet' screen when disconnected, and pops it when connected.
class ConnectivityListener extends StatefulWidget {
  final Widget child;

  const ConnectivityListener({super.key, required this.child});

  @override
  State<ConnectivityListener> createState() => _ConnectivityListenerState();
}

class _ConnectivityListenerState extends State<ConnectivityListener> {
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _connectivitySubscription = ConnectivityService.connectivityStream.listen((
      results,
    ) {
      _handleConnectivityChange(results);
    });
  }

  /// Handles connectivity changes by navigating to/from the no internet screen.
  void _handleConnectivityChange(List<ConnectivityResult> results) {
    bool isConnected = !results.contains(ConnectivityResult.none);

    // Schedule the navigation after the current frame to avoid build errors.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return; // Ensure the widget is still mounted

      final currentRoute = ModalRoute.of(context);
      final isNoInternetRoute = currentRoute?.settings.name == '/nointernet';

      if (!isConnected) {
        // If disconnected and not already on the no internet screen, navigate.
        if (!isNoInternetRoute) {
          Navigator.of(context).pushReplacementNamed('/nointernet');
        }
      } else {
        // If connected and currently on the no internet screen, pop it.
        if (isNoInternetRoute) {
          Navigator.of(context).pop();
        }
      }
    });
  }

  @override
  void dispose() {
    _connectivitySubscription
        ?.cancel(); // Cancel the subscription to prevent memory leaks.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
