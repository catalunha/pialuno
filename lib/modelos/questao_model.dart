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