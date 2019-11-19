import 'package:flutter/material.dart';
import 'package:pialuno/auth_bloc.dart';
import 'package:pialuno/componentes/default_scaffold.dart';
import 'package:pialuno/paginas/login/bemvindo_bloc.dart';

class BemVindoPage extends StatefulWidget {
  final AuthBloc authBloc;

  BemVindoPage(this.authBloc);

  _BemVindoPageState createState() => _BemVindoPageState(this.authBloc);
}

class _BemVindoPageState extends State<BemVindoPage> {
  BemvindoBloc bloc;
  _BemVindoPageState(AuthBloc authBloc) : bloc = BemvindoBloc(authBloc);

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
      title: StreamBuilder<BemvindoBlocState>(
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
          "Seja bem vindo(a)\nAo Aplicativo PI, versão para aluno.\nAqui você responde de forma simples\nsuas tarefas de escola, curso ou faculdade.",
          style: TextStyle(
            color: Colors.blue,
            fontSize: 22.0,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
