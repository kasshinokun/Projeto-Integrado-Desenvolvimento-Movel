import 'package:flutter/material.dart';
import 'package:rent_a_house/screens/internet.dart';
import 'package:rent_a_house/screens/no_internet.dart';
import 'package:provider/provider.dart';
import 'package:rent_a_house/services/teste/internetprovider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Internet Connection App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Consumer<InternetConnectionProvider>(
        builder: (context, internetProvider, child) {
          // This Consumer rebuilds whenever notifyListeners() is called in InternetConnectionProvider
          return const ConnectionHandlerScreen(); // Delegate connection handling to a separate widget
        },
      ),
    );
  }
}

// Separate widget to handle showing dialog and changing pages
class ConnectionHandlerScreen extends StatefulWidget {
  const ConnectionHandlerScreen({super.key});

  @override
  State<ConnectionHandlerScreen> createState() =>
      _ConnectionHandlerScreenState();
}

class _ConnectionHandlerScreenState extends State<ConnectionHandlerScreen> {
  bool _lastConnectionStatus = false; // To track the previous state

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize _lastConnectionStatus with the current status when the widget first builds
    if (mounted && _lastConnectionStatus == false) {
      // Only set once on initial build
      _lastConnectionStatus = Provider.of<InternetConnectionProvider>(
        context,
        listen: false,
      ).isConnectedToInternet;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InternetConnectionProvider>(
      builder: (context, internetProvider, child) {
        final currentConnectionStatus = internetProvider.isConnectedToInternet;

        // Show dialog only if the connection status has actually changed
        if (currentConnectionStatus != _lastConnectionStatus) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showStatusDialog(context, currentConnectionStatus);
          });
          _lastConnectionStatus =
              currentConnectionStatus; // Update the last status
        }
        if (currentConnectionStatus) {
          return InternetScreen();
        } else {
          return NoInternetScreen();
        }
      },
    );
  }

  void _showStatusDialog(BuildContext context, bool isConnected) {
    String title = isConnected ? "Online!" : "Offline!";
    String content = isConnected
        ? "You are back online."
        : "You are currently offline.";
    Color dialogColor = isConnected ? Colors.green : Colors.red;

    showDialog(
      context: context,
      barrierDismissible: false, // User must tap button to dismiss
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
                Navigator.of(dialogContext).pop(); // Dismiss the dialog
              },
            ),
          ],
        );
      },
    );
  }
}
