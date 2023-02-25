import 'dart:typed_data';

import 'package:cpedidos_pmp/src/orders/data/services/pdf_service.dart';
import 'package:cpedidos_pmp/src/orders/domain/entities/order.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late PdfService service;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    service = PdfService();
  });

  const tOrders = [
    Order(
      number: 'number',
      type: 'type',
      arrivalDate: 'arrivalDate',
      secretary: 'secretary',
      project: 'project',
      description: 'description',
    ),
  ];

  group('generateOrdersReport', () {
    test(
      'should return an Uint8List when generate pdf with success.',
      () async {
        // act
        final result = await service.generateOrdersReport(tOrders);
        // assert
        expect(result.getOrNull(), isA<Uint8List>());
      },
    );
  });
}
