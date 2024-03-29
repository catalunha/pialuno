import 'package:pialuno/modelos/avaliacao_model.dart';
import 'package:pialuno/modelos/base_model.dart';
import 'package:pialuno/modelos/questao_model.dart';
import 'package:pialuno/modelos/problema_model.dart';
import 'package:pialuno/modelos/simulacao_model.dart';
import 'package:pialuno/modelos/turma_model.dart';
import 'package:pialuno/modelos/usuario_model.dart';

class TarefaModel extends FirestoreModel {
  static final String collection = "Tarefa";
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
  int erroRelativo;
  String avaliacaoNota;
  String questaoNota;
  bool aberta;
  ProblemaFk problema;
  SimulacaoFk simulacao;
  Map<String, Variavel> variavel;
  Map<String, Gabarito> gabarito;

  // dynamic responderAte;
  // dynamic _tempoPResponder;

  TarefaModel({
    String id,
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
    this.problema,
    this.simulacao,
    this.variavel,
    this.gabarito,
  }) : super(id);

  @override
  TarefaModel fromMap(Map<String, dynamic> map) {
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
    problema = map.containsKey('problema') && map['problema'] != null
        ? ProblemaFk.fromMap(map['problema'])
        : null;
  simulacao = map.containsKey('simulacao') && map['simulacao'] != null
        ? SimulacaoFk.fromMap(map['simulacao'])
        : null;

    if (map["variavel"] is Map) {
      variavel = Map<String, Variavel>();
      for (var item in map["variavel"].entries) {
        variavel[item.key] = Variavel.fromMap(item.value);
      }
    }
    if (map["gabarito"] is Map) {
      gabarito = Map<String, Gabarito>();
      for (var item in map["gabarito"].entries) {
        gabarito[item.key] = Gabarito.fromMap(item.value);
      }
    }
    // _updateAll();
    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // _updateAll();
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

    if (this.problema != null) {
      data['problema'] = this.problema.toMap();
    }

  if (this.simulacao != null) {
      data['simulacao'] = this.simulacao.toMap();
    }
    if (variavel != null && variavel is Map) {
      data["variavel"] = Map<String, dynamic>();
      for (var item in variavel.entries) {
        data["variavel"][item.key] = item.value.toMap();
      }
    }
    if (gabarito != null && gabarito is Map) {
      data["gabarito"] = Map<String, dynamic>();
      for (var item in gabarito.entries) {
        data["gabarito"][item.key] = item.value.toMap();
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

// class Variavel {
//   String nome;
//   int ordem;
//   String tipo;
//   String valor;

//   Variavel({
//     this.nome,
//     this.ordem,
//     this.tipo,
//     this.valor,
//   });

//   Variavel.fromMap(Map<dynamic, dynamic> map) {
//     if (map.containsKey('ordem')) ordem = map['ordem'];
//     if (map.containsKey('nome')) nome = map['nome'];
//     if (map.containsKey('tipo')) tipo = map['tipo'];
//     if (map.containsKey('valor')) valor = map['valor'];
//   }

//   Map<dynamic, dynamic> toMap() {
//     final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
//     if (ordem != null) data['ordem'] = this.ordem;
//     if (nome != null) data['nome'] = this.nome;
//     if (tipo != null) data['tipo'] = this.tipo;
//     if (valor != null) data['valor'] = this.valor;
//     return data;
//   }
// }

// class Gabarito {
//   String nome;
//   int ordem;
//   String tipo;
//   String valor;
//   String resposta;
//   int nota;
//   String respostaUploadID;
//   String respostaPath;

//   Gabarito({
//     this.nome,
//     this.ordem,
//     this.tipo,
//     this.valor,
//     this.resposta,
//     this.nota,
//     this.respostaPath,
//     this.respostaUploadID,
//   });

//   Gabarito.fromMap(Map<dynamic, dynamic> map) {
//     if (map.containsKey('nome')) nome = map['nome'];
//     if (map.containsKey('ordem')) ordem = map['ordem'];
//     if (map.containsKey('tipo')) tipo = map['tipo'];
//     if (map.containsKey('valor')) valor = map['valor'];
//     if (map.containsKey('resposta')) resposta = map['resposta'];
//     if (map.containsKey('nota')) nota = map['nota'];
//     if (map.containsKey('respostaPath')) respostaPath = map['respostaPath'];
//     if (map.containsKey('respostaUploadID'))
//       respostaUploadID = map['respostaUploadID'];
//   }

//   Map<dynamic, dynamic> toMap() {
//     final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
//     if (nome != null) data['nome'] = this.nome;
//     if (ordem != null) data['ordem'] = this.ordem;
//     if (tipo != null) data['tipo'] = this.tipo;
//     if (valor != null) data['valor'] = this.valor;
//     if (resposta != null) data['resposta'] = this.resposta;
//     data['nota'] = this.nota ?? Bootstrap.instance.fieldValue.delete();
//     if (respostaPath != null) data['respostaPath'] = this.respostaPath;
//     if (respostaUploadID != null)
//       data['respostaUploadID'] = this.respostaUploadID;
//     return data;
//   }
// }
