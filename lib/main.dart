import 'package:flutter/material.dart';
import 'package:pialuno/bootstrap.dart';
import 'package:pialuno/paginas/avaliacao/avaliacao_list_page.dart';
import 'package:pialuno/paginas/desenvolvimento/desenvolvimento_page.dart';
import 'package:pialuno/paginas/login/home.dart';
import 'package:pialuno/paginas/login/versao.dart';
import 'package:pialuno/paginas/questao/questao_list_page.dart';
import 'package:pialuno/paginas/tarefa/tarefa_aberta_list_page.dart';
import 'package:pialuno/paginas/tarefa/tarefa_aberta_responder_page.dart';
import 'package:pialuno/paginas/tarefa/tarefa_list_page.dart';
import 'package:pialuno/paginas/tarefa/tarefa_page.dart';
import 'package:pialuno/paginas/turma/turma_list_page.dart';
import 'package:pialuno/paginas/upload/uploader_page.dart';
import 'package:pialuno/paginas/usuario/perfil_page.dart';
import 'package:pialuno/plataforma/recursos.dart';
import 'package:pialuno/web.dart';

void main() {
  webSetUp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authBloc = Bootstrap.instance.authBloc;
    Recursos.initialize(Theme.of(context).platform);

    return MaterialApp(
      title: 'PI - ALUNO',
      theme: ThemeData.dark(),
      initialRoute: "/tarefa/aberta",
      routes: {
        //homePage
        "/": (context) => HomePage(authBloc),

        //upload
        "/upload": (context) => UploaderPage(authBloc),

        //desenvolvimento
        "/desenvolvimento": (context) => Desenvolvimento(),

        //tarefa
        "/tarefa/aberta": (context) => TarefaAbertaListPage(authBloc),
        "/tarefa/responder": (context) {
          final settings = ModalRoute.of(context).settings;
          return TarefaAbertaResponderPage(settings.arguments);
        },
        "/tarefa/list": (context) {
          final settings = ModalRoute.of(context).settings;
          return TarefaListPage(authBloc, settings.arguments);
        },
        // "/tarefa": (context) {
        //   final settings = ModalRoute.of(context).settings;
        //   return TarefaPage(authBloc, settings.arguments);
        // },

        //turma
        "/turma/list": (context) => TurmaListPage(authBloc),

        //avaliacao
        "/avaliacao/list": (context) {
          final settings = ModalRoute.of(context).settings;
          return AvaliacaoListPage(authBloc, settings.arguments);
        },

        //questao
        "/questao/list": (context) {
          final settings = ModalRoute.of(context).settings;
          return QuestaoListPage(settings.arguments);
        },

        //EndDrawer
        //perfil
        "/perfil": (context) => PerfilPage(authBloc),
        //Versao
        "/versao": (context) => Versao(),
      },
    );
  }
}
