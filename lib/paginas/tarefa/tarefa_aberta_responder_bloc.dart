import 'package:pialuno/bootstrap.dart';
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
  final String pedeseKey;
  final String valor;

  UpdatePedeseEvent(this.pedeseKey, this.valor);
}

class SaveEvent extends TarefaAbertaResponderBlocEvent {}

class TarefaAbertaResponderBlocState {
  bool isDataValid = false;
  TarefaModel tarefaModel = TarefaModel();
  Map<String, Pedese> pedese = Map<String, Pedese>();
  void updateStateFromTarefaModel() {
    pedese = tarefaModel.pedese;
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
      // print('UpdatePedeseEvent: ${event.pedeseKey} = ${event.valor}');
      var pedese = _state.pedese[event.pedeseKey];
      if (pedese.tipo == 'numero' ||
          pedese.tipo == 'palavra' ||
          pedese.tipo == 'url' ||
          pedese.tipo == 'texto') {
        pedese.resposta = event.valor;
      } else if (pedese.tipo == 'imagem' || pedese.tipo == 'arquivo') {
        pedese.respostaPath = event.valor;
      }
      // print(pedese.toMap());
    }
    if (event is SaveEvent) {
      for (var pedese in _state.pedese.entries) {
        print('salvando: ${pedese.value.nome}');
        //Corrigir textos e numeros.
        if (pedese.value.tipo == 'palavra' &&
            pedese.value.resposta != null &&
            pedese.value.resposta.isNotEmpty) {
          if (pedese.value.resposta == pedese.value.gabarito) {
            _state.pedese[pedese.key].nota = 1;
          } else {
            _state.pedese[pedese.key].nota = 0;
          }
        }
        if (pedese.value.tipo == 'numero' &&
            pedese.value.resposta != null &&
            pedese.value.resposta.isNotEmpty) {
          double resposta = double.parse(pedese.value.resposta);
          double gabarito = double.parse(pedese.value.gabarito);
          double erroRelativoCalculado =
              (resposta - gabarito).abs() / gabarito.abs() * 100;
          double erroRelativoPermitido =
              double.parse(_state.tarefaModel.erroRelativo);

          if (erroRelativoCalculado <= erroRelativoPermitido) {
            _state.pedese[pedese.key].nota = 1;
          } else {
            _state.pedese[pedese.key].nota = 0;
          }
        }
        // Criar uploadID de imagem e arquivo
        if ((pedese.value.tipo == 'imagem' || pedese.value.tipo == 'arquivo') &&
            pedese.value.respostaPath != null) {
          // Deletar uploadID anterior se existir
          if (pedese.value.respostaUploadID != null) {
            final docRef = _firestore
                .collection(UploadModel.collection)
                .document(pedese.value.respostaUploadID);
            await docRef.delete();
            pedese.value.respostaUploadID = null;
          }
          //+++ Cria doc em UpLoadCollection
          final upLoadModel = UploadModel(
            usuario: _state.tarefaModel.aluno.id,
            path: pedese.value.respostaPath,
            upload: false,
            updateCollection: UpdateCollection(
                collection: TarefaModel.collection,
                document: _state.tarefaModel.id,
                field: "pedese.${pedese.key}.respostaUploadID"),
          );
          final docRef = _firestore
              .collection(UploadModel.collection)
              .document(pedese.value.respostaUploadID);
          await docRef.setData(upLoadModel.toMap(), merge: true);
          //Atualizar o pedese atual com o UploadID
          _state.pedese[pedese.key].respostaUploadID = docRef.documentID;
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
          pedese: _state.pedese,
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
