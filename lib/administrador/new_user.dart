import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:processo_almoxarifado/utils/functions.dart';
import '../struct.dart';

class NewUser extends StatefulWidget {
  NewUser({this.urlRest});
  final String urlRest;

  @override
  State<StatefulWidget> createState() =>
      new _NewUserState(urlRest: this.urlRest);
}

class _NewUserState extends State<NewUser> {
  _NewUserState({this.urlRest});
  final String urlRest;

  final formKey = new GlobalKey<FormState>();

  String _nome, _cpf, _email, _senha, _cargo;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          title: new Text(
            'Cadastrar Usuário',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blueGrey,
        ),
        body: new Container(
            padding: EdgeInsets.all(16.0),
            child: new Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: buildInputs() + buildButtons(),
                ))));
  }

  List<Widget> buildInputs() {
    return [
      Image.asset('assets/user.png', height: 130),
      new DropdownButton<String>(
        items: <String>['administrador', 'almoxarife', 'funcionário']
            .map((String value) {
          return new DropdownMenuItem<String>(
            value: value,
            child: new Text(value),
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            _cargo = newValue;
          });
        },
        isExpanded: true,
        value: _cargo,
        hint: new Text("Cargo"),
      ),
      new TextFormField(
        decoration: new InputDecoration(labelText: 'Email'),
        validator: (value) =>
            value.isEmpty ? 'O campo email é obrigatório!' : null,
        onSaved: (value) => _email = value,
      ),
      new TextFormField(
        decoration: new InputDecoration(labelText: 'Nome'),
        validator: (value) =>
            value.isEmpty ? 'O campo nome é obrigatório!' : null,
        onSaved: (value) => _nome = value,
      ),
      new TextFormField(
        decoration: new InputDecoration(labelText: 'CPF'),
        validator: (value) =>
            value.isEmpty ? 'O campo CPF é obrigatório!' : null,
        onSaved: (value) => _cpf = value,
      ),
      new TextFormField(
        decoration: new InputDecoration(labelText: 'Senha'),
        obscureText: true,
        validator: (value) =>
            value.isEmpty ? 'O campo senha é obrigatório!' : null,
        onSaved: (value) => _senha = value,
      ),
    ];
  }

  List<Widget> buildButtons() {
    List<Widget> arrayButtons = [];

    arrayButtons += [
      SizedBox(height: 25),
      new RaisedButton(
        child: new Text("Cadastrar",
            style: new TextStyle(fontSize: 17.0, color: Colors.white)),
        color: Colors.blueGrey,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onPressed: cadastrarUsuario,
      ),
    ];

    return arrayButtons += [
      new FlatButton(
        child: new Text("Cancelar", style: new TextStyle(fontSize: 15.0)),
        onPressed: () => Navigator.pop(this.context),
      )
    ];
  }

  bool validaDados() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      return true;
    } else
      return false;
  }

  cadastrarUsuario() async {
    if (!validaDados()) return;
    CreateUser request = new CreateUser(
        nome: _nome, cpf: _cpf, email: _email, senha: _senha, cargo: _cargo);

    String url = urlRest + 'pessoa';

    var response = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(request.toJson()));

    if (response.statusCode == 201)
      return Functions.showAlert(
          "Sucesso!", "Usuário criado com sucesso!", "FECHAR", this.context);
    else
      return Functions.showAlert(
          "Erro!", "Não foi possível criar usuário!", "FECHAR", this.context);
  }
}
