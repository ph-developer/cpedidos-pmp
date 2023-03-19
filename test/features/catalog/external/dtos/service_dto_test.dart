import 'package:cpedidos_pmp/features/catalog/domain/entities/service.dart';
import 'package:cpedidos_pmp/features/catalog/external/dtos/service_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tServiceMapEntry = MapEntry('itemCode', ['groupCode', 'itemDesc']);
  const tGroups = {'groupCode': 'groupDescription'};
  const tService = Service(
    code: 'itemCode',
    description: 'itemDesc',
    groupCode: 'groupCode',
    groupDescription: 'groupDescription',
  );

  group('fromMap', () {
    test(
      'should convert a mapEntry to Service.',
      () async {
        // act
        final result = ServiceDTO.fromMapEntry(tServiceMapEntry, tGroups);
        // assert
        expect(result, isA<Service>());
        expect(result, equals(tService));
      },
    );
  });
}
