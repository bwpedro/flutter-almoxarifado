import 'package:flutter/material.dart';

import '../auth.dart';
import '../historico.dart';
import '../settings.dart';
import 'busca_estoque.dart';
import 'new_user.dart';
import 'reposicao_pecas.dart';

class HomePageAdministrador extends StatefulWidget {
  HomePageAdministrador({this.auth, this.userDeslogar, this.urlRest});
  final String urlRest;
  final BaseAuth auth;
  final VoidCallback userDeslogar;
  @override
  State<StatefulWidget> createState() => new _HomePageAdministradorState(
      urlRest: this.urlRest, auth: this.auth, userDeslogar: this.userDeslogar);
}

class _HomePageAdministradorState extends State<HomePageAdministrador> {
  _HomePageAdministradorState({this.auth, this.userDeslogar, this.urlRest});
  final String urlRest;
  final BaseAuth auth;
  final VoidCallback userDeslogar;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(
            'Página Principal',
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
              children: buildButtons(context),
            ),
          ),
        ));
  }

  List<Widget> buildButtons(context) {
    return [
      new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new RaisedButton(
              color: Colors.orangeAccent[400],
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          BuscaEstoque(urlRest: this.urlRest)),
                );
              },
              child: new Column(children: [
                Icon(Icons.search, color: Colors.white),
                SizedBox(height: 10),
                new Text("Buscar\nEstoque",
                    textAlign: TextAlign.center,
                    style: new TextStyle(fontSize: 17.0, color: Colors.white))
              ]),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
          new RaisedButton(
              color: Colors.teal,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NewUser(urlRest: this.urlRest)),
                );
              },
              child: new Column(children: [
                Icon(Icons.add, color: Colors.white),
                SizedBox(height: 10),
                new Text("Cadastrar\nUsuário",
                    textAlign: TextAlign.center,
                    style: new TextStyle(fontSize: 17.0, color: Colors.white))
              ]),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
        ],
      ),
      SizedBox(height: 35),
      new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new RaisedButton(
              color: Colors.brown[200],
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ReposicaoPecas(urlRest: this.urlRest)),
                );
              },
              child: new Column(children: [
                Icon(Icons.build, color: Colors.white),
                SizedBox(height: 10),
                new Text("Reposição\nde Peças",
                    textAlign: TextAlign.center,
                    style: new TextStyle(fontSize: 17.0, color: Colors.white))
              ]),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
          new RaisedButton(
              color: Colors.indigo,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Historico(
                          urlRest: this.urlRest, userId: 0, userCargo: '')),
                );
              },
              child: new Column(children: [
                Icon(Icons.subdirectory_arrow_right, color: Colors.white),
                SizedBox(height: 10),
                new Text("Histórico\nde Retirada",
                    textAlign: TextAlign.center,
                    style: new TextStyle(fontSize: 17.0, color: Colors.white))
              ]),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
        ],
      ),
      SizedBox(height: 35),
      new Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        new RaisedButton(
            color: Colors.grey[800],
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Settings(
                        auth: this.auth, userDeslogar: this.userDeslogar)),
              );
            },
            child: new Column(children: [
              Icon(Icons.settings, color: Colors.white),
              SizedBox(height: 10),
              new Text("Configurações",
                  style: new TextStyle(fontSize: 17.0, color: Colors.white))
            ]),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))
      ])
    ];
  }
}
