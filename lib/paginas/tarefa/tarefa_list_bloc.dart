import 'package:pialuno/modelos/tarefa_model.dart';
import 'package:pialuno/modelos/usuario_model.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;
import 'package:rxdart/rxdart.dart';

class TarefaListBlocEvent {}

class GetUsuarioAuthEvent extends TarefaListBlocEvent {
  final UsuarioModel usuarioAuth;
  GetUsuarioAuthEvent(this.usuarioAuth);
}

class GetAvaliacaoIDEvent extends TarefaListBlocEvent {
  final String avaliacaoID;
  GetAvaliacaoIDEvent(this.avaliacaoID);
}

class UpdateTarefaListEvent extends TarefaListBlocEvent {}

class TarefaListBlocState {
  bool isDataValid = false;
  UsuarioModel usuarioAuth;
  String avaliacaoID;
  List<TarefaModel> tarefaList = List<TarefaModel>();
}

class TarefaListBloc {
  /// Firestore
  final fsw.Firestore _firestore;
  final _authBloc;

  /// Eventos
  final _eventController = BehaviorSubject<TarefaListBlocEvent>();
  Stream<TarefaListBlocEvent> get eventStream => _eventController.stream;
  Function get eventSink => _eventController.sink.add;

  /// Estados
  final TarefaListBlocState _state = TarefaListBlocState();
  final _stateController = BehaviorSubject<TarefaListBlocState>();
  Stream<TarefaListBlocState> get stateStream => _stateController.stream;
  Function get stateSink => _stateController.sink.add;

  /// Bloc
  TarefaListBloc(this._firestore, this._authBloc) {
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

  _mapEventToState(TarefaListBlocEvent event) async {
    if (event is GetUsuarioAuthEvent) {
      _state.usuarioAuth = event.usuarioAuth;
    }
    if (event is GetAvaliacaoIDEvent) {
      _state.avaliacaoID = event.avaliacaoID;
      _authBloc.perfil.listen((usuarioAuth) {
        eventSink(GetUsuarioAuthEvent(usuarioAuth));
        eventSink(UpdateTarefaListEvent());
        if (!_stateController.isClosed) _stateController.add(_state);
      });
    }

    if (event is UpdateTarefaListEvent) {
      _state.tarefaList.clear();

      final streamDocsRemetente = _firestore
          .collection(TarefaModel.collection)
          // .where("ativo", isEqualTo: true)
          .where("avaliacao.id", isEqualTo: _state.avaliacaoID)
          .where("aluno.id", isEqualTo: _state.usuarioAuth.id)
          .where("inicio", isLessThan: DateTime.now())
          .snapshots();

      final snapListRemetente = streamDocsRemetente.map((snapDocs) => snapDocs
          .documents
          .map((doc) => TarefaModel(id: doc.documentID).fromMap(doc.data))
          .toList());

      snapListRemetente.listen((List<TarefaModel> tarefaList) {
        _state.tarefaList = tarefaList;
        if (!_stateController.isClosed) _stateController.add(_state);
      });
    }

    _validateData();
    if (!_stateController.isClosed) _stateController.add(_state);
    print('event.runtimeType em TarefaListBloc  = ${event.runtimeType}');
  }
}
