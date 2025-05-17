class Logradouro {
  final int? id;
  final String cep;
  final String logradouro;
  Logradouro({this.id, required this.cep, required this.logradouro});

  Map<String, dynamic> toMap() {
    return {'id': id, 'cep': cep, 'logradouro': logradouro};
  }

  factory Logradouro.fromMap(Map<String, dynamic> map) {
    return Logradouro(
      id: map['id'],
      cep: map['cep'],
      logradouro: map['logradouro'],
    );
  }
}
