import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:processo_almoxarifado/utils/functions.dart';
import 'auth.dart';

class LoginPage extends StatefulWidget {
  LoginPage({this.auth, this.userLogado, this.urlRest});
  final BaseAuth auth;
  final VoidCallback userLogado;
  final String urlRest;

  @override
  State<StatefulWidget> createState() =>
      new _LoginPageState(urlRest: this.urlRest);
}

class _LoginPageState extends State<LoginPage> {
  _LoginPageState({this.urlRest});
  String urlRest;
  final formKey = new GlobalKey<FormState>();

  String _email, _senha;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomPadding: false,
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
      SizedBox(height: 35),
      Image.asset('assets/logo.png', height: 230),
      SizedBox(height: 15),
      new TextFormField(
        decoration: new InputDecoration(labelText: 'Email'),
        validator: (value) =>
            value.isEmpty ? 'O campo email é obrigatório!' : null,
        onSaved: (value) => _email = value,
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
    return [
      SizedBox(height: 20),
      new RaisedButton(
        child: new Text("Login",
            style: new TextStyle(fontSize: 17.0, color: Colors.white)),
        color: Colors.blueGrey,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onPressed: logarUsuario,
      ),
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

  void logarUsuario() async {
    if (validaDados()) {
      try {
        await widget.auth.signInWithEmailAndPassword(_email, _senha);
        widget.userLogado();
      } catch (error) {
        Functions.showAlert(
            "Erro!", "Usuário ou senha incorretos!", "OK", this.context);
      }
    }
  }
}
