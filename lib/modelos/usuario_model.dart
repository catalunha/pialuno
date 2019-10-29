import 'package:pialuno/modelos/base_model.dart';
import 'package:pialuno/modelos/upload_model.dart';

class UsuarioModel extends FirestoreModel {
  static final String collection = "Usuario";
  bool ativo;
  String nome;
  String cracha;
  String matricula;
  String celular;
  String email;
  String tokenFCM;
  UploadID foto;
  List<dynamic> rota;

  UsuarioModel({
    String id,
    this.nome,
    this.cracha,
    this.matricula,
    this.celular,
    this.email,
    this.tokenFCM,
    this.ativo,
    this.foto,
    this.rota,
  }) : super(id);

  @override
  UsuarioModel fromMap(Map<String, dynamic> map) {
    if (map.containsKey('nome')) nome = map['nome'];
    if (map.containsKey('cracha')) cracha = map['cracha'];
    if (map.containsKey('matricula')) matricula = map['matricula'];
    if (map.containsKey('celular')) celular = map['celular'];
    if (map.containsKey('tokenFCM')) tokenFCM = map['tokenFCM'];
    if (map.containsKey('email')) email = map['email'];
    if (map.containsKey('ativo')) ativo = map['ativo'];
    if (map.containsKey('foto')) {
      foto = map['foto'] != null ? new UploadID.fromMap(map['foto']) : null;
    }

    if (map.containsKey('rota')) rota = map['rota'];
    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (nome != null) data['nome'] = this.nome;
    if (cracha != null) data['cracha'] = this.cracha;
    if (matricula != null) data['matricula'] = this.matricula;
    if (celular != null) data['celular'] = this.celular;
    if (tokenFCM != null) data['tokenFCM'] = this.tokenFCM;
    if (email != null) data['email'] = this.email;
    if (ativo != null) data['ativo'] = this.ativo;
    if (this.foto != null) {
      data['foto'] = this.foto.toMap();
    }

    if (rota != null) data['rota'] = this.rota;

    return data;
  }
}
