import 'dart:async';
import 'package:pialuno/auth_bloc.dart';
import 'package:pialuno/modelos/upload_model.dart';
import 'package:pialuno/modelos/usuario_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;

/// Class base Eventos da Pagina Perfil
class PerfilEvent {}

class GetUsuarioAuthEvent extends PerfilEvent {}

class UpdateCrachaEvent extends PerfilEvent {
  final String cracha;

  UpdateCrachaEvent(this.cracha);
}

class UpdateCelularEvent extends PerfilEvent {
  final String celular;

  UpdateCelularEvent(this.celular);
}

class UpdateFotoEvent extends PerfilEvent {
  final String localPath;

  UpdateFotoEvent(this.localPath);
}

class SaveEvent extends PerfilEvent {}

/// Class base Estado da Pagina Perfil
class PerfilState {
  UsuarioModel usuarioModel;

  String cracha;
  String celular;
  String fotoUploadID;
  String fotoUrl;
  String localPath;

  void updateStateFromUsuarioModel() {
    cracha = usuarioModel.cracha;
    celular = usuarioModel.celular;
    fotoUploadID = usuarioModel?.foto?.uploadID;
    fotoUrl = usuarioModel?.foto?.url;
    localPath = usuarioModel?.foto?.path;
  }
}

/// class Bloc para Perfil
class PerfilBloc {
  final fsw.Firestore _firestore;

  // Authenticacação
  AuthBloc _authBloc;

  // Eventos da Página
  final _eventController = BehaviorSubject<PerfilEvent>();
  Stream<PerfilEvent> get eventStream => _eventController.stream;
  Function get eventSink => _eventController.sink.add;

  // Estados da Página
  final PerfilState _state = PerfilState();
  final _stateController = BehaviorSubject<PerfilState>();
  Stream<PerfilState> get stateStream => _stateController.stream;
  Function get stateSink => _stateController.sink.add;

  PerfilBloc(this._firestore, this._authBloc) {
    eventStream.listen(_mapEventToState);
    eventSink(GetUsuarioAuthEvent());
  }
  void dispose() async {
    await _eventController.drain();
    _eventController.close();
    await _stateController.drain();
    _stateController.close();
  }

  void _mapEventToState(PerfilEvent event) async {
    if (event is GetUsuarioAuthEvent) {
      _authBloc.perfil.listen((usuario) {
        _state.usuarioModel = usuario;
        _state.updateStateFromUsuarioModel();
        if (!_stateController.isClosed) _stateController.add(_state);
      });
    }

    if (event is SaveEvent) {
      UploadFk foto;
      UsuarioModel usuarioUpdate = UsuarioModel(
        id: _state.usuarioModel.id,
        cracha: _state.cracha,
        celular: _state.celular,
      );
      if (_state.localPath != null) {
        // Deletar uploadID anterior se existir
        if (_state.fotoUploadID != null) {
          final docRef = _firestore
              .collection(UploadModel.collection)
              .document(_state.fotoUploadID);
          await docRef.delete();
          _state.fotoUploadID = null;
        }
        //+++ Cria doc em UpLoadCollection
        final upLoadModel = UploadModel(
          usuario: _state.usuarioModel.id,
          path: _state.localPath,
          upload: false,
          updateCollection: UpdateCollection(
              collection: UsuarioModel.collection,
              document: _state.usuarioModel.id,
              field: "foto.url"),
        );
        final docRef = _firestore
            .collection(UploadModel.collection)
            .document(_state.fotoUploadID);
        await docRef.setData(upLoadModel.toMap(), merge: true);
        _state.fotoUploadID = docRef.documentID;
        //--- Cria doc em UpLoadCollection
        foto = UploadFk(uploadID: _state.fotoUploadID,url:null,path: _state.localPath);
        usuarioUpdate.foto=foto;
      }

      final docRef2 = _firestore
          .collection(UsuarioModel.collection)
          .document(_state.usuarioModel.id);

      await docRef2.setData(usuarioUpdate.toMap(), merge: true);
    }
    if (event is UpdateCrachaEvent) {
      _state.cracha = event.cracha;
    }
    if (event is UpdateCelularEvent) {
      _state.celular = event.celular;
    }
    if (event is UpdateFotoEvent) {
      _state.localPath = event.localPath;
      _state.fotoUrl = null;
    }

    if (!_stateController.isClosed) _stateController.add(_state);
    print('event.runtimeType em PerfilBloc  = ${event.runtimeType}');
  }
}
