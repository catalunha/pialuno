import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pialuno/bootstrap.dart';
import 'package:pialuno/componentes/clock.dart';
import 'package:pialuno/modelos/tarefa_model.dart';
import 'package:pialuno/paginas/tarefa/tarefa_aberta_responder_bloc.dart';
import 'package:pialuno/plataforma/recursos.dart';
import 'package:queries/collections.dart';
import 'package:pialuno/naosuportato/naosuportado.dart'
    show FilePicker, FileType;
import 'package:pialuno/naosuportato/url_launcher.dart'
    if (dart.library.io) 'package:url_launcher/url_launcher.dart';

class TarefaAbertaResponderPage extends StatefulWidget {
  final String tarefaID;

  const TarefaAbertaResponderPage(this.tarefaID);

  @override
  _TarefaAbertaResponderPageState createState() =>
      _TarefaAbertaResponderPageState();
}

class _TarefaAbertaResponderPageState extends State<TarefaAbertaResponderPage> {
  TarefaAbertaResponderBloc bloc;
  bool hasTimerStopped = false;

  final List<Tab> myTabs = <Tab>[
    Tab(text: "Proposta"),
    Tab(text: "Seus valores"),
    Tab(text: "Resposta"),
  ];
  @override
  void initState() {
    super.initState();
    bloc = TarefaAbertaResponderBloc(Bootstrap.instance.firestore);
    bloc.eventSink(GetTarefaEvent(widget.tarefaID));
  }

