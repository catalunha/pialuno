class ProblemaFk {
  String id;
  String nome;
  String url;

  ProblemaFk({this.id, this.nome, this.url});

  ProblemaFk.fromMap(Map<dynamic, dynamic> map) {
    if (map.containsKey('id')) id = map['id'];
    if (map.containsKey('nome')) nome = map['nome'];
    if (map.containsKey('url')) url = map['url'];
  }

  Map<dynamic, dynamic> toMap() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    if (id != null) data['id'] = this.id;
    if (nome != null) data['nome'] = this.nome;
    if (url != null) data['url'] = this.url;
    return data;
  }
}
