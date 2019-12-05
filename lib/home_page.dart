import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:processo_almoxarifado/auth.dart';

import 'almoxarife/home_page.dart';
import 'administrador/home_page.dart';
import 'funcionario/home_page.dart';
import 'struct.dart';

class HomePage extends StatefulWidget {
  HomePage({this.auth, this.userDeslogar, this.urlRest});
  final String urlRest;
  final BaseAuth auth;
  final VoidCallback userDeslogar;
  @override
  State<StatefulWidget> createState() => new _HomePageState(
      urlRest: this.urlRest, auth: this.auth, userDeslogar: this.userDeslogar);
}

class _HomePageState extends State<HomePage> {
  _HomePageState({this.auth, this.userDeslogar, this.urlRest});
  final String urlRest;
  final BaseAuth auth;
  final VoidCallback userDeslogar;
  Future<Iterable<User>> user;
  String currentUser;

  @override
  void initState() {
    super.initState();
    user = fetchUser();
  }

  Future<Iterable<User>> fetchUser() async {
    String email = await auth.currentUser();

    String url = urlRest + 'pessoa/' + email;

    var response = await http.get(url);

    try {
      var jsonObject =
          (jsonDecode(response.body) as List).cast<Map<String, dynamic>>();

      if (response.statusCode == 200) {
        return jsonObject.map((e) => e == null ? null : User.fromJson(e));
      } else
        return null;
    } catch (e) {
      return null;
    }
  }

  onDoneLoading(int id, String cargo) async {
    if (cargo == 'funcionario' || cargo == 'funcionário') {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => HomePageFuncionario(
              urlRest: this.urlRest,
              auth: this.auth,
              userDeslogar: this.userDeslogar,
              userId: id,
              userCargo: cargo)));
    } else if (cargo == 'almoxarife') {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => HomePageAlmoxarife(
              urlRest: this.urlRest,
              auth: this.auth,
              userDeslogar: this.userDeslogar,
              userId: id,
              userCargo: cargo)));
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => HomePageAdministrador(
              urlRest: this.urlRest,
              auth: this.auth,
              userDeslogar: this.userDeslogar)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Container(
      child: new Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FutureBuilder<Iterable<User>>(
              future: user,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  for (var user in snapshot.data) {
                    return AlertDialog(
                      title: new Text("Logado com sucesso!"),
                      content: new Text('Seja bem vindo,\n' + user.nome + '!'),
                      actions: <Widget>[
                        FlatButton(
                          child: new Text("OK"),
                          onPressed: () => onDoneLoading(user.id, user.cargo),
                        )
                      ],
                    );
                  }
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                } else if (snapshot.connectionState == ConnectionState.done) {
                  return AlertDialog(
                    title: new Text("Erro ao logar!"),
                    content: new Text('Falha na autenticação.'),
                    actions: <Widget>[
                      FlatButton(
                        child: new Text("TENTAR NOVAMENTE"),
                        onPressed: () => Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => HomePage(
                                    urlRest: this.urlRest,
                                    auth: this.auth,
                                    userDeslogar: this.userDeslogar))),
                      )
                    ],
                  );
                }
                return new Container(
                  margin: const EdgeInsets.all(10.0),
                  padding: const EdgeInsets.all(150.0),
                  alignment: Alignment.center,
                  child: new CircularProgressIndicator(),
                );
              })
        ],
      ),
    ));
  }
}
