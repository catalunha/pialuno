import 'package:pialuno/bootstrap.dart';
import 'package:pialuno/modelos/avaliacao_model.dart';
import 'package:pialuno/modelos/base_model.dart';
import 'package:pialuno/modelos/questao_model.dart';
import 'package:pialuno/modelos/situacao_model.dart';
import 'package:pialuno/modelos/turma_model.dart';
import 'package:pialuno/modelos/usuario_model.dart';

class TarefaModel extends FirestoreModel {
  static final String collection = "Tarefa";
  bool ativo;
  UsuarioFk professor;
  TurmaFk turma;
  AvaliacaoFk avaliacao;
  QuestaoFk questao;
  UsuarioFk aluno;
  dynamic modificado;
  dynamic inicio;
  dynamic iniciou;
  dynamic enviou;
  dynamic fim;
  int tentativa;
  dynamic tentou;
  int tempo;
  String erroRelativo;
  String avaliacaoNota;
  String questaoNota;
  bool aberta;
  SituacaoFk situacao;
  String simulacao;
  Map<String, Variavel> variavel;
  Map<String, Pedese> pedese;

  // dynamic responderAte;
  // dynamic _tempoPResponder;

  TarefaModel({
    String id,
    this.ativo,
    this.professor,
    this.turma,
    this.avaliacao,
    this.questao,
    this.aluno,
    this.modificado,
    this.inicio,
    this.iniciou,
    this.enviou,
    this.fim,
    this.tentativa,
    this.tentou,
    this.tempo,
    this.erroRelativo,
    this.avaliacaoNota,
    this.questaoNota,
    this.aberta,
    this.situacao,
    this.simulacao,
    this.variavel,
    this.pedese,
  }) : super(id);

  @override
  TarefaModel fromMap(Map<String, dynamic> map) {
    if (map.containsKey('ativo')) ativo = map['ativo'];
    professor = map.containsKey('professor') && map['professor'] != null
        ? UsuarioFk.fromMap(map['professor'])
        : null;
    turma = map.containsKey('turma') && map['turma'] != null
        ? TurmaFk.fromMap(map['turma'])
        : null;
    avaliacao = map.containsKey('avaliacao') && map['avaliacao'] != null
        ? AvaliacaoFk.fromMap(map['avaliacao'])
        : null;
    questao = map.containsKey('questao') && map['questao'] != null
        ? QuestaoFk.fromMap(map['questao'])
        : null;
    aluno = map.containsKey('aluno') && map['aluno'] != null
        ? UsuarioFk.fromMap(map['aluno'])
        : null;

    modificado = map.containsKey('modificado') && map['modificado'] != null
        ? DateTime.fromMillisecondsSinceEpoch(
            map['modificado'].millisecondsSinceEpoch)
        : null;
    inicio = map.containsKey('inicio') && map['inicio'] != null
        ? DateTime.fromMillisecondsSinceEpoch(
            map['inicio'].millisecondsSinceEpoch)
        : null;
    iniciou = map.containsKey('iniciou') && map['iniciou'] != null
        ? DateTime.fromMillisecondsSinceEpoch(
            map['iniciou'].millisecondsSinceEpoch)
        : null;
    enviou = map.containsKey('enviou') && map['enviou'] != null
        ? DateTime.fromMillisecondsSinceEpoch(
            map['enviou'].millisecondsSinceEpoch)
        : null;
    fim = map.containsKey('fim') && map['fim'] != null
        ? DateTime.fromMillisecondsSinceEpoch(map['fim'].millisecondsSinceEpoch)
        : null;
    if (map.containsKey('tentativa')) tentativa = map['tentativa'];
    if (map.containsKey('tentou')) tentou = map['tentou'];
    if (map.containsKey('tempo')) tempo = map['tempo'];
    if (map.containsKey('erroRelativo')) erroRelativo = map['erroRelativo'];
    if (map.containsKey('avaliacaoNota')) avaliacaoNota = map['avaliacaoNota'];
    if (map.containsKey('questaoNota')) questaoNota = map['questaoNota'];

    if (map.containsKey('aberta')) aberta = map['aberta'];
    situacao = map.containsKey('situacao') && map['situacao'] != null
        ? SituacaoFk.fromMap(map['situacao'])
        : null;
    if (map.containsKey('simulacao')) simulacao = map['simulacao'];

    if (map["variavel"] is Map) {
      variavel = Map<String, Variavel>();
      for (var item in map["variavel"].entries) {
        variavel[item.key] = Variavel.fromMap(item.value);
      }
    }
    if (map["pedese"] is Map) {
      pedese = Map<String, Pedese>();
      for (var item in map["pedese"].entries) {
        pedese[item.key] = Pedese.fromMap(item.value);
      }
    }
    // _updateAll();
    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // _updateAll();
    if (ativo != null) data['ativo'] = this.ativo;
    if (this.professor != null) {
      data['professor'] = this.professor.toMap();
    }
    if (this.turma != null) {
      data['turma'] = this.turma.toMap();
    }
    if (this.avaliacao != null) {
      data['avaliacao'] = this.avaliacao.toMap();
    }
    if (this.questao != null) {
      data['questao'] = this.questao.toMap();
    }
    if (this.aluno != null) {
      data['aluno'] = this.aluno.toMap();
    }
    if (modificado != null) data['modificado'] = this.modificado;
    if (inicio != null) data['inicio'] = this.inicio;
    if (iniciou != null) data['iniciou'] = this.iniciou;
    if (enviou != null) data['enviou'] = this.enviou;
    if (fim != null) data['fim'] = this.fim;
    if (tentativa != null) data['tentativa'] = this.tentativa;
    if (tentou != null) data['tentou'] = this.tentou;
    if (tempo != null) data['tempo'] = this.tempo;
    if (erroRelativo != null) data['erroRelativo'] = this.erroRelativo;
    if (avaliacaoNota != null) data['avaliacaoNota'] = this.avaliacaoNota;
    if (questaoNota != null) data['questaoNota'] = this.questaoNota;
    if (aberta != null) data['aberta'] = aberta;

    if (this.situacao != null) {
      data['situacao'] = this.situacao.toMap();
    }

    if (simulacao != null) data['simulacao'] = this.simulacao;

    if (variavel != null && variavel is Map) {
      data["variavel"] = Map<String, dynamic>();
      for (var item in variavel.entries) {
        data["variavel"][item.key] = item.value.toMap();
      }
    }
    if (pedese != null && pedese is Map) {
      data["pedese"] = Map<String, dynamic>();
      for (var item in pedese.entries) {
        data["pedese"][item.key] = item.value.toMap();
      }
    }
    return data;
  }

