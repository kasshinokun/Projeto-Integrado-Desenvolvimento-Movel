// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rent_a_house/services/teste/codigo_2.dart';
import 'package:rent_a_house/services/teste/codigo_1.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ConnectivityProvider(),
      child: MaterialApp(
        title: 'Connectivity Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // Define your routes
        routes: {
          '/': (context) => const ConnectivityListener(child: HomePage()), // Home page
          '/nointernet': (context) => const NoInternetPage(), // No Internet page
        },
        initialRoute: '/',
      ),
    );
  }
}

// Example Home Page
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // You can also access connectivity status here if needed
    final connectivityProvider = Provider.of<ConnectivityProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to the Home Page!',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            Text(
              'Current Connectivity: ${connectivityProvider.isConnected ? 'Online' : 'Offline'}',
              style: TextStyle(fontSize: 18, color: connectivityProvider.isConnected ? Colors.green : Colors.red),
            ),
            Text('Wi-Fi: ${connectivityProvider.isWifiConnected ? 'Connected' : 'Disconnected'}'),
            Text('Mobile Data: ${connectivityProvider.isMobileDataConnected ? 'Connected' : 'Disconnected'}'),
          ],
        ),
      ),
    );
  }
}

// Example No Internet Page
class NoInternetPage extends StatelessWidget {
  const NoInternetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('No Internet'),
        automaticallyImplyLeading: false, // Prevent going back from here
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off, size: 100, color: Colors.grey),
            SizedBox(height: 20),
            Text(
              'You are offline.',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Please check your internet connection.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}