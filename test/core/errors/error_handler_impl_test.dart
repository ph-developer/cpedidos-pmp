import 'package:cpedidos_pmp/core/errors/error_handler_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../mocks.dart';

void main() {
  late SentryClient mockSentryClient;
  late ErrorHandlerImpl handler;

  setUp(() {
    mockSentryClient = MockSentryClient();
    handler = ErrorHandlerImpl();
  });

  const tDsn = 'https://abc@def.ingest.sentry.io/1234567';

  group('reportException', () {
    test(
      'should report an exception to sentry.',
      () async {
        // arrange
        final tException = Exception('test');
        final tStackTrace = StackTrace.fromString('stackTrace test');
        await Sentry.init((options) => options.dsn = tDsn);
        Sentry.bindClient(mockSentryClient);
        registerFallbackValue(SentryEvent());
        // act
        await handler.reportException(tException, tStackTrace);
        // assert
        final captured = verify(
          () => mockSentryClient.captureEvent(
            captureAny(),
            stackTrace: captureAny(named: 'stackTrace'),
            scope: any(named: 'scope'),
            hint: any(named: 'hint'),
          ),
        ).captured;
        expect((captured[0] as SentryEvent).throwable, equals(tException));
        expect(captured[1], equals(tStackTrace));
      },
    );
  });
}
