import 'package:cpedidos_pmp/core/helpers/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Key containerKey;
  late Widget testableWidget;

  setUp(() {
    containerKey = const Key('key');
    testableWidget = MaterialApp(
      home: Scaffold(
        body: Container(
          key: containerKey,
        ),
      ),
    );
  });

  group('showSuccessSnackbar', () {
    testWidgets(
      'should display a success snackbar and hide after 3000ms (default).',
      (tester) async {
        late Finder widget;
        // arrange
        await tester.pumpWidget(testableWidget);
        final container = find.byKey(containerKey);
        final context = tester.element(container);
        // assert
        expect(context, isNotNull);
        // act
        context.showSuccessSnackbar('success');
        await tester.pump();
        // assert
        widget = find.text('success');
        expect(widget, findsOneWidget);
        // act
        await tester.pumpAndSettle(const Duration(milliseconds: 3000));
        // assert
        widget = find.text('success');
        expect(widget, findsNothing);
      },
    );

    testWidgets(
      'should display a success snackbar and hide after 500ms.',
      (tester) async {
        late Finder widget;
        // arrange
        await tester.pumpWidget(testableWidget);
        final container = find.byKey(containerKey);
        final context = tester.element(container);
        const duration = Duration(milliseconds: 500);
        // assert
        expect(context, isNotNull);
        // act
        context.showSuccessSnackbar('success', duration);
        await tester.pump();
        // assert
        widget = find.text('success');
        expect(widget, findsOneWidget);
        // act
        await tester.pumpAndSettle(duration);
        // assert
        widget = find.text('success');
        expect(widget, findsNothing);
      },
    );
  });

  group('showErrorSnackbar', () {
    testWidgets(
      'should display a error snackbar and hide after 3000ms (default).',
      (tester) async {
        late Finder widget;
        // arrange
        await tester.pumpWidget(testableWidget);
        final container = find.byKey(containerKey);
        final context = tester.element(container);
        // assert
        expect(context, isNotNull);
        // act
        context.showErrorSnackbar('error');
        await tester.pump();
        // assert
        widget = find.text('error');
        expect(widget, findsOneWidget);
        // act
        await tester.pumpAndSettle(const Duration(milliseconds: 3000));
        // assert
        widget = find.text('error');
        expect(widget, findsNothing);
      },
    );

    testWidgets(
      'should display a error snackbar and hide after 1000ms.',
      (tester) async {
        late Finder widget;
        // arrange
        await tester.pumpWidget(testableWidget);
        final container = find.byKey(containerKey);
        final context = tester.element(container);
        const duration = Duration(milliseconds: 1000);
        // assert
        expect(context, isNotNull);
        // act
        context.showErrorSnackbar('error', duration);
        await tester.pump();
        // assert
        widget = find.text('error');
        expect(widget, findsOneWidget);
        // act
        await tester.pumpAndSettle(duration);
        // assert
        widget = find.text('error');
        expect(widget, findsNothing);
      },
    );
  });

  group('hideSnackbar', () {
    testWidgets(
      'should hide a current success snackbar.',
      (tester) async {
        late Finder widget;
        // arrange
        await tester.pumpWidget(testableWidget);
        final container = find.byKey(containerKey);
        final context = tester.element(container);
        // assert
        expect(context, isNotNull);
        // act
        context.showSuccessSnackbar('success');
        await tester.pump();
        // assert
        widget = find.text('success');
        expect(widget, findsOneWidget);
        // act
        context.hideSnackbar();
        await tester.pump();
        // assert
        widget = find.text('success');
        expect(widget, findsNothing);
      },
    );

    testWidgets(
      'should hide a current error snackbar.',
      (tester) async {
        late Finder widget;
        // arrange
        await tester.pumpWidget(testableWidget);
        final container = find.byKey(containerKey);
        final context = tester.element(container);
        // assert
        expect(context, isNotNull);
        // act
        context.showErrorSnackbar('error');
        await tester.pump();
        // assert
        widget = find.text('error');
        expect(widget, findsOneWidget);
        // act
        context.hideSnackbar();
        await tester.pump();
        // assert
        widget = find.text('error');
        expect(widget, findsNothing);
      },
    );

    testWidgets(
      'should not throw errors when try hide a snackbar and they not exists.',
      (tester) async {
        // arrange
        await tester.pumpWidget(testableWidget);
        final container = find.byKey(containerKey);
        final context = tester.element(container);
        // assert
        expect(context, isNotNull);
        // act
        context.hideSnackbar();
        await tester.pumpAndSettle();
      },
    );
  });
}
