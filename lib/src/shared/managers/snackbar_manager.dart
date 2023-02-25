import 'package:flutter/material.dart';

class _SnackBarManager {
  final BuildContext context;

  _SnackBarManager(this.context);

  void _show({
    required String message,
    required Color backgroundColor,
    required Color textColor,
    required IconData icon,
  }) {
    final snackBar = SnackBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Material(
            borderRadius: BorderRadius.circular(6),
            elevation: 6,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Container(
                padding: const EdgeInsets.all(8),
                color: backgroundColor,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Icon(icon, color: textColor),
                          const SizedBox(width: 8),
                          Text(
                            message,
                            style: TextStyle(
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: hide,
                      icon: Icon(
                        Icons.close_rounded,
                        color: textColor,
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

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  void showSuccess(String message) {
    _show(
      message: message,
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      textColor: Theme.of(context).colorScheme.onTertiary,
      icon: Icons.check_circle_outline_rounded,
    );
  }

  void showError(String message) {
    _show(
      message: message,
      backgroundColor: Theme.of(context).colorScheme.error,
      textColor: Theme.of(context).colorScheme.onError,
      icon: Icons.warning_amber_rounded,
    );
  }

  void hide() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }
}

extension SnackBarManagerExt on BuildContext {
  void showSuccessSnackBar(String message) {
    _SnackBarManager(this).showSuccess(message);
  }

  void showErrorSnackBar(String message) {
    _SnackBarManager(this).showError(message);
  }

  void hideCurrentSnackBar() {
    _SnackBarManager(this).hide();
  }
}
