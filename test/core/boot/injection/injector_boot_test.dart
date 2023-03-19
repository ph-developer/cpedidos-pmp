import 'package:auto_injector/auto_injector.dart';
import 'package:cpedidos_pmp/core/boot/injection/injector_boot.dart';
import 'package:cpedidos_pmp/core/injection/injector.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks.dart';

void main() {
  late AutoInjector mockInjector;

  setUp(() {
    mockInjector = MockAutoInjector();
    setInjector(mockInjector);
  });

  group('run', () {
    test(
      'should run setupInjector without error.',
      () async {
        // act
        await InjectorBoot.run();
        // assert
        verify(() => mockInjector.commit()).called(1);
      },
    );

    test(
      'should run setupInjector with passed function.',
      () async {
        // arrange
        final callable = MockCallable();
        // act
        await InjectorBoot.run((injector) async => callable(injector));
        // assert
        verify(() => callable(mockInjector)).called(1);
        verifyNever(() => mockInjector.commit());
        verifyNoMoreInteractions(mockInjector);
      },
    );
  });
}
