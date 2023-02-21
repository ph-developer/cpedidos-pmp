import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cpedidos_pmp/src/shared/config/sentry/sentry_config.dart';

abstract class Callable<T> {
  void call([T? arg]) {}
}

class MockCallable<T> extends Mock implements Callable<T> {}

void main() {
  late Callable mockCallable;

  setUp(() {
    mockCallable = MockCallable();
  });

  group('setup', () {
    test(
      'should run appRunner function after init.',
      () async {
        // arrange
        final tAppRunner = mockCallable;
        // act
        await SentryConfig.setup(tAppRunner);
        // assert
        verify(() => mockCallable()).called(1);
      },
    );
  });
}
