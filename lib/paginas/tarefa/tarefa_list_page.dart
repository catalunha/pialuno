import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pialuno/auth_bloc.dart';
import 'package:pialuno/bootstrap.dart';
import 'package:pialuno/modelos/tarefa_model.dart';
import 'package:pialuno/paginas/tarefa/tarefa_list_bloc.dart';
import 'package:queries/collections.dart';

class TarefaListPage extends StatefulWidget {
  final AuthBloc authBloc;
  final String avaliacao;

  const TarefaListPage(this.authBloc, this.avaliacao);

  @override
  _TarefaListPageState createState() => _TarefaListPageState();
}

class _TarefaListPageState extends State<TarefaListPage> {
  TarefaListBloc bloc;
  @override
  void initState() {
    super.initState();
    bloc = TarefaListBloc(
      Bootstrap.instance.firestore,
      widget.authBloc,
    );
    bloc.eventSink(GetAvaliacaoIDEvent(widget.avaliacao));
  }

  @override
  void dispose() {
    super.dispose();
    bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Suas Tarefas nesta avaliação'),
        ),
        body: StreamBuilder<TarefaListBlocState>(
            stream: bloc.stateStream,
            builder: (BuildContext context,
                AsyncSnapshot<TarefaListBlocState> snapshot) {
              if (snapshot.hasError) {
                return Text("Existe algo errado! Informe o suporte.");
              }
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.data.isDataValid) {

                List<Widget> listaWidget = List<Widget>();
                String notas = '';
                Map<String, Pedese> pedeseMap = Map<String, Pedese>();

                for (var tarefa in snapshot.data.tarefaList) {
                  // print('tarefa.id: ${tarefa.id}');
                  pedeseMap.clear();
                  var dicPedese = Dictionary.fromMap(tarefa.pedese);
                  var pedeseOrderBy = dicPedese
                      .orderBy((kv) => kv.value.ordem)
                      .toDictionary$1((kv) => kv.key, (kv) => kv.value);
                  pedeseMap = pedeseOrderBy.toMap();
                  notas = '';
                  for (var pedese in pedeseMap.entries) {
                    notas += '${pedese.value.nome}=${pedese.value.nota ?? ""} ';
                  }
                  listaWidget.add(
                    Card(
                      child: ListTile(
                        // trailing: Text('${tarefa.questao.numero}'),
                        trailing: Text('${tarefa.questao.numero}'),
                        // selected: tarefa.iniciou != null,
                        title: Text('''
Turma: ${tarefa.turma.nome}
Prof.: ${tarefa.professor.nome}
Aval.: ${tarefa.avaliacao.nome}
Ques.: ${tarefa.situacao.nome}
Aberta: ${DateFormat('dd-MM HH:mm').format(tarefa.inicio)} até ${DateFormat('dd-MM HH:mm').format(tarefa.fim)}
Iniciou: ${tarefa.iniciou==null ? "" :DateFormat('dd-MM HH:mm').format(tarefa.iniciou)}
Enviou: ${tarefa.enviou==null ? "" :DateFormat('dd-MM HH:mm').format(tarefa.enviou)}
Tentativas: ${tarefa.tentou ?? 0} / ${tarefa.tentativa}
Tempo:  ${tarefa.tempo}h
Notas: $notas
                        '''),
//                         subtitle: Text('''
// Inicio: ${tarefa.inicio}
// fim: ${tarefa.fim}
// id: ${tarefa.id}
// Aberta: ${tarefa.aberta}
//                         '''),

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
