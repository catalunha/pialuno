import 'package:flutter/material.dart';
import 'package:pialuno/auth_bloc.dart';
import 'package:pialuno/bootstrap.dart';
import 'package:pialuno/componentes/default_scaffold.dart';
import 'package:pialuno/modelos/tarefa_model.dart';
import 'package:pialuno/paginas/desenvolvimento/clock.dart';
import 'package:pialuno/paginas/tarefa/tarefa_aberta_list_bloc.dart';
import 'package:queries/collections.dart';

class TarefaAbertaListPage extends StatefulWidget {
  final AuthBloc authBloc;

  const TarefaAbertaListPage(
    this.authBloc,
  );

  @override
  _TarefaAbertaListPageState createState() => _TarefaAbertaListPageState();
}

class _TarefaAbertaListPageState extends State<TarefaAbertaListPage> {
  TarefaAbertaListBloc bloc;
  @override
  void initState() {
    super.initState();
    bloc = TarefaAbertaListBloc(
      Bootstrap.instance.firestore,
      widget.authBloc,
    );
  }

  @override
  void dispose() {
    super.dispose();
    bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
        title: Text('Tarefas abertas'),
        body: StreamBuilder<TarefaAbertaListBlocState>(
            stream: bloc.stateStream,
            builder: (BuildContext context,
                AsyncSnapshot<TarefaAbertaListBlocState> snapshot) {
              if (snapshot.hasError) {
                return Text("Existe algo errado. Informe o suporte");
              }
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.data.isDataValid) {
                // print('dados validos...');

                List<Widget> listaWidget = List<Widget>();
                String nota = '';
                Map<String, Pedese> pedeseMap = Map<String, Pedese>();

                for (var tarefa in snapshot.data.tarefaList) {
                  // print('tarefa.id: ${tarefa.id}');
                  pedeseMap.clear();
                  var dicPedese = Dictionary.fromMap(tarefa.pedese);
                  var pedeseOrderBy = dicPedese
                      .orderBy((kv) => kv.value.ordem)
                      .toDictionary$1((kv) => kv.key, (kv) => kv.value);
                  pedeseMap = pedeseOrderBy.toMap();
                  nota = '';
                  for (var pedese in pedeseMap.entries) {
                    nota += '${pedese.value.nome}=${pedese.value.nota} ';
                  }
                  Widget contador;
                  if (tarefa.tempoPResponder == null) {
                    contador = Text('${tarefa.tempo} H');
                  } else {
                    contador = Container(
                      width: 100.0,
                      // padding: EdgeInsets.only(top: 3.0, right: 4.0),
                      child: CountDownTimer(
                        secondsRemaining: tarefa.tempoPResponder.inSeconds,
                        whenTimeExpires: () {
                          Navigator.pop(context);
                          print('terminou clock');
                        },
                        countDownTimerStyle: TextStyle(
                            color: Color(0XFFf5a623),
                            fontSize: 17.0,
                            height: 2),
                      ),
                    );
                  }
                  listaWidget.add(
                    Card(
                      child: ListTile(
                        // trailing: Text('${tarefa.questao.numero}'),
                        trailing: contador,
                        selected: tarefa.iniciou != null,
                        title: Text('''
Turma: ${tarefa.turma.nome}
Prof.: ${tarefa.professor.nome}
Aval.: ${tarefa.avaliacao.nome}
Ques.: ${tarefa.situacao.nome}
Inicio: ${tarefa.inicio}
Iniciou: ${tarefa.iniciou}
Editou: ${tarefa.editou}
fim: ${tarefa.fim}
Tentativas: ${tarefa.tentou} / ${tarefa.tentativa}
Notas: $nota
                        '''),
//                         subtitle: Text('''
// id: ${tarefa.id}
// Aberta: ${tarefa.aberta}
// Tempo:  ${tarefa.tempo} / ${tarefa.tempoPResponder}
//                         '''),
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
                }
                return ListView(
                  children: listaWidget,
                );
              } else {
                return Text('Existem dados inválidos. Informe o suporte.');
              }
            }));
  }
}
