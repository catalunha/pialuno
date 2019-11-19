import 'package:pialuno/modelos/base_model.dart';
import 'package:pialuno/modelos/usuario_model.dart';

class TurmaModel extends FirestoreModel {
  static final String collection = "Turma";
  bool ativo;
  dynamic numero;
  String instituicao;
  String componente;
  String nome;
  String descricao;
  String programa;
  UsuarioFk professor;
  dynamic questaoNumeroAdicionado;
  dynamic questaoNumeroExcluido;

  TurmaModel({
    String id,
    this.ativo,
    this.numero,
    this.instituicao,
    this.componente,
    this.nome,
    this.descricao,
    this.programa,
    this.professor,
    this.questaoNumeroAdicionado,
    this.questaoNumeroExcluido,
  }) : super(id);

  @override
  TurmaModel fromMap(Map<String, dynamic> map) {
    if (map.containsKey('ativo')) ativo = map['ativo'];
    if (map.containsKey('numero')) numero = map['numero'];
    if (map.containsKey('instituicao')) instituicao = map['instituicao'];
    if (map.containsKey('componente')) componente = map['componente'];
    if (map.containsKey('nome')) nome = map['nome'];
    if (map.containsKey('descricao')) descricao = map['descricao'];
    if (map.containsKey('programa')) programa = map['programa'];
    professor = map.containsKey('professor') && map['professor'] != null
        ? UsuarioFk.fromMap(map['professor'])
        : null;
    if (map.containsKey('questaoNumeroAdicionado'))
      questaoNumeroAdicionado = map['questaoNumeroAdicionado'];
    if (map.containsKey('questaoNumeroExcluido'))
      questaoNumeroExcluido = map['questaoNumeroExcluido'];
    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // _updateAll();
    if (ativo != null) data['ativo'] = this.ativo;
    if (numero != null) data['numero'] = this.numero;
    if (instituicao != null) data['instituicao'] = this.instituicao;
    if (componente != null) data['componente'] = this.componente;
    if (nome != null) data['nome'] = this.nome;
    if (descricao != null) data['descricao'] = this.descricao;
    if (programa != null) data['programa'] = this.programa;
    if (this.professor != null) {
      data['professor'] = this.professor.toMap();
    }
    if (questaoNumeroAdicionado != null)
      data['questaoNumeroAdicionado'] = this.questaoNumeroAdicionado;
    if (questaoNumeroExcluido != null)
      data['questaoNumeroExcluido'] = this.questaoNumeroExcluido;
    return data;
  }
}

class TurmaFk {
  String id;
  String nome;

  TurmaFk({this.id, this.nome});

  TurmaFk.fromMap(Map<dynamic, dynamic> map) {
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
