import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
import 'package:rent_a_house/pages/test/firebasesqflite/model/localuser.dart';

class LocalAuthService extends ChangeNotifier {
  final GlobalKey<ScaffoldMessengerState> snackbarKey =
      GlobalKey<ScaffoldMessengerState>();
  LocalUser? localusuario;
  String? idToken;
  bool isLoading = true;
}

Widget locaLoading() {
  return Scaffold(body: Center(child: CircularProgressIndicator()));
}
