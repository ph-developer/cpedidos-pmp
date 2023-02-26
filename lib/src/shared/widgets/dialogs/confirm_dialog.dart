import 'package:flutter/material.dart';

import '../buttons/outline_button.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String content;
  final Function() onYes;
  final Function()? onCancel;
  final String yesButtonText;
  final String cancelButtonText;

  const ConfirmDialog({
    required this.title,
    required this.content,
    required this.onYes,
    this.onCancel,
    this.yesButtonText = 'Sim',
    this.cancelButtonText = 'Cancelar',
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        OutlineButton(
          label: yesButtonText,
          icon: Icons.check_rounded,
          type: ButtonType.primary,
          onPressed: () {
            onYes();
            Navigator.pop(context);
          },
        ),
        OutlineButton(
          label: cancelButtonText,
          icon: Icons.close_rounded,
          type: ButtonType.primary,
          onPressed: () {
            onCancel?.call();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
