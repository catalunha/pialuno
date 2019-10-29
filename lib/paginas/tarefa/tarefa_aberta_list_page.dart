import 'package:flutter/material.dart';
import 'package:pialuno/auth_bloc.dart';
import 'package:pialuno/bootstrap.dart';
import 'package:pialuno/componentes/default_scaffold.dart';
import 'package:pialuno/paginas/tarefa/tarefa_aberta_list_bloc.dart';

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
                return Text("Sem dados ...");
              }
              if (snapshot.data.isDataValid) {
                print('dados validos...');

                List<Widget> listaWidget = List<Widget>();
                for (var tarefa in snapshot.data.tarefaList) {
                  // print('tarefa.id: ${tarefa.id}');
                  listaWidget.add(
                    Card(
                      child: ListTile(
                        title: Text('id: ${tarefa.id}'),
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
