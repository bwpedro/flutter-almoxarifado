import 'package:flutter/material.dart';

import '../auth.dart';
import '../historico.dart';
import '../settings.dart';
import 'timeline.dart';

class HomePageAlmoxarife extends StatefulWidget {
  HomePageAlmoxarife(
      {this.auth,
      this.userDeslogar,
      this.urlRest,
      this.userId,
      this.userCargo});
  final String urlRest;
  final BaseAuth auth;
  final VoidCallback userDeslogar;
  final int userId;
  final String userCargo;
  @override
  State<StatefulWidget> createState() => new _HomePageAlmoxarifeState(
      urlRest: this.urlRest,
      auth: this.auth,
      userDeslogar: this.userDeslogar,
      userId: this.userId,
      userCargo: this.userCargo);
}

class _HomePageAlmoxarifeState extends State<HomePageAlmoxarife> {
  _HomePageAlmoxarifeState(
      {this.auth,
      this.userDeslogar,
      this.urlRest,
      this.userId,
      this.userCargo});
  final String urlRest;
  final BaseAuth auth;
  final VoidCallback userDeslogar;
  final int userId;
  final String userCargo;

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
                          Timeline(urlRest: this.urlRest, userId: this.userId)),
                );
              },
              child: new Column(children: [
                Icon(Icons.dashboard, color: Colors.white),
                SizedBox(height: 10),
                new Text("Timeline",
                    style: new TextStyle(fontSize: 17.0, color: Colors.white))
              ]),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
          new RaisedButton(
              color: Colors.cyan,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Historico(
                            urlRest: this.urlRest,
                            userId: this.userId,
                            userCargo: this.userCargo)));
              },
              child: new Column(children: [
                Icon(Icons.description, color: Colors.white),
                SizedBox(height: 10),
                new Text("Histórico\nde Pedidos",
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
