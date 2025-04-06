//Código desenvolvido por Kleber Andrade - Setembro 12, 2019
//Adaptado por Gabriel Cassino - Abril 06, 2025
//Source-base URL: https://medium.com/flutter-comunidade-br/consultando-ceps-com-flutter-a395b86ce34a

//Rode antes: flutter pub add http
//import 'package:http/http.dart'; //se precisar, descomente este import


import 'package:rent_a_house/pages/cep/viacep.dart';
import 'package:flutter/material.dart';

//main class
void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(),
    theme: ThemeData(brightness: Brightness.light, primarySwatch: Colors.amber),
    darkTheme: ThemeData(
      brightness: Brightness.dark,
    ),
  ));
}

//homepage class
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _searchCepController = TextEditingController();
  bool _loading = false;
  bool _enableField = true;
  String _result;

  @override
  void dispose() {
    super.dispose();
    _searchCepController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consultar CEP'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildSearchCepTextField(),
            _buildSearchCepButton(),
            _buildResultForm()
          ],
        ),
      ),
    );
  }

  Widget _buildSearchCepTextField() {
    return TextField(
      autofocus: true,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(labelText: 'Cep'),
      controller: _searchCepController,
      enabled: _enableField,
    );
  }

  Widget _buildSearchCepButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child:
      ElevatedButton(
        style: ElevatedButton.styleFrom(
           backgroundColor: Colors.blue,
           shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(5.0),
           ),
           side: const BorderSide(
              width: 2,
              color: Colors.black87,. 
            ),
         ),
        onPressed: _searchCep,
        child: _loading ? _circularLoading() : Text('Consultar',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  void _searching(bool enable) {
    setState(() {
      _result = enable ? '' : _result;
      _loading = enable;
      _enableField = !enable;
    });
  }

  Widget _circularLoading() {
    return Container(
      height: 15.0,
      width: 15.0,
      child: CircularProgressIndicator(),
    );
  }
  Future _searchCep() async {
    _searching(true);

    final cep = _searchCepController.text;

    final resultCep = await ViaCepService.fetchCep(cep: cep);
    print(resultCep.localidade); // Exibindo somente a localidade no terminal

    setState(() {
      _result = resultCep.toJson();
    });

    _searching(false);
  }

  Widget _buildResultForm() {
    return Container(
      padding: EdgeInsets.only(top: 20.0),
      child: Text(_result ?? ''),
    );
  }
}
