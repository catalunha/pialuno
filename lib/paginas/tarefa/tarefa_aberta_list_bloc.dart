import 'package:pialuno/modelos/tarefa_model.dart';
import 'package:pialuno/modelos/usuario_model.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;
import 'package:rxdart/rxdart.dart';

class TarefaAbertaListBlocEvent {}

class GetUsuarioAuthEvent extends TarefaAbertaListBlocEvent {
  final UsuarioModel usuarioAuth;

  GetUsuarioAuthEvent(this.usuarioAuth);
}

class UpdateTarefaAbertaListEvent extends TarefaAbertaListBlocEvent {}

class TarefaAbertaListBlocState {
  bool isDataValid = false;
  UsuarioModel usuarioAuth;
  List<TarefaModel> tarefaList = List<TarefaModel>();
}

class TarefaAbertaListBloc {
  /// Firestore
  final fsw.Firestore _firestore;
  final _authBloc;

  /// Eventos
  final _eventController = BehaviorSubject<TarefaAbertaListBlocEvent>();
  Stream<TarefaAbertaListBlocEvent> get eventStream => _eventController.stream;
  Function get eventSink => _eventController.sink.add;

  /// Estados
  final TarefaAbertaListBlocState _state = TarefaAbertaListBlocState();
  final _stateController = BehaviorSubject<TarefaAbertaListBlocState>();
  Stream<TarefaAbertaListBlocState> get stateStream => _stateController.stream;
  Function get stateSink => _stateController.sink.add;

  /// Bloc
  TarefaAbertaListBloc(this._firestore, this._authBloc) {
    eventStream.listen(_mapEventToState);
    _authBloc.perfil.listen((usuarioAuth) {
      eventSink(GetUsuarioAuthEvent(usuarioAuth));
      if (!_stateController.isClosed) _stateController.add(_state);
      eventSink(UpdateTarefaAbertaListEvent());
    });
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

  _mapEventToState(TarefaAbertaListBlocEvent event) async {
    if (event is GetUsuarioAuthEvent) {
      _state.usuarioAuth = event.usuarioAuth;
    }
    if (event is UpdateTarefaAbertaListEvent) {
      _state.tarefaList.clear();

      final streamDocsRemetente =
          _firestore.collection(TarefaModel.collection)
          .where("aluno.id", isEqualTo: _state.usuarioAuth.id)
          .where("ativo", isEqualTo: true)
          .where("aberta", isEqualTo: true)
          .where("inicio", isGreaterThan: DateTime.now())
          .where("fim", isLessThan: DateTime.now())
          .snapshots();

      final snapListRemetente = streamDocsRemetente.map((snapDocs) => snapDocs
          .documents
          .map((doc) => TarefaModel(id: doc.documentID).fromMap(doc.data))
          .toList());

      snapListRemetente.listen((List<TarefaModel> tarefaList) {
        _state.tarefaList=tarefaList;
        if (!_stateController.isClosed) _stateController.add(_state);
      });
    }

    _validateData();
    if (!_stateController.isClosed) _stateController.add(_state);
    print('event.runtimeType em TarefaAbertaListBloc  = ${event.runtimeType}');
  }
}
