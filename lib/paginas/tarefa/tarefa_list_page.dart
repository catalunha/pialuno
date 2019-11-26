import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pialuno/auth_bloc.dart';
import 'package:pialuno/bootstrap.dart';
import 'package:pialuno/modelos/simulacao_model.dart';
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
          title: Text('Tarefas'),
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
                Map<String, Gabarito> gabaritoMap = Map<String, Gabarito>();

                for (var tarefa in snapshot.data.tarefaList) {
                  // print('tarefa.id: ${tarefa.id}');
                  gabaritoMap.clear();
                  var dicPedese = Dictionary.fromMap(tarefa.gabarito);
                  var gabaritoOrderBy = dicPedese
                      .orderBy((kv) => kv.value.ordem)
                      .toDictionary$1((kv) => kv.key, (kv) => kv.value);
                  gabaritoMap = gabaritoOrderBy.toMap();
                  notas = '';
                  for (var gabarito in gabaritoMap.entries) {
                    notas += '${gabarito.value.nome}=${gabarito.value.nota ?? "?"} ';
                  }
                  listaWidget.add(
                    Card(
                      child: ListTile(
                        // trailing: Text('${tarefa.questao.numero}'),
                        trailing: Text('${tarefa.questao.numero}'),
                        // selected: tarefa.iniciou != null,
// Turma: ${tarefa.turma.nome}
// Prof.: ${tarefa.professor.nome}
// Aval.: ${tarefa.avaliacao.nome}
                        title: Text('''
Prob.: ${tarefa.problema.nome}
Aberta: ${DateFormat('dd-MM HH:mm').format(tarefa.inicio)} até ${DateFormat('dd-MM HH:mm').format(tarefa.fim)}
Iniciou: ${tarefa.iniciou==null ? "" :DateFormat('dd-MM HH:mm').format(tarefa.iniciou)}. Enviou: ${tarefa.enviou==null ? "" :DateFormat('dd-MM HH:mm').format(tarefa.enviou)}.
Tempo:  ${tarefa.tempo}h. Usou ${tarefa.tentou ?? 0} das ${tarefa.tentativa} tentativas.
Sit.: $notas'''),
                        subtitle: Text('id: ${tarefa.id}'),
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
