import 'package:flutter/material.dart';
import 'package:pialuno/bloc/auth_bloc.dart';
import 'package:pialuno/componentes/default_scaffold.dart';
import 'package:pialuno/paginas/login/geral_bloc.dart';


class BemVindo extends StatefulWidget {
  final AuthBloc authBloc;

  BemVindo(this.authBloc);

  _BemVindoState createState() => _BemVindoState(this.authBloc);
}

class _BemVindoState extends State<BemVindo> {
  GeralBloc bloc;
  _BemVindoState(AuthBloc authBloc) : bloc = GeralBloc(authBloc);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      title: StreamBuilder<GeralBlocState>(
        stream: bloc.stateStream,
        builder: (context, snap) {
          if (snap.hasError) {
            return Text("ERROR");
          }
          if (!snap.hasData) {
            return Text("Buscando usuario...");
          }
          return Text("Olá ${snap.data?.usuarioID?.cracha}");
        },
      ),
      body: Center(
        child: Text(
            "Seja bem vindo(a)\nAo Aplicativo PI, versão para aluno.\nAqui você responde de forma simples\nsuas tarefas de escola, curso ou faculdade."),
      ),
    );
  }
}
