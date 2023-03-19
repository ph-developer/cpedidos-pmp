import 'package:cpedidos_pmp/core/router/transitions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks.dart';

void main() {
  late BuildContext mockBuildContext;
  late GoRouterState mockGoRouterState;

  setUp(() {
    mockBuildContext = MockBuildContext();
    mockGoRouterState = MockGoRouterState();
  });

  final tPage = Container();
  const tValueKey = ValueKey('test');

  group('fadeTransition', () {
    test(
      'should return a PageTransition.',
      () async {
        // act
        final result = fadeTransition(Container());
        // assert
        expect(result, isA<PageTransition>());
      },
    );

    test(
      'should PageTransition return a Page.',
      () async {
        // arrange
        when(() => mockGoRouterState.pageKey).thenReturn(tValueKey);
        // act
        final transition = fadeTransition(tPage);
        final result = transition(mockBuildContext, mockGoRouterState);
        // assert
        expect(result, isA<Page>());
      },
    );
  });
}
