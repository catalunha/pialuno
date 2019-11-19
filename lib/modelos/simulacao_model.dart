import 'package:pialuno/bootstrap.dart';
import 'package:pialuno/modelos/base_model.dart';
import 'package:pialuno/modelos/problema_model.dart';
import 'package:pialuno/modelos/usuario_model.dart';

class SimulacaoModel extends FirestoreModel {
  static final String collection = "Simulacao";
  bool ativo;
  dynamic modificado;
  int numero;
  UsuarioFk professor;
  ProblemaFk problema;
  bool algoritmoDoAdmin;
  bool algoritmoDoProfessor;
  int ordem;

  String nome;
  String descricao;
  String url;
  Map<String, Variavel> variavel = Map<String, Variavel>();
  Map<String, Gabarito> gabarito = Map<String, Gabarito>();

  SimulacaoModel({
    String id,
    this.ativo,
    this.modificado,
    this.numero,
    this.professor,
    this.problema,
    this.algoritmoDoAdmin,
    this.algoritmoDoProfessor,
    this.nome,
    this.ordem,
    this.descricao,
    this.url,
    this.variavel,
    this.gabarito,
  }) : super(id);

  @override
  SimulacaoModel fromMap(Map<String, dynamic> map) {
    if (map.containsKey('ativo')) ativo = map['ativo'];
    if (map.containsKey('numero')) numero = map['numero'];
    professor = map.containsKey('professor') && map['professor'] != null
        ? UsuarioFk.fromMap(map['professor'])
        : null;
    problema = map.containsKey('problema') && map['problema'] != null
        ? ProblemaFk.fromMap(map['problema'])
        : null;

    modificado = map.containsKey('modificado') && map['modificado'] != null
        ? DateTime.fromMillisecondsSinceEpoch(
            map['modificado'].millisecondsSinceEpoch)
        : null;

    if (map.containsKey('algoritmoDoAdmin'))
      algoritmoDoAdmin = map['algoritmoDoAdmin'];
    if (map.containsKey('algoritmoDoProfessor'))
      algoritmoDoProfessor = map['algoritmoDoProfessor'];
    if (map.containsKey('ordemAdicionada')) ordem = map['ordemAdicionada'];
    if (map.containsKey('nome')) nome = map['nome'];
    if (map.containsKey('descricao')) descricao = map['descricao'];
    if (map.containsKey('url')) url = map['url'];

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
    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // _updateAll();
    if (ativo != null) data['ativo'] = this.ativo;
    if (numero != null) data['numero'] = this.numero;
    if (this.professor != null) {
      data['professor'] = this.professor.toMap();
    }
    if (this.problema != null) {
      data['problema'] = this.problema.toMap();
    }

    if (modificado != null) data['modificado'] = this.modificado;
    if (algoritmoDoAdmin != null)
      data['algoritmoDoAdmin'] = this.algoritmoDoAdmin;
    if (algoritmoDoProfessor != null)
      data['algoritmoDoProfessor'] = this.algoritmoDoProfessor;
    if (ordem != null) data['ordemAdicionada'] = this.ordem;
    if (nome != null) data['nome'] = this.nome;
    if (descricao != null) data['descricao'] = this.descricao;
    if (url != null) data['url'] = this.url;

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

class Gabarito {
  String nome;
  int ordem;
  String tipo;
  String valor;
  String resposta;
  int nota;
  String respostaUploadID;
  String respostaPath;

  Gabarito({
    this.nome,
    this.ordem,
    this.tipo,
    this.valor,
    this.resposta,
    this.nota,
    this.respostaPath,
    this.respostaUploadID,
  });

  Gabarito.fromMap(Map<dynamic, dynamic> map) {
    if (map.containsKey('nome')) nome = map['nome'];
    if (map.containsKey('ordem')) ordem = map['ordem'];
    if (map.containsKey('tipo')) tipo = map['tipo'];
    if (map.containsKey('valor')) valor = map['valor'];
    if (map.containsKey('resposta')) resposta = map['resposta'];
    if (map.containsKey('nota')) nota = map['nota'];
    if (map.containsKey('respostaPath')) respostaPath = map['respostaPath'];
    if (map.containsKey('respostaUploadID'))
      respostaUploadID = map['respostaUploadID'];
  }

  Map<dynamic, dynamic> toMap() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    if (nome != null) data['nome'] = this.nome;
    if (ordem != null) data['ordem'] = this.ordem;
    if (tipo != null) data['tipo'] = this.tipo;
    if (valor != null) data['valor'] = this.valor;
    data['resposta'] = this.resposta;
    // data['nota'] = this.nota ?? Bootstrap.instance.fieldValue.delete();
    data['nota'] = this.nota;
    data['respostaPath'] = this.respostaPath;
    data['respostaUploadID'] = this.respostaUploadID;
    return data;
  }
}

class SimulacaoFk {
  String id;
  String nome;

  SimulacaoFk({this.id, this.nome});

  SimulacaoFk.fromMap(Map<dynamic, dynamic> map) {
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
