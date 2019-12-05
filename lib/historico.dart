import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './struct.dart';

class Historico extends StatefulWidget {
  Historico({this.urlRest, this.userId, this.userCargo});
  final String urlRest;
  final int userId;
  final String userCargo;
  @override
  State<StatefulWidget> createState() => new _HistoricoState(
      urlRest: this.urlRest, userId: this.userId, userCargo: this.userCargo);
}

class _HistoricoState extends State<Historico> {
  _HistoricoState({this.urlRest, this.userId, this.userCargo});
  final int userId;
  final String userCargo;
  String urlRest;
  Future<Iterable<HistoricoResult>> historico;

  @override
  void initState() {
    super.initState();
    historico = fetchHistorico();
  }

  Future<Iterable<HistoricoResult>> fetchHistorico() async {
    if (userCargo == 'funcionario')
      urlRest += 'retiradas/funcionario/' + userId.toString();
    else if (userCargo == 'almoxarife')
      urlRest += 'retiradas/almoxarife/' + userId.toString();
    else
      urlRest += 'retiradas/fechadas';

    var response = await http.get(urlRest);

    try {
      var jsonObject =
          (jsonDecode(response.body) as List).cast<Map<String, dynamic>>();

      if (response.statusCode == 200) {
        return jsonObject
            .map((e) => e == null ? null : HistoricoResult.fromJson(e));
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
            'Histórico de Pedidos',
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
                  FutureBuilder<Iterable<HistoricoResult>>(
                      future: historico,
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
                                        subtitle: Text(
                                            "Não há nenhum pedido finalizado."),
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
                              List dataPedido = pecaAtual.dataPedido.split("-");
                              List diaPedido =
                                  dataPedido[2].toString().split("T");
                              return Card(
                                  child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ListTile(
                                    leading: Icon(Icons.build),
                                    title: Text(pecaAtual.nome),
                                    subtitle: Text(diaPedido[0] +
                                        "/" +
                                        dataPedido[1] +
                                        "/" +
                                        dataPedido[0]),
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
}
