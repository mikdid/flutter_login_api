import 'package:flutter/material.dart';

Future<void> showSimpleAlert(context, String titre, String texte) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(titre),
        content: Text(texte),
        actions: <Widget>[
          TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
        ]
      );
    },
  );
}

/*void _showDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: new Text("Alert!!"),
        content: new Text("You are awesome!"),
        actions: <Widget>[
          new ElevatedButton(
            child: new Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}*/

/*showDialog(context) {
  return AlertDialog(
    title: new Text("Alert!!"),
    content: new Text("You are awesome!"),
    actions: <Widget>[
      new ElevatedButton(
        child: new Text("OK"),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    ],
  );
}*/