import 'package:pialuno/modelos/turma_model.dart';
import 'package:pialuno/modelos/usuario_model.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;
import 'package:rxdart/rxdart.dart';

class TurmaListBlocEvent {}

class GetUsuarioAuthEvent extends TurmaListBlocEvent {
  final UsuarioModel usuarioAuth;

  GetUsuarioAuthEvent(this.usuarioAuth);
}

class UpdateTurmaListEvent extends TurmaListBlocEvent {}

class TurmaListBlocState {
  bool isDataValid = false;
  UsuarioModel usuarioAuth;
  List<TurmaModel> turmaList = List<TurmaModel>();
}

class TurmaListBloc {
  /// Firestore
  final fsw.Firestore _firestore;
  final _authBloc;

  /// Eventos
  final _eventController = BehaviorSubject<TurmaListBlocEvent>();
  Stream<TurmaListBlocEvent> get eventStream => _eventController.stream;
  Function get eventSink => _eventController.sink.add;

  /// Estados
  final TurmaListBlocState _state = TurmaListBlocState();
  final _stateController = BehaviorSubject<TurmaListBlocState>();
  Stream<TurmaListBlocState> get stateStream => _stateController.stream;
  Function get stateSink => _stateController.sink.add;

  /// Bloc
  TurmaListBloc(this._firestore, this._authBloc) {
    eventStream.listen(_mapEventToState);
    _authBloc.perfil.listen((usuarioAuth) {
      eventSink(GetUsuarioAuthEvent(usuarioAuth));
      if (!_stateController.isClosed) _stateController.add(_state);
      eventSink(UpdateTurmaListEvent());
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

  _mapEventToState(TurmaListBlocEvent event) async {
    if (event is GetUsuarioAuthEvent) {
      _state.usuarioAuth = event.usuarioAuth;
    }

    if (event is UpdateTurmaListEvent) {
      _state.turmaList.clear();

      final colRef = _firestore.collection(TurmaModel.collection);
      for (var turma in _state.usuarioAuth.turma) {
        final docRef = colRef.document(turma);
        final snap = await docRef.get();
        if (snap.exists) {
          _state.turmaList
              .add(TurmaModel(id: snap.documentID).fromMap(snap.data));
        }
      }

      // final streamDocsRemetente = _firestore
      //     .collection(TurmaModel.collection)
      //     .where("alunoList", arrayContains: _state.usuarioAuth.id)
      //     .where("ativo", isEqualTo: true)
      //     .snapshots();

      // final snapListRemetente = streamDocsRemetente.map((snapDocs) => snapDocs
      //     .documents
      //     .map((doc) => TurmaModel(id: doc.documentID).fromMap(doc.data))
      //     .toList());

      // snapListRemetente.listen((List<TurmaModel> turmaList) {
      //   _state.turmaList = turmaList;
      //   if (!_stateController.isClosed) _stateController.add(_state);
      // });
    }

    _validateData();
    if (!_stateController.isClosed) _stateController.add(_state);
    print('event.runtimeType em TurmaListBloc  = ${event.runtimeType}');
  }
}
