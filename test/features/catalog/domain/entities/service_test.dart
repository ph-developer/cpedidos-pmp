import 'package:cpedidos_pmp/features/catalog/domain/entities/item.dart';
import 'package:cpedidos_pmp/features/catalog/domain/entities/service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'should extends Item.',
    () async {
      // arrange
      const tService = Service(
        code: 'code',
        description: 'description',
        groupCode: 'groupCode',
        groupDescription: 'groupDescription',
      );
      // assert
      expect(tService, isA<Item>());
    },
  );

  test(
    'should return true when all props are equals.',
    () async {
      // arrange
      const tServiceA = Service(
        code: 'code',
        description: 'description',
        groupCode: 'groupCode',
        groupDescription: 'groupDescription',
      );
      const tServiceB = Service(
        code: 'code',
        description: 'description',
        groupCode: 'groupCode',
        groupDescription: 'groupDescription',
      );
      // act
      final result = tServiceA == tServiceB;
      // assert
      expect(result, isTrue);
    },
  );

  test(
    'should return false when any prop are different.',
    () async {
      // arrange
      const tServiceA = Service(
        code: 'code1',
        description: 'description',
        groupCode: 'groupCode',
        groupDescription: 'groupDescription',
      );
      const tServiceB = Service(
        code: 'code2',
        description: 'description',
        groupCode: 'groupCode',
        groupDescription: 'groupDescription',
      );
      // act
      final result = tServiceA == tServiceB;
      // assert
      expect(result, isFalse);
    },
  );
}
