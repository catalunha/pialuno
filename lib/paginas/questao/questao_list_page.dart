import 'package:flutter/material.dart';
import 'package:pialuno/bootstrap.dart';
import 'package:pialuno/paginas/questao/questao_list_bloc.dart';

class QuestaoListPage extends StatefulWidget {
  final String avaliacao;

  const QuestaoListPage(this.avaliacao);

  @override
  _QuestaoListPageState createState() => _QuestaoListPageState();
}

class _QuestaoListPageState extends State<QuestaoListPage> {
  QuestaoListBloc bloc;
  @override
  void initState() {
    super.initState();
    bloc = QuestaoListBloc(
      Bootstrap.instance.firestore,
    );
    bloc.eventSink(UpdateQuestaoListEvent(widget.avaliacao));
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
          title: Text('Suas Questões'),
        ),
        body: StreamBuilder<QuestaoListBlocState>(
            stream: bloc.stateStream,
            builder: (BuildContext context,
                AsyncSnapshot<QuestaoListBlocState> snapshot) {
              if (snapshot.hasError) {
                return Text("Existe algo errado. Informe o suporte");
              }
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.data.isDataValid) {
                List<Widget> listaWidget = List<Widget>();

                for (var questao in snapshot.data.questaoList) {
                  listaWidget.add(
                    Card(
                      child: ListTile(
                        trailing: Text('${questao.numero}'),
                        title: Text('''
Turma: ${questao.turma.nome}
Prof.: ${questao.professor.nome}
Aval.: ${questao.avaliacao.nome}
Sit.: ${questao.situacao.nome}
Inicio: ${questao.inicio}
fim: ${questao.fim}
Tentativa | Tempo : ${questao.tentativa} | ${questao.tempo}h
Nota da questao: ${questao.nota}
                        '''),
                                                subtitle: Text('''
id: ${questao.id}
                        '''),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            "/tarefa",
                            arguments: questao.id,
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
