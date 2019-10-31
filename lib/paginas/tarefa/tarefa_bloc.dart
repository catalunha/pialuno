import 'package:pialuno/modelos/tarefa_model.dart';
import 'package:pialuno/modelos/usuario_model.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;
import 'package:rxdart/rxdart.dart';

class TarefaBlocEvent {}

class GetUsuarioAuthEvent extends TarefaBlocEvent {
  final UsuarioModel usuarioAuth;
  GetUsuarioAuthEvent(this.usuarioAuth);
}

class GetQuestaoIDEvent extends TarefaBlocEvent {
  final String questaoID;
  GetQuestaoIDEvent(this.questaoID);
}

class UpdateTarefaEvent extends TarefaBlocEvent {}

class TarefaBlocState {
  bool isDataValid = false;
  bool maisQ1Tarefa = true;
  UsuarioModel usuarioAuth;
  String questaoID;
  TarefaModel tarefaModel;
}

class TarefaBloc {
  /// Firestore
  final fsw.Firestore _firestore;
  final _authBloc;

  /// Eventos
  final _eventController = BehaviorSubject<TarefaBlocEvent>();
  Stream<TarefaBlocEvent> get eventStream => _eventController.stream;
  Function get eventSink => _eventController.sink.add;

  /// Estados
  final TarefaBlocState _state = TarefaBlocState();
  final _stateController = BehaviorSubject<TarefaBlocState>();
  Stream<TarefaBlocState> get stateStream => _stateController.stream;
  Function get stateSink => _stateController.sink.add;

  /// Bloc
  TarefaBloc(this._firestore, this._authBloc) {
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
    if (_state.maisQ1Tarefa) {
      _state.isDataValid = false;
    }
  }

  _mapEventToState(TarefaBlocEvent event) async {
    if (event is GetUsuarioAuthEvent) {
      _state.usuarioAuth = event.usuarioAuth;
    }
    if (event is GetQuestaoIDEvent) {
      _state.questaoID = event.questaoID;
      _authBloc.perfil.listen((usuarioAuth) {
        eventSink(GetUsuarioAuthEvent(usuarioAuth));
        eventSink(UpdateTarefaEvent());
        if (!_stateController.isClosed) _stateController.add(_state);
      });
    }

    if (event is UpdateTarefaEvent) {
      final streamDocsRemetente = await _firestore
          .collection(TarefaModel.collection)
          .where("questao.id", isEqualTo: _state.questaoID)
          .where("aluno.id", isEqualTo: _state.usuarioAuth.id)
          .getDocuments();

      List<TarefaModel> tarefaList = streamDocsRemetente.documents
          .map((doc) => TarefaModel(id: doc.documentID).fromMap(doc.data))
          .toList();
        print('tarefaList::::> ${tarefaList.length}');
      if (tarefaList==null || tarefaList.length != 1) {
        _state.maisQ1Tarefa = true;
      } else {
        _state.maisQ1Tarefa = false;
        _state.tarefaModel = tarefaList.first;
      }
    }

    _validateData();
    if (!_stateController.isClosed) _stateController.add(_state);
    print('event.runtimeType em TarefaBloc  = ${event.runtimeType}');
  }
}
