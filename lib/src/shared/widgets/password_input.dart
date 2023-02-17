import 'package:flutter/material.dart';

class PasswordInput extends StatelessWidget {
  final bool isEnabled;
  final TextEditingController controller;
  final String label;

  const PasswordInput({
    super.key,
    this.isEnabled = true,
    required this.controller,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: isEnabled,
      controller: controller,
      obscureText: true,
      enableSuggestions: false,
      autocorrect: false,
      style: TextStyle(
        color: isEnabled ? null : Theme.of(context).disabledColor,
      ),
      decoration: InputDecoration(
        label: Text(label),
        border: const OutlineInputBorder(),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        isDense: true,
        enabled: isEnabled,
      ),
    );
  }
}
