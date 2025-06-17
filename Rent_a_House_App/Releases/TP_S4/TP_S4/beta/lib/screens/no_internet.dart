import 'package:flutter/material.dart';
//import 'package:local_auth/local_auth.dart';

class NoInternetScreen extends StatefulWidget {
  const NoInternetScreen({super.key});
  @override
  State<NoInternetScreen> createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [Text("Without Internet")],
        ),
      ),
    );
  }
}
