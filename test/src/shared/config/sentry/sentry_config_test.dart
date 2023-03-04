import 'package:cpedidos_pmp/src/shared/config/sentry/sentry_config.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks.dart';

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
