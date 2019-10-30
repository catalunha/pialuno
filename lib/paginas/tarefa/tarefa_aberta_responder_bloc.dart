import 'package:pialuno/modelos/tarefa_model.dart';
import 'package:pialuno/modelos/usuario_model.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;
import 'package:rxdart/rxdart.dart';

class TarefaAbertaResponderBlocEvent {}

class GetTarefaEvent extends TarefaAbertaResponderBlocEvent {
  final String tarefaID;

  GetTarefaEvent(this.tarefaID);
}
class UpdatePedeseEvent extends TarefaAbertaResponderBlocEvent {
  final String pedeseKey;
  final String valor;

  UpdatePedeseEvent(this.pedeseKey, this.valor);
}
class TarefaAbertaResponderBlocState {
  bool isDataValid = false;
  TarefaModel tarefaModel = TarefaModel();
}

class TarefaAbertaResponderBloc {
  /// Firestore
  final fsw.Firestore _firestore;

  /// Eventos
  final _eventController = BehaviorSubject<TarefaAbertaResponderBlocEvent>();
  Stream<TarefaAbertaResponderBlocEvent> get eventStream =>
      _eventController.stream;
  Function get eventSink => _eventController.sink.add;

  /// Estados
  final TarefaAbertaResponderBlocState _state =
      TarefaAbertaResponderBlocState();
  final _stateController = BehaviorSubject<TarefaAbertaResponderBlocState>();
  Stream<TarefaAbertaResponderBlocState> get stateStream =>
      _stateController.stream;
  Function get stateSink => _stateController.sink.add;

  /// Bloc
  TarefaAbertaResponderBloc(this._firestore) {
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

  _mapEventToState(TarefaAbertaResponderBlocEvent event) async {
    if (event is GetTarefaEvent) {
      final streamDocsSnap = _firestore
          .collection(TarefaModel.collection)
          .document(event.tarefaID)
          .snapshots();

      final snapTarefa = streamDocsSnap
          .map((doc) => TarefaModel(id: doc.documentID).fromMap(doc.data));
      snapTarefa.listen((TarefaModel tarefa) {
        _state.tarefaModel = tarefa;
        if (!_stateController.isClosed) _stateController.add(_state);
      });
    }
    if (event is UpdatePedeseEvent) {
      print('UpdatePedeseEvent: ${event.pedeseKey} = ${event.valor}');
    }
    

    _validateData();
    if (!_stateController.isClosed) _stateController.add(_state);
    print(
        'event.runtimeType em TarefaAbertaResponderBloc  = ${event.runtimeType}');
  }
}