  @override
  void dispose() {
    super.dispose();
    bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: myTabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: _title(),
          bottom: TabBar(
            tabs: myTabs,
          ),
        ),
        body: _body(context),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.cloud_upload),
          onPressed: () {
            bloc.eventSink(SaveEvent());
            // Navigator.pop(context);

            // Navigator.pushNamed(context, '/painel/crud', arguments: null);
          },
        ),
      ),
    );
  }

  TabBarView _body(context) {
    return TabBarView(
      children: [
        _proposta(),
        _variaveis(),
        _resposta(),
      ],
    );
  }

  _proposta() {
    return StreamBuilder<TarefaAbertaResponderBlocState>(
        stream: bloc.stateStream,
        builder: (BuildContext context,
            AsyncSnapshot<TarefaAbertaResponderBlocState> snapshot) {
          if (snapshot.hasError) {
            return Text("ERROR");
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.data.isDataValid) {
            List<Widget> listaWidget = List<Widget>();
            Map<String, Pedese> pedeseMap;
            String nota = '';
            var tarefa = snapshot.data.tarefaModel;
            Widget pdf = ListTile(
              title: Text('Click aqui para ver a proposta da questão.'),
              trailing: Icon(Icons.picture_as_pdf),
              onTap: () {
                launch(tarefa.situacao.url);
              },
            );
            var dicPedese = Dictionary.fromMap(tarefa.pedese);
            var pedeseOrderBy = dicPedese
                .orderBy((kv) => kv.value.ordem)
                .toDictionary$1((kv) => kv.key, (kv) => kv.value);
            pedeseMap = pedeseOrderBy.toMap();

            for (var pedese in pedeseMap.entries) {
              nota += '${pedese.value.nome}=${pedese.value.nota ?? "?"} ';
            }
            // listaWidget.add(
            Widget proposta = Card(
              child: ListTile(
                trailing: Text('${tarefa.questao.numero}'),
                title: Text('''
Turma: ${tarefa.turma.nome}
Prof.: ${tarefa.professor.nome}
Aval.: ${tarefa.avaliacao.nome}
Ques.: ${tarefa.situacao.nome}
Aberta: ${DateFormat('dd-MM HH:mm').format(tarefa.inicio)} até ${DateFormat('dd-MM HH:mm').format(tarefa.fim)}
Iniciou: ${tarefa.iniciou == null ? "" : DateFormat('dd-MM HH:mm').format(tarefa.iniciou)}
Enviou: ${tarefa.enviou == null ? "" : DateFormat('dd-MM HH:mm').format(tarefa.enviou)}
Sit.: $nota'''),
// id: ${tarefa.id}
// Tentativas: ${tarefa.tentou ?? 0} / ${tarefa.tentativa}
// Aberta: ${tarefa.aberta}
// Tempo:  ${tarefa.tempo} / ${tarefa.tempoPResponder}
              ),
            );

            return Column(children: <Widget>[
              proposta,
              pdf,
            ]);
          } else {
            return Center(
                child: Text('Tarefa fechou por limite de tentativas ou tempo.',
                    style: TextStyle(
                      fontSize: 35,
                      color: Colors.blue,
                    )));
          }
        });
  }

  _variaveis() {
    return StreamBuilder<TarefaAbertaResponderBlocState>(
        stream: bloc.stateStream,
        builder: (BuildContext context,
            AsyncSnapshot<TarefaAbertaResponderBlocState> snapshot) {
          if (snapshot.hasError) {
            return Text("ERROR");
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.data.isDataValid) {
            List<Widget> listaWidget = List<Widget>();
            Map<String, Variavel> variavelMap;
            var tarefa = snapshot.data.tarefaModel;

            // print('tarefa.id: ${tarefa.id}');
            var dicPedese = Dictionary.fromMap(tarefa.variavel);
            var pedeseOrderBy = dicPedese
                .orderBy((kv) => kv.value.ordem)
                .toDictionary$1((kv) => kv.key, (kv) => kv.value);
            variavelMap = pedeseOrderBy.toMap();
            Widget icone;

            for (var variavel in variavelMap.entries) {
              if (variavel.value.tipo == 'numero') {
                icone = Icon(Icons.looks_one);
              } else if (variavel.value.tipo == 'palavra') {
                icone = Icon(Icons.text_format);
              } else if (variavel.value.tipo == 'texto') {
                icone = Icon(Icons.text_fields);
              } else if (variavel.value.tipo == 'url') {
                icone = IconButton(
                  tooltip: 'Um link ao um site ou arquivo',
                  icon: Icon(Icons.link),
                  onPressed: () {
                    launch(variavel.value.valor);
                  },
                );
              } else if (variavel.value.tipo == 'urlimagem') {
                icone = IconButton(
                  tooltip: 'Link para uma imagem',
                  icon: Icon(Icons.image),
                  onPressed: () {
                    launch(variavel.value.valor);
                  },
                );
              }

              listaWidget.add(
                Card(
                  child: ListTile(
                    title: Text('${variavel.value.nome}'),
                    subtitle: Text('${variavel?.value?.valor}'),
                    trailing: icone,
                  ),
                ),
              );
            }
            return Column(children: <Widget>[
              _descricaoAba('Na proposta considere os seguintes valores:'),
              _bodyAba(listaWidget)
            ]);
          } else {
            return Center(
                child: Text('Tarefa fechou por limite de tentativas ou tempo.',
                    style: TextStyle(
                      fontSize: 35,
                      color: Colors.blue,
                    )));
          }
        });
  }

  _resposta() {
    return StreamBuilder<TarefaAbertaResponderBlocState>(
        stream: bloc.stateStream,
        builder: (BuildContext context,
            AsyncSnapshot<TarefaAbertaResponderBlocState> snapshot) {
          if (snapshot.hasError) {
            return Text("ERROR");
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.data.isDataValid) {
            var pedese = snapshot.data.pedese;

            List<Widget> listaWidget = List<Widget>();
            Map<String, Pedese> pedeseMap;
            var dicPedese = Dictionary.fromMap(pedese);
            var pedeseOrderBy = dicPedese
                .orderBy((kv) => kv.value.ordem)
                .toDictionary$1((kv) => kv.key, (kv) => kv.value);
            pedeseMap = pedeseOrderBy.toMap();
            for (var pedese in pedeseMap.entries) {
              listaWidget.add(
                ListTile(
                  title: Text(
                    '${pedese.value.nome}',
                  ),
                  selected: pedese.value.nota != null,
                  trailing:
                      pedese.value.nota == null ? Text('') : Text('Sit.: ${pedese.value.nota}'),
                ),
              );

              if (pedese.value.tipo == 'numero' ||
                  pedese.value.tipo == 'palavra' ||
                  pedese.value.tipo == 'texto' ||
                  pedese.value.tipo == 'url' ||
                  pedese.value.tipo == 'urlimagem') {
                listaWidget.add(Padding(
                    padding: EdgeInsets.all(5.0),
                    child: PedeseNumeroTexto(
                      bloc,
                      pedese.key,
                      pedese.value,
                    )));
              }
              if (Recursos.instance.disponivel("file_picking")) {
                if (pedese.value.tipo == 'imagem') {
                  listaWidget.add(Padding(
                      padding: EdgeInsets.all(5.0),
                      child: ImagemSelect(
                        bloc,
                        pedese.key,
                        pedese.value,
                      )));
                }
              }
              if (Recursos.instance.disponivel("file_picking")) {
                if (pedese.value.tipo == 'arquivo') {
                  listaWidget.add(Padding(
                      padding: EdgeInsets.all(5.0),
                      child: ArquivoSelect(
                        bloc,
                        pedese.key,
                        pedese.value,
                      )));
                }
              }
            }
            // return Column(children: listaWidget);
            return ListView(
              children: listaWidget,
            );
          } else {
            return Center(
                child: Text('Tarefa fechou por limite de tentativas ou tempo.',
                    style: TextStyle(
                      fontSize: 35,
                      color: Colors.blue,
                    )));
          }
        });
  }

  Expanded _bodyAba(List<Widget> listaWidget) {
    return Expanded(
        flex: 10,
        child: listaWidget == null
            ? Container(
                child: Text('Sem itens de painel'),
              )
            : ListView(
                children: listaWidget,
              ));
  }

  Expanded _descricaoAba(String descricaoTab) {
    return Expanded(
      flex: 1,
      child: Center(child: Text('$descricaoTab')),
    );
  }

  _title() {
    return StreamBuilder<TarefaAbertaResponderBlocState>(
        stream: bloc.stateStream,
        builder: (BuildContext context,
            AsyncSnapshot<TarefaAbertaResponderBlocState> snapshot) {
          if (snapshot.hasError) {
            return Text("ERROR");
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.data.isDataValid) {
            var tarefa = snapshot.data.tarefaModel;

            Widget contador = Container(
              width: 100.0,
              // padding: EdgeInsets.only(top: 3.0, right: 4.0),
              child: CountDownTimer(
                secondsRemaining: tarefa.tempoPResponder.inSeconds,
                whenTimeExpires: () {
                  Navigator.pop(context);
                  print('terminou clock');
                },
                countDownTimerStyle: TextStyle(
                    color: Color(0XFFf5a623), fontSize: 17.0, height: 2),
              ),
            );
            Widget tentativas = Text(
              '${tarefa.tentou ?? 0} / ${tarefa.tentativa}',
              style: TextStyle(
                  color: Color(0XFFf5a623), fontSize: 17.0, height: 2),
            );
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                tentativas,
                contador,
              ],
            );
          } else {
            return Text('Tarefa já fechou...');
          }
        });
  }
}

