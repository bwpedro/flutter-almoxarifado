import 'package:flutter/material.dart';
import 'busca_pecas_result.dart';

class BuscaPecas extends StatefulWidget {
  BuscaPecas({
    this.urlRest,
    this.userId,
  });
  final String urlRest;
  final int userId;
  @override
  State<StatefulWidget> createState() =>
      new _BuscaPecasState(urlRest: this.urlRest, userId: this.userId);
}

class _BuscaPecasState extends State<BuscaPecas> {
  _BuscaPecasState({this.urlRest, this.userId});
  final String urlRest;
  final int userId;
  final formKey = new GlobalKey<FormState>();
  String _peca;

  _buscaQtdEstoque() {
    if (validaDados()) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => BuscaPecasResult(
                urlRest: this.urlRest, peca: _peca, userId: this.userId)),
      );
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
          backgroundColor: Colors.blueGrey,
        ),
        body: new Container(
            margin: const EdgeInsets.all(10.0),
            padding: const EdgeInsets.all(10.0),
            child: new Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: buildComponents(context),
                ))));
  }

  List<Widget> buildComponents(context) {
    List<Widget> inputs = [
      new TextFormField(
        decoration: new InputDecoration(labelText: 'Nome da peça'),
        validator: (value) =>
            value.isEmpty ? 'Digite uma peça para requisitar!' : null,
        onSaved: (value) => _peca = value,
      ),
    ];

    List<Widget> buttons = [
      SizedBox(height: 20),
      new RaisedButton(
        child: new Text("Buscar",
            style: new TextStyle(fontSize: 17.0, color: Colors.white)),
        color: Colors.blueGrey,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onPressed: _buscaQtdEstoque,
      ),
    ];

    return inputs + buttons;
  }

  bool validaDados() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      return true;
    } else
      return false;
  }
}
