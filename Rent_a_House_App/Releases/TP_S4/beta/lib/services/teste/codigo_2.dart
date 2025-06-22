// lib/widgets/connectivity_listener.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider package
import 'package:rent_a_house/services/teste/codigo_1.dart';

/// A StatelessWidget that listens to connectivity changes via ConnectivityProvider
/// and manages navigation and dialogs based on network status.
class ConnectivityListener extends StatefulWidget {
  final Widget child;

  const ConnectivityListener({super.key, required this.child});

  @override
  State<ConnectivityListener> createState() => _ConnectivityListenerState();
}

class _ConnectivityListenerState extends State<ConnectivityListener> {
  // We no longer need StreamSubscription here as the provider handles it.

  @override
  void initState() {
    super.initState();
    // No direct subscription needed here, we'll use Consumer/Selector or listen in build
    // but the initial check should happen via the provider's constructor.
  }

  /// Shows a connectivity status dialog.
  Future<void> _showConnectivityDialog(BuildContext context, String message, bool isConnected) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button to dismiss
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(isConnected ? 'Connected!' : 'No Internet'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss the dialog
              },
            ),
          ],
        );
      },
    );
  }

  /// Handles navigation based on connectivity.
  void _handleNavigation(BuildContext context, ConnectivityProvider connectivityProvider) async {
    final currentRoute = ModalRoute.of(context);
    final isNoInternetRoute = currentRoute?.settings.name == '/nointernet';
    //final isHomePageRoute = currentRoute?.settings.name == '/'; // Assuming home page is '/'

    // If connectivity status hasn't changed or dialog already shown for this state, do nothing
    if (connectivityProvider.isConnected && !connectivityProvider.hasShownNoInternetDialog && isNoInternetRoute) {
      // Was disconnected, now connected. Show dialog, then navigate.
      connectivityProvider.setNoInternetDialogShown(true); // Prevent re-showing immediately
      await _showConnectivityDialog(context, 'You are back online!', true);
      if (mounted) {
        Navigator.of(context).popUntil((route) => route.settings.name == '/'); // Go back to home
      }
      connectivityProvider.setNoInternetDialogShown(false); // Reset for next disconnection
    } else if (!connectivityProvider.isConnected && !connectivityProvider.hasShownNoInternetDialog && !isNoInternetRoute) {
      // Was connected, now disconnected. Show dialog, then navigate.
      connectivityProvider.setNoInternetDialogShown(true); // Prevent re-showing immediately
      await _showConnectivityDialog(context, 'You are disconnected from the internet.', false);
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/nointernet');
      }
    } else if (connectivityProvider.isConnected && connectivityProvider.hasShownNoInternetDialog && isNoInternetRoute) {
      // If we are on the no internet route and just reconnected but dialog was shown, pop.
      // This handles cases where the user might dismiss the dialog manually.
      if (mounted) {
        Navigator.of(context).popUntil((route) => route.settings.name == '/');
      }
      connectivityProvider.setNoInternetDialogShown(false); // Reset for next disconnection
    }
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityProvider>(
      builder: (context, connectivityProvider, child) {
        // Schedule the navigation and dialog handling after the build
        // to avoid "setState during build" issues.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          _handleNavigation(context, connectivityProvider);
        });
        return widget.child;
      },
    );
  }
}