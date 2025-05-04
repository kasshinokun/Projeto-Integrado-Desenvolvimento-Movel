import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> adicionarDocumento({
    required String colecao,
    required Map<String, dynamic> dados,
  }) async {
    await _db.collection(colecao).add(dados);
  }

  Stream<QuerySnapshot> lerDocumentos(String colecao) {
    return _db.collection(colecao).snapshots();
  }


  Future<void> atualizarDocumento({
    required String colecao,
    required String idDocumento,
    required Map<String, dynamic> novosDados,
  }) async {
    await _db.collection(colecao).doc(idDocumento).update(novosDados);
  }

  Future<void> deletarDocumento({
    required String colecao,
    required String idDocumento,
  }) async {
    await _db.collection(colecao).doc(idDocumento).delete();
  }
}