class PedeseNumeroTexto extends StatefulWidget {
  final TarefaAbertaResponderBloc bloc;
  final String pedeseKey;
  final Pedese pedeseValue;
  PedeseNumeroTexto(
    this.bloc,
    this.pedeseKey,
    this.pedeseValue,
  );
  @override
  PedeseNumeroTextoState createState() {
    return PedeseNumeroTextoState(
      bloc,
      pedeseKey,
      pedeseValue,
    );
  }
}

class PedeseNumeroTextoState extends State<PedeseNumeroTexto> {
  final _textFieldController = TextEditingController();
  final TarefaAbertaResponderBloc bloc;
  final String pedeseKey;
  final Pedese pedeseValue;
  PedeseNumeroTextoState(this.bloc, this.pedeseKey, this.pedeseValue);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<TarefaAbertaResponderBlocState>(
      stream: bloc.stateStream,
      builder: (BuildContext context,
          AsyncSnapshot<TarefaAbertaResponderBlocState> snapshot) {
        if (_textFieldController.text.isEmpty) {
          _textFieldController.text = pedeseValue.resposta;
        }
        return TextField(
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
          controller: _textFieldController,
          onChanged: (text) {
            bloc.eventSink(UpdatePedeseEvent(pedeseKey, text));
          },
        );
      },
    );
  }
}

class ImagemSelect extends StatelessWidget {
  // String resposta;
  // String _localPath;

  final TarefaAbertaResponderBloc bloc;
  final String pedeseKey;
  final Pedese pedeseValue;
  ImagemSelect(
    this.bloc,
    this.pedeseKey,
    this.pedeseValue,
  );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<TarefaAbertaResponderBlocState>(
      stream: bloc.stateStream,
      builder: (BuildContext context,
          AsyncSnapshot<TarefaAbertaResponderBlocState> snapshot) {
        if (snapshot.hasError) {
          return Container(
            child: Center(child: Text('Erro.')),
          );
        }
        return Column(
          children: <Widget>[
            Recursos.instance.disponivel("file_picking")
                ? ListTile(
                    title: Text('Selecione uma imagem conforme solicitado.'),
                    trailing: Icon(Icons.file_download),
                    onTap: () async {
                      await _selecionarNovoArquivo().then((localPath) {
                        // _localPath = arq;
                        bloc.eventSink(UpdatePedeseEvent(pedeseKey, localPath));
                      });
                    },
                    onLongPress: () {
                      bloc.eventSink(UpdatePedeseEvent(pedeseKey, null));
                    },
                  )
                : Text('Recurso não suporte nesta plataforma.'),
            _MostrarImagemUnica(
              uploadID: pedeseValue?.respostaUploadID,
              url: pedeseValue?.resposta,
              path: pedeseValue?.respostaPath,
            ),
          ],
        );
      },
    );
  }

  Future<String> _selecionarNovoArquivo() async {
    try {
      var arquivoPath = await FilePicker.getFilePath(type: FileType.ANY);
      if (arquivoPath != null) {
        return arquivoPath;
      }
    } catch (e) {
      print("_selecionarNovoArquivo: Unsupported operation" + e.toString());
    }
    return null;
  }
}

