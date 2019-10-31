import 'package:flutter/material.dart';
import 'package:pialuno/auth_bloc.dart';
import 'package:pialuno/bootstrap.dart';
import 'package:pialuno/modelos/usuario_model.dart';
import 'package:pialuno/plataforma/recursos.dart';
import 'package:pialuno/servicos/cache_service.dart';

class Rota {
  final String nome;
  final IconData icone;

  Rota(this.nome, this.icone);
}

class DefaultDrawer extends StatefulWidget {
  _DefaultDrawerState createState() => _DefaultDrawerState();
}

class _DefaultDrawerState extends State<DefaultDrawer> {
  final AuthBloc authBloc;
  Map<String, Rota> rotas;

  _DefaultDrawerState() : authBloc = Bootstrap.instance.authBloc {
    rotas = Map<String, Rota>();
    if (Recursos.instance.plataforma == 'android') {
      // rotas["/"] = Rota("Home", Icons.home);
      rotas["/tarefa/aberta"] = Rota("Tarefas abertas", Icons.assignment);
      rotas["/upload"] = Rota("Upload de arquivos", Icons.file_upload);
      rotas["/turma/list"] =
          Rota("Suas turmas", Icons.book);
      // rotas["/avaliacao/list"] = Rota("Resposta", Icons.playlist_add_check);
      // rotas["/sintese/home"] = Rota("Síntese", Icons.equalizer);
      // rotas["/produto/home"] = Rota("Produto", Icons.chrome_reader_mode);
      // rotas["/controle/home"] = Rota("Controle", Icons.control_point);
      // rotas["/setor_painel/home"] = Rota("Painel", Icons.compare);
      // // rotas["/comunicacao/home"] = Rota("Comunicação", Icons.contact_mail);
      // rotas["/administracao/home"] =
      //     Rota("Administração", Icons.business_center);
      rotas["/desenvolvimento"] = Rota("Desenvolvimento", Icons.build);
    } else if (Recursos.instance.plataforma == 'web') {
      rotas["/"] = Rota("Home", Icons.home);
      // rotas["/questionario/home"] = Rota("Questionários", Icons.assignment);
      // rotas["/resposta/home"] = Rota("Resposta", Icons.playlist_add_check);
      // rotas["/sintese/home"] = Rota("Síntese", Icons.equalizer);
      // rotas["/produto/home"] = Rota("Produto", Icons.chrome_reader_mode);
      // rotas["/controle/home"] = Rota("Controle", Icons.control_point);
      // rotas["/setor_painel/home"] = Rota("Painel", Icons.compare);
      // rotas["/administracao/home"] =
      //     Rota("Administração", Icons.business_center);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: SafeArea(
      child: Column(children: <Widget>[
        StreamBuilder<UsuarioModel>(
          stream: authBloc.perfil,
          builder: (context, snap) {
            if (snap.hasError) {
              return Center(
                child: Text("Erro"),
              );
            }
            if (!snap.hasData)
              return Center(
                child: CircularProgressIndicator(),
              );

            return DrawerHeader(
              child: Container(
                // decoration: BoxDecoration(
                //   border: Border(
                //     bottom: BorderSide(
                //         color: Theme.of(context).textTheme.title.color),
                //   ),
                // ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                        flex: 14,
                        child: Row(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                                flex: 4,
                                child: _ImagemUnica(
                                    fotoUrl: snap.data?.foto?.url,
                                    fotoUploadID: snap.data?.foto?.uploadID)),
                            Expanded(
                              flex: 8,
                              child: Container(
                                padding: EdgeInsets.only(left: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Text("${snap.data.cracha}"),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Text("${snap.data.celular}"),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Text("${snap.data.matricula}"),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Text("${snap.data.nome}"),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )),
                    Expanded(
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text("${snap.data.email}"),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.only(top: 8),
                      //   child: Text("${snap.data.nome}"),
                      // ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
        StreamBuilder<UsuarioModel>(
            stream: authBloc.perfil,
            builder: (context, snap) {
              if (snap.hasError) {
                return Center(
                  child: Text("Erro"),
                );
              }

              List<Widget> list = List<Widget>();
              if (snap.data == null ||
                  snap.data.rota == null ||
                  snap.data.rota.isEmpty) {
                list.add(Container());
              } else {
                rotas.forEach((k, v) {
                  if (snap.data.rota.contains(k)) {
                    list.add(ListTile(
                      title: Text(v.nome),
                      trailing: Icon(v.icone),
                      onTap: () {
                        Navigator.pushReplacementNamed(context, k);
                      },
                    ));
                  }
                });
              }
              if (list.isEmpty || list == null) {
                list.add(Container());
              }
              return Expanded(child: ListView(children: list));
            })
      ]),
    ));
  }
}

class _ImagemUnica extends StatelessWidget {
  final String fotoUrl;
  final String fotoUploadID;

  const _ImagemUnica({this.fotoUrl, this.fotoUploadID});

  @override
  Widget build(BuildContext context) {
    Widget foto;
    if (fotoUrl == null && fotoUploadID != null) {
      foto = Center(child: Text('Enviar imagem.'));
    } else if (fotoUrl != null) {
      foto = CircleAvatar(
        minRadius: 40,
        maxRadius: 50,
        backgroundImage: NetworkImage(fotoUrl),
      );
    }

    return Row(
      children: <Widget>[
        Spacer(
          flex: 1,
        ),
        Expanded(
          flex: 8,
          child: foto,
        ),
        Spacer(
          flex: 1,
        ),
      ],
    );
  }
}

class DefaultEndDrawer extends StatefulWidget {
  _DefaultEndDrawerState createState() => _DefaultEndDrawerState();
}

class _DefaultEndDrawerState extends State<DefaultEndDrawer> {
  final AuthBloc authBloc;
  Map<String, Rota> rotas;

  _DefaultEndDrawerState() : authBloc = Bootstrap.instance.authBloc {
    rotas = Map<String, Rota>();
    if (Recursos.instance.plataforma == 'android') {
      rotas["/perfil"] = Rota("Perfil", Icons.settings);
      // rotas["/perfil"] = Rota("Itens do Perfil", Icons.person);
      // rotas["/painel/home"] = Rota("Itens do Painel", Icons.table_chart);
      rotas["/versao"] = Rota("Versão & Sobre", Icons.device_unknown);
      // rotas["/noticias/noticias_visualizadas"] = Rota("Noticias lidas", Icons.event_available);
      rotas["/modooffline"] = Rota("Habilitar modo offline", Icons.save);
    } else if (Recursos.instance.plataforma == 'web') {
      rotas["/perfil"] = Rota("Perfil", Icons.settings);
      // rotas["/painel/home"] = Rota("Itens do Painel", Icons.table_chart);
      rotas["/versao"] = Rota("Versão & Sobre", Icons.device_unknown);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(children: <Widget>[
          StreamBuilder<UsuarioModel>(
              stream: authBloc.perfil,
              builder: (context, snap) {
                if (snap.hasError) {
                  return Center(
                    child: Text("Erro"),
                  );
                }
                List<Widget> list = List<Widget>();
                if (snap.data == null ||
                    snap.data.rota == null ||
                    snap.data.rota.isEmpty) {
                  list.add(Container());
                } else {
                  rotas.forEach((k, v) {
                    if (snap.data.rota.contains(k)) {
                      if (k == '/modooffline') {
                        list.add(ListTile(
                          title: Text("Habilitar modo offline"),
                          onTap: () async {
                            final cacheService =
                                CacheService(Bootstrap.instance.firestore);
                            await cacheService.load();
                            Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text("Modo offline completo.")));
                            Navigator.pop(context);
                          },
                          leading: Icon(Icons.save),
                        ));
                      } else {
                        list.add(ListTile(
                          title: Text(v.nome),
                          leading: Icon(v.icone),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, k);
                          },
                        ));
                      }
                    }
                  });
                }
                list.add(ListTile(
                  title: Text('Trocar de usuário'),
                  onTap: () {
                    authBloc.dispatch(LogoutAuthBlocEvent());
                    Navigator.pushReplacementNamed(context, "/");
                  },
                  leading: Icon(Icons.exit_to_app),
                ));
                return Expanded(child: ListView(children: list));
              })
        ]),
      ),
    );
  }
}

class MoreAppAction extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Icon(Icons.more_vert),
      onTap: () {
        Scaffold.of(context).openEndDrawer();
      },
    );
  }
}

class DefaultScaffold extends StatelessWidget {
  final Widget body;
  final Widget floatingActionButton;
  final Widget title;
  final Widget actions;
  final List<Widget> actionsMore;
  final Widget bottom;
  final Color backgroundColor;
  final FloatingActionButtonLocation floatingActionButtonLocation;

  const DefaultScaffold({
    Key key,
    this.body,
    this.floatingActionButton,
    this.title,
    this.actions,
    this.actionsMore,
    this.backgroundColor,
    this.bottom,
    this.floatingActionButtonLocation,
  }) : super(key: key);

  Widget _appBarBuild(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      actions: <Widget>[
        if (actionsMore != null) ...actionsMore,
        MoreAppAction(),
      ],
      centerTitle: true,
      title: title,
      bottom: bottom,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DefaultDrawer(),
      endDrawer: DefaultEndDrawer(),
      appBar: _appBarBuild(context),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      body: body,
    );
  }
}
