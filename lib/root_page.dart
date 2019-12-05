import 'package:flutter/material.dart';
import 'package:processo_almoxarifado/home_page.dart';
import 'home_page.dart';
import 'login_page.dart';
import 'auth.dart';

class RootPage extends StatefulWidget {
  RootPage({this.auth});
  final BaseAuth auth;
  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

enum AuthStatus {
  logado,
  naoLogado,
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.naoLogado;
  final String urlRest = '';

  @override
  void initState() {
    super.initState();
    widget.auth.currentUser().then((userId) {
      setState(() {
        authStatus = userId == null ? AuthStatus.naoLogado : AuthStatus.logado;
      });
    });
  }

  void _logado() {
    setState(() {
      authStatus = AuthStatus.logado;
    });
  }

  void _deslogado() {
    setState(() {
      authStatus = AuthStatus.naoLogado;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (authStatus == AuthStatus.naoLogado)
      return new LoginPage(
          auth: widget.auth, userLogado: _logado, urlRest: this.urlRest);
    else
      return new HomePage(
          auth: widget.auth, userDeslogar: _deslogado, urlRest: this.urlRest);
  }
}
