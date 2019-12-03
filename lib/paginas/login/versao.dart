import 'package:flutter/material.dart';
import 'package:pialuno/plataforma/recursos.dart';
import 'package:pialuno/naosuportato/url_launcher.dart' if (dart.library.io) 'package:url_launcher/url_launcher.dart';

class Versao extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Versão & Suporte'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Recursos.instance.plataforma == 'android' ? Text("Versão Android: 1.0.6 (6)") : Text("Versão Chrome: 1.0.6 (6) Build 201912032021"),
          ),
          ListTile(
            title: Text("Suporte via WhatsApp pelo número +55 63 984495507"),
            trailing: Icon(Icons.phonelink_ring),
          ),
          ListTile(
            title: Text("Suporte via email em brintec.education@gmail.com"),
            trailing: Icon(Icons.email),
          ),
          ListTile(
            title: Text('Click aqui para ir ao tutorial'),
            trailing: Icon(Icons.help),
            onTap: () {
              try {
                launch('https://docs.google.com/document/d/1d1BIX9q6XCULlYB0FQ4bdC7ApjtgicBJ-7sU6rzktF0');
              } catch (e) {}
            },
          ),
          Container(
            alignment: Alignment.center,
            child: Image.asset('assets/imagem/logo2.png'),
          ),
        ],
      ),
    );
  }
}
