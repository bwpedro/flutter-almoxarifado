import 'package:flutter/material.dart';
import 'package:processo_almoxarifado/utils/functions.dart';

class ReportarProblema extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _ReportarProblemaState();
}

class _ReportarProblemaState extends State<ReportarProblema> {
  final formKey = new GlobalKey<FormState>();

  String _descricao;

  _enviarProblema() {
    if (validaDados()) {
      Functions.showAlert(
          "Seu problema foi enviado!",
          "Obrigado por reportar um problema, sua mensagem será analisada por nossa equipe de suporte.",
          "FECHAR",
          this.context);
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
            'Reportar problema',
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
        decoration: new InputDecoration(labelText: 'Descrição'),
        validator: (value) =>
            value.isEmpty ? 'Digite uma descrição para reportar!' : null,
        onSaved: (value) => _descricao = value,
      ),
    ];

    List<Widget> buttons = [
      SizedBox(height: 20),
      new RaisedButton(
        child: new Text("Enviar",
            style: new TextStyle(fontSize: 17.0, color: Colors.white)),
        color: Colors.blueGrey,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onPressed: _enviarProblema,
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
