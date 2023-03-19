import 'package:cpedidos_pmp/core/boot/router/router_boot.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('run', () {
    test(
      'should setup router without errors.',
      () async {
        // act
        await RouterBoot.run();
      },
    );
  });
}
