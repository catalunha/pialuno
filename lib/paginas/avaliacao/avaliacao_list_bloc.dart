import 'package:pialuno/modelos/avaliacao_model.dart';
import 'package:pialuno/modelos/usuario_model.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;
import 'package:rxdart/rxdart.dart';

class AvaliacaoListBlocEvent {}

class GetUsuarioAuthEvent extends AvaliacaoListBlocEvent {
  final UsuarioModel usuarioAuth;
  GetUsuarioAuthEvent(this.usuarioAuth);
}

class GetTurmaIDEvent extends AvaliacaoListBlocEvent {
  final String turmaID;
  GetTurmaIDEvent(this.turmaID);
}

class UpdateAvaliacaoListEvent extends AvaliacaoListBlocEvent {}

class AvaliacaoListBlocState {
  bool isDataValid = false;
  UsuarioModel usuarioAuth;
  String turmaID;
  List<AvaliacaoModel> avaliacaoList = List<AvaliacaoModel>();
}

class AvaliacaoListBloc {
  /// Firestore
  final fsw.Firestore _firestore;
  final _authBloc;

  /// Eventos
  final _eventController = BehaviorSubject<AvaliacaoListBlocEvent>();
  Stream<AvaliacaoListBlocEvent> get eventStream => _eventController.stream;
  Function get eventSink => _eventController.sink.add;

  /// Estados
  final AvaliacaoListBlocState _state = AvaliacaoListBlocState();
  final _stateController = BehaviorSubject<AvaliacaoListBlocState>();
  Stream<AvaliacaoListBlocState> get stateStream => _stateController.stream;
  Function get stateSink => _stateController.sink.add;

  /// Bloc
  AvaliacaoListBloc(this._firestore, this._authBloc) {
    eventStream.listen(_mapEventToState);
  }

  void dispose() async {
    await _stateController.drain();
    _stateController.close();
    await _eventController.drain();
    _eventController.close();
  }

  _validateData() {
    _state.isDataValid = true;
  }

  _mapEventToState(AvaliacaoListBlocEvent event) async {
    if (event is GetUsuarioAuthEvent) {
      _state.usuarioAuth = event.usuarioAuth;
    }
    if (event is GetTurmaIDEvent) {
      _state.turmaID = event.turmaID;
      _authBloc.perfil.listen((usuarioAuth) {
        eventSink(GetUsuarioAuthEvent(usuarioAuth));
        eventSink(UpdateAvaliacaoListEvent());
        if (!_stateController.isClosed) _stateController.add(_state);
      });
    }

    if (event is UpdateAvaliacaoListEvent) {
      _state.avaliacaoList.clear();

      final streamDocsRemetente = _firestore
          .collection(AvaliacaoModel.collection)
          .where("aplicadaPAluno", arrayContains: _state.usuarioAuth.id)
          .where("ativo", isEqualTo: true)
          .where("aplicada", isEqualTo: true)
          .where("turma.id", isEqualTo: _state.turmaID)
          .snapshots();

      final snapListRemetente = streamDocsRemetente.map((snapDocs) => snapDocs
          .documents
          .map((doc) => AvaliacaoModel(id: doc.documentID).fromMap(doc.data))
          .toList());

      snapListRemetente.listen((List<AvaliacaoModel> avaliacaoList) {
        _state.avaliacaoList = avaliacaoList;
        if (!_stateController.isClosed) _stateController.add(_state);
      });
    }

    _validateData();
    if (!_stateController.isClosed) _stateController.add(_state);
    print('event.runtimeType em AvaliacaoListBloc  = ${event.runtimeType}');
  }
}
