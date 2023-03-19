import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextAreaInput extends StatelessWidget {
  final bool isEnabled;
  final List<TextInputFormatter> formatters;
  final TextEditingController controller;
  final String label;
  final int lines;

  const TextAreaInput({
    super.key,
    this.isEnabled = true,
    this.formatters = const [],
    this.lines = 1,
    required this.controller,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: isEnabled,
      controller: controller,
      inputFormatters: formatters,
      minLines: lines,
      maxLines: lines,
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
