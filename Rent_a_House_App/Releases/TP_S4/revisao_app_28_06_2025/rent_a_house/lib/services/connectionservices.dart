//Bibliotecas Default
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  static final Connectivity _connectivity = Connectivity();
  static Stream<List<ConnectivityResult>> get connectivityStream =>
      _connectivity.onConnectivityChanged;

  static Future<bool> isConnected() async {
    final result = await _connectivity.checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }
}

class ConnectivityListener extends StatelessWidget {
  final Widget child;

  const ConnectivityListener({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ConnectivityResult>>(
      stream: ConnectivityService.connectivityStream,
      builder: (context, snapshot) {
        final isConnected =
            !(snapshot.data?.contains(ConnectivityResult.none) ?? true);

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!isConnected) {
            // Navigate to No Internet Screen if disconnected
            Navigator.pushReplacementNamed(context, '/nointernet');
            Navigator.popAndPushNamed(context, '/nointernet');
          } else {
            // Pop No Internet Screen if connected
            if (Navigator.canPop(context)) Navigator.pop(context);
          }
        });

        return child;
      },
    );
  }
}
