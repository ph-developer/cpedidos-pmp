import 'dart:typed_data';

import 'package:cpedidos_pmp/src/orders/external/drivers/printer_driver_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:printing/src/interface.dart';

import '../../mocks.dart';

void main() {
  late PrinterDriverImpl driver;

  setUp(() {
    driver = PrinterDriverImpl();
    PrintingPlatform.instance = MockPrintingPlatform();
  });

  final tEmptyBytes = Uint8List(0);

  group('printPdfBytes', () {
    test(
      'should return true when success print.',
      () async {
        // act
        final result = await driver.printPdfBytes(tEmptyBytes);
        // assert
        expect(result, equals(true));
      },
    );
  });
}
