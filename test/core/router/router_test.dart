import 'package:cpedidos_pmp/core/router/router.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('setupRouter', () {
    test(
      'should setup router without errors.',
      () async {
        // act
        await setupRouter();
        // assert
        expect(router, isA<Router>());
      },
    );
  });
}
