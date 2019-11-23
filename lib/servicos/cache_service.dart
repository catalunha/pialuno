import 'package:firestore_wrapper/firestore_wrapper.dart' as fw;
import 'package:pialuno/modelos/tarefa_model.dart';

class CacheServiceEvent {}

class CacheService {
  final fw.Firestore _firestore;
  final _authBloc;

  CacheService(this._firestore, this._authBloc);

  load() async {
    _authBloc.perfil.listen((usuarioAuth) async {
      await _firestore
          .collection(TarefaModel.collection)
          .where("aluno.id", isEqualTo: usuarioAuth.id)
          // .where("aberta", isEqualTo: true)
          .where("fim", isGreaterThan: DateTime.now())
          .getDocuments();
    });
  }
}
