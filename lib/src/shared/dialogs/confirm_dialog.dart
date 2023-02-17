import 'package:asuka/asuka.dart';
import 'package:flutter/material.dart';

void showConfirmDialog({
  required String title,
  required String text,
  required Function() onOk,
  Function()? onCancel,
  String okButtonText = 'Ok',
  String cancelButtonText = 'Cancelar',
}) {
  Asuka.showDialog(
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(text),
      actions: [
        TextButton(
          onPressed: () {
            onCancel?.call();
            Navigator.pop(context);
          },
          child: Text(cancelButtonText),
        ),
        TextButton(
          onPressed: () {
            onOk();
            Navigator.pop(context);
          },
          child: Text(okButtonText),
        ),
      ],
    ),
  );
}
