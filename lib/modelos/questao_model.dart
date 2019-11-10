import 'package:pialuno/modelos/avaliacao_model.dart';
import 'package:pialuno/modelos/base_model.dart';
import 'package:pialuno/modelos/situacao_model.dart';
import 'package:pialuno/modelos/turma_model.dart';
import 'package:pialuno/modelos/usuario_model.dart';

class QuestaoModel extends FirestoreModel {
  static final String collection = "Questao";
  bool ativo;
  int numero;
  UsuarioFk professor;
  TurmaFk turma;
  AvaliacaoFk avaliacao;
  SituacaoFk situacao;
  dynamic inicio;
  dynamic fim;
  dynamic modificado;
  int tentativa;
  int tempo;
  int erroRelativo;
  String nota;

  QuestaoModel({
    String id,
    this.ativo,
    this.numero,
    this.professor,
    this.turma,
    this.avaliacao,
    this.situacao,
    this.inicio,
    this.fim,
    this.modificado,
    this.tentativa,
    this.tempo,
    this.erroRelativo,
    this.nota,
  }) : super(id);

  @override
  QuestaoModel fromMap(Map<String, dynamic> map) {
    if (map.containsKey('ativo')) ativo = map['ativo'];
    if (map.containsKey('numero')) numero = map['numero'];
    professor = map.containsKey('professor') && map['professor'] != null
        ? UsuarioFk.fromMap(map['professor'])
        : null;
    turma = map.containsKey('turma') && map['turma'] != null
        ? TurmaFk.fromMap(map['turma'])
        : null;
    avaliacao = map.containsKey('avaliacao') && map['avaliacao'] != null
        ? AvaliacaoFk.fromMap(map['avaliacao'])
        : null;
    situacao = map.containsKey('situacao') && map['situacao'] != null
        ? SituacaoFk.fromMap(map['situacao'])
        : null;
    inicio = map.containsKey('inicio') && map['inicio'] != null
        ? DateTime.fromMillisecondsSinceEpoch(
            map['inicio'].millisecondsSinceEpoch)
        : null;
    fim = map.containsKey('fim') && map['fim'] != null
        ? DateTime.fromMillisecondsSinceEpoch(map['fim'].millisecondsSinceEpoch)
        : null;
    modificado = map.containsKey('modificado') && map['modificado'] != null
        ? DateTime.fromMillisecondsSinceEpoch(
            map['modificado'].millisecondsSinceEpoch)
        : null;
    if (map.containsKey('tentativa')) tentativa = map['tentativa'];
    if (map.containsKey('tempo')) tempo = map['tempo'];
    if (map.containsKey('erroRelativo')) erroRelativo = map['erroRelativo'];
    if (map.containsKey('nota')) nota = map['nota'];
    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (ativo != null) data['ativo'] = this.ativo;
    if (numero != null) data['numero'] = this.numero;
    if (this.professor != null) {
      data['professor'] = this.professor.toMap();
    }
    if (this.turma != null) {
      data['turma'] = this.turma.toMap();
    }
    if (this.avaliacao != null) {
      data['avaliacao'] = this.avaliacao.toMap();
    }
    if (this.situacao != null) {
      data['situacao'] = this.situacao.toMap();
    }
    if (inicio != null) data['inicio'] = this.inicio;
    if (fim != null) data['fim'] = this.fim;
    if (modificado != null) data['modificado'] = this.modificado;
    if (tentativa != null) data['tentativa'] = this.tentativa;
    if (tempo != null) data['tempo'] = this.tempo;
    if (erroRelativo != null) data['erroRelativo'] = this.erroRelativo;
    if (nota != null) data['nota'] = this.nota;
    return data;
  }
}

class QuestaoFk {
  String id;
  int numero;

  QuestaoFk({this.id, this.numero});

  QuestaoFk.fromMap(Map<dynamic, dynamic> map) {
    if (map.containsKey('id')) id = map['id'];
    if (map.containsKey('numero')) numero = map['numero'];
  }

  Map<dynamic, dynamic> toMap() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    if (id != null) data['id'] = this.id;
    if (numero != null) data['numero'] = this.numero;
    return data;
  }
}
