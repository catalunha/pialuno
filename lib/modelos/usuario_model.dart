import 'package:pialuno/modelos/base_model.dart';
import 'package:pialuno/modelos/upload_model.dart';

class UsuarioModel extends FirestoreModel {
  static final String collection = "Usuario";
  bool professor;
  bool ativo;
  String celular;
  String cracha;
  String email;
  UploadFk foto;
  String matricula;
  String nome;
  List<dynamic> rota;
  int turmaNumeroAdicionado;
  int pastaNumeroAdicionado;
  int problemaNumeroAdicionado;
  // String tokenFCM;
  List<dynamic> turma;

  UsuarioModel({
    String id,
    this.nome,
    this.cracha,
    this.matricula,
    this.celular,
    this.email,
    // this.tokenFCM,
    this.ativo,
    this.professor,
    this.foto,
    this.turmaNumeroAdicionado,
    this.pastaNumeroAdicionado,
    this.problemaNumeroAdicionado,
    this.rota,
    this.turma
  }) : super(id);

  @override
  UsuarioModel fromMap(Map<String, dynamic> map) {
    // for (var item in map.entries) {
    //   print('${item.key} = ${item.value}');
    // }
    if (map.containsKey('nome')) nome = map['nome'];
    if (map.containsKey('cracha')) cracha = map['cracha'];
    if (map.containsKey('matricula')) matricula = map['matricula'];
    if (map.containsKey('celular')) celular = map['celular'];
    // if (map.containsKey('tokenFCM')) tokenFCM = map['tokenFCM'];
    if (map.containsKey('email')) email = map['email'];
    if (map.containsKey('ativo')) ativo = map['ativo'];
    if (map.containsKey('professor')) professor = map['professor'];
    if (map.containsKey('pastaNumeroAdicionado')) pastaNumeroAdicionado = map['pastaNumeroAdicionado'];
    if (map.containsKey('problemaNumeroAdicionado')) problemaNumeroAdicionado = map['problemaNumeroAdicionado'];
    if (map.containsKey('turmaNumeroAdicionado')) turmaNumeroAdicionado = map['turmaNumeroAdicionado'];
    if (map.containsKey('foto')) {
      foto = map['foto'] != null ? new UploadFk.fromMap(map['foto']) : null;
    }

    if (map.containsKey('rota')) rota = map['rota'];
        if (map.containsKey('turma')) turma = map['turma'];

    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (nome != null) data['nome'] = this.nome;
    if (cracha != null) data['cracha'] = this.cracha;
    if (matricula != null) data['matricula'] = this.matricula;
    if (celular != null) data['celular'] = this.celular;
    // if (tokenFCM != null) data['tokenFCM'] = this.tokenFCM;
    if (email != null) data['email'] = this.email;
    if (ativo != null) data['ativo'] = this.ativo;
    if (professor != null) data['professor'] = this.professor;
    if (pastaNumeroAdicionado != null) data['pastaNumeroAdicionado'] = this.pastaNumeroAdicionado;
    if (problemaNumeroAdicionado != null) data['problemaNumeroAdicionado'] = this.problemaNumeroAdicionado;
    if (turmaNumeroAdicionado != null) data['turmaNumeroAdicionado'] = this.turmaNumeroAdicionado;
    if (this.foto != null) {
      data['foto'] = this.foto.toMap();
    }
        if (turma != null) data['turma'] = this.turma;


    if (rota != null) data['rota'] = this.rota;

    return data;
  }
}


class UsuarioFk {
  String id;
  String nome;
  String foto;

  UsuarioFk({this.id, this.nome,this.foto});

  UsuarioFk.fromMap(Map<dynamic, dynamic> map) {
    if (map.containsKey('id')) id = map['id'];
    if (map.containsKey('nome')) nome = map['nome'];
    if (map.containsKey('foto')) foto = map['foto'];
  }

  Map<dynamic, dynamic> toMap() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    if (id != null) data['id'] = this.id;
    if (nome != null) data['nome'] = this.nome;
    if (foto != null) data['foto'] = this.foto;
    return data;
  }
}