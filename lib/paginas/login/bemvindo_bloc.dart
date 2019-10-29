import 'package:pialuno/modelos/usuario_model.dart';
import 'package:rxdart/rxdart.dart';

class BemvindoBlocEvent {}

class GetUsuarioIDEvent extends BemvindoBlocEvent {
  final UsuarioModel usuarioID;

  GetUsuarioIDEvent(this.usuarioID);
}

class BemvindoBlocState {
  bool isDataValid = false;

  UsuarioModel usuarioID;
}

class BemvindoBloc {
  final _authBloc;

  /// Eventos
  final _eventController = BehaviorSubject<BemvindoBlocEvent>();
  Stream<BemvindoBlocEvent> get eventStream => _eventController.stream;
  Function get eventSink => _eventController.sink.add;

  /// Estados
  final BemvindoBlocState _state = BemvindoBlocState();
  final _stateController = BehaviorSubject<BemvindoBlocState>();
  Stream<BemvindoBlocState> get stateStream => _stateController.stream;
  Function get stateSink => _stateController.sink.add;

  /// Bloc
  BemvindoBloc(
    this._authBloc
  ) {
    eventStream.listen(_mapEventToState);
    _authBloc.perfil.listen((usuarioID) {
      eventSink(GetUsuarioIDEvent(usuarioID));
    });
  }

  void dispose() async {
    await _stateController.drain();
    _stateController.close();
    await _eventController.drain();
    _eventController.close();
  }

  _validateData() {
    _state.isDataValid = false;
    if (_state?.usuarioID != null) {
      _state.isDataValid = true;
    }
  }

  _mapEventToState(BemvindoBlocEvent event) async {
    if (event is GetUsuarioIDEvent) {
      _state.usuarioID = event.usuarioID;
    }

    _validateData();
    if (!_stateController.isClosed) _stateController.add(_state);
    print('event.runtimeType em BemvindoBloc  = ${event.runtimeType}');
  }
}
