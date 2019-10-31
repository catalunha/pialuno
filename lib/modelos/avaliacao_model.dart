import 'package:pialuno/modelos/base_model.dart';
import 'package:pialuno/modelos/turma_model.dart';
import 'package:pialuno/modelos/usuario_model.dart';

class AvaliacaoModel extends FirestoreModel {
  static final String collection = "Avaliacao";
  bool ativo;
  UsuarioFk professor;
  TurmaFk turma;
  String nome;
  String descricao;
  dynamic inicio;
  dynamic fim;
  String nota;
  bool aplicada;
  List<dynamic> aplicadaPAluno;

  AvaliacaoModel({
    String id,
    this.ativo,
    this.professor,
    this.turma,
    this.nome,
    this.descricao,
    this.inicio,
    this.fim,
    this.nota,
    this.aplicada,
    this.aplicadaPAluno,
  }) : super(id);

  @override
  AvaliacaoModel fromMap(Map<String, dynamic> map) {
    if (map.containsKey('ativo')) ativo = map['ativo'];
    professor = map.containsKey('professor') && map['professor'] != null
        ? UsuarioFk.fromMap(map['professor'])
        : null;
    turma = map.containsKey('turma') && map['turma'] != null
        ? TurmaFk.fromMap(map['turma'])
        : null;
    if (map.containsKey('nome')) nome = map['nome'];
    if (map.containsKey('descricao')) descricao = map['descricao'];
    inicio = map.containsKey('inicio') && map['inicio'] != null
        ? DateTime.fromMillisecondsSinceEpoch(
            map['inicio'].millisecondsSinceEpoch)
        : null;
    fim = map.containsKey('fim') && map['fim'] != null
        ? DateTime.fromMillisecondsSinceEpoch(map['fim'].millisecondsSinceEpoch)
        : null;
    if (map.containsKey('nota')) nota = map['nota'];
    if (map.containsKey('aplicada')) aplicada = map['aplicada'];
    if (map.containsKey('aplicadaPAluno'))
      aplicadaPAluno = map['aplicadaPAluno'];
    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (ativo != null) data['ativo'] = this.ativo;
    if (this.professor != null) {
      data['professor'] = this.professor.toMap();
    }
    if (this.turma != null) {
      data['turma'] = this.turma.toMap();
    }
    if (nome != null) data['nome'] = this.nome;
    if (descricao != null) data['descricao'] = this.descricao;
    if (inicio != null) data['inicio'] = this.inicio;
    if (fim != null) data['fim'] = this.fim;
    if (nota != null) data['nota'] = this.nota;
    if (aplicada != null) data['aplicada'] = this.aplicada;
    if (aplicadaPAluno != null) data['aplicadaPAluno'] = this.aplicadaPAluno;
    return data;
  }
}

class AvaliacaoFk {
  String id;
  String nome;

  AvaliacaoFk({this.id, this.nome});

  AvaliacaoFk.fromMap(Map<dynamic, dynamic> map) {
    if (map.containsKey('id')) id = map['id'];
    if (map.containsKey('nome')) nome = map['nome'];
  }

  Map<dynamic, dynamic> toMap() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    if (id != null) data['id'] = this.id;
    if (nome != null) data['nome'] = this.nome;
    return data;
  }
}
