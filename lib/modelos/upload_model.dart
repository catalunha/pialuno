import 'package:pialuno/bootstrap.dart';
import 'package:pialuno/modelos/base_model.dart';

class UploadModel extends FirestoreModel {
  static final String collection = "Upload";
  String usuario;
  String nome;
  String path;
  bool upload;
  String storagePath;
  String contentType;
  String url;
  String hash;
  UpdateCollection updateCollection;

  UploadModel(
      {String id,
      this.usuario,
      this.nome,
      this.path,
      this.upload,
      this.storagePath,
      this.contentType,
      this.url,
      this.hash,
      this.updateCollection})
      : super(id);

  @override
  UploadModel fromMap(Map<String, dynamic> map) {
    if (map.containsKey('usuario')) usuario = map['usuario'];
    if (map.containsKey('nome')) nome = map['nome'];
    if (map.containsKey('path')) path = map['path'];
    if (map.containsKey('upload')) upload = map['upload'];
    if (map.containsKey('storagePath')) storagePath = map['storagePath'];
    if (map.containsKey('contentType')) contentType = map['contentType'];
    if (map.containsKey('url')) url = map['url'];
    if (map.containsKey('hash')) hash = map['hash'];
    if (map.containsKey('updateCollection')) {
      updateCollection = map['updateCollection'] != null
          ? new UpdateCollection.fromMap(map['updateCollection'])
          : null;
    }
    return this;
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (usuario != null) data['usuario'] = this.usuario;
    if (nome != null) data['nome'] = this.nome;
    if (path != null) data['path'] = this.path;
    if (upload != null) data['upload'] = this.upload;
    if (storagePath != null) data['storagePath'] = this.storagePath;
    if (contentType != null) data['contentType'] = this.contentType;
    if (url != null) data['url'] = this.url;
    if (hash != null) data['hash'] = this.hash;
    if (this.updateCollection != null) {
      data['updateCollection'] = this.updateCollection.toMap();
    }
    return data;
  }
}

class UploadFk {
  String uploadID;
  String url;
  // String path;

  UploadFk({
    this.uploadID,
    this.url,
    // this.path,
  });

  UploadFk.fromMap(Map<dynamic, dynamic> map) {
    if (map.containsKey('uploadID')) uploadID = map['uploadID'];
    if (map.containsKey('url')) url = map['url'];
    // if (map.containsKey('path')) path = map['path'];
  }

  Map<dynamic, dynamic> toMap() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    if (uploadID != null) data['uploadID'] = this.uploadID;
    data['url'] = this.url ?? Bootstrap.instance.fieldValue.delete();
    // data['url'] = this.url;
    return data;
  }
}

class UpdateCollection {
  String collection;
  String document;
  String field;
  String description;

  UpdateCollection(
      {this.collection, this.document, this.field, this.description});

  UpdateCollection.fromMap(Map<dynamic, dynamic> map) {
    if (map.containsKey('collection')) collection = map['collection'];
    if (map.containsKey('document')) document = map['document'];
    if (map.containsKey('field')) field = map['field'];
    if (map.containsKey('description')) description = map['description'];
  }

  Map<dynamic, dynamic> toMap() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    if (collection != null) data['collection'] = this.collection;
    if (document != null) data['document'] = this.document;
    if (field != null) data['field'] = this.field;
    if (description != null) data['description'] = this.description;
    return data;
  }
}
