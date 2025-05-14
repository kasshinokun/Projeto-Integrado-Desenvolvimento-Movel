import 'package:flutter/material.dart';

//Classes
//Lottie
import 'package:lottie/lottie.dart';
import 'package:rent_a_house/pages/test/connectionpage.dart';

//Isolar depois---------------------------------------------------------------------------------------------------------------
class NoInternet extends StatefulWidget {
  const NoInternet({super.key});

  @override
  State<NoInternet> createState() => _NoInternetState();
}

class _NoInternetState extends State<NoInternet> {
  @override
  Widget build(BuildContext context) {
    final hasConnection = ConnectionNotifier.of(context).value;
    String asset = hasConnection ? 'network' : 'no_connection';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text('No internet Demonstração'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[Lottie.asset('asset/$asset.json')],
        ),
      ),
    );
  }
}
