import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:processo_almoxarifado/struct.dart';

import '../utils/functions.dart';

class BuscaPecasResult extends StatefulWidget {
  BuscaPecasResult({this.urlRest, this.peca, this.userId});
  final String urlRest;
  final String peca;
  final int userId;
  @override
  State<StatefulWidget> createState() => new _BuscaPecasResultState(
      urlRest: this.urlRest, peca: this.peca, userId: this.userId);
}

class _BuscaPecasResultState extends State<BuscaPecasResult> {
  _BuscaPecasResultState({this.urlRest, this.peca, this.userId});
  final String peca;
  final int userId;
  String urlRest;

  Future<Iterable<Peca>> pecas;
  var control = new TextEditingController();

  @override
  void initState() {
    super.initState();
    pecas = fetchPecas();
  }

  Future<Iterable<Peca>> fetchPecas() async {
    String url = urlRest + 'peca/' + peca;

    var response = await http.get(url);

    try {
      var jsonObject =
          (jsonDecode(response.body) as List).cast<Map<String, dynamic>>();

      if (response.statusCode == 200)
        return jsonObject.map((e) => e == null ? null : Peca.fromJson(e));
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
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          title: new Text(
            'Requisitar Peça',
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
                                    subtitle: Text('Quantidade disponível: ' +
                                        pecaAtual.qtdDisponivel.toString()),
                                  ),
                                  ButtonTheme.bar(
                                    child: ButtonBar(
                                      children: <Widget>[
                                        FlatButton(
                                          child: Text('REQUISITAR'),
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
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                      new FlatButton(
                                                        child: new Text(
                                                            'CONFIRMAR'),
                                                        onPressed: () =>
                                                            requestPeca(
                                                                pecaAtual.id,
                                                                control.text,
                                                                pecaAtual
                                                                    .qtdDisponivel),
                                                      )
                                                    ],
                                                  );
                                                });
                                          },
                                        ),
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

  requestPeca(int idPeca, String qtdRequerida, int qtdDisponivel) async {
    Navigator.of(context).pop();
    if (int.parse(qtdRequerida) > qtdDisponivel)
      return Functions.showAlert(
          "Erro!",
          "A quantidade requerida é maior que a quantidade disponível da peça.",
          "FECHAR",
          this.context);

    RequestPeca request = new RequestPeca(
        idPeca: idPeca,
        idFuncionario: userId,
        qtdRequerida: int.parse(qtdRequerida));

    String url = urlRest + 'peca/retirar';

    var response = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(request.toJson()));

    if (response.statusCode == 200)
      return Functions.showAlert(
          "Sucesso!", "Pedido realizado com sucesso!", "FECHAR", this.context);
    else
      return Functions.showAlert("Erro!",
          "Não foi possível realizar este pedido!", "FECHAR", this.context);
  }
}
