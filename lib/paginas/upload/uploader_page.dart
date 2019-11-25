import 'package:pialuno/auth_bloc.dart';
import 'package:pialuno/componentes/default_scaffold.dart';
import 'package:pialuno/paginas/upload/uploader_bloc.dart';
import 'package:universal_io/io.dart' as io;
import 'package:flutter/material.dart';

import '../../bootstrap.dart';

class UploaderPage extends StatefulWidget {
  final AuthBloc authBloc;

  UploaderPage(this.authBloc);

  _UploaderPageState createState() => _UploaderPageState(this.authBloc);
}

class _UploaderPageState extends State<UploaderPage> {
  final UploaderBloc bloc;

  _UploaderPageState(AuthBloc authBloc)
      : bloc = UploaderBloc(Bootstrap.instance.firestore, authBloc);

  @override
  void initState() {
    super.initState();
    bloc.eventSink(UpdateUsuarioIDEvent());
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
        title: Text("Uploads pendentes"),
        body: Container(
          child: _uploadBody(),
        ));
  }

  _uploadBody() {
    return StreamBuilder<UploaderBlocState>(
        stream: bloc.stateStream,
        builder: (BuildContext context, AsyncSnapshot<UploaderBlocState> snapshot) {
          if (snapshot.hasError)
            return Center(
              child: Text("Erro. Informe ao administrador do aplicativo"),
            );
  
          if (!snapshot.hasData) {
            return Center(
              child: Text("Nenhum upload pendente."),
            );
          }
  
          // +++ Com lista de uploading
          var lista = snapshot.data?.uploadingList;
          if (lista == null) {
            return Text("Nenhum upload pendente.");
          } else {
            return ListView(
              children: lista
                  .map((uploading) => _listUpload(context, uploading))
                  .toList(),
            );
          }
          // --- Com lista de uploading
        });
  }

  Widget _listUpload(BuildContext context, Uploading uploading) {
    String dispositivo;
    if (!io.File(uploading.upload.path).existsSync()) {
      dispositivo = 'ESTE ARQUIVO ESTA EM OUTRO DISPOSITIVO.';
    }

    return Row(
      children: <Widget>[
        Expanded(
          child: ListTile(
            title:
                Text('Menu: ${uploading.upload.updateCollection.collection}'),
            subtitle: dispositivo != null
                ? Text(dispositivo +
                    '\nuploadID:${uploading.upload.id}\n${uploading.upload.updateCollection.collection}ID:${uploading.upload.updateCollection.document}')
                : Text(
                    '${uploading.upload.path}\nuploadID:${uploading.upload.id}\n${uploading.upload.updateCollection.collection}ID:${uploading.upload.updateCollection.document}'),
            trailing: dispositivo != null
                ? Icon(Icons.cloud_off)
                : IconButton(
                  tooltip: 'Enviar arquivo deste dispositivo para núvem',
                    icon: uploading.uploading
                        ? Icon(Icons.cloud_upload)
                        : Icon(Icons.send),
                    onPressed: () {
                      bloc.eventSink(StartUploadEvent(uploading.id));
                    },
                  ),
          ),
        ),
        dispositivo != null
            ? Container()
            : uploading.uploading
                ? CircularProgressIndicator()
                : IconButton(
                    icon: Icon(Icons.cloud_queue),
                    onPressed: () {},
                  ),
      ],
    );
  }
}
