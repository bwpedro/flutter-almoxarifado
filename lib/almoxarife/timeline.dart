import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:processo_almoxarifado/utils/functions.dart';

import '../struct.dart';

class Timeline extends StatefulWidget {
  Timeline({this.urlRest, this.userId});
  final String urlRest;
  final int userId;

  @override
  State<StatefulWidget> createState() =>
      new _TimelineState(urlRest: this.urlRest, userId: this.userId);
}

class _TimelineState extends State<Timeline> {
  _TimelineState({this.urlRest, this.userId});
  String urlRest;
  final int userId;
  Future<Iterable<PedidosAbertos>> pedidos;

  @override
  void initState() {
    super.initState();
    pedidos = fetchPedidos();
  }

  Future<Iterable<PedidosAbertos>> fetchPedidos() async {
    String url = urlRest + 'retiradas/abertas';

    var response = await http.get(url);

    try {
      var jsonObject =
          (jsonDecode(response.body) as List).cast<Map<String, dynamic>>();

      if (response.statusCode == 200)
        return jsonObject
            .map((e) => e == null ? null : PedidosAbertos.fromJson(e));
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
            'Pedidos em Aberto',
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
                  FutureBuilder<Iterable<PedidosAbertos>>(
                      future: pedidos,
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
                                            Text("Não há pedidos em aberto."),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ));
                          }
                          return Container(
                            child: Column(
                                children: snapshot.data.map((pedido) {
                              List dataPedido = pedido.dataPedido.split("-");
                              List diaPedido =
                                  dataPedido[2].toString().split("T");
                              return Card(
                                  child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ListTile(
                                    leading: Icon(Icons.build),
                                    title: Text(pedido.nomePeca),
                                    subtitle: Text(diaPedido[0] +
                                        "/" +
                                        dataPedido[1] +
                                        "/" +
                                        dataPedido[0] +
                                        '\n\nQuantidade: ' +
                                        pedido.qtdRequerida.toString()),
                                  ),
                                  ButtonTheme.bar(
                                    child: ButtonBar(
                                      children: <Widget>[
                                        FlatButton(
                                            child: Text('ACEITAR'),
                                            onPressed: () {
                                              return showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: Text(
                                                          'Deseja aceitar esta requisição?'),
                                                      actions: <Widget>[
                                                        new FlatButton(
                                                          child:
                                                              new Text('NÃO'),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                        new FlatButton(
                                                          child:
                                                              new Text('SIM'),
                                                          onPressed: () =>
                                                              acceptRequest(
                                                                  pedido.idPeca,
                                                                  pedido
                                                                      .idRetirada),
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

  acceptRequest(int idPeca, int idRetirada) async {
    Navigator.of(context).pop();
    String url = urlRest + 'retirada/aprovar';

    AcceptRequest request =
        new AcceptRequest(idRetirada: idRetirada, idAlmoxarife: userId);

    var response = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(request.toJson()));

    if (response.statusCode == 200)
      return Functions.showAlert(
          "Sucesso!",
          "Agora este pedido está assignado para você!",
          "FECHAR",
          this.context);
    else
      return Functions.showAlert("Erro!",
          "Não foi possível assignar este pedido!", "FECHAR", this.context);
  }
}
