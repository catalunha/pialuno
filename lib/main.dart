import 'package:flutter/material.dart';
import 'package:pialuno/bootstrap.dart';
import 'package:pialuno/paginas/login/home.dart';
import 'package:pialuno/paginas/login/versao.dart';
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
      initialRoute: "/",
      routes: {
        //homePage
        "/": (context) => HomePage(authBloc),
        //upload
        "/upload": (context) => UploaderPage(authBloc),

        //EndDrawer
        //perfil
        "/perfil": (context) => PerfilPage(authBloc),
        //Versao
        "/versao": (context) => Versao(),
      },
    );
  }
}
