import 'package:flutter/material.dart';

class PasswordInput extends StatefulWidget {
  final bool isEnabled;
  final TextEditingController controller;
  final String label;
  final Function(String)? onSubmitted;

  const PasswordInput({
    super.key,
    this.isEnabled = true,
    this.onSubmitted,
    required this.controller,
    required this.label,
  });

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  var showPassword = false;

  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: widget.isEnabled,
      controller: widget.controller,
      onSubmitted: widget.onSubmitted,
      obscureText: !showPassword,
      enableSuggestions: false,
      autocorrect: false,
      style: TextStyle(
        color: widget.isEnabled ? null : Theme.of(context).disabledColor,
      ),
      decoration: InputDecoration(
        label: Text(widget.label),
        border: const OutlineInputBorder(),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        isDense: true,
        enabled: widget.isEnabled,
        suffixIcon: IconButton(
          icon: Icon(showPassword
              ? Icons.lock_open_rounded
              : Icons.lock_outline_rounded),
          onPressed: () {
            setState(() {
              showPassword = !showPassword;
            });
          },
        ),
      ),
    );
  }
}
