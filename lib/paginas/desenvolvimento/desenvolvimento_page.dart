import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:firestore_wrapper/firestore_wrapper.dart' as fw;
import 'package:pialuno/bootstrap.dart';
import 'package:pialuno/componentes/default_scaffold.dart';
import 'package:pialuno/modelos/avaliacao_model.dart';
import 'package:pialuno/modelos/questao_model.dart';
import 'package:pialuno/modelos/situacao_model.dart';
import 'package:pialuno/modelos/tarefa_model.dart';
import 'package:pialuno/modelos/turma_model.dart';
import 'package:pialuno/modelos/upload_model.dart';
import 'package:pialuno/modelos/usuario_model.dart';

class Desenvolvimento extends StatefulWidget {
  @override
  _DesenvolvimentoState createState() => _DesenvolvimentoState();
}

class _DesenvolvimentoState extends State<Desenvolvimento> {
  final fw.Firestore _firestore = Bootstrap.instance.firestore;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
        title: Text('Desenvolvimento'),
        body: ListView(
          children: <Widget>[
            Text(
                'Algumas vezes precisamos fazer alimentação das coleções para testes. Por isto criei estes botões para facilitar de forma rápida estas ações.'),
            ListTile(
              title: Text('Criar Usuario em UsuarioCollection.'),
              trailing: IconButton(
                icon: Icon(Icons.menu),
                onPressed: () async {
                  // await cadastrarUsuario('Aq96qoxA0zgLfNDPGPCzFRAYtkl2');
                },
              ),
            ),
            ListTile(
              title: Text('Atualizar rotas de UsuarioCollection.'),
              trailing: IconButton(
                icon: Icon(Icons.menu),
                onPressed: () async {
                  // await atualizarRotaIndividual('YaTtTki7PZPPHznqpVtZrW6mIa42');
                  // await atualizarRotaTodos();
                },
              ),
            ),
            ListTile(
              title: Text('Cadastrar Tarefa.'),
              trailing: IconButton(
                icon: Icon(Icons.menu),
                onPressed: () async {
                  await cadastrarTarefa('0Teste1');
                },
              ),
            ),
            ListTile(
              title: Text('Testar comandos firebase.'),
              trailing: IconButton(
                icon: Icon(Icons.menu),
                onPressed: () async {
                  // await testarFirebaseCmds();
                },
              ),
            ),
          ],
        ));
  }

  Future atualizarRotaTodos() async {
    var collRef =
        await _firestore.collection(UsuarioModel.collection).getDocuments();

    for (var documentSnapshot in collRef.documents) {
      if (documentSnapshot.data.containsKey('routes')) {
        List<dynamic> routes = List<dynamic>();

        routes.addAll(documentSnapshot.data['routes']);
        print(routes.runtimeType);
        routes.addAll([
          // Drawer
          // '/',
          // '/upload',
          // '/questionario/home',
          // '/aplicacao/home',
          // '/resposta/home',
          // '/sintese/home',
          // '/produto/home',
          // '/comunicacao/home',
          // '/administracao/home',
          // '/controle/home',
          // "/perfil/configuracao",
          // endDrawer
          '/perfil/configuracao',
          '/perfil',
          // '/painel/home',
          '/modooffline',
          "/versao",
        ]);

        await documentSnapshot.reference
            .setData({"routes": routes}, merge: true);
      } else {
        print('Sem routes ${documentSnapshot.documentID}');
      }
    }
  }

  Future atualizarRotaIndividual(String userId) async {
    final docRef =
        _firestore.collection(UsuarioModel.collection).document(userId);
    var snap = await docRef.get();
    List<dynamic> routes = List<dynamic>();
    routes.addAll(snap.data['routes']);
    print(routes.runtimeType);
    routes.addAll([
      //Drawer
      // '/',
      // '/upload',
      // '/questionario/home',
      // '/aplicacao/home',
      // '/resposta/home',
      // '/sintese/home',
      // '/produto/home',
      // '/comunicacao/home',
      // '/administracao/home',
      // '/controle/home',
      // "/perfil/configuracao",
      // endDrawer
      '/perfil/configuracao',
      '/perfil',
      // '/painel/home',
      '/modooffline',
      "/versao",
    ]);

    await docRef.setData({"routes": routes}, merge: true);
  }

  Future cadastrarUsuario(String userId) async {
    // UsuarioModel usuarioModel = UsuarioModel(
    //   id: userId,
    //   ativo: true,
    //   nome: 'Catalunha UFT',
    //   celular: '0',
    //   email: 'catalunha@uft.edu.br',
    //   routes: [
    //     '/',
    //     '/desenvolvimento',
    //     '/upload',
    //     '/questionario/home',
    //     '/aplicacao/home',
    //     '/resposta/home',
    //     '/sintese/home',
    //     '/produto/home',
    //     '/comunicacao/home',
    //     '/administracao/home',
    //     '/controle/home'
    //   ],
    //   cargoID: CargoID(id: 'coordenador', nome: 'Coord'),
    //   eixoID: EixoID(id: 'estatisticadsti', nome: ''),
    //   eixoIDAtual: EixoID(id: 'estatisticadsti', nome: ''),
    //   eixoIDAcesso: [
    //     EixoID(id: 'abastecimentodeagua', nome: 'Abastecimento de Agua'),
    //     EixoID(id: 'drenagemurbana', nome: 'Drenagem Urbana'),
    //     EixoID(id: 'esgotamentosanitario', nome: 'Esgotamento Sanitário'),
    //     EixoID(id: 'residuosolido', nome: 'Resíduo Sólido'),
    //     EixoID(id: 'comunicacao', nome: 'Comunicação'),
    //     EixoID(id: 'direcao', nome: 'Direção'),
    //     EixoID(id: 'administracao', nome: 'Administração'),
    //     EixoID(id: 'saude', nome: 'Saúde'),
    //   ],
    //   setorCensitarioID: SetorCensitarioID(id: 'palmas', nome: 'pal'),
    // );
    // final docRef =
    //     _firestore.collection(UsuarioModel.collection).document(userId);

    // await docRef.setData(usuarioModel.toMap(), merge: true);
    // // print('>>> ok <<< ');
  }

  Future cadastrarTarefa(String tarefaId) async {
    final docRef =
        _firestore.collection(TarefaModel.collection).document(tarefaId);

    TarefaModel tarefaModel = TarefaModel(
      id: tarefaId,
      ativo: true,
      professor: UsuarioFk(id: 'prof01', nome: 'prof01'),
      turma: TurmaFk(id: 'turma01', nome: 'turma01'),
      avaliacao: AvaliacaoFk(id: 'avaliacao01', nome: 'avaliacao01'),
      questao: QuestaoFk(id: 'questao01', numero: 1),
      aluno: UsuarioFk(id: 'PMAxu4zKfmaOlYAmF3lgFGmCR1w2', nome: 'Cata'),
      modificado: DateTime.now(),
      inicio: DateTime.parse('2019-10-29T08:00:00.000Z'),
      // iniciou: DateTime.parse('2019-10-29T09:00:00.000Z'),
      // editou: DateTime.parse('2019-10-29T09:30:00.000Z'),
      fim: DateTime.parse('2019-10-29T12:00:00.000Z'),
      tentativa: 3,
      // tentou: 0,
      tempo: 2,
      aberta: true,
      situacao: SituacaoFk(
        id: 'situacao01',
        nome: 'situacao01',
        url:
            'https://firebasestorage.googleapis.com/v0/b/pi-brintec.appspot.com/o/texto_base.pdf?alt=media&token=617247d1-e4ae-452f-b79a-16a964a6745a',
      ),
      simulacao: 'simulacao01',
      variavel: {
        'var01': Variavel(
          nome: 'N1',
          ordem: 0,
          valor: '1',
        )
      },
      pedese: {
        'pedese01':Pedese(nome: 'a',ordem: 0,tipo: 'numero',gabarito: '2'),
      }
    );
    await docRef.setData(tarefaModel.toMap(), merge: true);
  }

  Future testarFirebaseCmds() async {
    print('+++ testarFirebaseCmds');
    UsuarioModel usuarioModel = UsuarioModel(
      id: 'PMAxu4zKfmaOlYAmF3lgFGmCR1w2',
      foto: UploadFk(uploadID: 'NFnVSDPpbOwQejMu1jXh', url: null),
    );
    final docRef = _firestore
        .collection(UsuarioModel.collection)
        .document('PMAxu4zKfmaOlYAmF3lgFGmCR1w2');
    await docRef.setData(usuarioModel.toMap(), merge: true);

    // final docRef = await _firestore
    //     .collection(UsuarioModel.collection)
    //     .where('routes', arrayContains: '/comunicacao/home')
    //     .getDocuments();
    // for (var item in docRef.documents) {
    //   print('Doc encontrados: ${item.documentID}');
    // }
    print('--- testarFirebaseCmds');
  }
}
