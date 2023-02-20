import 'package:flutter/material.dart';

import 'snack_bar.dart';

class ErrorSnackBar implements ISnackBar {
  final BuildContext context;
  final String text;

  ErrorSnackBar(
    this.context, {
    required this.text,
  });

  SnackBar get buildSnackBar => SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Material(
              borderRadius: BorderRadius.circular(6.0),
              elevation: 6.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6.0),
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  color: Theme.of(context).colorScheme.error,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          text,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onError,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: hide,
                        icon: Icon(
                          Icons.close_rounded,
                          color: Theme.of(context).colorScheme.onError,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  @override
  void show() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(buildSnackBar);
  }

  @override
  void hide() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }
}
