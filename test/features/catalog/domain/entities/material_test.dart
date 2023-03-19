import 'package:cpedidos_pmp/features/catalog/domain/entities/item.dart';
import 'package:cpedidos_pmp/features/catalog/domain/entities/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'should extends Item.',
    () async {
      // arrange
      const tMaterial = Material(
        code: 'code',
        description: 'description',
        groupCode: 'groupCode',
        groupDescription: 'groupDescription',
      );
      // assert
      expect(tMaterial, isA<Item>());
    },
  );

  test(
    'should return true when all props are equals.',
    () async {
      // arrange
      const tMaterialA = Material(
        code: 'code',
        description: 'description',
        groupCode: 'groupCode',
        groupDescription: 'groupDescription',
      );
      const tMaterialB = Material(
        code: 'code',
        description: 'description',
        groupCode: 'groupCode',
        groupDescription: 'groupDescription',
      );
      // act
      final result = tMaterialA == tMaterialB;
      // assert
      expect(result, isTrue);
    },
  );

  test(
    'should return false when any prop are different.',
    () async {
      // arrange
      const tMaterialA = Material(
        code: 'code1',
        description: 'description',
        groupCode: 'groupCode',
        groupDescription: 'groupDescription',
      );
      const tMaterialB = Material(
        code: 'code2',
        description: 'description',
        groupCode: 'groupCode',
        groupDescription: 'groupDescription',
      );
      // act
      final result = tMaterialA == tMaterialB;
      // assert
      expect(result, isFalse);
    },
  );
}
