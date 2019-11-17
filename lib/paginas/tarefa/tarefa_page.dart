import 'package:flutter/material.dart';
import 'package:pialuno/auth_bloc.dart';
import 'package:pialuno/bootstrap.dart';
import 'package:pialuno/modelos/simulacao_model.dart';
import 'package:pialuno/modelos/tarefa_model.dart';
import 'package:pialuno/paginas/tarefa/tarefa_bloc.dart';
import 'package:queries/collections.dart';

class TarefaPage extends StatefulWidget {
  final AuthBloc authBloc;
  final String questao;

  const TarefaPage(this.authBloc, this.questao);

  @override
  _TarefaPageState createState() => _TarefaPageState();
}

class _TarefaPageState extends State<TarefaPage> {
  TarefaBloc bloc;
  @override
  void initState() {
    super.initState();
    bloc = TarefaBloc(
      Bootstrap.instance.firestore,
      widget.authBloc,
    );
    bloc.eventSink(GetQuestaoIDEvent(widget.questao));
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
          title: Text('Sua Tarefa'),
        ),
        body: StreamBuilder<TarefaBlocState>(
            stream: bloc.stateStream,
            builder: (BuildContext context,
                AsyncSnapshot<TarefaBlocState> snapshot) {
              if (snapshot.hasError) {
                return Text("Existe algo errado! Informe o suporte.");
              }
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.data.isDataValid) {
                String notas = '';
                Map<String, Gabarito> gabaritoMap = Map<String, Gabarito>();
                TarefaModel tarefa = snapshot.data.tarefaModel;

                gabaritoMap.clear();
                var dicPedese = Dictionary.fromMap(tarefa.gabarito);
                var gabaritoOrderBy = dicPedese
                    .orderBy((kv) => kv.value.ordem)
                    .toDictionary$1((kv) => kv.key, (kv) => kv.value);
                gabaritoMap = gabaritoOrderBy.toMap();
                notas = '';
                for (var gabarito in gabaritoMap.entries) {
                  notas += '${gabarito.value.nome}=${gabarito.value.nota} ';
                }

Widget card = Card(
                      child: ListTile(
                        // trailing: Text('${tarefa.questao.numero}'),
                        trailing: Text('${tarefa.questao.numero}'),
                        selected: tarefa.iniciou != null,
                        title: Text('''
Turma: ${tarefa.turma.nome}
Prof.: ${tarefa.professor.nome}
Aval.: ${tarefa.avaliacao.nome}
Ques.: ${tarefa.problema.nome}
Inicio: ${tarefa.inicio}
Iniciou: ${tarefa.iniciou}
Enviou: ${tarefa.enviou}
fim: ${tarefa.fim}
Tentativas: ${tarefa.tentou} / ${tarefa.tentativa}
Tempo:  ${tarefa.tempo} h
Notas: $notas
                        '''),
//                         subtitle: Text('''
// id: ${tarefa.id}
// Aberta: ${tarefa.aberta}
//                         '''),
                        
                      ),
                    );

                return card;
              } else {
                return Text('Existem dados inválidos. Informe o suporte.');
              }
            }));
  }
}
