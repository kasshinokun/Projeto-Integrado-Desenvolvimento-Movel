//Código desenvolvido por: Kleber Andrade - Setembro 12, 2019
//Adaptado por Gabriel Cassino - Abril 06, 2025
//Source-base URL: https://medium.com/flutter-comunidade-br/consultando-ceps-com-flutter-a395b86ce34a

//Rode antes: flutter pub add http
//import 'package:http/http.dart'; //se precisar, descomente este import

//Classe para receber os valores

import 'dart:convert';

class ResultCep {
  String? cep;
  String? logradouro;
  String? complemento;
  String? bairro;
  String? localidade;
  String? uf;
  String? estado;

  ResultCep({
    this.cep,
    this.logradouro,
    this.complemento,
    this.bairro,
    this.localidade,
    this.uf,
    this.estado,
  });

  factory ResultCep.fromJson(String str) => ResultCep.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ResultCep.fromMap(Map<String, dynamic> json) => ResultCep(
    cep: json["cep"],
    logradouro: json["logradouro"],
    complemento: json["complemento"],
    bairro: json["bairro"],
    localidade: json["localidade"],
    uf: json["uf"],
    estado: json["estado"],
  );

  String? _estado() => getState[uf].toString();

  final getState = {
    "AC": "Acre",
    "AL": "Alagoas",
    "AP": "Amapá",
    "AM": "Amazonas",
    "BA": "Bahia",
    "CE": "Ceará",
    "DF": "Distrito Federal",
    "ES": "Espírito Santo",
    "GO": "Goiás",
    "MA": "Maranhão",
    "MT": "Mato Grosso",
    "MS": "Mato Grosso do Sul",
    "MG": "Minas Gerais",
    "PA": "Pará",
    "PB": "Paraíba",
    "PR": "Paraná",
    "PE": "Pernambuco",
    "PI": "Piauí",
    "RJ": "Rio de Janeiro",
    "RN": "Rio Grande do Norte",
    "RS": "Rio Grande do Sul",
    "RO": "Rondônia",
    "RR": "Roraima",
    "SC": "Santa Catarina",
    "SP": "São Paulo",
    "SE": "Sergipe",
    "TO": "Tocantins",
  };

  Map<String, dynamic> toMap() => {
    "cep": cep,
    "logradouro": logradouro,
    "complemento": complemento,
    "bairro": bairro,
    "localidade": localidade,
    "uf": uf,
    "estado": _estado(),
  };
}
