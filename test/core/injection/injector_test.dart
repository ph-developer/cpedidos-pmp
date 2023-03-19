import 'package:auto_injector/auto_injector.dart';
import 'package:cpedidos_pmp/core/injection/injector.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks.dart';

void main() {
  late AutoInjector mockInjector;

  setUp(() {
    mockInjector = MockAutoInjector();
    setInjector(mockInjector);
  });

  group('setupInjector', () {
    test(
      'should inject without errors.',
      () async {
        // act
        await setupInjector();
        // assert
        verify(() => mockInjector.commit()).called(1);
      },
    );

    test(
      'should call only the passed function, passing injector as param.',
      () async {
        // arrange
        final callable = MockCallable();
        // act
        await setupInjector((injector) async => callable(injector));
        // assert
        verify(() => callable(mockInjector)).called(1);
        verifyNever(() => mockInjector.commit());
        verifyNoMoreInteractions(mockInjector);
      },
    );
  });
}
