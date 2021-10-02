import 'package:flutter/material.dart';

Future<int?> showSimpleAlert(context, String titre, String texte) async {
  return showDialog<int>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(titre),
        content: Text(texte),
        actions: <Widget>[
          TextButton(
              onPressed: () => {
                Navigator.pop(context, 0) //return 0
              },
              child: const Text('OK'),
            ),
        ]
      );
    },
  );
}

