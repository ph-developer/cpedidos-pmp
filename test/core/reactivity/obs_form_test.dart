import 'package:cpedidos_pmp/core/reactivity/obs_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/mobx.dart';

enum TestFormFields { withInitialValue, withoutInitialValue }

void main() {
  late ObservableForm obs;

  setUp(() {
    obs = ObservableForm(TestFormFields.values, {
      TestFormFields.withInitialValue: 'test',
    })
      ..toString();
  });

  group('getController', () {
    test(
      'should return a controller of withInitialValue field.',
      () async {
        // act
        final result = obs.getController(TestFormFields.withInitialValue);
        // assert
        expect(result, isA<TextEditingController>());
        expect(result.text, equals('test'));
      },
    );

    test(
      'should return a controller of withoutInitialValue field.',
      () async {
        // act
        final result = obs.getController(TestFormFields.withoutInitialValue);
        // assert
        expect(result, isA<TextEditingController>());
        expect(result.text, equals(''));
      },
    );
  });

  group('getFocusNode', () {
    test(
      'should return a focusNode.',
      () async {
        // act
        final result = obs.getFocusNode(TestFormFields.withInitialValue);
        // assert
        expect(result, isA<FocusNode>());
      },
    );
  });

  group('getField', () {
    test(
      'should return an observable of withInitialValue.',
      () async {
        // act
        final result = obs.getField(TestFormFields.withInitialValue);
        // assert
        expect(result, isA<Observable<String>>());
        expect(result.value, equals('test'));
      },
    );

    test(
      'should return an observable of withoutInitialValue.',
      () async {
        // act
        final result = obs.getField(TestFormFields.withoutInitialValue);
        // assert
        expect(result, isA<Observable<String>>());
        expect(result.value, equals(''));
      },
    );
  });

  group('getFieldValue', () {
    test(
      'should a function that returns value of withInitialValue.',
      () async {
        // act
        final result = obs.getFieldValue;
        // assert
        expect(result, isA<Function>());
        expect(result(TestFormFields.withInitialValue), equals('test'));
      },
    );

    test(
      'should a function that returns value of withoutInitialValue.',
      () async {
        // act
        final result = obs.getFieldValue;
        // assert
        expect(result, isA<Function>());
        expect(result(TestFormFields.withoutInitialValue), equals(''));
      },
    );
  });

  group('getValues', () {
    test(
      'should return a function that return a map of form values.',
      () async {
        // act
        final result = obs.getValues;
        // assert
        expect(result, isA<Function>());
        expect(
          result(),
          equals({
            'withInitialValue': 'test',
            'withoutInitialValue': '',
          }),
        );
      },
    );
  });

  group('setFieldValue', () {
    test(
      'should set a field and controller value.',
      () async {
        // act
        obs.setFieldValue(TestFormFields.withInitialValue, 'newValue');
        final field = obs.getField(TestFormFields.withInitialValue);
        final ctrl = obs.getController(TestFormFields.withInitialValue);
        // assert
        expect(field.value, equals('newValue'));
        expect(ctrl.text, equals('newValue'));
      },
    );
  });

  group('setFieldValues', () {
    test(
      'should set multiple field and controller values.',
      () async {
        // act
        obs.setFieldValues({
          TestFormFields.withInitialValue: 'newValue1',
          TestFormFields.withoutInitialValue: 'newValue2',
        });
        final field1 = obs.getField(TestFormFields.withInitialValue);
        final ctrl1 = obs.getController(TestFormFields.withInitialValue);
        final field2 = obs.getField(TestFormFields.withoutInitialValue);
        final ctrl2 = obs.getController(TestFormFields.withoutInitialValue);
        // assert
        expect(field1.value, equals('newValue1'));
        expect(ctrl1.text, equals('newValue1'));
        expect(field2.value, equals('newValue2'));
        expect(ctrl2.text, equals('newValue2'));
      },
    );
  });

  group('clear', () {
    test(
      'should clear all fields, setting them with initial value.',
      () async {
        // arrange
        obs
          ..setFieldValues({
            TestFormFields.withInitialValue: '_',
            TestFormFields.withoutInitialValue: '_',
          })
          // act
          ..clear();
        final result = obs.getValues();
        // assert
        expect(result, {
          'withInitialValue': 'test',
          'withoutInitialValue': '',
        });
      },
    );

    test(
      'should clear only withoutInitialValue field, setting him with initial '
      'value.',
      () async {
        // arrange
        obs
          ..setFieldValues({
            TestFormFields.withInitialValue: '_',
            TestFormFields.withoutInitialValue: '_',
          })
          // act
          ..clear([TestFormFields.withInitialValue]);
        final result = obs.getValues();
        // assert
        expect(result, {
          'withInitialValue': 'test',
          'withoutInitialValue': '_',
        });
      },
    );
  });

  group('focus', () {
    testWidgets('should focus a field.', (tester) async {
      final focusNode = obs.getFocusNode(TestFormFields.withInitialValue);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Center(
              child: TextField(
                focusNode: focusNode,
              ),
            ),
          ),
        ),
      );

      expect(focusNode.hasPrimaryFocus, isFalse);

      obs.focus(TestFormFields.withInitialValue);

      await tester.pumpAndSettle();

      expect(focusNode.hasPrimaryFocus, isTrue);
    });
  });

  group('dispose', () {
    test(
      'should dispose controllers and focusNodes.',
      () async {
        // act
        obs.dispose();
        // assert
        for (final field in TestFormFields.values) {
          final controller = obs.getController(field);
          final focusNode = obs.getFocusNode(field);

          expect(controller.dispose, throwsFlutterError);
          expect(focusNode.dispose, throwsFlutterError);
        }
      },
    );
  });
}
