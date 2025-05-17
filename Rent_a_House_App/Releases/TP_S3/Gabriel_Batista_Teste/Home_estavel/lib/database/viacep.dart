//Código desenvolvido por Kleber Andrade - Setembro 12, 2019
//Adaptado por Gabriel Cassino - Abril 06, 2025
//Source-base URL: https://medium.com/flutter-comunidade-br/consultando-ceps-com-flutter-a395b86ce34a

//Rode antes: flutter pub add http
//import 'package:http/http.dart'; //se precisar, descomente este import

import 'package:http/http.dart' as httptasker;
import 'package:rent_a_house/database/resultcep.dart';

class ViaCepService {
  static Future<ResultCep> fetchCep({String? cep}) async {
    final response = await httptasker.get(
      Uri.parse('https://viacep.com.br/ws/$cep/json/'),
    );
    if (response.statusCode == 200) {
      return ResultCep.fromJson(response.body);
    } else {
      throw Exception('Requisição inválida!');
    }
  }
}
