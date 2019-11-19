import 'package:flutter/material.dart';
import 'package:pialuno/auth_bloc.dart';
import 'package:pialuno/bootstrap.dart';
import 'package:pialuno/componentes/default_scaffold.dart';
import 'package:pialuno/paginas/turma/turma_list_bloc.dart';
import 'package:pialuno/naosuportato/url_launcher.dart' if (dart.library.io) 'package:url_launcher/url_launcher.dart';

class TurmaListPage extends StatefulWidget {
  final AuthBloc authBloc;

  const TurmaListPage(this.authBloc);

  @override
  _TurmaListPageState createState() => _TurmaListPageState();
}

class _TurmaListPageState extends State<TurmaListPage> {
  TurmaListBloc bloc;
  @override
  void initState() {
    super.initState();
    bloc = TurmaListBloc(
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
        title: Text('Turmas'),
        body: StreamBuilder<TurmaListBlocState>(
            stream: bloc.stateStream,
            builder: (BuildContext context, AsyncSnapshot<TurmaListBlocState> snapshot) {
              if (snapshot.hasError) {
                return Text("Existe algo errado! Informe o suporte.");
              }
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.data.isDataValid) {
                List<Widget> listaWidget = List<Widget>();

                for (var turma in snapshot.data.turmaList) {
                  listaWidget.add(
                    Card(
                      child: ListTile(
                        title: Text('''
Inst.: ${turma.instituicao}
Comp.: ${turma.componente}
Turma: ${turma.nome}
Prof.: ${turma.professor.nome}'''),
                        trailing: IconButton(
                          icon: Icon(Icons.local_library),
                          onPressed: () {
                            try {
                              launch(turma.programa);
                            } catch (_) {}
                          },
                        ),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            "/avaliacao/list",
                            arguments: turma.id,
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
