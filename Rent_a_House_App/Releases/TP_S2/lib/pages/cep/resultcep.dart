//Código desenvolvido por: Kleber Andrade - Setembro 12, 2019
//Adaptado por Gabriel Cassino - Abril 06, 2025
//Source-base URL: https://medium.com/flutter-comunidade-br/consultando-ceps-com-flutter-a395b86ce34a

//Rode antes: flutter pub add http
//import 'package:http/http.dart'; //se precisar, descomente este import

//Classe para receber os valores 

import 'dart:convert';

class ResultCep {
    String cep;
    String logradouro;
    String complemento;
    String bairro;
    String localidade;
    String uf;
    //String unidade;
    
  

    ResultCep({
        this.cep,
        this.logradouro,
        this.complemento,
        this.bairro,
        this.localidade,
        this.uf,
        //this.unidade,

    
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
        //unidade: json["unidade"],
    
    );

    Map<String, dynamic> toMap() => {
        "cep": cep,
        "logradouro": logradouro,
        "complemento": complemento,
        "bairro": bairro,
        "localidade": localidade,
        "uf": uf,
        //"unidade": unidade,
    
    };
}
