import 'package:cpedidos_pmp/features/catalog/domain/entities/material.dart';
import 'package:cpedidos_pmp/features/catalog/external/dtos/material_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tMaterialMapEntry = MapEntry('itemCode', ['groupCode', 'itemDesc']);
  const tGroups = {'groupCode': 'groupDescription'};
  const tMaterial = Material(
    code: 'itemCode',
    description: 'itemDesc',
    groupCode: 'groupCode',
    groupDescription: 'groupDescription',
  );

  group('fromMap', () {
    test(
      'should convert a mapEntry to Material.',
      () async {
        // act
        final result = MaterialDTO.fromMapEntry(tMaterialMapEntry, tGroups);
        // assert
        expect(result, isA<Material>());
        expect(result, equals(tMaterial));
      },
    );
  });
}
