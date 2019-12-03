import 'package:flutter/material.dart';
import 'package:pialuno/auth_bloc.dart';
import 'package:pialuno/componentes/login_required.dart';
import 'package:pialuno/paginas/login/bemvindo_page.dart';


class HomePage extends StatefulWidget {
final AuthBloc authBloc;
  HomePage(this.authBloc);

  _HomePageState createState() => _HomePageState(this.authBloc);
}

class _HomePageState extends State<HomePage> {

  final AuthBloc authBloc;
  _HomePageState(this.authBloc);

  @override
  Widget build(BuildContext context) {
    return DefaultLoginRequired(
      child: BemVindoPage(widget.authBloc),
      // child: TarefaAbertaListPage(widget.authBloc),
      authBloc: this.authBloc,
    );
  }
}
