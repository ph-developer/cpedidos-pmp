import 'package:flutter/services.dart';

import 'package:mask/mask.dart';

extension InputFormatters on TextInputFormatter {
  static TextInputFormatter get digitsOnly =>
      FilteringTextInputFormatter.digitsOnly;

  static TextInputFormatter get digitsAndOneHyphenOnly =>
      FilteringTextInputFormatter.allow(RegExp(r'^\d+\-?\d*'));

  static TextInputFormatter get digitsAndOneDotOnly =>
      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'));

  static TextInputFormatter get uppercase => TextInputFormatter.withFunction(
        (oldValue, newValue) => TextEditingValue(
          text: newValue.text.toUpperCase(),
          selection: newValue.selection,
        ),
      );

  static TextInputFormatter get date => Mask.date();
}
