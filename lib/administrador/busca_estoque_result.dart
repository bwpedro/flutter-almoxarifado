import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:processo_almoxarifado/struct.dart';

class BuscaEstoqueResult extends StatefulWidget {
  BuscaEstoqueResult({this.urlRest, this.peca});
  final String urlRest;
  final String peca;
  @override
  State<StatefulWidget> createState() =>
      new _BuscaEstoqueResultState(urlRest: this.urlRest, peca: this.peca);
}

class _BuscaEstoqueResultState extends State<BuscaEstoqueResult> {
  _BuscaEstoqueResultState({this.urlRest, this.peca});
  String urlRest;
  final String peca;
  Future<Iterable<Peca>> pecas;

  @override
  void initState() {
    super.initState();
    pecas = fetchPecas();
  }

  Future<Iterable<Peca>> fetchPecas() async {
    urlRest += 'peca/' + peca;
    var response = await http.get(urlRest);

    try {
      var jsonObject =
          (jsonDecode(response.body) as List).cast<Map<String, dynamic>>();

      if (response.statusCode == 200)
        return jsonObject.map((e) => e == null ? null : Peca.fromJson(e));
      else
        return null;
    } catch (e) {
      return null;
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
            'Estoque Disponível',
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            new FlatButton(
              child: Icon(
                Icons.home,
                color: Colors.white,
              ),
              onPressed: () =>
                  {Navigator.of(context).popUntil((route) => route.isFirst)},
            )
          ],
          backgroundColor: Colors.blueGrey,
        ),
        body: new SingleChildScrollView(
            padding: const EdgeInsets.all(10.0),
            child: new Stack(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FutureBuilder<Iterable<Peca>>(
                      future: pecas,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data.isEmpty) {
                            return Container(
                                child: Column(
                              children: [
                                Card(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      ListTile(
                                        leading: Icon(Icons.error_outline),
                                        title: Text("Nada por aqui"),
                                        subtitle: Text("Busca por " +
                                            peca +
                                            " não retornou nenhuma peça!"),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ));
                          }
                          return Container(
                            child: Column(
                                children: snapshot.data.map((pecaAtual) {
                              return Card(
                                  child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ListTile(
                                    leading: Icon(Icons.build),
                                    title: Text(pecaAtual.nome),
                                    subtitle: Text('Quantidade: ' +
                                        pecaAtual.qtdDisponivel.toString()),
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
                                      leading: Icon(Icons.error_outline),
                                      title: Text("\nNada por aqui\n"),
                                      subtitle: Text("Busca por " +
                                          peca +
                                          " não retornou nenhuma peça!\n"),
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
                            children: [new CircularProgressIndicator()],
                          ),
                        );
                      })
                ],
              )
            ])));
  }
}
