import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:processo_almoxarifado/utils/functions.dart';
import '../auth.dart';
import '../historico.dart';
import '../settings.dart';
import '../struct.dart';
import 'busca_pecas.dart';

class HomePageFuncionario extends StatefulWidget {
  HomePageFuncionario(
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
  State<StatefulWidget> createState() => new _HomePageFuncionarioState(
      urlRest: this.urlRest,
      auth: this.auth,
      userDeslogar: this.userDeslogar,
      userId: this.userId,
      userCargo: this.userCargo);
}

class _HomePageFuncionarioState extends State<HomePageFuncionario> {
  _HomePageFuncionarioState(
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
  Future<Iterable<RetiradasAbertas>> retiradasAbertas;

  @override
  void initState() {
    super.initState();
    retiradasAbertas = fetchRetiradasAbertas();
  }

  Future<Iterable<RetiradasAbertas>> fetchRetiradasAbertas() async {
    String url = urlRest + 'retiradas/abertas/' + userId.toString();

    var response = await http.get(url);

    try {
      var jsonObject =
          (jsonDecode(response.body) as List).cast<Map<String, dynamic>>();

      if (response.statusCode == 200)
        return jsonObject
            .map((e) => e == null ? null : RetiradasAbertas.fromJson(e));
      else
        throw null;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(
            'Página Principal',
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            new FlatButton(
                child: Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => HomePageFuncionario(
                            urlRest: this.urlRest,
                            auth: this.auth,
                            userDeslogar: this.userDeslogar,
                            userId: userId,
                            userCargo: userCargo))))
          ],
          backgroundColor: Colors.blueGrey,
        ),
        body: new SingleChildScrollView(
            child: new Container(
                margin: const EdgeInsets.all(10.0),
                padding: const EdgeInsets.all(10.0),
                child: new Column(children: [
                  new Stack(children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        FutureBuilder<Iterable<RetiradasAbertas>>(
                            future: retiradasAbertas,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Container(
                                  child: Column(
                                      children: snapshot.data.map((retirada) {
                                    return Card(
                                        color: retirada.status == "aberta"
                                            ? Colors.grey[300]
                                            : Colors.green[300],
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            ListTile(
                                              leading: Icon(
                                                  Icons.assignment_turned_in),
                                              title: Text(retirada.nomePeca),
                                              subtitle: retirada.status ==
                                                      "aberta"
                                                  ? Text(
                                                      'Peça em processo de busca')
                                                  : Text(
                                                      'Está pronta para buscar!'),
                                            ),
                                            ButtonTheme.bar(
                                              child: FlatButton(
                                                child: retirada.status ==
                                                        "aberta"
                                                    ? Text('')
                                                    : Text(
                                                        'BUSCAR',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                onPressed:
                                                    retirada.status == "aberta"
                                                        ? null
                                                        : () {
                                                            return showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return AlertDialog(
                                                                    title: Text(
                                                                        'Tem certeza que deseja buscar esta peça?'),
                                                                    actions: <
                                                                        Widget>[
                                                                      new FlatButton(
                                                                        child: new Text(
                                                                            'NÃO'),
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                      ),
                                                                      new FlatButton(
                                                                        child: new Text(
                                                                            'SIM'),
                                                                        onPressed:
                                                                            () =>
                                                                                closeRetirada(retirada.idRetirada),
                                                                      )
                                                                    ],
                                                                  );
                                                                });
                                                          },
                                              ),
                                            ),
                                          ],
                                        ));
                                  }).toList()),
                                );
                              } else if (snapshot.hasError) {
                                return Text("${snapshot.error}");
                              } else if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                return Container(
                                    child: Column(
                                  children: [
                                    Card(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          ListTile(
                                            leading: Icon(Icons.thumb_down),
                                            title: Text("\nErro!\n"),
                                            subtitle: Text(
                                                "Ocorreu um erro ao carregar os dados.\n"),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ));
                              }
                              return new Container(
                                margin: const EdgeInsets.all(10.0),
                                padding: const EdgeInsets.all(10.0),
                                alignment: Alignment(0.0, 0.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    new CircularProgressIndicator(),
                                  ],
                                ),
                              );
                            })
                      ],
                    )
                  ]),
                  SizedBox(height: 15),
                  new ButtonTheme(
                    minWidth: 150.0,
                    height: 150.0,
                    child: Column(
                      children: buildButtons(context),
                    ),
                  ),
                ]))));
  }

  List<Widget> buildButtons(context) {
    return [
      new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new RaisedButton(
              color: Colors.teal,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BuscaPecas(
                          urlRest: this.urlRest, userId: this.userId)),
                );
              },
              child: new Column(children: [
                Icon(Icons.search, color: Colors.white),
                SizedBox(height: 10),
                new Text("Requisitar\nPeças",
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
                          urlRest: this.urlRest,
                          userId: this.userId,
                          userCargo: this.userCargo)),
                );
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

  closeRetirada(int idRetirada) async {
    Navigator.pop(this.context);
    BuscarPeca request = new BuscarPeca(idRetirada: idRetirada);

    String url = urlRest + 'retirada/ok';

    var response = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(request.toJson()));

    if (response.statusCode == 200) {
      return Functions.showAlert("Sucesso!",
          "A retirada desta peça foi confirmada!", "FECHAR", this.context);
    } else
      return Functions.showAlert(
          "Erro!",
          "Não foi possível confirmar retirada esta peça!",
          "FECHAR",
          this.context);
  }
}
