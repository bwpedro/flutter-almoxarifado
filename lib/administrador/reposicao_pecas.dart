import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:processo_almoxarifado/utils/functions.dart';

import '../struct.dart';

class ReposicaoPecas extends StatefulWidget {
  ReposicaoPecas({this.urlRest});
  final String urlRest;
  @override
  State<StatefulWidget> createState() =>
      new _ReposicaoPecasState(urlRest: this.urlRest);
}

class _ReposicaoPecasState extends State<ReposicaoPecas> {
  _ReposicaoPecasState({this.urlRest});
  String urlRest;
  Future<Iterable<PecasRepor>> pecas;

  var control = new TextEditingController();
  @override
  void initState() {
    super.initState();
    pecas = fetchPecasRepor();
  }

  Future<Iterable<PecasRepor>> fetchPecasRepor() async {
    String url = urlRest + 'pecasParaRepor';

    var response = await http.get(url);

    try {
      var jsonObject =
          (jsonDecode(response.body) as List).cast<Map<String, dynamic>>();

      if (response.statusCode == 200) {
        return jsonObject.map((e) => e == null ? null : PecasRepor.fromJson(e));
      } else
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
            'Reposição de Peças',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blueGrey,
        ),
        body: new SingleChildScrollView(
            padding: const EdgeInsets.all(10.0),
            child: new Stack(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FutureBuilder<Iterable<PecasRepor>>(
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
                                        subtitle:
                                            Text("Não há peças para repor."),
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
                                    title: Text(pecaAtual.nomePeca),
                                    subtitle: Text(pecaAtual.dataAviso),
                                  ),
                                  ButtonTheme.bar(
                                    child: ButtonBar(
                                      children: <Widget>[
                                        FlatButton(
                                            child: Text('REPOR'),
                                            onPressed: () {
                                              return showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: Text(
                                                          'Informe a quantidade'),
                                                      content: TextField(
                                                        decoration:
                                                            InputDecoration(
                                                                hintText:
                                                                    "Quantidade"),
                                                        controller: control,
                                                      ),
                                                      actions: <Widget>[
                                                        new FlatButton(
                                                          child: new Text(
                                                              'CANCELAR'),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                        new FlatButton(
                                                          child: new Text(
                                                              'CONFIRMAR'),
                                                          onPressed: () =>
                                                              reporPeca(
                                                            control.text,
                                                            pecaAtual.idPeca,
                                                            pecaAtual.idAviso,
                                                          ),
                                                        )
                                                      ],
                                                    );
                                                  });
                                            })
                                      ],
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
            ])));
  }

  reporPeca(String qtdRepor, int idPeca, int idAviso) async {
    Navigator.of(context).pop();
    String url = urlRest + 'peca/repor';
    ReporPeca request = new ReporPeca(
        qtdRepor: int.parse(qtdRepor), idPeca: idPeca, idAviso: idAviso);

    var response = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(request.toJson()));

    if (response.statusCode == 200)
      return Functions.showAlert(
          "Sucesso!", "Sua requisção foi enviada!", "FECHAR", this.context);
    else
      return Functions.showAlert("Erro!",
          "Não foi possível enviar sua requisição!", "FECHAR", this.context);
  }
}
