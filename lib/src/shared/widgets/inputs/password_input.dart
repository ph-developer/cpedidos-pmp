import 'package:flutter/material.dart';

import '../../helpers/universal_imports.dart' show JS
  if (dart.library.js) 'package:js/js.dart';

@JS('fixPasswordCss')
external void fixPasswordCss();

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
  final focusNode = FocusNode();
  var showPassword = false;

  _fixEdgePasswordRevealButton() {
    focusNode.unfocus();
    Future.microtask(() {
      focusNode.requestFocus();
      fixPasswordCss();
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: widget.isEnabled,
      controller: widget.controller,
      onSubmitted: widget.onSubmitted,
      obscureText: !showPassword,
      enableSuggestions: false,
      autocorrect: false,
      focusNode: focusNode,
      onChanged: (_) => _fixEdgePasswordRevealButton(),
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
