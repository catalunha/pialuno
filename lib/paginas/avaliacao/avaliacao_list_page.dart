import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
import 'package:pialuno/auth_bloc.dart';
import 'package:pialuno/bootstrap.dart';
import 'package:pialuno/paginas/avaliacao/avaliacao_list_bloc.dart';

class AvaliacaoListPage extends StatefulWidget {
  final AuthBloc authBloc;
  final String turma;

  const AvaliacaoListPage(this.authBloc, this.turma);

  @override
  _AvaliacaoListPageState createState() => _AvaliacaoListPageState();
}

class _AvaliacaoListPageState extends State<AvaliacaoListPage> {
  AvaliacaoListBloc bloc;
  @override
  void initState() {
    super.initState();
    bloc = AvaliacaoListBloc(
      Bootstrap.instance.firestore,
      widget.authBloc,
    );
    bloc.eventSink(GetTurmaIDEvent(widget.turma));
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
          title: Text('Avaliações'),
        ),
        body: StreamBuilder<AvaliacaoListBlocState>(
            stream: bloc.stateStream,
            builder: (BuildContext context,
                AsyncSnapshot<AvaliacaoListBlocState> snapshot) {
              if (snapshot.hasError) {
                return Text("Existe algo errado! Informe o suporte.");
              }
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.data.isDataValid) {
                List<Widget> listaWidget = List<Widget>();

                for (var avaliacao in snapshot.data.avaliacaoList) {
                  listaWidget.add(
                    Card(
                      child: ListTile(
                        title: Text('''
Turma: ${avaliacao.turma.nome}
Prof.: ${avaliacao.professor.nome}
Avaliacao: ${avaliacao.nome}
                        '''),
// Nota da avaliação: ${avaliacao.nota}
// Aberta: ${DateFormat('dd-MM HH:mm').format(avaliacao.inicio)} até ${DateFormat('dd-MM HH:mm').format(avaliacao.fim)}
// Inicio: ${DateFormat('dd-MM HH:mm').format(avaliacao.inicio)}
// Inicio: ${avaliacao.inicio}
// fim: ${avaliacao.fim}
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            "/tarefa/list",
                            arguments: avaliacao.id,
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
