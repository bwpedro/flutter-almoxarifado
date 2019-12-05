import 'package:flutter/material.dart';

class Functions {
  static void showAlert(title, content, button, context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(title),
            content: new Text(content),
            actions: <Widget>[
              FlatButton(
                child: new Text(button),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        });
  }
}
