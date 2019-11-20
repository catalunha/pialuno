// import 'package:flutter/foundation.dart';
// import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_native_web/flutter_native_web.dart';
import 'package:intl/intl.dart';
import 'package:pialuno/bootstrap.dart';
import 'package:pialuno/componentes/clock.dart';
import 'package:pialuno/modelos/simulacao_model.dart';
import 'package:pialuno/paginas/tarefa/tarefa_aberta_responder_bloc.dart';
import 'package:pialuno/plataforma/recursos.dart';
import 'package:queries/collections.dart';
import 'package:pialuno/naosuportato/naosuportado.dart' show FilePicker, FileType;
import 'package:pialuno/naosuportato/url_launcher.dart' if (dart.library.io) 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TarefaAbertaResponderPage extends StatefulWidget {
  final String tarefaID;

  const TarefaAbertaResponderPage(this.tarefaID);

  @override
  _TarefaAbertaResponderPageState createState() => _TarefaAbertaResponderPageState();
}

class _TarefaAbertaResponderPageState extends State<TarefaAbertaResponderPage> {
  TarefaAbertaResponderBloc bloc;
  bool hasTimerStopped = false;
  // WebController webController;
  // FlutterNativeWeb flutterWebView;
// String urlProblema;
  final List<Tab> myTabs = <Tab>[
    Tab(text: "Problema"),
    Tab(text: "Valores"),
    Tab(text: "Resposta"),
    Tab(text: "Tarefa"),
  ];
  @override
  void initState() {
    // this.webview();

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
        floatingActionButton: StreamBuilder<TarefaAbertaResponderBlocState>(
            stream: bloc.stateStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Container();
              return FloatingActionButton(
                onPressed: snapshot.data.isDataValid
                    ? () {
                        bloc.eventSink(SaveEvent());
                      }
                    : null,
                child: Icon(Icons.cloud_upload),
                backgroundColor: snapshot.data.isDataValid ? Colors.blue : Colors.grey,
              );
            }),
      ),
    );
  }

  TabBarView _body(context) {
    return TabBarView(
      children: [
        _problema(),
        _variaveis(),
        _resposta(),
        _tarefa(),
      ],
    );
  }

  _tarefa() {
    return StreamBuilder<TarefaAbertaResponderBlocState>(
        stream: bloc.stateStream,
        builder: (BuildContext context, AsyncSnapshot<TarefaAbertaResponderBlocState> snapshot) {
          if (snapshot.hasError) {
            return Text("ERROR");
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.data.isDataValid) {
            List<Widget> listaWidget = List<Widget>();
            Map<String, Gabarito> gabaritoMap;
            String nota = '';
            var tarefa = snapshot.data.tarefaModel;
            Widget pdf = ListTile(
              title: Text('Click aqui para ver a proposta da tarefa.'),
              trailing: Icon(Icons.local_library),
              onTap: () {
                launch(tarefa.problema.url);
              },
            );
            // String urlProblema = snapshot.data.tarefaModel.problema.url;
            // Widget gdocs = Container(
            //         child: flutterWebView,
            //         width: 500.0,
            //         height: 1000.0,
            //       );
            var dicPedese = Dictionary.fromMap(tarefa.gabarito);
            var gabaritoOrderBy =
                dicPedese.orderBy((kv) => kv.value.ordem).toDictionary$1((kv) => kv.key, (kv) => kv.value);
            gabaritoMap = gabaritoOrderBy.toMap();

            for (var gabarito in gabaritoMap.entries) {
              nota += '${gabarito.value.nome}=${gabarito.value.nota ?? "?"} ';
            }
            // listaWidget.add(
            Widget proposta = Card(
              child: ListTile(
                trailing: Text('Tarefa: ${tarefa.questao.numero}',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 20.0,
                    )),
                title: Text('''
Turma: ${tarefa.turma.nome}
Prof.: ${tarefa.professor.nome}
Aval.: ${tarefa.avaliacao.nome}
Prob.: ${tarefa.problema.nome}
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

            // return ListView(children: <Widget>[
            //   proposta,
            //   pdf,
            //   gdocs,
            // ]);

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                proposta,
                // pdf,
                // Expanded(
                //     child: WebView(
                //   initialUrl: urlProblema,
                //   javascriptMode: JavascriptMode.disabled,
                // ),)
              ],
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

  _problema() {
    return StreamBuilder<TarefaAbertaResponderBlocState>(
        stream: bloc.stateStream,
        builder: (BuildContext context, AsyncSnapshot<TarefaAbertaResponderBlocState> snapshot) {
          if (snapshot.hasError) {
            return Text("ERROR");
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.data.isDataValid) {
            // List<Widget> listaWidget = List<Widget>();
            // Map<String, Gabarito> gabaritoMap;
            // String nota = '';
            var tarefa = snapshot.data.tarefaModel;
            Widget pdf = ListTile(
              title: Text('Se não visualizar a proposta abaixo, clique aqui.'),
              trailing: Icon(Icons.local_library),
              onTap: () {
                launch(tarefa.problema.url);
              },
            );
            String urlProblema = snapshot.data.tarefaModel.problema.url;
            // Widget gdocs = Container(
            //         child: flutterWebView,
            //         width: 500.0,
            //         height: 1000.0,
            //       );
            // var dicPedese = Dictionary.fromMap(tarefa.gabarito);
            // var gabaritoOrderBy =
            //     dicPedese.orderBy((kv) => kv.value.ordem).toDictionary$1((kv) => kv.key, (kv) => kv.value);
            // gabaritoMap = gabaritoOrderBy.toMap();

            // for (var gabarito in gabaritoMap.entries) {
            //   nota += '${gabarito.value.nome}=${gabarito.value.nota ?? "?"} ';
            // }
            // listaWidget.add(
//             Widget proposta = Card(
//               child: ListTile(
//                 trailing: Text('Tarefa: ${tarefa.questao.numero}',
//                     style: TextStyle(
//                       color: Colors.blue,
//                       fontSize: 20.0,
//                     )),
//                 title: Text('''
// Turma: ${tarefa.turma.nome}
// Prof.: ${tarefa.professor.nome}
// Aval.: ${tarefa.avaliacao.nome}
// Prob.: ${tarefa.problema.nome}
// Aberta: ${DateFormat('dd-MM HH:mm').format(tarefa.inicio)} até ${DateFormat('dd-MM HH:mm').format(tarefa.fim)}
// Iniciou: ${tarefa.iniciou == null ? "" : DateFormat('dd-MM HH:mm').format(tarefa.iniciou)}
// Enviou: ${tarefa.enviou == null ? "" : DateFormat('dd-MM HH:mm').format(tarefa.enviou)}
// Sit.: $nota'''),
// // id: ${tarefa.id}
// // Tentativas: ${tarefa.tentou ?? 0} / ${tarefa.tentativa}
// // Aberta: ${tarefa.aberta}
// // Tempo:  ${tarefa.tempo} / ${tarefa.tempoPResponder}
//               ),
//             );

//             // return ListView(children: <Widget>[
//             //   proposta,
//             //   pdf,
//             //   gdocs,
//             // ]);
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                pdf,
                Expanded(
                  child: WebView(
                    initialUrl: urlProblema,
                    // initialUrl: 'https://drive.google.com/file/d/1go4qo40kNf0pUl7JliDnyG2A_fQxGLU0/edit',
                    javascriptMode: JavascriptMode.disabled,
                  ),
                )
              ],
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

  _variaveis() {
    return StreamBuilder<TarefaAbertaResponderBlocState>(
        stream: bloc.stateStream,
        builder: (BuildContext context, AsyncSnapshot<TarefaAbertaResponderBlocState> snapshot) {
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
            var gabaritoOrderBy =
                dicPedese.orderBy((kv) => kv.value.ordem).toDictionary$1((kv) => kv.key, (kv) => kv.value);
            variavelMap = gabaritoOrderBy.toMap();
            Widget icone;

            for (var variavel in variavelMap.entries) {
              if (variavel.value.tipo == 'numero') {
                icone = Icon(Icons.looks_one);
              } else if (variavel.value.tipo == 'palavra') {
                icone = Icon(Icons.text_format);
              } else if (variavel.value.tipo == 'texto') {
                icone = Icon(Icons.text_fields);
              } else if (variavel.value.tipo == 'url') {
                icone = Icon(Icons.link);
              } else if (variavel.value.tipo == 'urlimagem') {
                icone = Icon(Icons.image);
              }

              // listaWidget.add(
              //   Card(
              //     child: ListTile(
              //       title: Text('${variavel.value.nome}'),
              //       subtitle: Text('${variavel?.value?.valor}'),
              //       trailing: icone,
              //     ),
              //   ),
              // );

              if (variavel.value.tipo == 'urlimagem') {
                String linkValorModificado;
                if (variavel?.value?.valor != null && variavel.value.valor.contains('drive.google.com/open')) {
                  linkValorModificado = variavel.value.valor.replaceFirst('open', 'uc');
                } else {
                  linkValorModificado = variavel.value.valor;
                }
                listaWidget.add(
                  Card(
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: Text('${variavel.value.nome}'),
                          // subtitle: Text('${variavel?.value?.valor}'),
                          trailing: icone,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: _MostraImagemUnica(
                                urlModificada: linkValorModificado,
                                urlOriginal: variavel.value.valor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              } else if (variavel.value.tipo == 'url') {
                listaWidget.add(
                  Card(
                    child: ListTile(
                      title: Text('${variavel.value.nome}'),
                      subtitle: Text('${variavel?.value?.valor}'),
                      trailing: icone,
                      onTap: () {
                        launch(variavel.value.valor);
                      },
                    ),
                  ),
                );
              } else {
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
            }
            listaWidget.add(Container(
              padding: EdgeInsets.only(top: 70),
            ));

            return Column(children: <Widget>[
              _descricaoAba('No problema considere os seguintes valores:'),
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
        builder: (BuildContext context, AsyncSnapshot<TarefaAbertaResponderBlocState> snapshot) {
          if (snapshot.hasError) {
            return Text("ERROR");
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.data.isDataValid) {
            var gabarito = snapshot.data.resposta;

            List<Widget> listaWidget = List<Widget>();
            Map<String, Gabarito> gabaritoMap;
            var dicPedese = Dictionary.fromMap(gabarito);
            var gabaritoOrderBy =
                dicPedese.orderBy((kv) => kv.value.ordem).toDictionary$1((kv) => kv.key, (kv) => kv.value);
            gabaritoMap = gabaritoOrderBy.toMap();
            Widget icone;

            for (var gabarito in gabaritoMap.entries) {
              Color cor;
              if (gabarito.value.nota != null && gabarito.value.nota == 1) {
                cor = Colors.green;
              }
              if (gabarito.value.tipo == 'numero') {
                icone = IconButton(
                  icon: Icon(Icons.looks_one, color: cor),
                  tooltip: "Um número. Use ponto para decimal.",
                );
              } else if (gabarito.value.tipo == 'palavra') {
                icone = IconButton(
                  icon: Icon(Icons.text_format, color: cor),
                  tooltip: "Uma palavra ou frase fechada.",
                );
              } else if (gabarito.value.tipo == 'texto') {
                icone = IconButton(
                  icon: Icon(Icons.text_fields, color: cor),
                  tooltip: "Um texto aberto com uma ou várias linhas.",
                );
              } else if (gabarito.value.tipo == 'url') {
                icone = IconButton(
                  icon: Icon(Icons.link, color: cor),
                  tooltip: "Um link a um arquivo compartilhado ou site.",
                );
              } else if (gabarito.value.tipo == 'urlimagem') {
                icone = IconButton(
                  icon: Icon(Icons.image, color: cor),
                  tooltip: "Um link a uma imagem.",
                );
              } else if (gabarito.value.tipo == 'arquivo') {
                icone = IconButton(
                  icon: Icon(Icons.description, color: cor),
                  tooltip: "Upload de um arquivo.",
                );
              } else if (gabarito.value.tipo == 'imagem') {
                icone = IconButton(
                  icon: Icon(Icons.photo_album, color: cor),
                  tooltip: "Upload de uma imagem.",
                );
              }

              listaWidget.add(
                ListTile(
                  title: Text(
                    '${gabarito.value.nome}',
                  ),
                  trailing: icone,
                  // selected: gabarito.value.nota != null,
                  // trailing: gabarito.value.nota == null
                  //     ? Text('')
                  //     : Icon(Icons.check),
                ),
              );

              if (gabarito.value.tipo == 'numero' ||
                  gabarito.value.tipo == 'palavra' ||
                  gabarito.value.tipo == 'texto' ||
                  gabarito.value.tipo == 'url' ||
                  gabarito.value.tipo == 'urlimagem') {
                listaWidget.add(Padding(
                    padding: EdgeInsets.all(5.0),
                    child: PedeseNumeroTexto(
                      bloc,
                      gabarito.key,
                      gabarito.value,
                    )));
              }
              if (Recursos.instance.disponivel("file_picking")) {
                if (gabarito.value.tipo == 'imagem') {
                  listaWidget.add(Padding(
                      padding: EdgeInsets.all(5.0),
                      child: ImagemSelect(
                        bloc,
                        gabarito.key,
                        gabarito.value,
                      )));
                }
              }
              if (Recursos.instance.disponivel("file_picking")) {
                if (gabarito.value.tipo == 'arquivo') {
                  listaWidget.add(Padding(
                      padding: EdgeInsets.all(5.0),
                      child: ArquivoSelect(
                        bloc,
                        gabarito.key,
                        gabarito.value,
                      )));
                }
              }
            }
            listaWidget.add(Container(
              padding: EdgeInsets.only(top: 70),
            ));

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

// webview(){
//       this.flutterWebView = new FlutterNativeWeb(
//       onWebCreated: onWebCreated,
//       gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
//                         Factory<OneSequenceGestureRecognizer>(
//                           () => TapGestureRecognizer(),
//                         ),
//                       ].toSet(),
//     );
//     return;
//   }

//   void onWebCreated(webController) {
//     this.webController = webController;
//     this.webController.loadUrl(urlProblema);
//     // this.webController.loadUrl("https://docs.google.com/document/d/16yTCmubD-IHu7VDhjFY4SGxWp9XYAjtW-I_2StafsD0/edit#heading=h.4nme0svt2xhv");
//     this.webController.onPageStarted.listen((url) =>
//         print("Loading $url")
//     );
//     this.webController.onPageFinished.listen((url) =>
//         print("Finished loading $url")
//     );
//   }
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
        builder: (BuildContext context, AsyncSnapshot<TarefaAbertaResponderBlocState> snapshot) {
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
                countDownTimerStyle: TextStyle(color: Color(0XFFf5a623), fontSize: 17.0, height: 2),
              ),
            );
            Widget tentativas = Text(
              '${tarefa.tentou ?? 0} de ${tarefa.tentativa}',
              style: TextStyle(color: Color(0XFFf5a623), fontSize: 17.0, height: 2),
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
  final String gabaritoKey;
  final Gabarito gabaritoValue;
  PedeseNumeroTexto(
    this.bloc,
    this.gabaritoKey,
    this.gabaritoValue,
  );
  @override
  PedeseNumeroTextoState createState() {
    return PedeseNumeroTextoState(
      bloc,
      gabaritoKey,
      gabaritoValue,
    );
  }
}

class PedeseNumeroTextoState extends State<PedeseNumeroTexto> {
  final _textFieldController = TextEditingController();
  final TarefaAbertaResponderBloc bloc;
  final String gabaritoKey;
  final Gabarito gabaritoValue;
  PedeseNumeroTextoState(this.bloc, this.gabaritoKey, this.gabaritoValue);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<TarefaAbertaResponderBlocState>(
      stream: bloc.stateStream,
      builder: (BuildContext context, AsyncSnapshot<TarefaAbertaResponderBlocState> snapshot) {
        if (_textFieldController.text.isEmpty) {
          _textFieldController.text = gabaritoValue.resposta;
        }
        return TextField(
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
          controller: _textFieldController,
          onChanged: (text) {
            bloc.eventSink(UpdatePedeseEvent(gabaritoKey, text));
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
  final String gabaritoKey;
  final Gabarito gabaritoValue;
  ImagemSelect(
    this.bloc,
    this.gabaritoKey,
    this.gabaritoValue,
  );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<TarefaAbertaResponderBlocState>(
      stream: bloc.stateStream,
      builder: (BuildContext context, AsyncSnapshot<TarefaAbertaResponderBlocState> snapshot) {
        if (snapshot.hasError) {
          return Container(
            child: Center(child: Text('Erro.')),
          );
        }
        return Column(
          children: <Widget>[
            Recursos.instance.disponivel("file_picking")
                ? ListTile(
                    leading: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        bloc.eventSink(UpdateApagarAnexoImagemArquivoEvent(gabaritoKey, null));
                      },
                    ),
                    title: Text('ou, selecione uma imagem conforme solicitado.'),
                    trailing: Icon(Icons.file_download),
                    onTap: () async {
                      await _selecionarNovoArquivo().then((localPath) {
                        // _localPath = arq;
                        bloc.eventSink(UpdatePedeseEvent(gabaritoKey, localPath));
                      });
                    },
                  )
                : Text('Recurso não suporte nesta plataforma.'),
            _UploadImagem(
              uploadID: gabaritoValue?.respostaUploadID,
              url: gabaritoValue?.resposta,
              path: gabaritoValue?.respostaPath,
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

class _UploadImagem extends StatelessWidget {
  final String uploadID;
  final String url;
  final String path;

  const _UploadImagem({this.uploadID, this.url, this.path});

  @override
  Widget build(BuildContext context) {
    Widget foto = Text('?');
    Widget msg = Text('');

    if (path == null && url == null) {
      foto = Text('Você ainda não enviou uma imagem.');
    }
    if (path != null && url == null) {
      try {
        foto = Container(
            // color: Colors.yellow,
            child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Image.asset(path),
        ));
      } on Exception {
        msg = ListTile(
          title: Text('Não consegui abrir a imagem.'),
        );
      } catch (e) {
        msg = ListTile(
          title: Text('Não consegui abrir a imagem.'),
        );
      }
      msg = Text(
          'Esta imagem precisa ser enviada. Salve esta edição de tarefa e depois acesse o menu upload de arquivos para enviar esta imagem.');
    }
    if (url != null && uploadID != null) {
      try {
        foto = Container(
            child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Image.network(url),
        ));
      } on Exception {
        print('Exception');
        msg = ListTile(
          title: Text('Não consegui abrir a imagem.'),
        );
      } catch (e) {
        print('catch');
        msg = ListTile(
          title: Text('Não consegui abrir a imagem.'),
        );
      }
    }
    return Column(
      children: <Widget>[
        msg,
        Row(
          children: <Widget>[
            Spacer(
              flex: 2,
            ),
            Expanded(
              flex: 10,
              child: foto,
            ),
            Spacer(
              flex: 2,
            ),
          ],
        ),
      ],
    );
  }
}

class _MostraImagemUnica extends StatelessWidget {
  final String urlModificada;
  final String urlOriginal;

  const _MostraImagemUnica({this.urlModificada, this.urlOriginal});

  @override
  Widget build(BuildContext context) {
    Widget url;
    Widget link;

    link = Center(child: Text('Sem link para imagem.'));
    if (urlModificada == null) {
      url = Center(child: Text('Sem imagem nesta resposta.'));
    } else {
      if (urlOriginal != null) {
        link = ListTile(
          title: Text('Se não visualizar a imagem click aqui para ir ao link.'),
          trailing: Icon(Icons.launch),
          onTap: () {
            launch(urlOriginal);
          },
        );
      }

      try {
        url = Container(
          child: Image.network(urlModificada),
        );
      } on Exception {
        url = ListTile(
          title: Text('Não consegui abrir este link como imagem. Use o link.'),
        );
      } catch (e) {
        url = ListTile(
          title: Text('Não consegui abrir este link como imagem. Use o link.'),
        );
      }
    }

    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Spacer(
              flex: 1,
            ),
            Expanded(
              flex: 16,
              child: url,
            ),
            Spacer(
              flex: 1,
            ),
          ],
        ),
        link,
      ],
    );
  }
}

// class _UploadImagemUnica extends StatelessWidget {
//   final String uploadID;
//   final String url;
//   final String path;

//   const _UploadImagemUnica({this.uploadID, this.url, this.path});

//   @override
//   Widget build(BuildContext context) {
//     Widget imagem;
//     if (uploadID != null && url == null) {
//       imagem = Center(
//           child: Text(
//               'Você não enviou a última imagem selecionada. Vá para o menu Upload de Arquivos.'));
//     } else if (url == null && path == null) {
//       imagem = Center(child: Text('Sem imagem selecionada.'));
//     } else if (url != null) {
//       imagem = Container(
//           child: Padding(
//         padding: const EdgeInsets.all(2.0),
//         child: Image.network(url),
//       ));
//     } else {
//       imagem = Container(
//           // color: Colors.yellow,
//           child: Padding(
//         padding: const EdgeInsets.all(2.0),
//         child: Image.asset(path),
//       ));
//     }
//     return Row(
//       children: <Widget>[
//         Spacer(
//           flex: 2,
//         ),
//         Expanded(
//           flex: 2,
//           child: imagem,
//         ),
//         Spacer(
//           flex: 2,
//         ),
//       ],
//     );
//   }
// }

class ArquivoSelect extends StatelessWidget {
  // String resposta;
  // String _localPath;

  final TarefaAbertaResponderBloc bloc;
  final String gabaritoKey;
  final Gabarito gabaritoValue;
  ArquivoSelect(
    this.bloc,
    this.gabaritoKey,
    this.gabaritoValue,
  );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<TarefaAbertaResponderBlocState>(
      stream: bloc.stateStream,
      builder: (BuildContext context, AsyncSnapshot<TarefaAbertaResponderBlocState> snapshot) {
        if (snapshot.hasError) {
          return Container(
            child: Center(child: Text('Erro.')),
          );
        }
        return Column(
          children: <Widget>[
            Recursos.instance.disponivel("file_picking")
                ? ListTile(
                    leading: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        bloc.eventSink(UpdateApagarAnexoImagemArquivoEvent(gabaritoKey, null));
                      },
                    ),
                    title: Text('ou, selecione um arquivo conforme solicitado.'),
                    trailing: Icon(Icons.file_download),
                    onTap: () async {
                      await _selecionarNovoArquivo().then((localPath) {
                        // _localPath = arq;
                        bloc.eventSink(UpdatePedeseEvent(gabaritoKey, localPath));
                      });
                    },
                    // onLongPress: () {
                    //   bloc.eventSink(UpdateApagarAnexoImagemArquivoEvent(
                    //       gabaritoKey, null));
                    // },
                  )
                : Text('Recurso não suporte nesta plataforma.'),
            _UploadArquivo(
              uploadID: gabaritoValue?.respostaUploadID,
              url: gabaritoValue?.resposta,
              path: gabaritoValue?.respostaPath,
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

class _UploadArquivo extends StatelessWidget {
  final String uploadID;
  final String url;
  final String path;

  const _UploadArquivo({this.uploadID, this.url, this.path});

  @override
  Widget build(BuildContext context) {
    Widget arquivo = Text('?');
    Widget msg = Text('');

    if (path == null && url == null) {
      arquivo = Text('Você ainda não enviou um arquivo.');
    }
    if (path != null && url == null) {
      arquivo = ListTile(
        title: Text('Arquivo local.'),
        subtitle: Text('$path'),
      );
      msg = Text(
          'Este arquivo precisa ser enviado. Salve esta edição de tarefa e depois acesse o menu upload de arquivos para enviar este arquivo.');
    }
    if (url != null && uploadID != null) {
      try {
        arquivo = ListTile(
          title: Text('Arquivo em nuvem.'),
          subtitle: Text('$url'),
          trailing: Icon(Icons.launch),
          onTap: () {
            launch(url);
          },
        );
      } on Exception {
        print('Exception');
        msg = ListTile(
          title: Text('Não consegui abrir o arquivo.'),
        );
      } catch (e) {
        print('catch');
        msg = ListTile(
          title: Text('Não consegui abrir o arquivo.'),
        );
      }
    }
    return Column(
      children: <Widget>[
        msg,
        arquivo,
      ],
    );
  }
}

// class _UploadArquivo extends StatelessWidget {
//   final String uploadID;
//   final String url;
//   final String path;

//   const _UploadArquivo({this.uploadID, this.url, this.path});

//   @override
//   Widget build(BuildContext context) {
//     Widget imagem;
//     if (uploadID != null && url == null) {
//       imagem = Center(
//           child: Text(
//               'Você não enviou o último arquivo selecionado. Vá para o menu Upload de Arquivos.'));
//     } else if (url == null && path == null) {
//       imagem = Center(child: Text('Sem arquivo selecionado.'));
//     } else if (url != null) {
//       imagem = ListTile(
//         title: Text('$url'),
//         trailing: Icon(Icons.link),
//         onTap: () {
//           launch(url);
//         },
//       );
//     } else {
//       imagem = ListTile(
//         title: Text('$path'),
//         // onTap: () {
//         //   launch(url);
//         // },
//       );
//     }

//     return imagem;
//   }
// }
