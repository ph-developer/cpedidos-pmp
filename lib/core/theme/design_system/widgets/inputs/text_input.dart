import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextInput extends StatelessWidget {
  final bool isEnabled;
  final bool isLoading;
  final bool autofocus;
  final List<TextInputFormatter> formatters;
  final TextEditingController controller;
  final String label;
  final FocusNode? focusNode;
  final Function(String)? onSubmitted;

  const TextInput({
    super.key,
    this.isEnabled = true,
    this.isLoading = false,
    this.autofocus = false,
    this.formatters = const [],
    this.focusNode,
    this.onSubmitted,
    required this.controller,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: focusNode,
      enabled: isEnabled,
      controller: controller,
      inputFormatters: formatters,
      autofocus: autofocus,
      onSubmitted: onSubmitted,
      style: TextStyle(
        color: isEnabled ? null : Theme.of(context).disabledColor,
      ),
      decoration: InputDecoration(
        label: Text(label),
        border: const OutlineInputBorder(),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        isDense: true,
        enabled: isEnabled,
        suffixIcon: isLoading
            ? Transform.scale(
                scale: 0.5,
                child: const CircularProgressIndicator(),
              )
            : null,
      ),
    );
  }
}
