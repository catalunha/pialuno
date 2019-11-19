import 'package:pialuno/bootstrap.dart';
import 'package:pialuno/modelos/simulacao_model.dart';
import 'package:pialuno/modelos/tarefa_model.dart';
import 'package:pialuno/modelos/upload_model.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;
import 'package:rxdart/rxdart.dart';

class TarefaAbertaResponderBlocEvent {}

class GetTarefaEvent extends TarefaAbertaResponderBlocEvent {
  final String tarefaID;

  GetTarefaEvent(this.tarefaID);
}

class UpdatePedeseEvent extends TarefaAbertaResponderBlocEvent {
  final String gabaritoKey;
  final String valor;

  UpdatePedeseEvent(this.gabaritoKey, this.valor);
}

class UpdateApagarAnexoImagemArquivoEvent
    extends TarefaAbertaResponderBlocEvent {
  final String gabaritoKey;
  final String valor;

  UpdateApagarAnexoImagemArquivoEvent(this.gabaritoKey, this.valor);
}

class SaveEvent extends TarefaAbertaResponderBlocEvent {}

class TarefaAbertaResponderBlocState {
  bool isDataValid = false;
  TarefaModel tarefaModel = TarefaModel();
  Map<String, Gabarito> gabarito = Map<String, Gabarito>();
  void updateStateFromTarefaModel() {
    gabarito = tarefaModel.gabarito;
  }
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
    if (_state.tarefaModel.aberta != null && !_state.tarefaModel.aberta) {
      _state.isDataValid = false;
    }
    if (_state.tarefaModel?.tempoPResponder?.inSeconds == null) {
      _state.isDataValid = false;
    }
  }

  _mapEventToState(TarefaAbertaResponderBlocEvent event) async {
    if (event is GetTarefaEvent) {
      final docRef = _firestore
          .collection(TarefaModel.collection)
          .document(event.tarefaID);
      var docSnap = await docRef.get();

      _state.tarefaModel =
          TarefaModel(id: docSnap.documentID).fromMap(docSnap.data);

      // final snapTarefa = streamDocsSnap
      //     .map((doc) => TarefaModel(id: doc.documentID).fromMap(doc.data));
      // snapTarefa.listen((TarefaModel tarefa) async {
      _state.tarefaModel.modificado = DateTime.now();
      _state.tarefaModel.updateAll();
      if (_state.tarefaModel.iniciou == null) {
        _state.tarefaModel.iniciou = DateTime.now();
        // print('Tarefa sendo iniciada...');
        final docRef = _firestore
            .collection(TarefaModel.collection)
            .document(_state.tarefaModel.id);
        await docRef.setData(
          _state.tarefaModel.toMap(),
          merge: true,
        );
      } else {
        // print('Tarefa JA iniciada...');
      }
      _state.updateStateFromTarefaModel();
      if (!_stateController.isClosed) _stateController.add(_state);
    }
    if (event is UpdatePedeseEvent) {
      // print('UpdatePedeseEvent: ${event.gabaritoKey} = ${event.valor}');
      var gabarito = _state.gabarito[event.gabaritoKey];
      if (gabarito.tipo == 'numero' ||
          gabarito.tipo == 'palavra' ||
          gabarito.tipo == 'texto' ||
          gabarito.tipo == 'url' ||
          gabarito.tipo == 'urlimagem') {
        _state.gabarito[event.gabaritoKey].resposta = event.valor;
      } else if (gabarito.tipo == 'imagem' || gabarito.tipo == 'arquivo') {
        _state.gabarito[event.gabaritoKey].respostaPath = event.valor;
        _state.gabarito[event.gabaritoKey].resposta = null;
      }
      // print(gabarito.toMap());
    }
    if (event is UpdateApagarAnexoImagemArquivoEvent) {
      print('apagar');
      var gabarito = _state.gabarito[event.gabaritoKey];
      if (gabarito.tipo == 'imagem' || gabarito.tipo == 'arquivo') {
        _state.gabarito[event.gabaritoKey].respostaUploadID = null;
        _state.gabarito[event.gabaritoKey].respostaPath = null;
        _state.gabarito[event.gabaritoKey].resposta = null;
      }
      print(_state.gabarito[event.gabaritoKey]);
    }

    if (event is SaveEvent) {
      for (var gabarito in _state.gabarito.entries) {
        print('salvando: ${gabarito.value.nome}');
        print('salvando: ${gabarito.value.resposta}');
        print('salvando: ${gabarito.value.respostaPath}');
        print('salvando: ${gabarito.value.respostaUploadID}');
        //Corrigir textos e numeros.
        if (gabarito.value.tipo == 'palavra' &&
            gabarito.value.resposta != null &&
            gabarito.value.resposta.isNotEmpty) {
          if (gabarito.value.resposta == gabarito.value.valor) {
            _state.gabarito[gabarito.key].nota = 1;
          } else {
            _state.gabarito[gabarito.key].nota = 0;
          }
        }
        if (gabarito.value.tipo == 'numero' &&
            gabarito.value.resposta != null &&
            gabarito.value.resposta.isNotEmpty) {
          double resposta = double.parse(gabarito.value.resposta);
          double valor = double.parse(gabarito.value.valor);
          double erroRelativoCalculado =
              (resposta - valor).abs() / valor.abs() * 100;
          double erroRelativoPermitido =
              _state.tarefaModel.erroRelativo.toDouble();

          if (erroRelativoCalculado <= erroRelativoPermitido) {
            _state.gabarito[gabarito.key].nota = 1;
          } else {
            _state.gabarito[gabarito.key].nota = 0;
          }
        }
        // Criar uploadID de imagem e arquivo
        if ((gabarito.value.tipo == 'imagem' ||
                gabarito.value.tipo == 'arquivo') &&
            gabarito.value.respostaPath != null) {
          //+++ Deletar uploadID anterior se existir
          if (gabarito.value.respostaUploadID != null) {
            final docRef = _firestore
                .collection(UploadModel.collection)
                .document(gabarito.value.respostaUploadID);
            await docRef.delete();
            gabarito.value.respostaUploadID = null;
          }
          //--- Deletar uploadID anterior se existir
          //+++ Cria doc em UpLoadCollection
          final upLoadModel = UploadModel(
            usuario: _state.tarefaModel.aluno.id,
            path: gabarito.value.respostaPath,
            upload: false,
            updateCollection: UpdateCollection(
                collection: TarefaModel.collection,
                document: _state.tarefaModel.id,
                field: "gabarito.${gabarito.key}.resposta"),
          );
          final docRef = _firestore
              .collection(UploadModel.collection)
              .document(gabarito.value.respostaUploadID);
          await docRef.setData(upLoadModel.toMap(), merge: true);
          //--- Cria doc em UpLoadCollection
          //Atualizar o gabarito atual com o UploadID
          _state.gabarito[gabarito.key].respostaUploadID = docRef.documentID;
        }
        if (gabarito.value.resposta == null &&
            gabarito.value.respostaPath == null &&
            gabarito.value.respostaUploadID == null) {
          _state.gabarito[gabarito.key].resposta = null;
          _state.gabarito[gabarito.key].respostaPath = null;
          _state.gabarito[gabarito.key].respostaUploadID = null;
        }
      }
      final docRef = _firestore
          .collection(TarefaModel.collection)
          .document(_state.tarefaModel.id);
      TarefaModel tarefaUpdate = TarefaModel(
          iniciou: _state.tarefaModel.iniciou,
          tentou: Bootstrap.instance.fieldValue.increment(1),
          enviou: Bootstrap.instance.fieldValue.serverTimestamp(),
          modificado: Bootstrap.instance.fieldValue.serverTimestamp(),
          gabarito: _state.gabarito,
          aberta: _state.tarefaModel.isAberta);

      await docRef.setData(
        tarefaUpdate.toMap(),
        merge: true,
      );
      _state.tarefaModel.tentou = _state.tarefaModel.tentou != null
          ? _state.tarefaModel.tentou = _state.tarefaModel.tentou + 1
          : 1;
      _state.tarefaModel.modificado = DateTime.now();
      _state.tarefaModel.enviou = DateTime.now();
      _state.tarefaModel.updateAll();
      print('fim SaveEvent. tentou ${_state.tarefaModel.tentou}');
    }

    _validateData();
    if (!_stateController.isClosed) _stateController.add(_state);
    print(
        'event.runtimeType em TarefaAbertaResponderBloc  = ${event.runtimeType}');
  }
}
