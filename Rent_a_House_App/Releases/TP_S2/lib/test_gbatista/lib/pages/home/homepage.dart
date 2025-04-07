import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: Padding(
          //-----------------------------------> padding
          padding: EdgeInsets.only(right: 16.0),
          child: IconButton(
            // ------> Icone Home
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/');
              Navigator.popAndPushNamed(context, '/');
            },
            icon: Icon(Icons.home_rounded),
          ), // Fim do Icone Home
        ), // Fim do Padding
        title: Text(widget.title),
        actions: [
          //-----------------------------------> Actions
          Padding(
            //-----------------------------------> padding
            padding: EdgeInsets.only(right: 16.0),
            child: IconButton(
              // ------> Icone Home
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/responsive');
                Navigator.popAndPushNamed(context, '/responsive');
              },
              icon: Icon(Icons.window_rounded),
            ), // Fim do Icone Windows
          ), // Fim do Padding
        ], // Fim do Actions
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
