import 'package:flutter/services.dart';

import 'package:mask/mask.dart';

extension InputFormatters on TextInputFormatter {
  static TextInputFormatter get digitsOnly =>
      FilteringTextInputFormatter.digitsOnly;

  static TextInputFormatter get digitsAndHyphensOnly =>
      FilteringTextInputFormatter.allow(RegExp(r'[0-9-]'));

  static TextInputFormatter get uppercase => TextInputFormatter.withFunction(
        (oldValue, newValue) => TextEditingValue(
          text: newValue.text.toUpperCase(),
          selection: newValue.selection,
        ),
      );

  static TextInputFormatter get date => Mask.date();
}
