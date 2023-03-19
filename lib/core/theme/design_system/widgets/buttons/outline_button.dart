import 'package:flutter/material.dart';

enum ButtonType { primary, success, error }

class OutlineButton extends StatelessWidget {
  final bool isEnabled;
  final ButtonType type;
  final Function() onPressed;
  final String label;
  final IconData icon;

  const OutlineButton({
    super.key,
    this.isEnabled = true,
    required this.type,
    required this.onPressed,
    required this.label,
    required this.icon,
  });

  Color getColor(BuildContext context) {
    switch (type) {
      case ButtonType.primary:
        return Theme.of(context).colorScheme.primary;
      case ButtonType.success:
        return Theme.of(context).colorScheme.tertiary;
      case ButtonType.error:
        return Theme.of(context).colorScheme.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      icon: Icon(icon),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(140, 45),
        foregroundColor: getColor(context),
        side: BorderSide(
          color:
              isEnabled ? getColor(context) : Theme.of(context).disabledColor,
        ),
      ),
      onPressed: isEnabled ? onPressed : null,
    );
  }
}
