import 'package:flutter/material.dart';
import 'package:pialuno/plataforma/recursos.dart';

class Versao extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Versão & Sobre'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Recursos.instance.plataforma == 'android' ? Text("Versão 1.0.0"):Text("Build: 20191128"),
          ),
        ],
      ),
    );
  }
}