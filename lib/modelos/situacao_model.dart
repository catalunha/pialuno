class SituacaoFk {
  String id;
  String nome;
  String erroRelativo;
  String url;

  SituacaoFk({this.id, this.nome, this.erroRelativo,this.url});

  SituacaoFk.fromMap(Map<dynamic, dynamic> map) {
    if (map.containsKey('id')) id = map['id'];
    if (map.containsKey('nome')) nome = map['nome'];
    if (map.containsKey('erroRelativo')) erroRelativo = map['erroRelativo'];
    if (map.containsKey('url')) url = map['url'];
  }

  Map<dynamic, dynamic> toMap() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    if (id != null) data['id'] = this.id;
    if (nome != null) data['nome'] = this.nome;
    if (erroRelativo != null) data['erroRelativo'] = this.erroRelativo;
    if (url != null) data['url'] = this.url;
    return data;
  }
}
