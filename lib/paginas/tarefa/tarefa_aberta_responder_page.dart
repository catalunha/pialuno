import 'package:flutter/material.dart';
import 'package:pialuno/bootstrap.dart';
import 'package:pialuno/componentes/default_scaffold.dart';
import 'package:pialuno/modelos/tarefa_model.dart';
import 'package:pialuno/paginas/desenvolvimento/clock.dart';
import 'package:pialuno/paginas/tarefa/tarefa_aberta_responder_bloc.dart';
import 'package:queries/collections.dart';

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
            return Text("SEM DADOS");
          }
          if (snapshot.data.isDataValid) {
            List<Widget> listaWidget = List<Widget>();
            Map<String, Pedese> pedeseMap;
            String nota = '';
            var tarefa = snapshot.data.tarefaModel;

            Widget contador = Container(
              width: 100.0,
              // padding: EdgeInsets.only(top: 3.0, right: 4.0),
              child: CountDownTimer(
                secondsRemaining: tarefa.tempoPResponder.inSeconds,
                whenTimeExpires: () {
                  setState(() {
                    hasTimerStopped = true;
                  });
                  print('terminou clock');
                },
                countDownTimerStyle: TextStyle(
                    color: Color(0XFFf5a623), fontSize: 17.0, height: 2),
              ),
            );
            // print('tarefa.id: ${tarefa.id}');
            var dicPedese = Dictionary.fromMap(tarefa.pedese);
            var pedeseOrderBy = dicPedese
                .orderBy((kv) => kv.value.ordem)
                .toDictionary$1((kv) => kv.key, (kv) => kv.value);
            pedeseMap = pedeseOrderBy.toMap();

            for (var pedese in pedeseMap.entries) {
              nota += '${pedese.value.nome}=${pedese.value.nota} ';
            }
            listaWidget.add(
              Card(
                child: ListTile(
                  trailing: Text('${tarefa.questao.numero}'),
                  selected: tarefa.iniciou != null,
                  title: Text('''
        id: ${tarefa.id}
        Aberta: ${tarefa.aberta}
        Turma: ${tarefa.turma.nome}
        Prof.: ${tarefa.professor.nome}
        Aval.: ${tarefa.avaliacao.nome}
        Ques.: ${tarefa.situacao.nome}
        Inicio: ${tarefa.inicio}
        Iniciou: ${tarefa.iniciou}
        Editou: ${tarefa.editou}
        fim: ${tarefa.fim}
        Tentativas: ${tarefa.tentou} / ${tarefa.tentativa}
        Tempo:  ${tarefa.tempo} / ${tarefa.tempoPResponder}
        Notas: $nota
                                '''),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      "/tarefa/responder",
                      arguments: tarefa.id,
                    );
                  },
                ),
              ),
            );

            return Column(children: <Widget>[contador, _bodyAba(listaWidget)]);
          } else {
            return Text('Dados inválidos...');
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
            return Text("SEM DADOS");
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

            for (var variavel in variavelMap.entries) {
              listaWidget.add(
                Card(
                  child: ListTile(
                    title: Text('${variavel.value.nome}'),
                    subtitle: Text('${variavel.value.valor}'),
                  ),
                ),
              );
            }

            return Column(children: <Widget>[
              _descricaoAba('Na proposta considere os seguintes valores:'),
              _bodyAba(listaWidget)
            ]);
          } else {
            return Text('Dados inválidos...');
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
            return Text("SEM DADOS");
          }
          if (snapshot.data.isDataValid) {
            var tarefa = snapshot.data.tarefaModel;

            List<Widget> listaWidget = List<Widget>();
            Map<String, Pedese> pedeseMap;
            var dicPedese = Dictionary.fromMap(tarefa.pedese);
            var pedeseOrderBy = dicPedese
                .orderBy((kv) => kv.value.ordem)
                .toDictionary$1((kv) => kv.key, (kv) => kv.value);
            pedeseMap = pedeseOrderBy.toMap();
            for (var pedese in pedeseMap.entries) {
              // nota += '${pedese.value.nome}=${pedese.value.nota} ';
              print('${pedese.value.nome}');
              if (pedese.value.tipo == 'numero' ||
                  pedese.value.tipo == 'palavra'||
                  pedese.value.tipo == 'texto') {
                listaWidget.add(Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text(
                      '${pedese.value.nome}',
                      style: TextStyle(fontSize: 15, color: Colors.blue),
                    )));
                listaWidget.add(Padding(
                    padding: EdgeInsets.all(5.0),
                    child: PedeseNumeroTexto(bloc, pedese.key, pedese.value)));
              }
            }
            return Column(children: listaWidget);
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
            return Text("SEM DADOS");
          }
          if (snapshot.data.isDataValid) {
            var tarefa = snapshot.data.tarefaModel;

            Widget contador = Container(
              width: 100.0,
              // padding: EdgeInsets.only(top: 3.0, right: 4.0),
              child: CountDownTimer(
                secondsRemaining: tarefa.tempoPResponder.inSeconds,
                // whenTimeExpires: () {
                //   setState(() {
                //     hasTimerStopped = true;
                //   });
                //   print('terminou clock');
                // },
                countDownTimerStyle: TextStyle(
                    color: Color(0XFFf5a623), fontSize: 17.0, height: 2),
              ),
            );
            Widget tentativas = Text(
              '${tarefa.tentou} / ${tarefa.tentativa}',
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
            return Text('Dados inválidos...');
          }
        });
  }
}

class PedeseNumeroTexto extends StatefulWidget {
  final TarefaAbertaResponderBloc bloc;
  final String pedeseKey;
  final Pedese pedeseValue;
  PedeseNumeroTexto(this.bloc, this.pedeseKey, this.pedeseValue);
  @override
  PedeseNumeroTextoState createState() {
    return PedeseNumeroTextoState(bloc, pedeseKey, pedeseValue);
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
