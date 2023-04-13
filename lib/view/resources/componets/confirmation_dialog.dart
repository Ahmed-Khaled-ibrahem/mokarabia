import 'package:flutter/material.dart';

Future<void> showConfirmDialog(context, callback, title, content) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title:  Text(title),
        content:  Text(content),
        actions: <Widget>[
          TextButton(
            onPressed: callback,
            child: const Text('YES'),
          ),
          TextButton(
            child: const Text('NO'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}