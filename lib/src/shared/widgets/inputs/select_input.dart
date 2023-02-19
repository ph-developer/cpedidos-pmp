import 'package:flutter/material.dart';

class SelectInput extends StatelessWidget {
  final bool isEnabled;
  final TextEditingController controller;
  final String label;
  final Map<String, String> items;
  final String fallbackValue;

  SelectInput({
    super.key,
    this.isEnabled = true,
    this.fallbackValue = '',
    required this.controller,
    required this.label,
    required this.items,
  }) : assert(
          items.isNotEmpty,
          'SelectInput: items property can\'t be empty!',
        );

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: controller.text,
      onChanged: isEnabled
          ? (value) => controller.text = value ?? fallbackValue
          : null,
      decoration: InputDecoration(
        label: Text(label),
        border: const OutlineInputBorder(),
        enabled: isEnabled,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding: const EdgeInsets.fromLTRB(14.0, 14.0, 8.0, 14.0),
        isDense: true,
      ),
      items: items.entries
          .map((entry) => DropdownMenuItem(
                value: entry.key,
                child: Text(entry.value),
              ))
          .toList(),
    );
  }
}
