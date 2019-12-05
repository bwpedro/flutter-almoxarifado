import 'dart:io';

import 'package:flutter/material.dart';
import 'package:processo_almoxarifado/reportar_problema.dart';
import 'package:processo_almoxarifado/utils/functions.dart';
import './auth.dart';

class Settings extends StatefulWidget {
  Settings({this.auth, this.userDeslogar});
  final BaseAuth auth;
  final VoidCallback userDeslogar;

  @override
  State<StatefulWidget> createState() =>
      new _SettingsState(auth: this.auth, userDeslogar: this.userDeslogar);
}

enum FormType { login, cadastrar, esqueci }

class _SettingsState extends State<Settings> {
  _SettingsState({this.auth, this.userDeslogar});
  final BaseAuth auth;
  final VoidCallback userDeslogar;
  final formKey = new GlobalKey<FormState>();

  void _deslogar() async {
    try {
      await auth.signOut();
      exit(0);
    } catch (e) {
      Functions.showAlert(
          "Erro!", "Não foi possível deslogar", "OK", this.context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          title: new Text(
            'Configurações',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blueGrey,
        ),
        body: new Container(
          margin: const EdgeInsets.all(10.0),
          padding: const EdgeInsets.all(10.0),
          child: new ButtonTheme(
            minWidth: 150.0,
            height: 150.0,
            child: Column(
              children: buildButtons(),
            ),
          ),
        ));
  }

  List<Widget> buildButtons() {
    List<Widget> arrayButtons = [];

    arrayButtons += [
      new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new RaisedButton(
              color: Colors.red[900],
              onPressed: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ReportarProblema()),
                    ),
                  },
              child: new Column(children: [
                Icon(Icons.bug_report, color: Colors.white),
                SizedBox(height: 10),
                new Text("Reportar\nProblema",
                    textAlign: TextAlign.center,
                    style: new TextStyle(fontSize: 17.0, color: Colors.white))
              ]),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
          new RaisedButton(
              color: Colors.indigo,
              onPressed: () {
                return showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Tem certeza que deseja deslogar?'),
                        content: Text(
                            'Esta ação irá fechar o aplicativo e será necessário logar novamente.'),
                        actions: <Widget>[
                          new FlatButton(
                            child: new Text('NÃO'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          new FlatButton(
                            child: new Text('SIM'),
                            onPressed: _deslogar,
                          )
                        ],
                      );
                    });
              },
              child: new Column(children: [
                Icon(Icons.exit_to_app, color: Colors.white),
                SizedBox(height: 10),
                new Text("Deslogar",
                    style: new TextStyle(fontSize: 17.0, color: Colors.white))
              ]),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)))
        ],
      ),
      // new Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      //   new RaisedButton(
      //       color: Colors.grey[700],
      //       onPressed: () => {},
      //       child: new Column(children: [
      //         Icon(Icons.wb_sunny, color: Colors.white),
      //         SizedBox(height: 10),
      //         new Text("Dark/Light mode",
      //             style: new TextStyle(fontSize: 17.0, color: Colors.white))
      //       ]),
      //       shape: RoundedRectangleBorder(
      //           borderRadius: BorderRadius.circular(10))),
      //   SizedBox(height: 35),
      // ])
    ];

    return arrayButtons;
  }
}