  bool get isAberta {
    if (this.aberta && this.fim.isBefore(DateTime.now())) {
      this.aberta = false;
      print('==> Tarefa ${this.id}. aberta=${this.aberta} pois fim < now');
    }
    if (this.aberta &&
        this.iniciou != null &&
        this.responderAte != null &&
        this.responderAte.isBefore(DateTime.now())) {
      this.aberta = false;
      print('==> Tarefa ${this.id} Fechada pois responderAte < now');
    }
    if (this.aberta && this.tentou != null && this.tentou >= this.tentativa) {
      this.aberta = false;
      print('==> Tarefa ${this.id} Fechada pois tentou < tentativa');
    }
    return this.aberta;
  }

  DateTime get responderAte {
    if (this.iniciou != null) {
      return this.iniciou.add(Duration(hours: this.tempo));
    } else {
      return null;
    }
  }

  dynamic get tempoPResponder {
    responderAte;
    if (this.iniciou == null) {
      // return Duration(hours: this.tempo);
      return null;
    } else {
      if (this.responderAte != null && this.fim.isBefore(this.responderAte)) {
        return this.fim.difference(DateTime.now());
      }
      if (this.responderAte != null) {
        return this.responderAte.difference(DateTime.now());
      }
    }
  }

  void updateAll() {
    responderAte;
    tempoPResponder;
    isAberta;
  }
}

class Variavel {
  String nome;
  int ordem;
  String tipo;
  String valor;

  Variavel({
    this.nome,
    this.ordem,
    this.tipo,
    this.valor,
  });

  Variavel.fromMap(Map<dynamic, dynamic> map) {
    if (map.containsKey('ordem')) ordem = map['ordem'];
    if (map.containsKey('nome')) nome = map['nome'];
    if (map.containsKey('tipo')) tipo = map['tipo'];
    if (map.containsKey('valor')) valor = map['valor'];
  }

  Map<dynamic, dynamic> toMap() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    if (ordem != null) data['ordem'] = this.ordem;
    if (nome != null) data['nome'] = this.nome;
    if (tipo != null) data['tipo'] = this.tipo;
    if (valor != null) data['valor'] = this.valor;
    return data;
  }
}

class Pedese {
  String nome;
  int ordem;
  String tipo;
  String gabarito;
  String resposta;
  int nota;
  String gabaritoUploadID;
  String respostaUploadID;
  String respostaPath;

  Pedese({
    this.nome,
    this.ordem,
    this.tipo,
    this.gabarito,
    this.resposta,
    this.nota,
    this.gabaritoUploadID,
    this.respostaPath,
    this.respostaUploadID,
  });

  Pedese.fromMap(Map<dynamic, dynamic> map) {
    if (map.containsKey('nome')) nome = map['nome'];
    if (map.containsKey('ordem')) ordem = map['ordem'];
    if (map.containsKey('tipo')) tipo = map['tipo'];
    if (map.containsKey('gabarito')) gabarito = map['gabarito'];
    if (map.containsKey('resposta')) resposta = map['resposta'];
    if (map.containsKey('nota')) nota = map['nota'];
    if (map.containsKey('gabaritoUploadID'))
      gabaritoUploadID = map['gabaritoUploadID'];
    if (map.containsKey('respostaPath')) respostaPath = map['respostaPath'];
    if (map.containsKey('respostaUploadID'))
      respostaUploadID = map['respostaUploadID'];
  }

  Map<dynamic, dynamic> toMap() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    if (nome != null) data['nome'] = this.nome;
    if (ordem != null) data['ordem'] = this.ordem;
    if (tipo != null) data['tipo'] = this.tipo;
    if (gabarito != null) data['gabarito'] = this.gabarito;
    if (resposta != null) data['resposta'] = this.resposta;
    data['nota'] = this.nota ?? Bootstrap.instance.fieldValue.delete();
    if (gabaritoUploadID != null)
      data['gabaritoUploadID'] = this.gabaritoUploadID;
    if (respostaPath != null) data['respostaPath'] = this.respostaPath;
    if (respostaUploadID != null)
      data['respostaUploadID'] = this.respostaUploadID;
    return data;
  }
}