class _MostrarImagemUnica extends StatelessWidget {
  final String uploadID;
  final String url;
  final String path;

  const _MostrarImagemUnica({this.uploadID, this.url, this.path});

  @override
  Widget build(BuildContext context) {
    Widget imagem;
    if (uploadID != null && url == null) {
      imagem = Center(
          child: Text(
              'Você não enviou a última imagem selecionada. Vá para o menu Upload de Arquivos.'));
    } else if (url == null && path == null) {
      imagem = Center(child: Text('Sem imagem selecionada.'));
    } else if (url != null) {
      imagem = Container(
          child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Image.network(url),
      ));
    } else {
      imagem = Container(
          // color: Colors.yellow,
          child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Image.asset(path),
      ));
    }
    return Row(
      children: <Widget>[
        Spacer(
          flex: 2,
        ),
        Expanded(
          flex: 2,
          child: imagem,
        ),
        Spacer(
          flex: 2,
        ),
      ],
    );
  }
}

class ArquivoSelect extends StatelessWidget {
  // String resposta;
  // String _localPath;

  final TarefaAbertaResponderBloc bloc;
  final String pedeseKey;
  final Pedese pedeseValue;
  ArquivoSelect(
    this.bloc,
    this.pedeseKey,
    this.pedeseValue,
  );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<TarefaAbertaResponderBlocState>(
      stream: bloc.stateStream,
      builder: (BuildContext context,
          AsyncSnapshot<TarefaAbertaResponderBlocState> snapshot) {
        if (snapshot.hasError) {
          return Container(
            child: Center(child: Text('Erro.')),
          );
        }
        return Column(
          children: <Widget>[
            Recursos.instance.disponivel("file_picking")
                ? ListTile(
                    title: Text('Selecione um arquivo conforme solicitado.'),
                    trailing: Icon(Icons.file_download),
                    onTap: () async {
                      await _selecionarNovoArquivo().then((localPath) {
                        // _localPath = arq;
                        bloc.eventSink(UpdatePedeseEvent(pedeseKey, localPath));
                      });
                    },
                    onLongPress: () {
                      bloc.eventSink(UpdatePedeseEvent(pedeseKey, null));
                    },
                  )
                : Text('Recurso não suporte nesta plataforma.'),
            _MostraArquivo(
              uploadID: pedeseValue?.respostaUploadID,
              url: pedeseValue?.resposta,
              path: pedeseValue?.respostaPath,
            ),
          ],
        );
      },
    );
  }

  Future<String> _selecionarNovoArquivo() async {
    try {
      var arquivoPath = await FilePicker.getFilePath(type: FileType.ANY);
      if (arquivoPath != null) {
        return arquivoPath;
      }
    } catch (e) {
      print("_selecionarNovoArquivo: Unsupported operation" + e.toString());
    }
    return null;
  }
}

class _MostraArquivo extends StatelessWidget {
  final String uploadID;
  final String url;
  final String path;

  const _MostraArquivo({this.uploadID, this.url, this.path});

  @override
  Widget build(BuildContext context) {
    Widget imagem;
    if (uploadID != null && url == null) {
      imagem = Center(
          child: Text(
              'Você não enviou o último arquivo selecionado. Vá para o menu Upload de Arquivos.'));
    } else if (url == null && path == null) {
      imagem = Center(child: Text('Sem arquivo selecionado.'));
    } else if (url != null) {
      imagem = ListTile(
        title: Text('$url'),
        trailing: Icon(Icons.link),
        onTap: () {
          launch(url);
        },
      );
    } else {
      imagem = ListTile(
        title: Text('$path'),
        // onTap: () {
        //   launch(url);
        // },
      );
    }

    return imagem;
  }
}
