// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import '../helpers/map_helper.dart';

part 'obs_form.g.dart';

typedef _FieldGetter<T, R> = R Function(T field);
typedef _FieldsGetter<R> = R Function();

class ObservableForm<T extends Enum> = _ObservableFormBase
    with _$ObservableForm;

abstract class _ObservableFormBase<T extends Enum> with Store {
  final Map<T, Observable<String>> _values = {};
  final Map<T, TextEditingController> _controllers = {};
  final Map<T, FocusNode> _focusNodes = {};
  final Map<T, String> _initialValues = {};

  _ObservableFormBase(List<T> fields, [Map<T, String>? initialValues]) {
    for (final field in fields) {
      final initialValue = initialValues?[field] ?? '';
      _initialValues[field] = initialValue;
      _values[field] = Observable(initialValue);
      _focusNodes[field] = FocusNode();
      final controller = TextEditingController(text: initialValue);
      controller.addListener(() => _setInternalValue(field, controller.text));
      _controllers[field] = controller;
    }
  }

  TextEditingController getController(T field) => _controllers[field]!;
  FocusNode getFocusNode(T field) => _focusNodes[field]!;
  Observable<String> getField(T field) => _values[field]!;

  @computed
  _FieldGetter<T, String> get getFieldValue {
    return (T field) => getField(field).value;
  }

  @computed
  _FieldsGetter<Map<String, String>> get getValues {
    return () => _values.entries
        .map((entry) => MapEntry(entry.key.name, entry.value.value))
        .toMap();
  }

  @action
  void _setInternalValue(T field, String value) {
    _values[field]!.value = _controllers[field]!.text;
  }

  @action
  void setFieldValue(T field, String value) {
    getController(field).text = value;
  }

  @action
  void setFieldValues(Map<T, String> values) {
    values.forEach(setFieldValue);
  }

  @action
  void clear([List<T> only = const []]) {
    _controllers.forEach((field, controller) {
      if (only.isEmpty || only.contains(field)) {
        controller.text = _initialValues[field] ?? '';
      }
    });
  }

  @action
  void focus(T field) {
    getFocusNode(field).requestFocus();
  }

  void dispose() {
    _controllers.forEach((key, controller) => controller.dispose());
    _focusNodes.forEach((key, focusNode) => focusNode.dispose());
  }
}
