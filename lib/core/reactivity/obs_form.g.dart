// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'obs_form.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ObservableForm<T extends Enum> on _ObservableFormBase<T>, Store {
  Computed<_FieldGetter<T, String>>? _$getFieldValueComputed;

  @override
  _FieldGetter<T, String> get getFieldValue => (_$getFieldValueComputed ??=
          Computed<_FieldGetter<T, String>>(() => super.getFieldValue,
              name: '_ObservableFormBase.getFieldValue'))
      .value;
  Computed<_FieldsGetter<Map<String, String>>>? _$getValuesComputed;

  @override
  _FieldsGetter<Map<String, String>> get getValues => (_$getValuesComputed ??=
          Computed<_FieldsGetter<Map<String, String>>>(() => super.getValues,
              name: '_ObservableFormBase.getValues'))
      .value;

  late final _$_ObservableFormBaseActionController =
      ActionController(name: '_ObservableFormBase', context: context);

  @override
  void _setInternalValue(T field, String value) {
    final _$actionInfo = _$_ObservableFormBaseActionController.startAction(
        name: '_ObservableFormBase._setInternalValue');
    try {
      return super._setInternalValue(field, value);
    } finally {
      _$_ObservableFormBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setFieldValue(T field, String value) {
    final _$actionInfo = _$_ObservableFormBaseActionController.startAction(
        name: '_ObservableFormBase.setFieldValue');
    try {
      return super.setFieldValue(field, value);
    } finally {
      _$_ObservableFormBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setFieldValues(Map<T, String> values) {
    final _$actionInfo = _$_ObservableFormBaseActionController.startAction(
        name: '_ObservableFormBase.setFieldValues');
    try {
      return super.setFieldValues(values);
    } finally {
      _$_ObservableFormBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clear([List<T> only = const []]) {
    final _$actionInfo = _$_ObservableFormBaseActionController.startAction(
        name: '_ObservableFormBase.clear');
    try {
      return super.clear(only);
    } finally {
      _$_ObservableFormBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void focus(T field) {
    final _$actionInfo = _$_ObservableFormBaseActionController.startAction(
        name: '_ObservableFormBase.focus');
    try {
      return super.focus(field);
    } finally {
      _$_ObservableFormBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
getFieldValue: ${getFieldValue},
getValues: ${getValues}
    ''';
  }
}
