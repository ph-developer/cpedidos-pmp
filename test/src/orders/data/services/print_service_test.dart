import 'dart:typed_data';

import 'package:cpedidos_pmp/src/orders/data/services/print_service.dart';
import 'package:flutter/services.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pdf/pdf.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:printing/src/callback.dart';
import 'package:printing/src/interface.dart';
import 'package:printing/src/printer.dart';
import 'package:result_dart/result_dart.dart';

class MockPrintingPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements PrintingPlatform {
  @override
  Future<bool> layoutPdf(
    Printer? printer,
    LayoutCallback onLayout,
    String name,
    PdfPageFormat format,
    bool dynamicLayout,
    bool usePrinterSettings,
  ) async {
    return true;
  }
}

void main() {
  late PrintService service;

  setUp(() {
    service = PrintService();
    PrintingPlatform.instance = MockPrintingPlatform();
    registerFallbackValue(const PdfPageFormat(1, 1));
  });

  final tEmptyBytes = Uint8List(0);

  group('printPdfBytes', () {
    test(
      'should return an Unit when success print.',
      () async {
        // act
        final result = await service.printPdfBytes(tEmptyBytes);
        // assert
        expect(result.getOrNull(), equals(unit));
      },
    );
  });
}
